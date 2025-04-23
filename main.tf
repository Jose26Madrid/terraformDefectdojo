provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "ssh_web_access" {
  name        = "ssh_web_access"
  description = "Permitir SSH y acceso web"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "DefectDojo Web UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "defectdojo_spot" {
  ami                    = "ami-00399ec92321828f5"
  instance_type          = "t3.large"
  key_name               = "aws"
  vpc_security_group_ids = [aws_security_group.ssh_web_access.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl enable docker
              systemctl start docker
              usermod -a -G docker ec2-user
              mkdir -p ~/.docker/cli-plugins
              curl -SL https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-linux-x86_64 \
                -o ~/.docker/cli-plugins/docker-compose
              chmod +x ~/.docker/cli-plugins/docker-compose
              mkdir -p /home/ec2-user/defectdojo
              cd /home/ec2-user/defectdojo
              curl -o docker-compose.yml https://raw.githubusercontent.com/Jose26Madrid/defectdojo/main/docker-compose-persistente.yml
              docker compose up -d
              chown -R ec2-user:ec2-user /home/ec2-user/defectdojo
              EOF

  tags = {
    Name = "DefectDojo-Spot"
  }
}

output "acceso_instancia" {
  value       = "Accede a la IP ${aws_instance.defectdojo_spot.public_ip} usando los puertos: SSH (22), HTTP (80), HTTPS (443), DefectDojo (8080)"
  description = "IP pública y puertos disponibles para acceso"
}

output "id_instancia" {
  value       = aws_instance.defectdojo_spot.id
  description = "ID de la instancia EC2 creada"
}

# MIT License
# Copyright (c) 2025 Jose Magariño
# See LICENSE file for more details.
