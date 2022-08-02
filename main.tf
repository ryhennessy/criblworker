terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
}

data "aws_ami" "east2-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnets" "current" {
  filter {
    name   = "vpc-id"
    values = [var.worker_vpc_id]
  }
}

resource "aws_instance" "worker" {
  count                       = var.worker_count
  ami                         = var.worker_ami != null ? var.worker_ami : data.aws_ami.east2-ami.id
  instance_type               = var.inst_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = var.sg_groups
  subnet_id                   = element(data.aws_subnets.current.ids, (length(data.aws_subnets.current.ids) % count.index))
  tags = {
    Name   = "worker_node-${count.index + 1}"
    worker = "yes"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    content     = templatefile("${path.module}/install_worker.tftpl", { leaderip = var.stream_leader, workergroup = var.stream_workergroup, token = var.stream_token, install = var.stream_install })
    destination = "/tmp/install_worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 700 /tmp/install_worker.sh",
      "sudo /tmp/install_worker.sh"
    ]
  }

}
