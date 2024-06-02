SELECT Username, IpAddress
FROM Users
WHERE IpAddress LIKE '___.1%._%.___'
ORDER BY Username