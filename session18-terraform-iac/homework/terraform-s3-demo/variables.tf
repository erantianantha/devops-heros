variable "aws_region" {
  type        = string
  description = "AWS region where the S3 bucket will be created."
  default     = "ap-south-1"
}
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket."
  default     = "yatri1107"
}

variable "aws_endpoint" {
  type        = string
  description = "AWS API endpoint (Moto running locally)."
  default     = "http://localhost:4566"
}
