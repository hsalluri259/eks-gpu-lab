# k8s-gpu-lab
This repo contains scripts and instructions to launch an EC2 instance with a GPU  to create a Kubernetes cluster for learning and experimentation.

# Kubernetes GPU Lab with Terraform 🚀

This repository provisions an AWS environment using **Terraform** to launch a GPU-enabled EC2 instance and set up a Kubernetes cluster for learning and experimentation.

## 🎯 Goals
- Provision AWS resources with Infrastructure as Code (IaC).
- Launch a GPU-enabled EC2 instance (`g4dn.xlarge` by default).
- Install Kubernetes (via kubeadm) and NVIDIA GPU drivers.
- Deploy the NVIDIA device plugin to schedule GPU workloads.

---

## 🛠️ Prerequisites
Before you begin, ensure you have:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.5+ recommended)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (configured with `aws configure`)
- An existing AWS key pair for SSH access
- IAM permissions for:
  - `AmazonEC2FullAccess`
  - `AmazonVPCFullAccess`
  - `IAMFullAccess`

---

## 📂 Repo Structure
eks-gpu-lab/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
└── README.md


---

## ⚡ Quick Start

### 1. Clone the Repo
```bash
git clone https://github.com/<your-username>/k8s-gpu-lab.git
cd k8s-gpu-lab
```

### 2: Prerequisites

#### a. Configure AWS CLI
Terraform uses your AWS credentials. Configure your CLI:
```bash
aws configure --profile personal

```
Provide:

AWS Access Key ID

AWS Secret Key

Default region (e.g., us-east-1)

Default output format (json)

Verify:
```bash
aws --profile personal sts get-caller-identity
```

#### b. Generate key-pair
```bash
ssh-keygen -t rsa -b 4096 -C "k8s-lab" -f ~/.ssh/k8s-lab
```
### 3. Initialize Terraform
```bash
terraform init
```

### 3. Plan the Infrastructure
```bash
export AWS_PROFILE=personal
terraform plan -var="key_name=<your-aws-keypair>"
```

### 4. Apply and Launch
```bash
terraform apply -var-file terraform.tfvars
```

### 5. Connect to the EC2 GPU Instance
```bash
ssh -i ~/.ssh/<your-key>.pem ubuntu@<public_ip_from_output>
```

✅ Post-Deployment Steps

1. Verify GPU is accessible:
```bash
nvidia-smi
```
2. Initialize Kubernetes cluster:
```bash
sudo bash /scripts/init-cluster.sh
```
3. Deploy NVIDIA device plugin:
```bash
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.16.0/nvidia-device-plugin.yml
```
4. Test GPU workload:
```bash
kubectl run gpu-test --rm -it \
  --image=nvidia/cuda:12.2.0-base-ubuntu22.04 \
  --limits="nvidia.com/gpu=1" -- nvidia-smi
```

🧹 Cleanup

To avoid charges, always destroy resources when done:
```bash
terraform destroy -auto-approve
```

### Verify Raw key-value pairs stored in etcd
```bash
export ETCDCTL_API=3
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key

# list all keys
etcdctl get / --prefix --keys-only

# list all pods in all namespaces
etcdctl get /registry/pods/ --prefix --keys-only
```