# Create a VPC to launch our instances into
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.terraform_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_security_group" "allow_icmp" {
  name = "allow_icmp"
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  ingress {
    from_port   = 8 
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_dns_udp" {
  name = "allow_dns_udp"
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  ingress {
    from_port   = 53 
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_dns_tcp" {
  name = "allow_dns_tcp"
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  ingress {
    from_port   = 53 
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_http" {
  name = "allow_http"
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}

