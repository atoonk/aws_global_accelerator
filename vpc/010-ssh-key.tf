#variable region { }
resource "aws_key_pair" "my-key-pair" {
  key_name   = "my-key-pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
