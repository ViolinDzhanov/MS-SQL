SELECT
	CountryCode,
	MountainRange,
	PeakName,
	Elevation
FROM MountainsCountries AS mc
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON m.Id = p.MountainId
WHERE CountryCode = 'BG' AND Elevation > 2835
ORDER BY Elevation DESC