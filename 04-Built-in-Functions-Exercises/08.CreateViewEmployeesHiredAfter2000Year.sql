CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000