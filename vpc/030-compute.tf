#variable region { }
variable compute_count { }


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  #ami           = "ami-0a313d6098716f372" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type US east1
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.micro"
  key_name        = "${aws_key_pair.my-key-pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}", "${aws_security_group.allow_icmp.id}", "${aws_security_group.allow_dns_udp.id}", "${aws_security_group.allow_dns_tcp.id}", "${aws_security_group.allow_http.id}"]
  subnet_id = "${aws_subnet.default.id}"
  tags = {
    Name = "${format("compute-%03d", count.index)}"
  }
  count = "${var.compute_count}"

  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
}

 provisioner "file" {
  source      = "scripts/nsd.sh"
  destination = "/tmp/nsd.sh"
 }
 provisioner "file" {
  source      = "scripts/web.go"
  destination = "/tmp/web.go"
 }
 # We run a remote provisioner on the instance after creating it.
 # In this case, we just install nginx and start it. By default,
 # this should be on port 80
 provisioner "remote-exec" {
   inline = [
     "sudo chmod +x /tmp/nsd.sh",
     "sudo bash -x /tmp/nsd.sh",
   ]
 }

 # Could also use this for aws
 user_data = "${file("scripts/go.sh")}"
}

resource "aws_eip" "eip" {
    count = "${var.compute_count}"
    instance = "${element(aws_instance.example.*.id,count.index)}"
    vpc = true
    depends_on = ["aws_instance.example"]

}
output "PublicIPS" {
  value = "${aws_eip.eip.*.id}"
}



output "names" {
  value = ["${aws_instance.example.*.tags.Name}"]
}
output "PublicDNS" {
  value = ["${aws_instance.example.*.public_dns}"]
}


