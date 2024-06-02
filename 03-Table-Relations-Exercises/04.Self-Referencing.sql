CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY (101, 1),
	[Name] VARCHAR(50),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES('John', NULL)
INSERT INTO Teachers VALUES('Greta', NULL)
INSERT INTO Teachers VALUES('Mark', NULL)
INSERT INTO Teachers VALUES('Ted', NULL)
INSERT INTO Teachers VALUES('Maya', NULL)
INSERT INTO Teachers VALUES('Silvia', NULL)	
--OR
UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID in (102, 103)
SELECT * FROM Teachers