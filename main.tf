terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
}

data "aws_ec2_instance_type" "worker_instance_type" {
  instance_type = var.inst_type
}

data "aws_ami" "worker-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami*-hvm-*-gp2"]
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
    values = data.aws_ec2_instance_type.worker_instance_type.supported_architectures
  }
}

data "aws_subnets" "current" {
  filter {
    name   = "vpc-id"
    values = [var.worker_vpc_id]
  }
}


resource "aws_security_group" "cribl_sg" {
  name        = "cribl_worker_sg"
  count       = length(var.existing_sg_groups) != 0 ? 0 : 1
  vpc_id      = var.worker_vpc_id
  description = "Security Group for Cribl Workers"
  dynamic "ingress" {
    for_each = var.worker_service_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "worker" {
  count                       = var.worker_count
  ami                         = var.worker_ami != null ? var.worker_ami : data.aws_ami.worker-ami.id
  instance_type               = var.inst_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = length(var.existing_sg_groups) != 0 ? var.existing_sg_groups : [aws_security_group.cribl_sg[0].id]
  subnet_id                   = element(data.aws_subnets.current.ids, count.index)
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
    content     = templatefile("${path.module}/install_worker.tftpl", { cloudinstance = var.cribl_cloud_instance, tls = var.cribl_tls, streamleader = var.cribl_leader, workergroup = var.cribl_workergroup, token = var.cribl_token, install = var.cribl_install })
    destination = "/tmp/install_worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 700 /tmp/install_worker.sh",
      "sudo /tmp/install_worker.sh"
    ]
  }

}
