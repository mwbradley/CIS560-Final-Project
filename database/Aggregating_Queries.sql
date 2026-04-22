USE CIS560;

SELECT P.PlayerName, P.BirthDate
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
WHERE S.LeagueID = 1
ORDER BY P.PlayerName ASC

SELECT *
FROM FantasyFootball.Player

SELECT P.PlayerName, T.TeamName,
	AVG(PM.Goals) AS AverageGoals
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
WHERE S.LeagueID = 1
GROUP BY P.PlayerName, T.TeamName
ORDER BY AVG(PM.Goals) ASC