#!/bin/env bash

yum install epel-release -y
yum install git -y
yum install docker -y && systemctl enable --now docker
yum install kubectl-$1 kubeadm-$1 -y
systemctl enable --now kubelet
