from db import execute_query
from flask import Blueprint, jsonify

players_bp = Blueprint("players", __name__)

# Get all players across all leagues and teams
@players_bp.route("/", methods=["GET"])
def get_players():
    players = execute_query("""SELECT P.PlayerID, P.PlayerName, P.BirthDate, P.Position
                             FROM FantasyFootball.Player P
                                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                             ORDER BY P.PlayerName ASC""")
    return jsonify(players)