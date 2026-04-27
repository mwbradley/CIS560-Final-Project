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
GROUP BY P.PlayerName, T.TeamName
ORDER BY AVG(PM.Goals) ASC


SELECT P.PlayerName, T.TeamName,
	COUNT(DISTINCT PM.MatchID) AS NumMatches
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
WHERE P.PlayerName = N'Erling Haaland'
GROUP BY P.PlayerName, T.TeamName

SELECT T.TeamName, S.SeasonName,
	SUM(PM.RedCards) OVER(PARTITION BY T.TeamName) AS TotalTeamRedCards
FROM FantasyFootball.PlayerMatch PM
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = PM.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
GROUP BY T.TeamName, S.SeasonName, PM.RedCards

SELECT TOP(1)
	P.PlayerName,
	MAX((YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate))) AS PlayerAge,
	SUM(PM.Goals) AS TotalGoals
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
GROUP BY P.PlayerName, P.BirthDate, PM.Goals
HAVING SUM(PM.Goals) > 0
ORDER BY PlayerAge DESC

SELECT *
FROM FantasyFootball.[User]

SELECT *
FROM FantasyFootball.UserTeam


SELECT *
FROM FantasyFootball.PlayerMatch

SELECT *
FROM FantasyFootball.Season


SELECT P.PlayerID, P.PlayerName,  
	(YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
P.Position, TP.TeamPlayerID, S.SeasonID
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
	INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
WHERE S.SeasonID = 1


SELECT *
FROM FantasyFootball.UserTeam


 SELECT P.PlayerName, P.Position, T.TeamName, TP.TeamPlayerID
        FROM FantasyFootball.UserTeam UT
            INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = UT.TeamPlayerID
            INNER JOIN FantasyFootball.Player P ON P.PlayerID = TP.PlayerID
            INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
            INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
            INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
        WHERE UT.UserID = 1
			AND UT.SeasonID = 1