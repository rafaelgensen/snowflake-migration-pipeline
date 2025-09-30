# Project metadata
variable "project_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "dp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Staging bucket
variable "staging_bucket_name" {
  description = "S3 bucket name for staging raw data"
  type        = string
  default     = "dp-staging-bucket"
}

# Glue job parameters
variable "jdbc_url" {
  description = "JDBC connection URL for SQL Server"
  type        = string
}

variable "jdbc_user" {
  description = "SQL Server username"
  type        = string
}

variable "jdbc_password" {
  description = "SQL Server password (use Secrets Manager in prod)"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of Secrets Manager secret with SQL Server creds"
  type        = string
  default     = ""
}

# Availability zone (optional, only needed for VPC connections)
variable "availability_zone" {
  description = "Availability zone for Glue connection (if needed)"
  type        = string
  default     = ""
}

variable "mwaa_subnet_ids" {
  description = "List of subnet IDs for MWAA environment"
  type        = list(string)
  default     = ["subnet-xxxxxxxx"]  # test
}

variable "mwaa_security_group_id" {
  description = "Security group ID for MWAA environment"
  type        = string
  default     = "sg-xxxxxxxx"  # test
}