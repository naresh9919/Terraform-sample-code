output "public-ip-of-Jenkins-instance" {
    description = "this is the public IP"
    value = aws_instance.Jenkins-instance.public_ip
}

output "private-ip-of-Jenkins-instance" {
    description = "this is the private IP"
    value = aws_instance.Jenkins-instance.private_ip
}
