from db import execute_query
from flask import Blueprint, jsonify

teams_bp = Blueprint("team", __name__)

@teams_bp.route("/<teamName>", methods=["GET"])
def get_players_team(teamName):
    teamPlayer = execute_query("""SELECT T.TeamName, P.PlayerName
                                  FROM FantasyFootball.Player P
                                    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                                  WHERE T.TeamName = ?                              
    """, (teamName,))
    return jsonify(teamPlayer)