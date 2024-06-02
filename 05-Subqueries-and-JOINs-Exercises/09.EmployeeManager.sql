
SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	ep.FirstName
FROM Employees AS e
JOIN Employees AS ep ON e.ManagerID = ep.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID