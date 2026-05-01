USE CIS560;

-----------------------------
-- Players
-----------------------------
DECLARE @PageNumber INT = 1;

SELECT P.PlayerID, P.PlayerName,  
    (YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
    P.Position,
    SUM(PM.Goals)   AS TotalGoals,
    SUM(PM.Assists) AS TotalAssists
FROM FantasyFootball.Player P
    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
GROUP BY P.PlayerID, P.PlayerName, P.BirthDate, P.Position
ORDER BY TotalGoals DESC, TotalAssists DESC
OFFSET (20 * (@PageNumber - 1)) ROWS FETCH NEXT 20 ROWS ONLY;


-- Purpose: Finds players with the highest total goals
SELECT TOP(1)
    P.PlayerName,
    MAX((YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate))) AS PlayerAge,
    SUM(PM.Goals) AS TotalGoals
FROM FantasyFootball.Player P
    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
    INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
GROUP BY P.PlayerName, P.BirthDate
ORDER BY TotalGoals DESC;

-- Purpose: Retrieves players based on user input
SELECT P.PlayerID, P.PlayerName,  
    (YEAR(S.SeasonStartDate) - YEAR(P.BirthDate)) AS PlayerAge, 
    P.Position, TP.TeamPlayerID, S.SeasonID, T.TeamName,
    SUM(PM.Goals)   AS TotalGoals,
    SUM(PM.Assists) AS TotalAssists
FROM FantasyFootball.Player P
    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
    INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
    INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
-- Filters added dynamically in backend:
-- AND P.PlayerName LIKE '%@PlayerName%'
-- AND T.TeamID = @TeamID
-- AND L.LeagueID = @LeagueID
-- AND S.SeasonID IN (@SeasonID)
GROUP BY 
    P.PlayerID, P.PlayerName, P.BirthDate, P.Position, 
    TP.TeamPlayerID, S.SeasonID, T.TeamName, S.SeasonStartDate
ORDER BY 
    TotalGoals DESC, TotalAssists DESC;

-----------------------------
-- Matches
-----------------------------

-- Retrieves top five matches of selected team
SELECT TOP 5 M.MatchID, M.MatchDate, M.MatchLocation,
    HT.TeamName AS HomeTeam,
    AT.TeamName AS AwayTeam,
    CASE
        WHEN HMT.Winner = N'Draw'   THEN 'Draw'
        WHEN HMT.Winner = N'Winner' THEN HT.TeamName
        WHEN HMT.Winner = N'Loser'  THEN AT.TeamName
    END AS Winner
FROM FantasyFootball.Match M
    INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
    INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
    INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
    INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
    INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
    INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
ORDER BY M.MatchDate DESC;

-- Calculates average goals per player
SELECT P.PlayerName, P.Position, T.TeamName,
    AVG(PM.Goals) AS AverageGoals
FROM FantasyFootball.Player P
    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
GROUP BY P.PlayerName, P.Position, T.TeamName
ORDER BY AVG(PM.Goals) ASC;

-- Purpose: Counts the number of players with at least 20 minutes played
SELECT P.PlayerName, P.Position, T.TeamName,
    COUNT(DISTINCT PM.MatchID) AS NumMatches
FROM FantasyFootball.Player P
    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
WHERE P.PlayerName = @PlayerName
    AND PM.MinutesPlayed >= 20
GROUP BY P.PlayerName, P.Position, T.TeamName


-- Purpose: Top five teams wins with a score dif
SELECT TOP 5
                M.MatchID, M.MatchDate, M.MatchLocation,
                HT.TeamName AS HomeTeam,
                [AT].TeamName AS AwayTeam,
                COALESCE(HMP.Goals, 0) AS HomeGoals,
                COALESCE(AMP.Goals, 0) AS AwayGoals,
                HMT.Winner AS HomeWinner, AMT.Winner AS AwayWinner,
                CASE
                    WHEN HMT.Winner = N'Winner' THEN HT.TeamName
                    WHEN AMT.Winner = N'Winner' THEN [AT].TeamName
                    WHEN HMT.Winner = N'Draw'   THEN N'Draw'
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
           WHERE HMT.TeamSeasonID = @TeamSeasonID OR AMT.TeamSeasonID = @TeamSeasonID
           ORDER BY
                CASE
                    WHEN HMT.TeamSeasonID = @TeamSeasonID
                        THEN COALESCE(HMP.Goals, 0) - COALESCE(AMP.Goals, 0)
                    ELSE
                        COALESCE(AMP.Goals, 0) - COALESCE(HMP.Goals, 0)
                END DESC


-- Purpose to grab season id for frontend
SELECT TS.TeamSeasonID
             FROM FantasyFootball.TeamSeason TS
             WHERE TS.TeamID = @TeamID AND TS.SeasonID = @SeasonID


-----------------------------
-- Authorization
-----------------------------
-- Add user to table
INSERT INTO FantasyFootball.AppUser (Username, PasswordHash, Email) VALUES (@Username, @Password, @Email)

-- Checks for user in database
SELECT * FROM FantasyFootball.AppUser WHERE Username = @Username

-----------------------------
-- Leagues
-----------------------------

-- Purpose: Retrieves all leagues with a team count
SELECT L.LeagueID, L.LeagueName, COUNT(*) AS TeamCount
             FROM FantasyFootball.League L
                INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             GROUP BY L.LeagueID, L.LeagueName
             ORDER BY L.LeagueName ASC

-- Purpose: 
SELECT L.LeagueID, L.LeagueName, COUNT(DISTINCT T.TeamID) AS TeamCount
             FROM FantasyFootball.League L
                INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE L.LeagueName = @LeagueName
             GROUP BY L.LeagueID, L.LeagueName
             ORDER BY L.LeagueName ASC

SELECT T.TeamName, S.SeasonName,
               SUM(
                    CASE 
                        WHEN MT.Winner = N'Winner' THEN 1 
                        ELSE 0 
                END) AS Wins,
                SUM(
                    CASE 
                        WHEN MT.Winner IS NOT NULL AND MT.Winner = N'Loser' THEN 1 
                        ELSE 0 
                END) AS Losses,
                SUM(
                    CASE 
                        WHEN MT.Winner = N'Draw' THEN 1 
                        ELSE 0 
                END) AS Draws,
               COUNT(DISTINCT MT.MatchID) AS Played,
               SUM(
                    CASE 
                        WHEN MT.Winner = N'Winner' THEN 3 
                        ELSE 0 
                    END) + 
                    SUM(
                        CASE 
                            WHEN MT.Winner = N'Draw' THEN 1 
                            ELSE 0 
                END) AS Points
           FROM FantasyFootball.League L
           INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
           INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
           INNER JOIN FantasyFootball.MatchTeam MT ON MT.TeamSeasonID = TS.TeamSeasonID
           WHERE S.SeasonID = @SeasonID
           GROUP BY T.TeamName, S.SeasonName
           ORDER BY Points DESC, Wins DESC

SELECT L.LeagueID, L.LeagueName, COUNT(DISTINCT T.TeamID) AS TeamCount
             FROM FantasyFootball.League L
             INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
             INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
             INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE S.SeasonID = @SeasonID
             GROUP BY L.LeagueID, L.LeagueName
             ORDER BY L.LeagueName ASC

-----------------------------
-- User's Team
-----------------------------

-- Retrieves players on fantasy football roster
SELECT P.PlayerID, P.PlayerName, P.Position, T.TeamName, TP.TeamPlayerID
        FROM FantasyFootball.UserTeam UT
            INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = UT.TeamPlayerID
            INNER JOIN FantasyFootball.Player P ON P.PlayerID = TP.PlayerID
            INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
            INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
            INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
        WHERE UT.UserID = @UserID

-- Grabs teamplayerID to be able to add them
SELECT TS.SeasonID 
        FROM FantasyFootball.TeamPlayer TP
            INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
        WHERE TP.TeamPlayerID = @TeamPlayerID
        
-- Purpose: Adds player to fantasy football roster
INSERT INTO FantasyFootball.UserTeam (UserID, TeamPlayerID, SeasonID) VALUES (@UserID, @TeamPlayerID, @SeasonID)

-- Purpose: Deletse player from fantasy football roster
DELETE FROM FantasyFootball.UserTeam WHERE UserID = @UeerID AND TeamPlayerID = @TeamPlayerID


-----------------------------
-- Seasons
-----------------------------

-- Retrieves all seasons
SELECT S.SeasonID, S.SeasonName,
               CONVERT(VARCHAR, S.SeasonStartDate, 101) AS SeasonStartDate,
               CONVERT(VARCHAR, S.SeasonEndDate, 101) AS SeasonEndDate,
               L.LeagueName, T.TeamName
           FROM FantasyFootball.Season S
           INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
           INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
           WHERE T.TeamName = @TeamName
           ORDER BY S.SeasonStartDate DESC

SELECT S.SeasonID, S.SeasonName, CONVERT(VARCHAR, S.SeasonStartDate, 101) AS SeasonStartDate, CONVERT(VARCHAR, S.SeasonEndDate, 101) AS SeasonEndDate,
                L.LeagueName
            FROM FantasyFootball.Season S
            INNER JOIN FantasyFootball.League L ON S.LeagueID = L.LeagueID
            ORDER BY S.SeasonStartDate ASC

SELECT S.SeasonID, S.SeasonName
             FROM FantasyFootball.Season S
             WHERE S.LeagueID = @LeagueID
             ORDER BY S.SeasonStartDate DESC


-----------------------------
-- Teams
-----------------------------

SELECT DISTINCT T.TeamID, T.TeamName
             FROM FantasyFootball.Team T
             ORDER BY T.TeamName ASC

SELECT T.TeamName, P.PlayerName
             FROM FantasyFootball.Player P
             INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
             INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
             INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE T.TeamName = @TeamName

SELECT T.TeamID, T.TeamName, S.SeasonName,
                COALESCE(SUM(PM.RedCards), 0)    AS TotalTeamRedCards,
                COALESCE(SUM(PM.YellowCards), 0) AS TotalTeamYellowCards,
                COALESCE(SUM(PM.Goals), 0)       AS TotalTeamGoals,
                COALESCE(SUM(PM.Assists), 0)     AS TotalTeamAssists
           FROM FantasyFootball.Team T
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamID = T.TeamID
           INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
           LEFT JOIN FantasyFootball.PlayerMatch PM ON PM.TeamSeasonID = TS.TeamSeasonID
           WHERE S.SeasonID = @SeasonID
           GROUP BY T.TeamID, T.TeamName, S.SeasonName
           ORDER BY T.TeamName ASC

SELECT T.TeamName,
               SUM(IIF(MT.Winner = N'Winner', 1, 0)) AS Wins,
               SUM(IIF(MT.Winner = N'Loser',  1, 0)) AS Losses,
               SUM(IIF(MT.Winner = N'Draw',   1, 0)) AS Draws
           FROM FantasyFootball.Team T
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamID = T.TeamID
           INNER JOIN FantasyFootball.MatchTeam MT ON MT.TeamSeasonID = TS.TeamSeasonID
           INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
           WHERE S.SeasonID = @SeasonID
           GROUP BY T.TeamName
           ORDER BY Wins DESC

SELECT DISTINCT T.TeamID, T.TeamName
             FROM FantasyFootball.Team T
             INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamID = T.TeamID
             WHERE TS.SeasonID = @SeasonID
             ORDER BY T.TeamName ASC