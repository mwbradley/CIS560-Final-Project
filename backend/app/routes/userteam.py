from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import execute_query

userteam_bp = Blueprint("userteam", __name__)

@userteam_bp.route("/", methods=["GET"])
@jwt_required()
def get_user_team():
    user_id = get_jwt_identity()
    team = execute_query("""
        SELECT P.PlayerName, P.Position, T.TeamName
        FROM FantasyFootball.UserTeam UT
            INNER JOIN FantasyFootball.TeamPlayer TP ON TP.TeamPlayerID = UT.TeamPlayerID
            INNER JOIN FantasyFootball.Player P ON P.PlayerID = TP.PlayerID
            INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
            INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
        WHERE UT.UserID = ?
    """, params=(user_id,))
    return jsonify(team)

@userteam_bp.route("/add", methods=["POST"])
@jwt_required()
def add_player():
    user_id = get_jwt_identity()
    data = request.get_json()
    execute_query(
        "INSERT INTO FantasyFootball.UserTeam (UserID, TeamPlayerID) VALUES (?, ?)",
        params=(user_id, data["TeamPlayerID"]),
        fetchall=False
    )
    return jsonify({"message": "Player added to your team"}), 201

@userteam_bp.route("/remove", methods=["DELETE"])
@jwt_required()
def remove_player():
    user_id = get_jwt_identity()
    data = request.get_json()
    execute_query(
        "DELETE FROM FantasyFootball.UserTeam WHERE UserID = ? AND TeamPlayerID = ?",
        params=(user_id, data["TeamPlayerID"]),
        fetchall=False
    )
    return jsonify({"message": "Player removed from your team"})