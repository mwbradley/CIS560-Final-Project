from db import execute_query
from flask import Blueprint, jsonify

teams_bp = Blueprint("teamPlayer", __name__)


# Get all teams
@teams_bp.route("/", methods=["GET"])
def get_teams():
    teams = execute_query(
        """SELECT DISTINCT T.TeamID, T.TeamName
             FROM FantasyFootball.Team T
             ORDER BY T.TeamName ASC"""
    )
    return jsonify(teams)


# Get players for a specific team
@teams_bp.route("/<teamName>", methods=["GET"])
def get_players_team(teamName):
    teamPlayer = execute_query(
        """SELECT T.TeamName, P.PlayerName
             FROM FantasyFootball.Player P
             INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
             INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
             INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE T.TeamName = ?""",
        (teamName,),
    )
    return jsonify(teamPlayer)


# Get stats for all teams using the season id
@teams_bp.route("/stats/<int:season_id>", methods=["GET"])
def get_team_stats(season_id):
    stats = execute_query(
        """SELECT T.TeamName, S.SeasonName,
             SUM(PM.RedCards)    AS TotalTeamRedCards,
             SUM(PM.YellowCards) AS TotalTeamYellowCards,
             SUM(PM.Goals)       AS TotalTeamGoals,
             SUM(PM.Assists)     AS TotalTeamAssists
           FROM FantasyFootball.PlayerMatch PM
           INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = PM.TeamPlayerID
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
           INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
           INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
           WHERE S.SeasonID = ?
           GROUP BY T.TeamName, S.SeasonName
           ORDER BY T.TeamName ASC""",
        (season_id,),
    )
    return jsonify(stats)
