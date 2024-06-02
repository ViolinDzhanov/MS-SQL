SELECT 
	CountryCode,
	COUNT(MountainRange) AS MountainRanges
FROM MountainsCountries AS mc
JOIN Mountains AS m ON mc.MountainId = M.Id
WHERE CountryCode IN ('BG', 'RU', 'US')
GROUP BY CountryCode