
locals {
  trust_policy_statements = concat(
    var.service_principal != null ? [
      {
        Effect = "Allow"
        Principal = {
          Service = var.service_principal
        }
        Action = "sts:AssumeRole"
      }
    ] : [],

    length(var.trusted_aws_account_ids) > 0 ? [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            for account_id in var.trusted_aws_account_ids :
            "arn:aws:iam::${account_id}:root"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ] : [],

    length(var.trusted_role_arns) > 0 ? [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_role_arns
        }
        Action = "sts:AssumeRole"
      }
    ] : []
  )
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.description
  path                 = var.path
  max_session_duration = var.max_session_duration

  permissions_boundary = var.permissions_boundary_arn

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.trust_policy_statements
  })

  tags = var.tags
}

# Attach AWS managed or customer managed policies

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Create inline policies

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}
