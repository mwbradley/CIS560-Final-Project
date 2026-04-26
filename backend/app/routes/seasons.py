from db import execute_query
from flask import Blueprint, jsonify

season_bp = Blueprint("get_seasons", __name__)


# Get a particular season
@season_bp.route("/<seasonName>", methods=["GET"])
def get_season(seasonName):
    season = execute_query(
        """SELECT S.SeasonName, S.SeasonStartDate, S.SeasonEndDate, L.LeagueName, T.TeamName
             FROM FantasyFootball.Season S
                INNER JOIN FantasyFootball.League L ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON S.SeasonID = TS.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE S.SeasonName = ?
             ORDER BY S.SeasonName ASC""",
        (seasonName,)
    )
    return jsonify(season)


# Get all seasons
@season_bp.route("/", methods=["GET"])
def get_seasons():
    seasons = execute_query(
        """SELECT S.SeasonName, S.SeasonStartDate, S.SeasonEndDate, L.LeagueName, T.TeamName
             FROM FantasyFootball.Season S
                INNER JOIN FantasyFootball.League L ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON S.SeasonID = TS.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             ORDER BY S.SeasonName ASC"""
    )
    return jsonify(seasons)
