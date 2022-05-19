#!/bin/bash

# Turn off ufw or open a specific port for kubeflow installation

#---------------- create default storage class
echo "\
> apiVersion: storage.k8s.io/v1
> kind: StorageClass
> metadata:
>   name: standard
> provisioner: kubernetes.io/aws-ebs
> parameters:
>   type: gp2
> reclaimPolicy: Retain
> allowVolumeExpansion: true
> mountOptions:
>   - debug
> volumeBindingMode: Immediate" >> default-storageclass.yaml

kubectl apply -f default-storageclass.yaml

kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

#---------------- download kubeflow manifest repository
git clone https://github.com/kubeflow/manifests.git

#---------------- download kustomize.exe file 3.2.0 for linux which is stable with over kubeflow version 1.5.0
wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64

#---------------- copy kustomize exe into /bin/bash
chmod +x kustomize_3.2.0_linux_amd64
mv kustomize_3.2.0_linux_amd64 /usr/bin

#---------------- install kubeflow as a single command
cd manifests
while ! kustomize_3.2.0_linux_amd64 build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
