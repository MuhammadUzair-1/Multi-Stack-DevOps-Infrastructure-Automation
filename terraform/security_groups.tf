resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-frontend-sg"
  description = "Public HTTP/HTTPS and restricted SSH access to frontend/bastion"
  vpc_id      = aws_vpc.main.id

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
    description = "Voting application"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Results application"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my current public IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-frontend-sg"
    Project = var.project_name
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg"
  description = "Redis from frontend tier and SSH from bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Redis from frontend tier"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    description     = "SSH from frontend bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    description = "Outbound traffic including connections to PostgreSQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-backend-sg"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "redis_from_backend" {
  description              = "Redis access from backend worker"
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  source_security_group_id = aws_security_group.backend.id
}

resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "PostgreSQL from backend tier only; SSH via bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL from frontend and backend tiers"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    security_groups = [
      aws_security_group.frontend.id,
      aws_security_group.backend.id
    ]
  }

  ingress {
    description     = "SSH from frontend bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-database-sg"
    Project = var.project_name
  }
}
