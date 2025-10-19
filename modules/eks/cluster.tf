# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.3.2"

  name = "${var.name}-cluster"

  kubernetes_version  = var.cluster_version
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  authentication_mode = "API_AND_CONFIG_MAP"
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }
  # enable_irsa = true
  access_entries = {
    my_role_access = {
      principal_arn = var.role_arn
      type          = "STANDARD"

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  eks_managed_node_groups = {
    gpu_nodes = {
      instance_types = ["g4dn.xlarge"] # NVIDIA T4 GPU instance
      # https://github.com/awslabs/amazon-eks-ami/releases
      # Copy AL2023_x86_64_NVIDIA from package for preinstalled NVIDIA toolkit
      ami_type      = "AL2023_x86_64_NVIDIA"
      desired_size  = 1
      min_size      = 1
      max_size      = 1
      capacity_type = "SPOT"
      # additional_security_group_ids = var.additional_security_group_ids
      labels = {
        role = "gpu"
      }
      # taints = {
      #   gpu = {
      #     key    = "nvidia.com/gpu"
      #     value  = "true"
      #     effect = "NO_SCHEDULE"
      #   }
      # }

      timeouts = {
        create = "20m" # default is longer (~40m)
        update = "5m"
        delete = "5m"
      }
    }
    cpu_nodes = {
      instance_types = ["t3.medium"]
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      capacity_type  = "SPOT"

      labels = {
        role = "cpu"
      }
      timeouts = {
        create = "10m" # default is longer (~40m)
        update = "10m"
        delete = "10m"
      }
    }

  }

  # To access cluster objects via kubectl from your local machine without using a bastion host.
  endpoint_public_access = true
  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

}
