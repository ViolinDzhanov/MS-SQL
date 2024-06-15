--CREATE DATABASE NationalTouristSitesOfBulgaria
--USE NationalTouristSitesOgBulgaria

--01

CREATE TABLE Categories(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL
)

CREATE TABLE Locations(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Municipality VARCHAR(50),
Province VARCHAR(50)
)

CREATE TABLE Sites(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
LocationId INT NOT NULL FOREIGN KEY REFERENCES Locations(Id), 
CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
Establishment VARCHAR(15)
)

CREATE TABLE Tourists(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Age INT NOT NULL 
	CHECK(Age >= 0 AND Age <= 120),
PhoneNumber VARCHAR(20) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Reward VARCHAR(20)
)

CREATE TABLE SitesTourists(
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id),
SiteId INT NOT NULL FOREIGN KEY REFERENCES Sites(Id),
PRIMARY KEY (TouristId, SiteId)
)

CREATE TABLE BonusPrizes(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes(
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id),
BonusPrizeId INT NOT NULL FOREIGN KEY REFERENCES BonusPrizes(Id),
PRIMARY KEY (TouristId, BonusPrizeId)
)

--2. Insert
INSERT INTO Tourists(Name, Age, PhoneNumber, Nationality, Reward) VALUES
('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
('Peter Bosh', 48, '+447911844141', 'UK', NULL),
('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites(Name, LocationId, CategoryId, Establishment) VALUES
('Ustra fortress', 90, 7, 'X'),
('Karlanovo Pyramids', 65, 7, NULL),
('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
('Sinite Kamani Natural Park', 17, 1, null),
('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

--03

UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL

--04

DELETE FROM TouristsBonusPrizes WHERE BonusPrizeId = 5
DELETE FROM BonusPrizes WHERE [Name] = 'Sleeping bag'

--05

SELECT
	[Name],
	Age,
	PhoneNumber,
	Nationality
FROM Tourists
ORDER BY Nationality, Age DESC, [Name]

--06

SELECT
	s.[Name] AS [Site],
	l.[Name] AS [Location],
	Establishment,
	c.[Name]
FROM Sites AS s
JOIN Categories AS c ON s.CategoryId = c.Id
JOIN Locations AS l ON s.LocationId = l.Id
ORDER BY c.[Name] DESC, l.[Name], s.[Name]

--07

SELECT
	l.Province
	, l.Municipality
	, l.[Name] AS Location
	, COUNT(s.Id) AS CountOfSites
FROM Sites AS s
JOIN Locations AS l ON s.LocationId = l.Id
WHERE l.Province = 'Sofia'
GROUP BY l.Province, l.Municipality, l.Name
ORDER BY CountOfSites DESC, Location

--08

SELECT 
	s.[Name] AS 'Site', 
	l.Name AS 'Location',
	l.Municipality, 
	l.Province, 
	s.Establishment 
FROM Sites AS s
JOIN Locations AS l ON s.LocationId = l.Id
WHERE LEFT(l.[Name], 1) NOT LIKE '[B,M,D]'
AND s.Establishment LIKE '%BC'
ORDER BY s.[Name]

--09

SELECT
	t.[Name]
	, t.Age
	, t.PhoneNumber
	, t.Nationality
	, COALESCE(b.[Name], '(no bonus prize)') AS Reward
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb ON tb.TouristId = t.Id
LEFT JOIN BonusPrizes AS b ON tb.BonusPrizeId = b.Id
ORDER BY t.[Name]

--10

SELECT DISTINCT
	SUBSTRING(t.[Name], CHARINDEX(' ', t.Name, 1) + 1, LEN(t.Name) - CHARINDEX(' ', t.Name, 1)) AS LastName
	, Nationality
	, t.Age
	, t.PhoneNumber
FROM Tourists AS t
JOIN SitesTourists AS st ON st.TouristId = t.Id
JOIN Sites AS s ON st.SiteId = s.Id
JOIN Categories AS c ON s.CategoryId = c.Id
WHERE c.[Name] = 'History and archaeology'
ORDER BY LastName

--11

CREATE OR ALTER FUNCTION udf_GetTouristsCountOnATouristSite 
	(@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
RETURN 
(
	SELECT
		COUNT(*)
	FROM Tourists AS t
	JOIN SitesTourists AS st ON st.TouristId = t.Id
	JOIN Sites AS s ON st.SiteId = s.Id
	WHERE s.[Name] = @Site 
)
END

--12

CREATE OR ALTER PROC usp_AnnualRewardLottery
	(@TouristName VARCHAR(50))
AS
UPDATE Tourists
SET Reward = CASE 
		WHEN (SELECT COUNT(*) FROM SitesTourists WHERE TouristId = Tourists.Id) >= 100 THEN 'Gold badge'
		WHEN (SELECT COUNT(*) FROM SitesTourists WHERE TouristId = Tourists.Id) >= 50 THEN 'Silver badge'
		WHEN (SELECT COUNT(*) FROM SitesTourists WHERE TouristId = Tourists.Id) >= 25 THEN 'Bronze badge'
	ELSE Reward
END
WHERE Name = @TouristName
SELECT Name, Reward FROM Tourists WHERE Name = @TouristName