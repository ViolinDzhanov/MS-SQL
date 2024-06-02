SELECT TOP (5)
	CountryName,
	MAX(Elevation) AS HighestPeakElevation,
	MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId 
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
GROUP BY 
	CountryName
ORDER BY
	HighestPeakElevation DESC,
	LongestRiverLength DESC,
	CountryName

SELECT TOP(5) 
      c.CountryName
     ,CASE WHEN p.Elevation = NULL
	  THEN NULL
	  ELSE MAX(p.Elevation)
	  END AS HighestPeakElevation

	  ,CASE WHEN r.[Length] = NULL
	  THEN NULL
	  ELSE MAX(r.[Length])
	  END AS LongestRiverLength
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Peaks AS p ON mc.MountainId = p.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName
