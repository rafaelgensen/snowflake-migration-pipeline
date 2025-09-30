CREATE VIEW HR.vw_AvgSalaryByDepartment
AS
SELECT 
    e.Department,
    AVG(s.Amount) AS AvgSalary,
    COUNT(DISTINCT e.EmployeeID) AS NumEmployees,
    MAX(s.Amount) AS MaxSalary,
    MIN(s.Amount) AS MinSalary
FROM HR.Employees e
JOIN HR.Salaries s
    ON e.EmployeeID = s.EmployeeID
WHERE s.EndDate IS NULL
GROUP BY e.Department;
