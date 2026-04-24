from db import execute_query
from flask import Blueprint, jsonify

league_bp = Blueprint("get_league", __name__)

# Get a particular league
@league_bp.route("/<leagueName>", methods=["GET"])
def get_seasons(leagueName):
    league = execute_query(
        """SELECT L.LeagueID, L.LeagueName, COUNT(*) AS TeamCount
             FROM FantasyFootball.League L
                INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE L.LeagueName = ?
             ORDER BY L.LeagueName ASC""",
        (leagueName,),
    )
    return jsonify(league)
