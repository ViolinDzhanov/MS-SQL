SELECT COUNT(*)
FROM Countries
WHERE CountryCode NOT IN (SELECT DISTINCT CountryCode FROM MountainsCountries)