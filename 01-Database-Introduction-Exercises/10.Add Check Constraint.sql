ALTER TABLE Users
	ADD CONSTRAINT CHK_PasswordAtLeastFiveSymbols
	CHECK(LEN([Password]) >= 5)