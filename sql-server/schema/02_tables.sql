-- Employees
CREATE TABLE HR.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT UQ_Employees_Name UNIQUE (FirstName, LastName, HireDate)
);

-- Salaries
CREATE TABLE HR.Salaries (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    EffectiveDate DATE NOT NULL,
    EndDate DATE NULL,
    CONSTRAINT FK_Salaries_Employees FOREIGN KEY (EmployeeID)
        REFERENCES HR.Employees(EmployeeID)
);