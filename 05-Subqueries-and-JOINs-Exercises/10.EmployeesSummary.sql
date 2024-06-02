SELECT TOP 50
	e.EmployeeID,
	CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName,
	CONCAT_WS(' ', ep.FirstName, ep.LastName) AS ManagerName,
	d.[Name]
FROM Employees AS e
JOIN Employees AS ep ON e.ManagerID = ep.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY E.EmployeeID