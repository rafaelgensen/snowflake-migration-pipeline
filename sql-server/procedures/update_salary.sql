-- Update Salary
CREATE PROCEDURE HR.UpdateSalary
    @EmployeeID INT,
    @NewAmount DECIMAL(12,2),
    @EffectiveDate DATE
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;

    UPDATE HR.Salaries
    SET EndDate = DATEADD(DAY, -1, @EffectiveDate)
    WHERE EmployeeID = @EmployeeID AND EndDate IS NULL;

    INSERT INTO HR.Salaries (EmployeeID, Amount, EffectiveDate, EndDate)
    VALUES (@EmployeeID, @NewAmount, @EffectiveDate, NULL);

    COMMIT;
END;
GO
