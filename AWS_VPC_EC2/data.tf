data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID do proprietário para imagens oficiais da Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # Nome da AMI do Ubuntu 22.04
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_availability_zones" "azs" {

}