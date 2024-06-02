
SELECT 
	FirstName,
	LastName,
	HireDate,
	d.[Name]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = D.DepartmentID
WHERE d.[Name] IN ('Sales', 'Finance')
	AND HireDate > '1999-01-01'
ORDER BY HireDate