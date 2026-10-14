resource "aws_instance" "frontend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-frontend"
    Project = var.project_name
    Tier    = "application"
  }
}

resource "aws_instance" "backend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private_backend.id
  vpc_security_group_ids      = [aws_security_group.backend.id]
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-backend"
    Project = var.project_name
    Tier    = "backend"
  }
}

resource "aws_instance" "database" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private_database.id
  vpc_security_group_ids      = [aws_security_group.database.id]
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-database"
    Project = var.project_name
    Tier    = "database"
  }
}
