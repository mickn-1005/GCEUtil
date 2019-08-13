#!/bin/bash
# GCEでまっさらな状態からDockerのインストールとTensorflowイメージでの実行までを行う．
# 参考文献 https://cloud.google.com/compute/docs/gpus/add-gpus?hl=ja#install-driver-script

echo "Checking for CUDA and installing."
# Check for CUDA and try to install.
if ! dpkg-query -W cuda-10-0; then
  # The 16.04 installer works with 16.10.
  curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
  dpkg -i ./cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
  apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
  apt-get update
  apt-get install cuda-10-0 -y
fi
# Enable persistence mode
nvidia-smi -pm 1

echo "Test code running."
nvidia-smi



echo "install tensorflow latest-gpu-jupyter"
docker pull tensorflow/tensorflow:latest-gpu-jupyter

echo "testrunning nvidia-docker"
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi

echo "test running tensrflow image"
docker run --runtime=nvidia -it --rm tensorflow/tensorflow:latest-gpu-py3 \
   python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"
