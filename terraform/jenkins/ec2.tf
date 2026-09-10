data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }

  filter {
    name = "architecture"

    values = [
      "x86_64"
    ]
  }

  filter {
    name = "root-device-type"

    values = [
      "ebs"
    ]
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.jenkins_public.id

  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"

    # Force IMDSv2
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"

    volume_size = 30

    encrypted = true

    delete_on_termination = true

    tags = {
      Name = "fullstack-jenkins-ebs"
    }
  }

  tags = {
    Name = "fullstack-jenkins-server"
  }

  depends_on = [
    aws_route.internet,
    aws_iam_role_policy_attachment.ssm
  ]
}

resource "aws_eip" "jenkins" {
  domain = "vpc"

  instance = aws_instance.jenkins.id

  tags = {
    Name = "fullstack-jenkins-eip"
  }

  depends_on = [
    aws_internet_gateway.jenkins
  ]
}