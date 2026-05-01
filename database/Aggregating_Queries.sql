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


SELECT *
FROM FantasyFootball.TeamSeason TS
    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
WHERE T.TeamName = N'Arsenal'

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

SELECT MatchID, COUNT(*) 
FROM FantasyFootball.MatchTeam 
WHERE MatchID = 2816
GROUP BY MatchID


SELECT TOP 5
                M.MatchID, M.MatchDate, M.MatchLocation,
                HT.TeamName AS HomeTeam,
                [AT].TeamName AS AwayTeam,
                COALESCE(HMP.Goals, 0) AS HomeGoals,
                COALESCE(AMP.Goals, 0) AS AwayGoals,
                HMT.Winner AS HomeWinner, AMT.Winner AS AwayWinner,
                CASE
                    WHEN HMT.TeamSeasonID = 39 AND HMT.Winner = N'Winner' THEN HT.TeamName
                    WHEN HMT.TeamSeasonID = 39 AND HMT.Winner = N'Loser'  THEN [AT].TeamName
                    WHEN AMT.TeamSeasonID = 39 AND AMT.Winner = N'Winner' THEN [AT].TeamName
                    WHEN AMT.TeamSeasonID = 39 AND AMT.Winner = N'Loser'  THEN HT.TeamName
                    WHEN HMT.Winner = N'Draw' AND AMT.Winner = N'Draw' THEN 'Draw'
                END AS Winner
           FROM FantasyFootball.Match M
           INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
           INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
           INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
           INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team [AT] ON [AT].TeamID = ATS.TeamID
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
           WHERE HMT.TeamSeasonID = 39 OR AMT.TeamSeasonID = 39
           ORDER BY
                CASE
                    WHEN HMT.TeamSeasonID = 39
                        THEN COALESCE(HMP.Goals, 0) - COALESCE(AMP.Goals, 0)
                    ELSE
                        COALESCE(AMP.Goals, 0) - COALESCE(HMP.Goals, 0)
                END DESC

SELECT 
    M.MatchID, M.MatchDate,
    HT.TeamName AS HomeTeam, HMT.Winner AS HomeWinner,
    AT.TeamName AS AwayTeam, AMT.Winner AS AwayWinner,
    HMP.Goals AS HomeGoals, AMP.Goals AS AwayGoals
FROM FantasyFootball.Match M
INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
LEFT JOIN (SELECT MatchID, TeamSeasonID, SUM(Goals) AS Goals FROM FantasyFootball.PlayerMatch GROUP BY MatchID, TeamSeasonID) HMP 
    ON HMP.MatchID = M.MatchID AND HMP.TeamSeasonID = HMT.TeamSeasonID
LEFT JOIN (SELECT MatchID, TeamSeasonID, SUM(Goals) AS Goals FROM FantasyFootball.PlayerMatch GROUP BY MatchID, TeamSeasonID) AMP 
    ON AMP.MatchID = M.MatchID AND AMP.TeamSeasonID = AMT.TeamSeasonID
WHERE 
    (HMP.Goals > AMP.Goals AND HMT.Winner != 'Winner')
    OR (AMP.Goals > HMP.Goals AND AMT.Winner != 'Winner')
    OR (HMP.Goals = AMP.Goals AND HMT.Winner != 'Draw')


UPDATE MT
SET MT.Winner = CASE
    WHEN HMP.Goals > AMP.Goals AND MT.TeamTypeID = 1 THEN 'Winner'
    WHEN HMP.Goals > AMP.Goals AND MT.TeamTypeID = 2 THEN 'Loser'
    WHEN AMP.Goals > HMP.Goals AND MT.TeamTypeID = 2 THEN 'Winner'
    WHEN AMP.Goals > HMP.Goals AND MT.TeamTypeID = 1 THEN 'Loser'
    ELSE 'Draw'
END
FROM FantasyFootball.MatchTeam MT
INNER JOIN (
    SELECT MatchID, TeamSeasonID, SUM(Goals) AS Goals
    FROM FantasyFootball.PlayerMatch
    GROUP BY MatchID, TeamSeasonID
) HMP ON HMP.MatchID = MT.MatchID AND HMP.TeamSeasonID = MT.TeamSeasonID
    AND MT.TeamTypeID = 1
INNER JOIN FantasyFootball.MatchTeam MT2 ON MT2.MatchID = MT.MatchID AND MT2.TeamTypeID = 2
INNER JOIN (
    SELECT MatchID, TeamSeasonID, SUM(Goals) AS Goals
    FROM FantasyFootball.PlayerMatch
    GROUP BY MatchID, TeamSeasonID
) AMP ON AMP.MatchID = MT2.MatchID AND AMP.TeamSeasonID = MT2.TeamSeasonID



WITH GoalTotals AS (
    SELECT MatchID, TeamSeasonID, SUM(Goals) AS Goals
    FROM FantasyFootball.PlayerMatch
    GROUP BY MatchID, TeamSeasonID
),
MatchGoals AS (
    SELECT 
        HMT.MatchID,
        HMT.TeamSeasonID AS HomeTeamSeasonID,
        AMT.TeamSeasonID AS AwayTeamSeasonID,
        COALESCE(HG.Goals, 0) AS HomeGoals,
        COALESCE(AG.Goals, 0) AS AwayGoals
    FROM FantasyFootball.MatchTeam HMT
    INNER JOIN FantasyFootball.MatchTeam AMT 
        ON AMT.MatchID = HMT.MatchID AND AMT.TeamTypeID = 2
    LEFT JOIN GoalTotals HG 
        ON HG.MatchID = HMT.MatchID AND HG.TeamSeasonID = HMT.TeamSeasonID
    LEFT JOIN GoalTotals AG 
        ON AG.MatchID = AMT.MatchID AND AG.TeamSeasonID = AMT.TeamSeasonID
    WHERE HMT.TeamTypeID = 1
)
UPDATE MT
SET MT.Winner = CASE
    WHEN MT.TeamTypeID = 1 AND MG.HomeGoals > MG.AwayGoals THEN 'Winner'
    WHEN MT.TeamTypeID = 1 AND MG.HomeGoals < MG.AwayGoals THEN 'Loser'
    WHEN MT.TeamTypeID = 2 AND MG.AwayGoals > MG.HomeGoals THEN 'Winner'
    WHEN MT.TeamTypeID = 2 AND MG.AwayGoals < MG.HomeGoals THEN 'Loser'
    ELSE 'Draw'
END
FROM FantasyFootball.MatchTeam MT
INNER JOIN MatchGoals MG 
    ON MG.MatchID = MT.MatchID
    AND (MT.TeamSeasonID = MG.HomeTeamSeasonID OR MT.TeamSeasonID = MG.AwayTeamSeasonID)