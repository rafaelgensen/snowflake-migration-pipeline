-- Add Employee
CREATE PROCEDURE HR.AddEmployee
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @HireDate DATE,
    @Department NVARCHAR(50)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;

    INSERT INTO HR.Employees (FirstName, LastName, HireDate, Department)
    VALUES (@FirstName, @LastName, @HireDate, @Department);

    COMMIT;
END;
GO

