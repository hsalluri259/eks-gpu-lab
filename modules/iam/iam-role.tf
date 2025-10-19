# Create an IAM role to assume by an IAM user
resource "aws_iam_role" "assumable_role" {
  name = "${var.name}-admin-assumable-role"

  # Trust Policy - who can assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            var.user_arn
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a permissions policy to this role (AdministratorAccess in this case)
resource "aws_iam_role_policy_attachment" "admin_role_attach" {
  role       = aws_iam_role.assumable_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#######################################
# IAM Role for EKS Node Group (EC2)
#######################################
resource "aws_iam_role" "eks_node_role" {
  name = "${var.name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.name}-node-role"
  }
}

#######################################
# Attach required managed policies
#######################################

# Allows worker nodes to connect to cluster
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Allows access to ECR (for pulling container images)
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Allows CloudWatch logging (optional but common)
resource "aws_iam_role_policy_attachment" "cw_agent_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
