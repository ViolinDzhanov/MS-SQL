SELECT TOP 5
	e.EmployeeID,
	FirstName,
	P.[Name]
FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE StartDate > '2002-08-13' AND EndDate IS NULL
ORDER BY e.EmployeeID