###
#   Ressourcen
#

# Externe Security Group 

resource "aws_security_group" "security" {
  name        = var.module

  dynamic "ingress" {
    for_each = var.ports 
      content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]      
      } 
  }
  
  dynamic "ingress" {
    for_each = var.ports 
      content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "udp"
            cidr_blocks = ["0.0.0.0/0"]      
      } 
  }  
  
  # All other from myip (tcp)
  ingress {
    from_port   = 22
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
  # All other from myip (udp)
  ingress {
    from_port   = 22
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }    

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VMs

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "vm" {
  ami                           = data.aws_ami.ubuntu.id  
  instance_type                 = lookup( var.instance_type, var.memory )
  associate_public_ip_address   = true
  user_data                     = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids        = [aws_security_group.security.id]

  tags = {
    Name = var.module
  }
  
  root_block_device {
    volume_size = 32
  }
}

