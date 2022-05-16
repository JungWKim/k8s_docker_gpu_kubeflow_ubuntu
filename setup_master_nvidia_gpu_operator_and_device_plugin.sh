#!/bin/bash

#------------- Before executing this script, all GPU worker nodes must be installed with NVIDIA driver and nvidia-docker 2.0 !!!

#------------- install NVIDIA GPU operator

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh

# add NVIDIA Helm repository
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
  && helm repo update

# this is for the case with pre-installed nvidia driver and nvidia docker
# if you are under different circumstances, please refer to the official site of installing NVIDIA GPU operator
# https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/getting-started.html#install-nvidia-gpu-operator
helm install --wait --generate-name \
  -n gpu-operator --create-namespace \
  nvidia/gpu-operator \
  --set driver.enabled=false \
  --set toolkit.enabled=false

#------------- install NVIDIA device plugin

# add nvidia device plugin helm repository
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin \
  && helm repo update

# deploy nvidia device plugin
helm install --generate-name nvdp/nvidia-device-plugin
