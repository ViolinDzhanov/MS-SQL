CREATE TABLE People
(
 Id INT PRIMARY KEY IDENTITY,
 [Name] NVARCHAR(200) NOT NULL,
 Picture VARBINARY(MAX),
 Height DECIMAL(3,2),
 [Weight] DECIMAL(5,2),
 Gender CHAR(1) NOT NULL
	CHECK (Gender in('m', 'f')),
 Birthdate DATETIME2 NOT NULL,
 Biography NVARCHAR(MAX)
 )

 INSERT INTO People([Name], Height, [Weight], Gender, Birthdate)
	VALUES ('Velio', 1.78, 75, 'm', '1986-12-06'),
	       ('Tedi', 1.60, 44, 'f', '1991-11-23'),
		   ('Neli', 1.68, 98, 'f', '1962-11-26'),
		   ('Ivan', 1.76, 88, 'm', '1961-11-28'),
		   ('Petia', 1.70, 58, 'f', '1994-03-09')