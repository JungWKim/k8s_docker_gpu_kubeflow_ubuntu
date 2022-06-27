#!/bin/bash

read -e -p "Enter the nfs server's IP: " nfs_ip
read -e -p "Enter the nfs path to install db files: (ex. /volume1/kubeflow ) " nfs_path

#------------- add nfs provisioner repository
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

#------------- install nfs provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=${nfs_ip} \
    --set nfs.path=${nfs_path}

#------------- set nfs-client as default storage class
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
