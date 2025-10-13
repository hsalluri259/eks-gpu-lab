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
