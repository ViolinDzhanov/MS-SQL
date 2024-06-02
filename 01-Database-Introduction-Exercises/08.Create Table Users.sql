CREATE TABLE Users
(
 Id BIGINT PRIMARY KEY IDENTITY,
 Username VARCHAR(30) NOT NULL,
 [Password] VARCHAR(26) NOT NULL,
 ProfilePicture VARBINARY(MAX),
 LastLoginTime DATETIME2,
 IsDeleted BIT
)

INSERT INTO Users(Username, [Password])
	VALUES ('Pesho', '123456'),
	       ('Gosho', '732568'),
		   ('Stamat', '952364'),
		   ('Dimitrichko', '324859'),
		   ('Stanka', '932654')

SELECT * FROM Users