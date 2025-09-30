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

-- Departments
CREATE TABLE HR.Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Departments_Name UNIQUE (Name)
);

-- Positions
CREATE TABLE HR.Positions (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Positions_Departments FOREIGN KEY (DepartmentID)
        REFERENCES HR.Departments(DepartmentID)
);

-- Benefits
CREATE TABLE HR.Benefits (
    BenefitID INT IDENTITY(1,1) PRIMARY KEY,
    Description NVARCHAR(255) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    EmployeeID INT NOT NULL,
    CONSTRAINT FK_Benefits_Employees FOREIGN KEY (EmployeeID)
        REFERENCES HR.Employees(EmployeeID)
);