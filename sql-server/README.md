# SQL Server Module – CompanyDB

## Overview
This module defines the OLTP source system used in the portfolio project.  
It simulates a simplified HR domain with employees, salary history, departments, positions, and benefits.

```mermaid
erDiagram
    HR_Employees {
        int EmployeeID PK
        nvarchar FirstName
        nvarchar LastName
        date HireDate
        int DepartmentID FK
        bit IsActive
    }

    HR_Salaries {
        int SalaryID PK
        int EmployeeID FK
        decimal Amount
        date EffectiveDate
        date EndDate
    }

    HR_Departments {
        int DepartmentID PK
        varchar Name
    }

    HR_Positions {
        int PositionID PK
        int DepartmentID FK
        varchar Title
    }

    HR_Benefits {
        int BenefitID PK
        nvarchar Description
        date StartDate
        date EndDate
        int EmployeeID FK
    }

    %% Relationships
    HR_Employees ||--o{ HR_Salaries : "has salaries"
    HR_Departments ||--o{ HR_Positions : "has positions"
    HR_Employees ||--o{ HR_Benefits : "receives benefits"
    HR_Departments ||--o{ HR_Employees : "belongs to department"

    %% Views (not physical tables, but shown as derived entities)
    vw_RawEmployeeSalary }o--|| HR_Employees : "derived from"
    vw_RawEmployeeSalary }o--|| HR_Salaries : "derived from"

    vw_AvgSalaryByDepartment }o--|| HR_Employees : "derived from"
    vw_AvgSalaryByDepartment }o--|| HR_Salaries : "derived from"
```

## Structure
```sql
/sql-server/
├── schema/ # DDL scripts (schemas, tables, indexes, constraints)
├── procedures/ # Stored procedures for OLTP operations
├── views/ # Consumption layer (views for ETL/Glue)
├── seed/ # Initial inserts (sample data)
└── README.md
```

## Key Design Choices and Trade-offs

- **Historical salaries**: Stored with `EffectiveDate` and `EndDate`.  
  - Pros: Enables SCD Type 2–style processing.  
  - Cons: Slightly more complex to query and maintain.

- **Indexes**:  
  - `IX_Salaries_Employee_EffectiveDate`: speeds up “latest salary” queries.  
  - `IX_Employees_Department`: supports department-level lookups.  
  - Trade-off: Write operations pay extra cost on insert/update.

- **Stored procedures** (`AddEmployee`, `UpdateSalary`):  
  - Pros: Encapsulates logic, consistency in DML operations.  
  - Cons: More objects to maintain.

- **Isolation level SERIALIZABLE** in procedures:  
  - Pros: Strong consistency.  
  - Cons: Lower concurrency under heavy workloads. In real-world scenarios, `READ COMMITTED SNAPSHOT` is often preferred.

- **Consumption layer via views**:  
  - `vw_EmployeeCurrentSalary` exposes current salary without ETL embedding business logic.  
  - Trade-off: Additional object to maintain, but decouples ETL from transactional schema.

- **3NF**: 
  - For OLTP consistency. 

## Views: Raw vs. Analytical

The SQL Server module includes two view styles for simulating ingestion scenarios:

### 1. Raw Views
Example: `vw_RawEmployeeSalary`
- Direct exposure of transactional data, without transformation.
- Useful as a **staging layer** for ETL.
- Maintains flexibility: the Data Warehouse (DWH) concentrates the analytical logic.
- **Trade-offs**: greater volume of data transferred and higher processing costs in the DWH.

### 2. Analytical Views
Example: `vw_AvgSalaryByDepartment`
- Pre-calculates metrics (average, maximum, minimum, count).
- Reduces data traffic and simplifies consumption when metrics are fixed.
- **Trade-offs**: adds load on OLTP, reduces flexibility, and makes metrics governance more difficult (rules are outside the DWH).

### Recommended Decision
- In real-world scenarios, prioritize raw views as the ingestion point and calculate metrics in the DWH (Snowflake, Redshift, etc.).
- Analytical views can be used when "official" metrics already exist in the OLTP, but it's best practice to replicate the logic in the DWH to ensure consistency.

## Additional Setup

- Permissions: consider creating dedicated `etl_user` with SELECT-only access.  
- SQL Server Agent jobs can be scripted to simulate automated inserts/updates.  
- Seed data included for testing ETL pipelines.

---

## Database Documentation Support

This document was generated with the help of a language model (LLM), which analyzed and interpreted the SQL DDL and view definitions from the existing database. Based on this input, the schema was reviewed, and improvements were suggested to better align with normalization best practices (up to 3rd Normal Form).

### Key Contributions

- Identified and resolved denormalization issues in the `HR.Employees` table by replacing a textual `Department` field with a foreign key (`DepartmentID`) referencing a new `HR.Departments` table.
- Created the missing tables: `HR.Departments`, `HR.Positions`, and `HR.Benefits`, including appropriate primary and foreign key constraints.
- Refactored existing views (`vw_RawEmployeeSalary`, `vw_AvgSalaryByDepartment`) to match the updated, normalized schema.
- Provided corrected DDL statements for schema adjustments and view definitions.
- Ensured that all table and column names follow consistent, clear naming conventions.

This process helped organize and document the HR schema structure more effectively, making it easier to maintain, extend, and integrate with modern data pipelines or analytics workflows.
