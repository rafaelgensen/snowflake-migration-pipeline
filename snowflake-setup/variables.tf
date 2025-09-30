variable "snowflake_account" {
  description = "Snowflake account identifier (e.g. xy12345.us-east-1.aws)"
  type        = string
}

variable "snowflake_user" {
  description = "Admin username for Snowflake"
  type        = string
}

variable "snowflake_password" {
  description = "Password for the Snowflake admin user"
  type        = string
  sensitive   = true
}

variable "snowflake_region" {
  description = "Region of the Snowflake account (e.g. us-east-1)"
  type        = string
}

variable "etl_user_password" {
  description = "Password for the ETL user (Glue/Airflow)"
  type        = string
  sensitive   = true
}
