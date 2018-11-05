# global/main.tf
# same script 3 different envs
variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  region  = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

terraform {
  backend "s3" {  
    bucket = "personal-remote-state-oldtf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "personal-remote-state-dev"
    key    = "terraform.tfstate"
    region = "us-east-1"    
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  }
}

variable "count" {}
resource "aws_instance" "tf_instance" {
  ami           = "ami-0922553b7b0369273"
  instance_type = "t2.micro"
  count = "${var.count}"
  tags {
    Name = "tf_instance"
  }
}

output "backend_config" {
  value = "${data.terraform_remote_state.network.config}"
}
