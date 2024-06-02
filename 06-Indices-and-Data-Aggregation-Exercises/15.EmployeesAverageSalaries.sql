SELECT * INTO RichPeople
FROM Employees
WHERE Salary > 30000

DELETE FROM RichPeople
WHERE ManagerID = 42

UPDATE RichPeople
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT 
	DepartmentID,
	AVG(Salary) AS AverageSalary
FROM RichPeople
GROUP BY DepartmentID