from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import AwsGlueJobOperator
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from datetime import datetime

default_args = {
    "owner": "data-platform",
    "retries": 1,
}

with DAG(
    dag_id="sqlserver_to_snowflake_pipeline",
    default_args=default_args,
    start_date=datetime(2025, 9, 30),
    schedule_interval="@daily",
    catchup=False,
    tags=["etl", "glue", "snowflake"]
) as dag:

    # Task 1: Run Glue job to ingest data from SQL Server and dump as Parquet in S3
    run_glue_job = AwsGlueJobOperator(
        task_id="run_glue_ingestion",
        job_name="dp-dev-ingest-job",
    )

    # Task 2: Create Snowflake table if it doesn't exist
    create_table = SnowflakeOperator(
        task_id="create_snowflake_table",
        sql="""
        CREATE TABLE IF NOT EXISTS my_table (
            EmployeeID INT,
            FirstName STRING,
            LastName STRING,
            BirthDate DATE,
            HireDate DATE,
            Department STRING
        );
        """,
        snowflake_conn_id="snowflake_default",
    )

    # Task 3: Load data from S3 into Snowflake
    load_into_snowflake = SnowflakeOperator(
        task_id="load_to_snowflake",
        sql="""
        COPY INTO my_table
        FROM @my_stage
        FILE_FORMAT = (TYPE = PARQUET);
        """,
        snowflake_conn_id="snowflake_default",
    )

    run_glue_job >> create_table >> load_into_snowflake
