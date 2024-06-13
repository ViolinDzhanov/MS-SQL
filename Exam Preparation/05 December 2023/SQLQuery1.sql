--01

CREATE DATABASE RailwaysDb

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE RailwayStations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Trains
(
	Id INT PRIMARY KEY IDENTITY,
	HourOfDeparture VARCHAR(5) NOT NULL,
	HourOfArrival VARCHAR(5) NOT NULL,
	DepartureTownId INT REFERENCES Towns(Id),
	ArrivalTownId INT REFERENCES Towns(Id)
)

CREATE TABLE TrainsRailwayStations
(
	TrainId INT FOREIGN KEY REFERENCES Trains(Id),
	RailwayStationId INT FOREIGN KEY REFERENCES RailwayStations(Id)
	PRIMARY KEY(TrainId, RailwayStationId)
)

CREATE TABLE MaintenanceRecords
(
	Id INT PRIMARY KEY IDENTITY,
	DateOfMaintenance DATE NOT NULL,
	Details VARCHAR(2000) NOT NULL,
	TrainId INT FOREIGN KEY REFERENCES Trains(Id)
)

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(18,2) NOT NULL,
	DateOfDeparture DATE NOT NULL,
	DateOfArrival DATE NOT NULL,
	TrainId INT FOREIGN KEY REFERENCES Trains(Id),
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id)
)

--02

INSERT INTO Trains
VALUES
	('07:00', '19:00', 1, 3),
	('08:30', '20:30', 5, 6),
	('09:00', '21:00', 4, 8),
	('06:45', '03:55', 27, 7),
	('10:15', '12:15', 15, 5)

INSERT INTO TrainsRailwayStations
VALUES
	(36, 1),
	(36, 4),
	(36, 31),
	(37, 60),
	(37, 16),
	(38, 10),
	(39, 3),
	(39, 31),
	(39, 19),
	(36, 57),
	(36, 7),
	(37, 13),
	(37, 54),
	(38, 50),
	(38, 52),
	(38, 22),
	(39, 68),
	(40, 41),
	(40, 7),
	(40, 52),
	(40, 13)

INSERT INTO Tickets
VALUES
	(90.00,	'2023-12-01',	'2023-12-01',	36,	1),
	(115.00, '2023-08-02',	'2023-08-02',	37,	2),
	(160.00, '2023-08-03',	'2023-08-03',	38,	3),
	(255.00, '2023-09-01',	'2023-09-02',	39,	21),
	(95.00,	'2023-09-02',	'2023-09-03',	40,	22)

--03

UPDATE Tickets
SET
	DateOfDeparture = DATEADD(DAY, 7, DateOfDeparture),
	DateOfArrival = DATEADD(DAY, 7, DateOfArrival)
WHERE DateOfDeparture > '2023-10-31'

--04
BEGIN  TRANSACTION 

DECLARE @trainId INT

SELECT TOP 1
	@trainId = tr.Id 
	FROM Trains AS tr
	JOIN Towns AS t ON tr.DepartureTownId = t.Id
	WHERE t.Name = 'Berlin';

DELETE FROM Tickets
WHERE TrainId = @trainId

DELETE FROM MaintenanceRecords
WHERE TrainId = @trainId

DELETE FROM TrainsRailwayStations
WHERE TrainId = @trainId

DELETE FROM Trains
WHERE Id = @trainId

ROLLBACK

--05

SELECT
	DateOfDeparture,
	Price
FROM Tickets
ORDER BY Price, DateOfDeparture DESC

--06

SELECT
	p.[Name],
	tr.Price,
	tr.DateOfDeparture,
	tr.TrainId
FROM Tickets AS tr
JOIN Passengers AS p ON tr.PassengerId = p.Id
ORDER BY tr.Price DESC, p.[Name]

--07
SELECT
	t.[Name] AS Town
	,rs.[Name] AS RailwayStation
FROM RailwayStations AS rs
LEFT JOIN TrainsRailwayStations AS trs ON rs.Id = trs.RailwayStationId
JOIN Towns AS t ON rs.TownId = t.Id
WHERE trs.TrainId IS NULL
ORDER BY Town, RailwayStation


--08

SELECT TOP 3
	tr.Id AS TrainId,
	tr.HourOfDeparture AS HourOfDeparture,
	tk.Price,
	t.[Name]
FROM Trains AS tr
JOIN Tickets AS tk ON tk.TrainId = tr.Id
JOIN Towns AS t ON tr.ArrivalTownId = t.Id
WHERE tr.HourOfDeparture LIKE '08:%' AND tk.Price > 50.00
ORDER BY tk.Price

--09

SELECT
	t.[Name] AS TownName,
	COUNT(*) AS PassengersCount
FROM Tickets AS tk
JOIN Trains AS tr ON tk.TrainId = tr.Id
JOIN Towns AS t ON tr.ArrivalTownId = t.Id
WHERE tk.Price > 76.99
GROUP BY t.[Name]
ORDER BY t.[Name]

--10

SELECT 
	tr.Id AS TrainID,
	t.[Name] AS DepartureTown,
	mr.Details AS Details
FROM MaintenanceRecords AS mr
JOIN Trains AS tr ON mr.TrainId = tr.Id 
JOIN Towns AS t ON tr.DepartureTownId = t.Id
WHERE mr.Details LIKE '%inspection%'
ORDER BY TrainId

--11

CREATE OR ALTER FUNCTION udf_TownsWithTrains(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @result INT
	SELECT 
		@result = COUNT(*)
	FROM Trains AS tr
	WHERE tr.DepartureTownId = (SELECT Id FROM Towns WHERE Name = @name) OR
			tr.ArrivalTownId = (SELECT Id FROM Towns WHERE Name = @name)
	RETURN @result
END

SELECT dbo.udf_TownsWithTrains('Paris') AS "Output"

--12

CREATE OR ALTER PROC usp_SearchByTown(@townName NVARCHAR(30))
AS
SELECT
	p.Name AS PassengerName
	,tc.DateOfDeparture AS DateOfDeparture
	,tr.HourOfDeparture AS HourOfDeparture
FROM Passengers AS p
JOIN Tickets AS tc ON p.Id = tc.PassengerId
JOIN Trains AS tr ON tc.TrainId = tr.Id
JOIN Towns AS tn ON tr.ArrivalTownId = tn.Id
WHERE tn.Name = @townName
ORDER BY DateOfDeparture DESC, PassengerName

EXEC usp_SearchByTown 'Berlin'