#!/bin/bash

#---------------- download kubeflow manifest repository
git clone https://github.com/kubeflow/manifests.git

#---------------- download kustomize.exe file 3.2.0 for linux which is stable with over kubeflow version 1.5.0
wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64

#---------------- copy kustomize exe into /bin/bash
chmod +x kustomize_3.2.0_linux_amd64
mv kustomize_3.2.0_linux_amd64 /bin/bash

#---------------- install kubeflow as a single command
cd manifests
while ! kustomize_3.2.0_linux_amd64 build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
