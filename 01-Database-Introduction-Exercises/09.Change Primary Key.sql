ALTER TABLE Users
 DROP CONSTRAINT PK__Users__3214EC07A089F177

 ALTER TABLE Users
	ADD CONSTRAINT PK_UsersTable PRIMARY KEY(Id, Username)