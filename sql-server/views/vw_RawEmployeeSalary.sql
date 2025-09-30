CREATE VIEW HR.vw_RawEmployeeSalary
AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Department,
    s.Amount,
    s.EffectiveDate,
    s.EndDate
FROM HR.Employees e
JOIN HR.Salaries s
    ON e.EmployeeID = s.EmployeeID;
