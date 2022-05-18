#!/bin/bash

#------------- install kfctl which is a CLI for deploy and manage kubeflow components
wget https://github.com/kubeflow/kfctl/releases/download/v1.2-rc.4/kfctl_v1.2.0-0-gbc038f9_linux.tar.gz

tar xzvf kfctl_v1.2.0-0-gbc038f9_linux.tar.gz
mv kfctl /usr/bin

#------------- create directory to store scripts && set distribution template
export KF_NAME=handson-kubeflow
export BASE_DIR=/home/${USER}
export KF_DIR=${BASE_DIR}/${KF_NAME}
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.2-branch/kfdef/kfctl_k8s_istio.v1.2.0.yaml"

#------------- build kustomize packages
mkdir -p ${KF_DIR}
cd ${KF_DIR}
kfctl build -V -f ${CONFIG_URI}

#------------- execute packages using kfctl
export CONFIG_FILE=${KF_DIR}/kfctl_k8s_istio.v1.0.0.yaml
kfctl apply -V -f ${CONFIG_FILE}
