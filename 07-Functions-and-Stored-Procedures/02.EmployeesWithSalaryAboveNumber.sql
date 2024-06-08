CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAboveNumber(@amount DECIMAL(18,4))
AS
	SELECT 
		FirstName,
		LastName
	FROM Employees
WHERE Salary >= @amount