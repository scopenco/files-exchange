output "address" {
  value = "${aws_instance.fe.dns_name} with ${aws_instance.fe.public_ip}"
}
