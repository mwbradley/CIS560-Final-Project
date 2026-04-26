from db import execute_query
from flask import Blueprint, jsonify

match_bp = Blueprint("avg_goals", __name__)


@match_bp.route("/", methods=["GET"])
def get_five_recent_matches():
    recent_matches = execute_query(
        """SELECT TOP 5 M.MatchID, M.MatchDate, M.MatchLocation, HT.TeamName AS HomeTeam, AT.TeamName AS AwayTeam,
                CASE HMT.Winner
                   WHEN 1 THEN HT.TeamName
                   WHEN 0 THEN AT.TeamName
                   ELSE 'Draw'
               END AS Winner
           FROM FantasyFootball.Match M
                INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
                INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
                INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
                INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
                INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
                INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
            ORDER BY M.MatchDate DESC
           """
    )
    return jsonify(recent_matches)


@match_bp.route("/avg-goals", methods=["GET"])
def get_avg_goals_match():
    avg_goals = execute_query("""SELECT P.PlayerName, P.Position, T.TeamName,
                                AVG(PM.Goals) AS AverageGoals
                             FROM FantasyFootball.Player P
                                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                             GROUP BY P.PlayerName, P.Position, T.TeamName
                             ORDER BY AVG(PM.Goals) ASC""")
    return jsonify(avg_goals)


# Change to be based on if the player played more than 20 minutes??
@match_bp.route("/<playerName>", methods=["GET"])
def get_num_matches(playerName):
    num_matches = execute_query("""SELECT P.PlayerName, P.Position, T.TeamName,
                                    COUNT(DISTINCT PM.MatchID) AS NumMatches
                                   FROM FantasyFootball.Player P
                                    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                                    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                    INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                                   WHERE P.PlayerName = ?
                                        AND PM.MinutesPlayed >= 20
                                   GROUP BY P.PlayerName, P.Position, T.TeamName
   """, (playerName,))
    return jsonify(num_matches)
