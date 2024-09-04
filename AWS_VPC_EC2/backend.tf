terraform {
  backend "s3" {
    bucket = "terraform-ansible-docker-s3"
    key    = "ansible_docker/terraform.tfstate"
    region = "us-east-1"
  }
}