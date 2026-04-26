from db import execute_query
from flask import Blueprint, jsonify

season_bp = Blueprint("get_seasons", __name__)


# Get a particular season
# Get all seasons for a specific team
@season_bp.route("/team/<teamName>", methods=["GET"])
def get_team_seasons(teamName):
    seasons = execute_query(
        """SELECT S.SeasonID, S.SeasonName,
               CONVERT(VARCHAR, S.SeasonStartDate, 101) AS SeasonStartDate,
               CONVERT(VARCHAR, S.SeasonEndDate, 101) AS SeasonEndDate,
               L.LeagueName, T.TeamName
           FROM FantasyFootball.Season S
           INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
           INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
           WHERE T.TeamName = ?
           ORDER BY S.SeasonStartDate DESC""",
        (teamName,),
    )
    return jsonify(seasons)


# Get all seasons
@season_bp.route("/", methods=["GET"])
def get_seasons():
    seasons = execute_query(
        """SELECT S.SeasonName, CONVERT(VARCHAR, S.SeasonStartDate, 101) AS SeasonStartDate, CONVERT(VARCHAR, S.SeasonEndDate, 101) AS SeasonEndDate,
                L.LeagueName
            FROM FantasyFootball.Season S
            INNER JOIN FantasyFootball.League L ON S.LeagueID = L.LeagueID
            ORDER BY S.SeasonName ASC"""
    )
    return jsonify(seasons)
