from db import execute_query
from flask import Blueprint, jsonify

avg_goals_match_bp = Blueprint("avg_goals", __name__)
num_matches_bp = Blueprint("num_matches", __name__)

@avg_goals_match_bp.route("/", methods=["GET"])
def get_avg_goals_match():
    avg_goals = execute_query("""SELECT P.PlayerName, T.TeamName,
                              AVG(PM.Goals) AS AverageGoals
                             FROM FantasyFootball.Player P
                                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                             WHERE S.LeagueID = 1
                             GROUP BY P.PlayerName, T.TeamName
                             ORDER BY AVG(PM.Goals) ASC""")
    return jsonify(avg_goals)

@num_matches_bp.route("/<playerName>", methods=["GET"])
def get_num_matches(playerName):
    num_matches = execute_query("""SELECT P.PlayerName, T.TeamName,
                                    COUNT(DISTINCT PM.MatchID) AS NumMatches
                                   FROM FantasyFootball.Player P
                                    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                                    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                                   WHERE P.PlayerName = ?
                                   GROUP BY P.PlayerName, T.TeamName
   """, (playerName,))
    return jsonify(num_matches)