#!/bin/bash

# add NVIDIA Helm repository
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
  && helm repo update

# install NVIDIA GPU operator
# this will create 
# (1) nvidia driver daemonset
# (2) nvidia container toolkit daemonset
# (3) nvidia cuda daemonset
# (4) nvidia dcgm exporter
# (5) nvidia operator feature discovery
# (6) nvidia operator validator
# (7) nvidia gpu feature discovery
# (8) nvidia device plugin
# (9) nvidia mig manager

helm install --wait --generate-name \
     -n gpu-operator --create-namespace \
     nvidia/gpu-operator
