USE CIS560;

IF SCHEMA_ID(N'FantasyFootball') IS NULL -- Yall can change the name if you want
   EXEC(N'CREATE SCHEMA [FantasyFootball];');


-- DROP TABLES

DROP TABLE IF EXISTS FantasyFootball.PlayerMatch;
DROP TABLE IF EXISTS FantasyFootball.UserTeam;
DROP TABLE IF EXISTS FantasyFootball.MatchTeam;
DROP TABLE IF EXISTS FantasyFootball.TeamPlayer;
DROP TABLE IF EXISTS FantasyFootball.[Match];
DROP TABLE IF EXISTS FantasyFootball.TeamSeason;
DROP TABLE IF EXISTS FantasyFootball.[User];
DROP TABLE IF EXISTS FantasyFootball.Team;
DROP TABLE IF EXISTS FantasyFootball.Referee;
DROP TABLE IF EXISTS FantasyFootball.Season;
DROP TABLE IF EXISTS FantasyFootball.Player;
DROP TABLE IF EXISTS FantasyFootball.TeamType;
DROP TABLE IF EXISTS FantasyFootball.League;
GO

-- Independent tables (No FK's)

CREATE TABLE FantasyFootball.League
(
	LeagueID INT PRIMARY KEY IDENTITY(1, 1),
	LeagueName NVARCHAR(64) NOT NULL
);


CREATE TABLE FantasyFootball.Player
(
	PlayerID INT PRIMARY KEY IDENTITY(1, 1),
	PlayerName NVARCHAR(32) NOT NULL,
	BirthDate DATE NOT NULL,
	Position NVARCHAR(32) NOT NULL
);

CREATE TABLE FantasyFootball.[Match]
(
	MatchID INT PRIMARY KEY IDENTITY(1, 1),
	MatchDate DATE NOT NULL,
	MatchLocation NVARCHAR(128) NOT NULL
);

CREATE TABLE FantasyFootball.TeamType
(
	TeamTypeID INT PRIMARY KEY IDENTITY(1, 1),
	TeamName NVARCHAR(128) NOT NULL

	UNIQUE(TeamName)
);
GO

-- Tables Dependent on League

CREATE TABLE FantasyFootball.Referee
(
	RefereeID INT PRIMARY KEY IDENTITY(1, 1),
	LeagueID INT NOT NULL,
	RefereeName NVARCHAR(64) NOT NULL,

	CONSTRAINT FK_Referee_League FOREIGN KEY(LeagueID) REFERENCES FantasyFootball.League(LeagueID)
);


CREATE TABLE FantasyFootball.Season
(
	SeasonID INT PRIMARY KEY IDENTITY(1, 1),
	LeagueID INT NOT NULL,
	SeasonName NVARCHAR(16) NOT NULL,
	SeasonStartDate DATE NOT NULL,
	SeasonEndDate DATE NOT NULL,

	CONSTRAINT FK_Season_League FOREIGN KEY(LeagueID) REFERENCES FantasyFootball.League(LeagueID),
	UNIQUE(LeagueID, SeasonName),
	UNIQUE(SeasonStartDate)
);
GO

-- Tables Dependent on Season

CREATE TABLE FantasyFootball.Team
(
	TeamID INT PRIMARY KEY IDENTITY(1, 1),
	SeasonID INT NOT NULL,
	TeamName NVARCHAR(32),

	CONSTRAINT FK_Team_Season FOREIGN KEY(SeasonID) REFERENCES FantasyFootball.Season(SeasonID),
	UNIQUE(TeamName)
);
GO

-- Bridge Tables

CREATE TABLE FantasyFootball.TeamSeason
(
	TeamSeasonID INT PRIMARY KEY IDENTITY(1, 1),
	SeasonID INT NOT NULL,
	TeamID INT NOT NULL,

	CONSTRAINT FK_TeamSeason_Team   FOREIGN KEY(TeamID)   REFERENCES FantasyFootball.Team(TeamID),
    CONSTRAINT FK_TeamSeason_Season FOREIGN KEY(SeasonID) REFERENCES FantasyFootball.Season(SeasonID),
	UNIQUE(SeasonID, TeamID)
);

CREATE TABLE FantasyFootball.TeamPlayer
(
	TeamPlayerID INT PRIMARY KEY IDENTITY(1, 1),
	TeamSeasonID INT NOT NULL,
	PlayerID INT NOT NULL,

	CONSTRAINT FK_TeamPlayer_TeamSeason FOREIGN KEY(TeamSeasonID) REFERENCES FantasyFootball.TeamSeason(TeamSeasonID),
	CONSTRAINT FK_TeamPlayer_Player FOREIGN KEY(PlayerID) REFERENCES FantasyFootball.Player(PlayerID)
);
GO

-- Tables Dependent on Match

CREATE TABLE FantasyFootball.MatchTeam
(
	MatchTeamID INT PRIMARY KEY IDENTITY(1, 1),
	MatchID INT NOT NULL,
	TeamTypeID INT NOT NULL,
	TeamSeasonID INT NOT NULL,
	Winner NVARCHAR(32), -- Same as TeamName

	CONSTRAINT FK_MatchTeam_Match FOREIGN KEY(MatchID) REFERENCES FantasyFootball.[Match](MatchID),
	CONSTRAINT FK_MatchTeam_TeamType FOREIGN KEY(TeamTypeID) REFERENCES FantasyFootball.TeamType(TeamTypeID),
	CONSTRAINT FK_MatchTeam_TeamSeason FOREIGN KEY(TeamSeasonID) REFERENCES FantasyFootball.TeamSeason(TeamSeasonID),
	UNIQUE(MatchTeamID, MatchID, TeamTypeID)
);

CREATE TABLE FantasyFootball.PlayerMatch
(
	PlayerMatchID INT PRIMARY KEY IDENTITY(1, 1),
	MatchID INT NOT NULL,
	TeamPlayerID INT NOT NULL,
	TeamSeasonID INT NOT NULL,
	MinutesPlayed INT DEFAULT 0,
	Goals INT DEFAULT 0,
	Assists INT DEFAULT 0,
	xG DECIMAL(5, 2),
	ChancesCreated INT DEFAULT 0,
	YellowCards INT DEFAULT 0,
	RedCards INT DEFAULT 0
);
GO

-- We need some test values before we commit to the full data
-- I might make some to test, probably just generate some dummy values

CREATE TABLE FantasyFootball.[User]
(
	UserID       INT PRIMARY KEY IDENTITY(1,1),
    Username     NVARCHAR(64) NOT NULL,
    PasswordHash NVARCHAR(256) NOT NULL,
    Email        NVARCHAR(128) NOT NULL,

	UNIQUE(UserName),
	UNIQUE(Email)
);

CREATE TABLE FantasyFootball.UserTeam
(
	UserTeamID   INT PRIMARY KEY IDENTITY(1,1),
    UserID       INT NOT NULL,
    TeamPlayerID INT NOT NULL,
    CONSTRAINT FK_UserTeam_User       FOREIGN KEY (UserID)       REFERENCES FantasyFootball.AppUser(UserID),
    CONSTRAINT FK_UserTeam_TeamPlayer FOREIGN KEY (TeamPlayerID) REFERENCES FantasyFootball.TeamPlayer(TeamPlayerID)
)