resource "aws_eip" "eip" {
  for_each = toset(var.eip_names)
  domain = "vpc"

  tags = {
    Name = each.key
    description = "Internet EIP for ${each.key}"
  }
}
