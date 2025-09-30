-- Strategic Indexes
CREATE NONCLUSTERED INDEX IX_Salaries_Employee_EffectiveDate
    ON HR.Salaries(EmployeeID, EffectiveDate DESC);

CREATE NONCLUSTERED INDEX IX_Employees_Department
    ON HR.Employees(Department);
