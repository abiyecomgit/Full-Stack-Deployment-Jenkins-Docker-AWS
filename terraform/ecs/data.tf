data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["fullstack-jenkins-vpc"]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = ["fullstack-public-subnet-a"]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = ["fullstack-public-subnet-b"]
  }
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["fullstack-private-subnet-a"]
  }
}

data "aws_subnet" "private_b" {
  filter {
    name   = "tag:Name"
    values = ["fullstack-private-subnet-b"]
  }
}