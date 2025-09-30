import sys
from pyspark.context import SparkContext
from pyspark.sql import SparkSession
from awsglue.utils import getResolvedOptions  # Required to get Glue job arguments

# Get parameters passed automatically by Glue
args = getResolvedOptions(sys.argv, ["JOB_NAME", "connection_name", "output_bucket"])

sc = SparkContext()
spark = SparkSession.builder.appName(args["JOB_NAME"]).getOrCreate()

# JDBC URL for SQL Server (adjust as needed)
jdbc_url = f"jdbc:sqlserver://{args['connection_name']}"

# JDBC connection properties
jdbc_properties = {
    "user": "<your-username>",  # Replace with actual username or fetch securely
    "password": "<your-password>",  # Replace with actual password or fetch securely
    "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver"
}

# Read the HR.Employees table from SQL Server via JDBC
df = spark.read.jdbc(
    url=jdbc_url,
    table="HR.Employees",
    properties=jdbc_properties
)

# Write data as Parquet to the specified S3 output path, appending to existing data
output_path = f"s3://{args['output_bucket']}/data/employees/"

df.write.mode("append").parquet(output_path)

sc.stop()
