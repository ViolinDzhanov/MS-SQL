CREATE PROCEDURE usp_EmployeesBySalaryLevel(@levelOfSalary VARCHAR(10))
AS
	SELECT
		FirstName,
		LastName
	FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @levelOfSalary