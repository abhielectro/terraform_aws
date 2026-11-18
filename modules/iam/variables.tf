
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of IAM role"
  type        = string
  default     = "Managed by Terraform"
}

variable "service_principal" {
  description = "AWS service allowed to assume this role"
  type        = string
  default     = null
}

variable "trusted_aws_account_ids" {
  description = "AWS account IDs allowed to assume this role"
  type        = list(string)
  default     = []
}

variable "trusted_role_arns" {
  description = "Specific IAM role ARNs allowed to assume this role"
  type        = list(string)
  default     = []
}

variable "managed_policy_arns" {
  description = "List of AWS managed or customer managed policy ARNs"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline IAM policies"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for IAM role"
  type        = map(string)
  default     = {}
}

variable "max_session_duration" {
  description = "Maximum role session duration in seconds"
  type        = number
  default     = 3600
}

variable "path" {
  description = "IAM role path"
  type        = string
  default     = "/"
}

variable "permissions_boundary_arn" {
  description = "Optional IAM permissions boundary ARN"
  type        = string
  default     = null
}
