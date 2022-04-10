#!/bin/env bash

# ttl을 0으로 설정해 24시간 후에도 토큰이 유지되게함
# 워커 노드가 정해진 토큰으로 들어오게한다
# 쿠버네티스가 자동으로 컨테이너에 부여하는 네트워크를 172.16.0.0/16으로 지정
# 워커 노드가 접속하는 API 서버의 IP를 192.168.1.10으로 지정하여 자동으로 API 서버에 연결되게함
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=192.168.1.10

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# export KUBECONFIG=/etc/kubernetes/admin.conf

# calico CNI
kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
