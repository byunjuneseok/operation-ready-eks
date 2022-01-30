resource "aws_security_group" "additional" {
  name_prefix = "${var.cluster_name}-additional"
  vpc_id      = data.aws_vpc.cluster_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = local.common_tags
}
