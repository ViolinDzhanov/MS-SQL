SELECT ProductName, OrderDate, [Pay Due] =
	DATEADD(DAY, 3, OrderDate),
	[Deliver Due] = DATEADD(MONTH, 1, OrderDate)
FROM ORDERS