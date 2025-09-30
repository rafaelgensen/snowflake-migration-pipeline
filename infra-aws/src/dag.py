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

    run_glue_job = AwsGlueJobOperator(
        task_id="run_glue_ingestion",
        job_name="dp-dev-ingest-job",  
    )

    load_into_snowflake = SnowflakeOperator(
        task_id="load_to_snowflake",
        sql="COPY INTO my_table FROM @my_stage FILE_FORMAT = (TYPE = PARQUET);",
        snowflake_conn_id="snowflake_default",  
    )

    run_glue_job >> load_into_snowflake
