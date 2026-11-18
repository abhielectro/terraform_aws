# IAM Role for EKS Pod Identity
resource "aws_iam_role" "eks_s3_readonly" {
  name        = "${var.project_name}-${var.env}-eks-s3-readonly"
  description = "EKS Pod Identity role for S3 read-only access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "pods.eks.amazonaws.com"
      }

      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })

  tags = local.common_tags
}

# S3 Read-only IAM Policy
resource "aws_iam_policy" "s3_readonly" {
  name        = "${var.project_name}-${var.env}-s3-readonly"
  description = "Allow EKS workloads to list all S3 buckets and read objects"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # List all S3 buckets in the AWS account
      {
        Effect = "Allow"

        Action = [
          "s3:ListAllMyBuckets"
        ]

        Resource = "*"
      },

      # Read objects from the specified bucket
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]

        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },

      # List objects inside the specified bucket
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })

  tags = local.common_tags
}

# Attach S3 Policy to IAM Role
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.eks_s3_readonly.name
  policy_arn = aws_iam_policy.s3_readonly.arn
}

# Create EKS Pod Identity association
resource "aws_eks_pod_identity_association" "s3_readonly" {
  cluster_name    = var.cluster_name
  namespace       = "default"
  service_account = "aws-cli-sa"

  role_arn = aws_iam_role.eks_s3_readonly.arn

  depends_on = [
    aws_iam_role_policy_attachment.s3_readonly,
    module.eks
  ]

  tags = local.common_tags
}
