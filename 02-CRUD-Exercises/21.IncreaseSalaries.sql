SELECT * FROM [Departments]

UPDATE [Employees]
	SET [Salary] = [Salary] * 1.12
	WHERE [DepartmentID] IN (1, 2,  4, 11)  

SELECT [Salary] FROM [Employees] 

UPDATE [Employees]
	SET [Salary] = [Salary] / 1.12
	WHERE [DepartmentID] IN (1, 2,  4, 11) 