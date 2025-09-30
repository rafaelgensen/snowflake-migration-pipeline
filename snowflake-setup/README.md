# Snowflake Infrastructure for ETL – Terraform Provisioning

This project defines the necessary Snowflake infrastructure to support ETL pipelines using AWS Glue and Apache Airflow, fully provisioned via Terraform.

## 📦 Provisioned Components

- **Warehouse**: `ETL_WH` – for executing ETL jobs.
- **Database**: `ETL_DB` – dedicated ETL database.
- **Schema**: `PUBLIC` – default schema.
- **Role**: `ETL_ROLE` – with controlled access.
- **User**: `etl_user` – used by tools like Glue and Airflow.
- **Grants**: Specific permissions for warehouse, database, schema, and `SELECT` access to tables.

---

## ⚙️ Variables

All required variables are declared in `variables.tf`. Be sure to populate your sensitive values in a `terraform.tfvars` file (excluded from version control).

---

## 🚀 Advantages of Running Snowflake on AWS

The decision to host Snowflake **within AWS** (e.g. `xy12345.us-east-1.aws`) offers multiple strategic and operational advantages:

### ✅ Native Integration with AWS Services

- **Glue**: Easily use Snowflake as a source or destination with secure JDBC or native Snowflake connectors.
- **S3**: Snowflake can directly access S3 buckets with low latency and reduced data transfer costs, simplifying ingestion/export.
- **IAM & Networking**: You can leverage PrivateLink, NAT gateways, and fine-grained access control via IAM roles.
- **Airflow (MWAA or ECS)**: Communication between Airflow and Snowflake happens within the same cloud, reducing latency and networking complexity.

---

## ⚖️ Trade-offs

By choosing to run Snowflake inside AWS:

| Advantage                             | Potential Trade-off                  |
|--------------------------------------|--------------------------------------|
| Tight integration with AWS Glue/S3   | Some degree of cloud vendor lock-in  |
| Lower latency for data operations    | May depend on AWS-specific services  |
| Optimized costs for data movement    | Multi-cloud flexibility is reduced   |

---

## 📋 Running `CREATE TABLE` via Airflow

A common use case in data pipelines is to dynamically create tables using schema files or business logic.

### How to do this in Airflow:

1. **Configure a Snowflake connection** in the Airflow UI or as an environment variable.
   - Use the `etl_user` provisioned by Terraform.

2. **Use the `SnowflakeOperator`** from the official Airflow provider:
   ```python
   from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator

   create_table = SnowflakeOperator(
       task_id='create_table',
       sql="""
           CREATE TABLE IF NOT EXISTS ETL_DB.PUBLIC.my_table (
               id INT,
               name STRING,
               created_at TIMESTAMP
           )
       """,
       snowflake_conn_id='snowflake_default',
       warehouse='ETL_WH',
       role='ETL_ROLE',
       database='ETL_DB',
       schema='PUBLIC',
       dag=dag
   )
    ```

3. **Version control**: You can manage your SQL scripts in separate `.sql` files or integrate with **dbt**, which can be orchestrated and executed via Airflow. This allows for:

   - Easier collaboration on data model definitions.
   - Better tracking of schema changes over time.
   - Modular and testable SQL logic.

---

## 🛡️ Security

- All sensitive credentials (like passwords) are defined as `sensitive` variables in Terraform.
- The ETL user (`etl_user`) is granted only the minimal required privileges, following the **least privilege principle**.
- Role inheritance from `SYSADMIN` is limited to the initial provisioning steps when absolutely required.

---

## 📂 Project Structure

```yml
├── main.tf # Main infrastructure definition
├── variables.tf # Variables declaration
├── terraform.tfvars # (Not included) Your variable values
├── README.md # This documentation
```
