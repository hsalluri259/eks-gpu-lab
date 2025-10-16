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

  eks_managed_node_groups = merge(
    {
      default = {
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 1
        capacity_type  = "SPOT"
        public_key     = "test"
        labels = {
          role = "default"
        }
      }
    },
    var.create_gpu_nodegroup ? {
      gpu = {
        instance_types                = ["g4dn.xlarge"]
        min_size                      = 1
        max_size                      = 1
        desired_size                  = 1
        capacity_type                 = "SPOT"
        key_name                      = var.public_key
        additional_security_group_ids = var.additional_security_group_ids
        labels = {
          role = "gpu"
        }
        # taints = [
        #   {
        #     key    = "nvidia.com/gpu"
        #     value  = "true"
        #     effect = "NO_SCHEDULE"
        #   }
        # ]
      }
    } : {}
  )


  # To access cluster objects via kubectl from your local machine without using a bastion host.
  endpoint_public_access = true
  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

}
