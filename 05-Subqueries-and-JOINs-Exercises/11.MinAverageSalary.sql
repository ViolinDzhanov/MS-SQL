SELECT TOP 1 AVG(Salary) MinAverageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY MinAverageSalary