-- Drop column and add FK-based department field
ALTER TABLE HR.Employees
DROP COLUMN Department;

ALTER TABLE HR.Employees
ADD DepartmentID INT NOT NULL;

ALTER TABLE HR.Employees
ADD CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentID)
    REFERENCES HR.Departments(DepartmentID);