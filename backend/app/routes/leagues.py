from db import execute_query
from flask import Blueprint, jsonify

league_bp = Blueprint("get_league", __name__)

# Get all leagues
@league_bp.route("/", methods=["GET"])
def get_leagues():
    leagues = execute_query(
        """SELECT L.LeagueID, L.LeagueName, COUNT(*) AS TeamCount
             FROM FantasyFootball.League L
                INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             GROUP BY L.LeagueID, L.LeagueName
             ORDER BY L.LeagueName ASC"""
    )
    return jsonify(leagues)


# Get particular league
@league_bp.route("/<leagueName>", methods=["GET"])
def get_league(LeagueName):
    league = execute_query(
        """SELECT L.LeagueID, L.LeagueName, COUNT(*) AS TeamCount
             FROM FantasyFootball.League L
                INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             WHERE L.LeagueName = ?
             GROUP BY L.LeagueID, L.LeagueName
             ORDER BY L.LeagueName ASC""",
        (LeagueName,),
    )
    return jsonify(league)
