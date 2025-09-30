CREATE VIEW HR.vw_RawEmployeeSalary AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.Name AS Department,
    s.Amount,
    s.EffectiveDate,
    s.EndDate
FROM HR.Employees e
JOIN HR.Salaries s
    ON e.EmployeeID = s.EmployeeID
JOIN HR.Departments d
    ON e.DepartmentID = d.DepartmentID;