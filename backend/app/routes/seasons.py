from db import execute_query
from flask import Blueprint, jsonify

get_season_bp = Blueprint("get_season", __name__)


# Get a particular season
@get_season_bp.route("/<seasonName>", methods=["GET"])
def get_seasons(seasonName):
    season = execute_query(
        """SELECT S.SeasonName, S.SeasonStartDate, S.SeasonEndDate, L.LeagueName, T.TeamName
             FROM FantasyFootball.Season S
                INNER JOIN FantasyFootball.League L ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON S.SeasonID = ST.SeasonID
                INNER JOIN FantasyFootball.Team T ON S.TeamID = T.TeamID
             WHERE S.SeasonName = ?
             ORDER BY S.SeasonName ASC""",
        (seasonName,)
    )
    return jsonify(season)
