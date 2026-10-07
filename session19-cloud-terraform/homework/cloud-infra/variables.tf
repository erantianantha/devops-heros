variable "aws_region" {
  description = "AWS region for the Session 19 mini project."
  type        = string
  default     = "ap-south-1"
}

variable "aws_endpoint" {
  description = "AWS API endpoint (Moto running locally)."
  type        = string
  default     = "http://localhost:4566"
}

variable "instance_type" {
  description = "EC2 instance type (free tier)."
  type        = string
  default     = "t3.micro"
}
