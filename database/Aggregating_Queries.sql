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
			AND S.SeasonID = 1



DECLARE @PageSize INT = 20,
		@Page INT = 1;

SELECT P.PlayerName, P.Position, P.Position, TP.TeamPlayerID, S.SeasonID,
	(YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
    INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
    INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
GROUP BY P.PlayerName, P.Position, P.Position, TP.TeamPlayerID, S.SeasonID, P.BirthDate
ORDER BY P.PlayerName ASC
OFFSET (@PageSize * (@Page - 1)) ROWS FETCH NEXT @PageSize ROWS ONLY;


SELECT T.TeamName,
               SUM(IIF(MT.Winner = N'Winner', 1, 0)) AS Wins,
               SUM(IIF (MT.Winner != N'Winner' AND MT.Winner IS NOT NULL, 1 , 0)) AS Losses,
               SUM(IIF(MT.Winner IS NULL, 1, 0)) AS Draws
           FROM FantasyFootball.Team T
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamID = T.TeamID
           INNER JOIN FantasyFootball.MatchTeam MT  ON MT.TeamSeasonID = TS.TeamSeasonID
           INNER JOIN FantasyFootball.Season S       ON S.SeasonID = TS.SeasonID
           WHERE S.SeasonID = 1
           GROUP BY T.TeamName
           ORDER BY Wins DESC


SELECT *
FROM FantasyFootball.MatchTeam

SELECT P.PlayerID, P.PlayerName,  
(YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
P.Position, TP.TeamPlayerID,
SUM(PM.Goals) AS TotalGoals,
SUM(PM.Assists) as TotalAssists
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
GROUP BY P.PlayerID, P.PlayerName, P.BirthDate, P.Position, TP.TeamPlayerID
ORDER BY P.PlayerName ASC
OFFSET (20 * (1 - 1)) ROWS FETCH NEXT 20 ROWS ONLY


SELECT P.PlayerID, P.PlayerName,  
	(YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
	P.Position, TP.TeamPlayerID, S.SeasonID,
	SUM(PM.Goals)   AS TotalGoals,
	SUM(PM.Assists) AS TotalAssists
FROM FantasyFootball.Player P
	INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
	INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
	INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
	INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
	INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
	INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
WHERE L.LeagueID = 1 AND S.SeasonID IN (3, 6, 9) AND P.PlayerName LIKE N'%Har%'
GROUP BY P.PlayerID, P.PlayerName, P.BirthDate, P.Position, TP.TeamPlayerID, S.SeasonID
ORDER BY P.PlayerName ASC


SELECT DISTINCT SeasonID 
FROM FantasyFootball.TeamSeason
ORDER BY SeasonID


SELECT COUNT(*) 
FROM FantasyFootball.TeamSeason
WHERE SeasonID IN (1,4,7)

SELECT DISTINCT P.PlayerName
FROM FantasyFootball.Player P
JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
WHERE P.PlayerName LIKE '%Har%'

SELECT DISTINCT P.PlayerName
FROM FantasyFootball.Player P
JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
WHERE P.PlayerName LIKE '%Har%'



SELECT * 
FROM FantasyFootball.AppUser

SELECT P.PlayerID, P.PlayerName, P.Position, T.TeamName, TP.TeamPlayerID
        FROM FantasyFootball.UserTeam UT
            INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = UT.TeamPlayerID
            INNER JOIN FantasyFootball.Player P ON P.PlayerID = TP.PlayerID
            INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
            INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
            INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
        WHERE UT.UserID = 2

SELECT SeasonID, SeasonName, LeagueID 
FROM FantasyFootball.Season 
ORDER BY LeagueID, SeasonID