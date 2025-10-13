# eks-gpu-lab
This repository provisions a complete AWS environment for learning and experimenting with Kubernetes on GPU-powered nodes.
It uses Terraform to create:
- A custom VPC
- An IAM role with appropriate EKS access entries
- An EKS cluster
- An optional EC2 GPU instance to act as a worker node or for ML experimentation.

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
```bash
eks-gpu-lab/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── nodegroup.tf
│   │
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── main.tf              # Root Terraform entry point
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md

---
```
## ⚡ Quick Start

### 1. Clone the Repo
```bash
git clone https://github.com/<your-username>/eks-gpu-lab.git
cd eks-gpu-lab
```

### 2: Prerequisites

#### a. Configure AWS CLI
Terraform uses your AWS credentials. Configure your CLI:
```bash
aws configure --profile personal

Provide:
AWS Access Key ID
AWS Secret Key
Default region (e.g., us-east-1)
Default output format (json)
```

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
terraform plan -var-file terraform.tfvars
```

### 4. Apply and Launch
```bash
terraform apply -var-file terraform.tfvars
```

### 5. Update your kubeconfig
```bash
aws --profile personal eks update-kubeconfig --region us-west-2 --name <cluster-name>
kubectl get nodes
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