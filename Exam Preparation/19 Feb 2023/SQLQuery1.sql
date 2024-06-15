--01

--CREATE DATABASE Boardgames 

-- Create the Categories table
CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL
);

-- Create the Addresses table
CREATE TABLE Addresses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    StreetName NVARCHAR(100) NOT NULL,
    StreetNumber INT NOT NULL,
    Town VARCHAR(30) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    ZIP INT NOT NULL
);

-- Create the Publishers table
CREATE TABLE Publishers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(30) UNIQUE NOT NULL,
    AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
    Website NVARCHAR(40),
    Phone NVARCHAR(20)
);

-- Create the PlayersRanges table
CREATE TABLE PlayersRanges (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PlayersMin INT NOT NULL,
    PlayersMax INT NOT NULL
);

-- Create the Boardgames table
CREATE TABLE Boardgames (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(30) NOT NULL,
    YearPublished INT NOT NULL,
    Rating DECIMAL(18, 2) NOT NULL,
    CategoryId INT NOT NULL,
    PublisherId INT NOT NULL,
    PlayersRangeId INT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (PublisherId) REFERENCES Publishers(Id),
    FOREIGN KEY (PlayersRangeId) REFERENCES PlayersRanges(Id)
);

-- Create the Creators table
CREATE TABLE Creators (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    Email NVARCHAR(30) NOT NULL
);

CREATE TABLE CreatorsBoardgames
(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id),
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id)
	PRIMARY KEY(CreatorId, BoardgameId)
)

--02

INSERT INTO Boardgames (Name, YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES
    ('Deep Blue', 2019, 5.67, 1, 15, 7),
    ('Paris', 2016, 9.78, 7, 1, 5),
    ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
    ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
    ('One Small Step', 2019, 5.75, 5, 9, 2);

INSERT INTO Publishers (Name, AddressId, Website, Phone)
VALUES
    ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
    ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
    ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907');

--03

UPDATE PlayersRanges
SET PlayersMax = PlayersMax + 1
WHERE PlayersMin = 2 AND PlayersMax = 2


UPDATE Boardgames
SET [Name] = [NAME] + 'V2'
WHERE YearPublished >= 2020

--04

DELETE FROM CreatorsBoardgames WHERE BoardgameId IN (1, 16, 31, 47)
DELETE FROM Boardgames WHERE PublisherId IN (1, 16)
DELETE FROM Publishers WHERE AddressId = 5
DELETE FROM Addresses WHERE Town LIKE 'L%'

--05

SELECT
	[Name],
	Rating
FROM Boardgames
ORDER BY YearPublished, [Name] DESC

--06

SELECT 
	bg.Id AS Id,
	bg.[Name] AS [Name],
	YearPublished,
	c.[Name] AS CategoryName
FROM Boardgames AS bg
JOIN Categories AS c ON bg.CategoryId = c.Id
WHERE c.[Name] IN ('Strategy Games', 'Wargames')
ORDER BY YearPublished DESC

--07

SELECT
	C.Id AS Id,
	CONCAT_WS(' ', FirstName, LastName) AS [Name],
	Email
FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
WHERE cb.BoardgameId IS NULL

--08

SELECT TOP 5
	b.[Name],
	Rating,
	c.[Name] AS CategoryName
FROM Boardgames AS b
JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
JOIN Categories AS c ON b.CategoryId = c.Id
WHERE Rating > 7 AND b.[Name] LIKE '%a%'
OR Rating > 7.5 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5
ORDER BY b.[Name], Rating DESC

--09

SELECT
	CONCAT_WS(' ', FirstName, LastName) AS FullName,
	Email,
	MAX(b.Rating) AS Rating
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
WHERE c.Email LIKE '%.COM'
GROUP BY FirstName, LastName, Email
ORDER BY FullName

--10

SELECT
	LastName,
	CEILING(AVG(b.Rating)) AS AverageRating,
	p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
JOIN Publishers AS p ON b.PublisherId = p.Id
WHERE cb.CreatorId IS NOT NULL AND  p.[Name] = 'Stonemaier Games' 
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

--11

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
    DECLARE @BoardgameCount INT;

    SELECT @BoardgameCount = COUNT(*)
    FROM Creators c
    JOIN CreatorsBoardgames cb ON c.Id = cb.CreatorId
    WHERE c.FirstName = @name;

    RETURN @BoardgameCount;
END;

--12

USE Boardgames
GO

CREATE OR ALTER PROC usp_SearchByCategory(@category NVARCHAR(50)) 
AS
SELECT
	b.Name
	, b.YearPublished
	, b.Rating
	, c.Name AS CategoryName
	, p.Name AS PublisherName
	, CONCAT(pr.PlayersMin, ' people') AS MinPlayers
	, CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
FROM Boardgames AS b
JOIN Categories AS c ON b.CategoryId = c.Id
	AND c.Name = @category
JOIN Publishers AS p ON b.PublisherId = p.Id
JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
ORDER BY PublisherName, YearPublished DESC
GO

EXEC usp_SearchByCategory 'Wargames'