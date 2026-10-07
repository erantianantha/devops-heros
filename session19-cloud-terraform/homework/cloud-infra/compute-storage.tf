# EC2 + S3 added on top of the instructor's VPC / subnet / IGW / route table / security group.

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id              # implicit dependency -> subnet -> VPC
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name      = "session19-web"
    Session   = "19"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "assets" {
  bucket        = "session19-assets-anantha"
  force_destroy = true

  # explicit dependency: only create the bucket once the web server exists
  depends_on = [aws_instance.web]
}
