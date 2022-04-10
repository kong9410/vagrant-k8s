#!/bin/env bash

# 쿠버네티스 요구조건, 스왑되지 않도록 설정
swapoff -a
# 시스템이 다시시작되더라도 스왑되지 않도록함
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# 쿠버네티스 설치
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# selinux(시스템 액세스 권한을 효과적으로 제어할 수 있는 보안 아키텍쳐)가 제한적으로 사용되지 않도록 변경
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# network ip4 ip6 bridge 설정
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter

# hosts 설정
echo "192.168.1.10 m-k8s" >> /etc/hosts
for ((i=1; i<=$1; i++)); do echo "192.168.10.10$i w$i-k8s" >> /etc/hosts; done

# 외부 서버 사용
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF
