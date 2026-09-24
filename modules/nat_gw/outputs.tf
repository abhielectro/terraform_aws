output "nat_eip" {
    value = aws_eip.nat_eip.public_ip
}
