resource "aws_mwaa_environment" "main" {
  name = "${var.project_prefix}-${var.environment}-mwaa"

  airflow_version     = "2.8.1"
  environment_class   = "mw1.small"
  execution_role_arn  = aws_iam_role.mwaa_execution_role.arn
  source_bucket_arn   = aws_s3_bucket.staging_bucket.arn
  dag_s3_path         = "dags/"
  requirements_s3_path = "requirements.txt"

  network_configuration {
    security_group_ids = [var.mwaa_security_group_id]
    subnet_ids         = var.mwaa_subnet_ids
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  airflow_configuration_options = {
    "core.load_examples" = "False"
  }

  tags = {
    Project     = var.project_prefix
    Environment = var.environment
  }

  depends_on = [
    aws_s3_object.mwaa_requirements,
    aws_s3_object.mwaa_dag,
    aws_iam_role.mwaa_execution_role
  ]
}

# Upload da DAG
resource "aws_s3_object" "mwaa_dag" {
  bucket = aws_s3_bucket.staging_bucket.id
  key    = "dags/dag.py"
  source = "${path.module}/src/dag.py"
  etag   = filemd5("${path.module}/src/dag.py")

  depends_on = [aws_s3_bucket.staging_bucket]
}

# Upload do requirements.txt
resource "aws_s3_object" "mwaa_requirements" {
  bucket = aws_s3_bucket.staging_bucket.id
  key    = "requirements.txt"
  source = "${path.module}/src/requirements.txt"
  etag   = filemd5("${path.module}/src/requirements.txt")

  depends_on = [aws_s3_bucket.staging_bucket]
}
