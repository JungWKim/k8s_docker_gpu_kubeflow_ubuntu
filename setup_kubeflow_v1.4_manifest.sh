#!/bin/bash

# Turn off ufw or open a specific port for kubeflow installation

#---------------- create default storage class
echo "\
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer" >> default-storageclass.yaml

kubectl apply -f default-storageclass.yaml

kubectl patch storageclass local-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

#---------------- download kubeflow manifest repository
git clone https://github.com/kubeflow/manifests.git

#---------------- check out to branch kubeflow 1.4.1
git checkout v1.4.1

#---------------- download kustomize.exe file 3.2.0 for linux which is stable with over kubeflow version 1.5.0
wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64

#---------------- copy kustomize exe into /bin/bash
chmod +x kustomize_3.2.0_linux_amd64
mv kustomize_3.2.0_linux_amd64 /usr/bin/kustomize

#---------------- install kubeflow as a single command
cd manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
