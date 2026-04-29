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
FROM FantasyFootball.TeamSeason TS	
	INNER JOIN FantasyFootball.Season S ON TS.SeasonID = S.SeasonID
	INNER JOIN FantasyFootball.Team T ON TS.TeamID = T.TeamID
WHERE S.LeagueID = 2




SELECT TOP 5
	M.MatchID, M.MatchDate, M.MatchLocation,
	HT.TeamName AS HomeTeam,
	AT.TeamName AS AwayTeam,
	COALESCE(HMP.Goals, 0) AS HomeGoals,
	COALESCE(AMP.Goals, 0) AS AwayGoals,
	CASE
		WHEN HMT.Winner = N'Draw' THEN 'Draw'
		WHEN HMT.TeamSeasonID = 106 AND HMT.Winner = N'Winner' THEN HT.TeamName
		WHEN HMT.TeamSeasonID = 106 AND HMT.Winner = N'Loser'  THEN AT.TeamName
		WHEN AMT.TeamSeasonID = 106 AND AMT.Winner = N'Winner' THEN AT.TeamName
		WHEN AMT.TeamSeasonID = 106 AND AMT.Winner = N'Loser'  THEN HT.TeamName
	END AS Winner
FROM FantasyFootball.Match M
	INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
	INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
	INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
	INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
	INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
	INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
	LEFT JOIN (
		SELECT PM.MatchID, PM.TeamSeasonID, SUM(PM.Goals) AS Goals
		FROM FantasyFootball.PlayerMatch PM
		GROUP BY PM.MatchID, PM.TeamSeasonID
	) HMP ON HMP.MatchID = M.MatchID AND HMP.TeamSeasonID = HMT.TeamSeasonID
	LEFT JOIN (
		SELECT PM.MatchID, PM.TeamSeasonID, SUM(PM.Goals) AS Goals
		FROM FantasyFootball.PlayerMatch PM
		GROUP BY PM.MatchID, PM.TeamSeasonID
	) AMP ON AMP.MatchID = M.MatchID AND AMP.TeamSeasonID = AMT.TeamSeasonID
WHERE HMT.TeamSeasonID = 106 OR AMT.TeamSeasonID = 106
ORDER BY
CASE
    WHEN HMT.TeamSeasonID = 106
        THEN COALESCE(HMP.Goals, 0) - COALESCE(AMP.Goals, 0)
    ELSE
        COALESCE(AMP.Goals, 0) - COALESCE(HMP.Goals, 0)
END DESC


SELECT MatchDate, MatchLocation, COUNT(*) as Count
FROM FantasyFootball.Match
GROUP BY MatchDate, MatchLocation
HAVING COUNT(*) > 1

-- Check MatchID 2098 specifically
SELECT * FROM FantasyFootball.MatchTeam WHERE MatchID = 2098

SELECT MatchID, COUNT(*) as Count
FROM FantasyFootball.MatchTeam
GROUP BY MatchID
HAVING COUNT(*) > 2