terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.45.0"
    }
  }
}

provider "snowflake" {
  account  = var.snowflake_account    # e.g. xy12345.us-east-1.aws
  username = var.snowflake_user       # admin user
  password = var.snowflake_password
  role     = "ACCOUNTADMIN"
  region   = var.snowflake_region
}

# Warehouse para execução de queries
resource "snowflake_warehouse" "etl_wh" {
  name      = "ETL_WH"
  warehouse_size = "XSMALL"
  auto_suspend  = 60
  auto_resume   = true
  initially_suspended = true
  comment    = "Warehouse for ETL jobs"
}

# Database para armazenar tabelas
resource "snowflake_database" "etl_db" {
  name    = "ETL_DB"
  comment = "Database for ETL pipeline"
}

# Schema dentro do database
resource "snowflake_schema" "etl_schema" {
  name      = "PUBLIC"
  database  = snowflake_database.etl_db.name
  comment   = "Default schema"
}

# Role para Glue e Airflow
resource "snowflake_role" "etl_role" {
  name    = "ETL_ROLE"
  comment = "Role for ETL access"
}

# Usuário para ETL (Glue + Airflow)
resource "snowflake_user" "etl_user" {
  name         = "etl_user"
  login_name   = "etl_user"
  password     = var.etl_user_password
  default_role = snowflake_role.etl_role.name
  default_warehouse = snowflake_warehouse.etl_wh.name
  default_namespace = "${snowflake_database.etl_db.name}.${snowflake_schema.etl_schema.name}"
  comment      = "User for ETL Glue and Airflow jobs"
}

# Concede permissões de uso do warehouse e acesso ao database/schema
resource "snowflake_role_grants" "role_grants" {
  role_name = snowflake_role.etl_role.name
  roles     = ["SYSADMIN"]
}

resource "snowflake_database_grant" "db_grant" {
  database_name = snowflake_database.etl_db.name
  privilege     = "USAGE"
  roles         = [snowflake_role.etl_role.name]
}

resource "snowflake_schema_grant" "schema_grant" {
  database_name = snowflake_database.etl_db.name
  schema_name   = snowflake_schema.etl_schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.etl_role.name]
}

resource "snowflake_warehouse_grant" "wh_grant" {
  warehouse_name = snowflake_warehouse.etl_wh.name
  privilege      = "USAGE"
  roles          = [snowflake_role.etl_role.name]
}

resource "snowflake_table_grant" "table_grant" {
  database_name = snowflake_database.etl_db.name
  schema_name   = snowflake_schema.etl_schema.name
  table_name    = "*"  # All tables in schema
  privilege     = "SELECT"
  roles         = [snowflake_role.etl_role.name]
}
