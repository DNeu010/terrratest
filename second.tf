terraform {
  backend "s3" {
    bucket = "table2dnterraform"
    key = "terra/state"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  alias = "ap-northeast-2"
  region = "ap-northeast-2"
}

resource "aws_instance" "frontend" {
  depends_on = ["aws_instance.backend"]
  ami = "ami-0a8e17334212f7052"
  instance_type = "t2.micro"
  key_name = "user8a"
  tags = {
    Name = "table2dn-fe"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend" {
  count = 1
  provider = "aws.ap-northeast-2"
  ami = "ami-067c32f3d5b9ace91"
  instance_type = "t2.micro"
  key_name = "user8a"
  tags = {
    Name = "table2dn-be"
  }
  timeouts {
    create = "60m"
    delete = "2h"
  }
}
