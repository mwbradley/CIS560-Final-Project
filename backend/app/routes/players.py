from db import execute_query
from flask import Blueprint, jsonify

players_bp = Blueprint("players", __name__)

@players_bp.route("/", methods=["GET"])
def get_players():
    players = execute_query("""SELECT P.PlayerName, P.BirthDate
                             FROM FantasyFootball.Player P
                                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                             WHERE S.LeagueID = 1
                             ORDER BY P.PlayerName ASC""")
    return jsonify(players)