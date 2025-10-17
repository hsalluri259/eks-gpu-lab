# create eks optimized node with nvidia ami_type
# apply manifest 
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.17.2/deployments/static/nvidia-device-plugin.yml


# aws
https://docs.aws.amazon.com/eks/latest/userguide/ml-eks-optimized-ami.html

k apply -f manifests/nvidia-smi.yaml