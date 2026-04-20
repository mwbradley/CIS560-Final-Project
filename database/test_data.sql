-- =============================================
-- Soccer League Test Data
-- Run schema.sql first before running this file
-- =============================================

-- =============================================
-- TeamType (Home / Away)
-- =============================================
INSERT INTO FantasyFootball.TeamType (TeamName) VALUES ('Home');
INSERT INTO FantasyFootball.TeamType (TeamName) VALUES ('Away');

-- =============================================
-- Leagues
-- =============================================
INSERT INTO FantasyFootball.League DEFAULT VALUES;  -- LeagueID = 1 (Premier League)
INSERT INTO FantasyFootball.League DEFAULT VALUES;  -- LeagueID = 2 (La Liga)
INSERT INTO FantasyFootball.League DEFAULT VALUES;  -- LeagueID = 3 (Bundesliga)

-- =============================================
-- Seasons
-- =============================================
INSERT INTO FantasyFootball.Season (LeagueID, SeasonName, SeasonStartDate, SeasonEndDate)
VALUES (1, 'Premier League 2023/24', '2023-08-11', '2024-05-19');

INSERT INTO FantasyFootball.Season (LeagueID, SeasonName, SeasonStartDate, SeasonEndDate)
VALUES (2, 'La Liga 2023/24', '2023-08-12', '2024-05-26');

INSERT INTO FantasyFootball.Season (LeagueID, SeasonName, SeasonStartDate, SeasonEndDate)
VALUES (3, 'Bundesliga 2023/24', '2023-08-18', '2024-05-18');

-- =============================================
-- Referees
-- =============================================
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (1, 'Michael Oliver');
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (1, 'Anthony Taylor');
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (2, 'Jesus Gil Manzano');
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (2, 'Ricardo de Burgos');
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (3, 'Felix Zwayer');
INSERT INTO FantasyFootball.Referee (LeagueID, RefereeName) VALUES (3, 'Daniel Siebert');

-- =============================================
-- Teams
-- =============================================

-- Premier League Teams (SeasonID = 1)
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (1, 'Manchester City');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (1, 'Arsenal');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (1, 'Liverpool');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (1, 'Chelsea');

-- La Liga Teams (SeasonID = 2)
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (2, 'Real Madrid');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (2, 'Barcelona');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (2, 'Atletico Madrid');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (2, 'Sevilla');

-- Bundesliga Teams (SeasonID = 3)
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (3, 'Bayern Munich');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (3, 'Borussia Dortmund');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (3, 'RB Leipzig');
INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (3, 'Bayer Leverkusen');

-- =============================================
-- Players
-- =============================================

-- Premier League Players
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Erling Haaland',   '2000-07-21');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Kevin De Bruyne',  '1991-06-28');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Bukayo Saka',      '2001-09-05');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Martin Odegaard',  '1998-12-17');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Mohamed Salah',    '1992-06-15');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Virgil van Dijk',  '1991-07-08');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Cole Palmer',      '2002-05-06');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Raheem Sterling',  '1994-12-08');

-- La Liga Players
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Vinicius Jr',      '2000-07-12');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Jude Bellingham',  '2003-06-29');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Robert Lewandowski','1988-08-21');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Pedri',            '2002-11-25');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Antoine Griezmann','1991-03-21');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Alvaro Morata',    '1992-10-23');

-- Bundesliga Players
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Harry Kane',       '1993-07-28');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Jamal Musiala',    '2003-02-26');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Niclas Fullkrug',  '1993-02-09');
INSERT INTO FantasyFootball.Player (PlayerName, BirthDate) VALUES ('Florian Wirtz',    '2003-05-03');

-- =============================================
-- TeamSeason (links Teams to Seasons)
-- =============================================

-- Premier League (SeasonID = 1)
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (1, 1);  -- Man City
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (2, 1);  -- Arsenal
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (3, 1);  -- Liverpool
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (4, 1);  -- Chelsea

-- La Liga (SeasonID = 2)
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (5, 2);  -- Real Madrid
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (6, 2);  -- Barcelona
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (7, 2);  -- Atletico Madrid
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (8, 2);  -- Sevilla

-- Bundesliga (SeasonID = 3)
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (9,  3); -- Bayern Munich
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (10, 3); -- Dortmund
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (11, 3); -- RB Leipzig
INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) VALUES (12, 3); -- Leverkusen

-- =============================================
-- TeamPlayer (links Players to TeamSeasons)
-- TeamSeasonIDs: Man City=1, Arsenal=2, Liverpool=3, Chelsea=4
--                Real Madrid=5, Barcelona=6, Atletico=7, Sevilla=8
--                Bayern=9, Dortmund=10, Leipzig=11, Leverkusen=12
-- =============================================

INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (1,  1);  -- Haaland -> Man City
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (1,  2);  -- De Bruyne -> Man City
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (2,  3);  -- Saka -> Arsenal
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (2,  4);  -- Odegaard -> Arsenal
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (3,  5);  -- Salah -> Liverpool
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (3,  6);  -- Van Dijk -> Liverpool
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (4,  7);  -- Palmer -> Chelsea
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (4,  8);  -- Sterling -> Chelsea
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (5,  9);  -- Vinicius -> Real Madrid
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (5,  10); -- Bellingham -> Real Madrid
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (6,  11); -- Lewandowski -> Barcelona
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (6,  12); -- Pedri -> Barcelona
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (7,  13); -- Griezmann -> Atletico
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (7,  14); -- Morata -> Atletico
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (9,  15); -- Kane -> Bayern
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (9,  16); -- Musiala -> Bayern
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (10, 17); -- Fullkrug -> Dortmund
INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) VALUES (12, 18); -- Wirtz -> Leverkusen

-- =============================================
-- Matches
-- =============================================

-- Premier League Matches
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-19', 'Etihad Stadium');
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-20', 'Emirates Stadium');
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-09-02', 'Stamford Bridge');

-- La Liga Matches
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-20', 'Santiago Bernabeu');
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-27', 'Camp Nou');

-- Bundesliga Matches
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-18', 'Allianz Arena');
INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) VALUES ('2023-08-26', 'Signal Iduna Park');

-- =============================================
-- MatchTeam (who played in each match)
-- MatchIDs:  1=Man City vs Arsenal, 2=Arsenal vs Liverpool
--            3=Chelsea vs Liverpool
--            4=Real Madrid vs Barcelona, 5=Barcelona vs Atletico
--            6=Bayern vs Dortmund, 7=Dortmund vs Leipzig
-- TeamTypeID: 1=Home, 2=Away
-- =============================================

-- Match 1: Man City (Home) vs Arsenal (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (1, 1, 1, 1); -- Man City wins
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (1, 2, 2, 0); -- Arsenal loses

-- Match 2: Arsenal (Home) vs Liverpool (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (2, 1, 2, 0); -- Arsenal loses
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (2, 2, 3, 1); -- Liverpool wins

-- Match 3: Chelsea (Home) vs Liverpool (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (3, 1, 4, 1); -- Chelsea wins
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (3, 2, 3, 0); -- Liverpool loses

-- Match 4: Real Madrid (Home) vs Barcelona (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (4, 1, 5, 1); -- Real Madrid wins
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (4, 2, 6, 0); -- Barcelona loses

-- Match 5: Barcelona (Home) vs Atletico (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (5, 1, 6, 0); -- Barcelona loses
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (5, 2, 7, 1); -- Atletico wins

-- Match 6: Bayern (Home) vs Dortmund (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (6, 1, 9,  1); -- Bayern wins
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (6, 2, 10, 0); -- Dortmund loses

-- Match 7: Dortmund (Home) vs Leipzig (Away)
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (7, 1, 10, 1); -- Dortmund wins
INSERT INTO FantasyFootball.MatchTeam (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (7, 2, 11, 0); -- Leipzig loses

-- =============================================
-- PlayerMatch (individual player stats per match)
-- =============================================

-- Match 1: Man City vs Arsenal
INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (1, 1, 1, 90, 2, 0, 2.30, 3, 0, 0); -- Haaland

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (1, 2, 1, 90, 0, 2, 0.40, 5, 1, 0); -- De Bruyne

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (1, 3, 2, 90, 1, 0, 0.85, 4, 0, 0); -- Saka

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (1, 4, 2, 90, 0, 1, 0.20, 3, 0, 0); -- Odegaard

-- Match 2: Arsenal vs Liverpool
INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (2, 3, 2, 90, 0, 0, 0.55, 2, 1, 0); -- Saka

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (2, 5, 3, 90, 1, 1, 1.10, 4, 0, 0); -- Salah

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (2, 6, 3, 90, 0, 0, 0.10, 1, 1, 0); -- Van Dijk

-- Match 4: Real Madrid vs Barcelona
INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (4, 9,  5, 90, 1, 1, 1.50, 5, 0, 0); -- Vinicius

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (4, 10, 5, 90, 1, 0, 0.90, 3, 0, 0); -- Bellingham

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (4, 11, 6, 90, 0, 0, 0.60, 2, 1, 0); -- Lewandowski

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (4, 12, 6, 75, 0, 0, 0.30, 3, 0, 0); -- Pedri

-- Match 6: Bayern vs Dortmund
INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (6, 15, 9,  90, 2, 0, 2.10, 4, 0, 0); -- Kane

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (6, 16, 9,  90, 0, 2, 0.25, 6, 0, 0); -- Musiala

INSERT INTO FantasyFootball.PlayerMatch (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, xG, ChancesCreated, YellowCards, RedCards)
VALUES (6, 17, 10, 90, 1, 0, 0.75, 2, 1, 0); -- Fullkrug