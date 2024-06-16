--01

CREATE TABLE Contacts
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Email NVARCHAR(100) NULL,
	PhoneNumber NVARCHAR(20) NULL,
	PostAddress NVARCHAR(200) NULL,
	Website NVARCHAR(50) NULL
)

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(100) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Libraries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Genres
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
)

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(100) NOT NULL,
	YearPublished INT NOT NULL,
	ISBN NVARCHAR(13) UNIQUE NOT NULL,
	AuthorId INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL
)

CREATE TABLE LibrariesBooks
(
	LibraryId INT FOREIGN KEY REFERENCES Libraries(Id) NOT NULL,
	BookId INT FOREIGN KEY REFERENCES Books(Id) NOT NULL
    PRIMARY KEY(LibraryId, BookId)
)

--02

INSERT INTO Contacts ( Email, PhoneNumber, PostAddress, Website)
VALUES 
    ( NULL, NULL, NULL, NULL),
    ( NULL, NULL, NULL, NULL),
    ( 'stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
    ( 'suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com');

INSERT INTO Authors ( [Name], ContactId)
VALUES 
    ( 'George Orwell', 21),
    ( 'Aldous Huxley', 22),
    ( 'Stephen King', 23),
    ( 'Suzanne Collins', 24);

INSERT INTO Books (Title, YearPublished, ISBN, AuthorId, GenreId)
VALUES 
    ('1984', 1949, '9780451524935', 16, 2),
    ('Animal Farm', 1945, '9780451526342', 16, 2),
    ('Brave New World', 1932, '9780060850524', 17, 2),
    ('The Doors of Perception', 1954, '9780060850531', 17, 2),
    ('The Shining', 1977, '9780307743657', 18, 9),
    ('It', 1986, '9781501142970', 18, 9),
    ('The Hunger Games', 2008, '9780439023481', 19, 7),
    ('Catching Fire', 2009, '9780439023498', 19, 7),
    ('Mockingjay', 2010, '9780439023511', 19, 7);

INSERT INTO LibrariesBooks (LibraryId, BookId)
VALUES 
    (1, 36),
    (1, 37),
    (2, 38),
    (2, 39),
    (3, 40),
    (3, 41),
    (4, 42),
    (4, 43),
    (5, 44);
--03

UPDATE Contacts
SET Website = 'www.' + REPLACE(LOWER(a.Name), ' ', '') + '.com'
FROM Contacts c
JOIN Authors a ON c.Id = a.ContactId
WHERE c.Website IS NULL;

--04

DELETE FROM LibrariesBooks WHERE BookId = 1
DELETE FROM Books WHERE AuthorId = 1
--DELETE FROM Contacts 
DELETE FROM Authors WHERE [Name] = 'Alex Michaelides' 

--05

SELECT 
    Title AS [Book Title], 
    ISBN, 
    YearPublished AS [YearReleased]
FROM  Books
ORDER BY 
    YearPublished DESC, 
    Title ASC;

--06

SELECT 
    B.Id, 
    B.Title, 
    B.ISBN, 
    G.[Name] AS Genre
FROM Books AS b
JOIN Genres AS g ON b.GenreId = g.Id
WHERE 
    g.[Name] IN ('Biography', 'Historical Fiction')
ORDER BY 
    g.[Name] ASC, 
    b.Title ASC;

--07

SELECT
	l.[Name] AS [Library],
	c.Email AS Email
FROM Libraries AS l
JOIN LibrariesBooks AS lb ON l.Id = lb.LibraryId
JOIN Books AS b ON b.Id = lb.BookId
JOIN Genres AS g ON b.GenreId = g.Id
JOIN Contacts AS c ON  l.ContactId = c.Id
GROUP BY l.[Name], c.Email
HAVING COUNT(CASE WHEN g.[Name] = 'Mystery' THEN 1 ELSE NULL END) = 0
ORDER BY l.[Name] ASC

--08

SELECT TOP 3
    b.Title,
    b.YearPublished AS [Year],
    g.[Name] AS Genre
FROM
    Books AS b
JOIN Genres  AS g ON b.GenreId = g.Id
WHERE
    (b.YearPublished > 2000 AND b.Title LIKE '%a%')
    OR
    (b.YearPublished < 1950 AND g.[Name] LIKE '%Fantasy%')
ORDER BY
    B.Title ASC,
    B.YearPublished DESC;

--09

SELECT 
    a.[Name] AS Author,
    c.Email,
    c.PostAddress AS [Address]
FROM 
    Authors AS a
JOIN Contacts AS c ON a.ContactId = c.Id
WHERE 
    c.PostAddress LIKE '%UK%'
ORDER BY 
    a.[Name] ASC;

--10

SELECT 
    A.[Name] AS Author,
    B.Title,
    L.[Name] AS [Library],
    C.PostAddress AS LibraryAddress
FROM 
    Books B
JOIN 
    Authors A ON B.AuthorId = A.Id
JOIN 
    LibrariesBooks LB ON B.Id = LB.BookId
JOIN 
    Libraries L ON LB.LibraryId = L.Id
JOIN 
    Contacts C ON L.ContactId = C.Id
JOIN 
    Genres G ON B.GenreId = G.Id
WHERE 
    G.[Name] = 'Fictions'
    AND C.PostAddress LIKE '%Denver%'
ORDER BY 
    B.Title ASC;

--11

CREATE FUNCTION udf_AuthorsWithBooks (@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TotalBooks INT;

    SELECT @TotalBooks = COUNT(*)
    FROM Books B
    JOIN Authors A ON B.AuthorId = A.Id
    JOIN LibrariesBooks LB ON B.Id = LB.BookId
    JOIN Libraries L ON LB.LibraryId = L.Id
    WHERE A.Name = @name;

    RETURN @TotalBooks;
END;

--12

CREATE PROCEDURE usp_SearchByGenre
    @genreName NVARCHAR(100)
AS
BEGIN

    SELECT
        B.Title AS Title,
        B.YearPublished AS Year,
        B.ISBN AS ISBN,
        A.Name AS Author,
        G.Name AS Genre
    FROM
        Books B
        JOIN Authors A ON B.AuthorId = A.Id
        JOIN Genres G ON B.GenreId = G.Id
    WHERE
        G.Name = @genreName
    ORDER BY
        B.Title ASC;
END;