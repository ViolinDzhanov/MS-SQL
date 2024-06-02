
WITH DepartmentAVGSalaries AS
(
	SELECT DepartmentID, AVG(Salary) AS AverageSalary
	FROM Employees
	GROUP BY DepartmentID
)
SELECT TOP 10
	FirstName,
	LastName,
	e.DepartmentID
FROM Employees AS e
JOIN DepartmentAVGSalaries AS das ON das.DepartmentID = e.DepartmentID
WHERE e.Salary > das.AverageSalary
ORDER BY E.DepartmentID 