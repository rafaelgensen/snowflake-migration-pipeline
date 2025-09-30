resource "aws_glue_catalog_database" "companydb" {
  name = "${var.project_prefix}_${var.environment}_catalog"

  tags = {
    Project     = var.project_prefix
    Environment = var.environment
  }

  depends_on = [aws_s3_bucket.staging_bucket]
}

resource "aws_glue_connection" "sqlserver_jdbc" {
  name = "${var.project_prefix}-${var.environment}-sqlserver-conn"

  connection_properties = {
    JDBC_CONNECTION_URL = var.jdbc_url
    USERNAME            = var.jdbc_user
    PASSWORD            = var.jdbc_password
  }

  physical_connection_requirements {
    availability_zone = var.availability_zone
  }

  depends_on = [aws_s3_bucket.staging_bucket]
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.staging_bucket.id
  key    = "scripts/ingest.py"
  source = "${path.module}/src/ingest.py"
  etag   = filemd5("${path.module}/src/ingest.py")

  depends_on = [aws_s3_bucket.staging_bucket]
}

resource "aws_glue_job" "sqlserver_to_s3" {
  name     = "${var.project_prefix}-${var.environment}-ingest-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.staging_bucket_name}/scripts/ingest.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"    = "python"
    "--TempDir"         = "s3://${var.staging_bucket_name}/temp/"
    "--connection-name" = aws_glue_connection.sqlserver_jdbc.name
    "--output_bucket"   = var.staging_bucket_name
    "--enable-metrics"  = ""
  }

  glue_version       = "4.0"
  number_of_workers  = 2
  worker_type        = "G.1X"
  max_retries        = 1

  tags = {
    Project     = var.project_prefix
    Environment = var.environment
  }

  depends_on = [
    aws_glue_catalog_database.companydb,
    aws_glue_connection.sqlserver_jdbc,
    aws_iam_role.glue_role,
    aws_s3_bucket.staging_bucket,
    aws_s3_object.glue_script 
  ]
}
