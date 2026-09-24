data "aws_vpc" "main_vpc" {
    filter {
      name = "tag:Name"
      values = ["${var.env}-main_vpc"]
    }
}
