from db import execute_query
from flask import Blueprint, jsonify

match_bp = Blueprint("avg_goals", __name__)


@match_bp.route("/", methods=["GET"])
def get_five_recent_matches():
    recent_matches = execute_query(
        """SELECT TOP 5 M.MatchID, M.MatchDate, M.MatchLocation,
                HT.TeamName AS HomeTeam,
                AT.TeamName AS AwayTeam,
                CASE
                    WHEN HMT.Winner = N'Draw'   THEN 'Draw'
                    WHEN HMT.Winner = N'Winner' THEN HT.TeamName
                    WHEN HMT.Winner = N'Loser'  THEN AT.TeamName
                END AS Winner
           FROM FantasyFootball.Match M
           INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
           INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
           INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
           INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
           ORDER BY M.MatchDate DESC"""
    )
    return jsonify(recent_matches)


@match_bp.route("/avg-goals", methods=["GET"])
def get_avg_goals_match():
    avg_goals = execute_query(
        """SELECT P.PlayerName, P.Position, T.TeamName,
                AVG(PM.Goals) AS AverageGoals
             FROM FantasyFootball.Player P
             INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
             INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
             INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
             INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
             GROUP BY P.PlayerName, P.Position, T.TeamName
             ORDER BY AVG(PM.Goals) ASC"""
    )
    return jsonify(avg_goals)


@match_bp.route("/<playerName>", methods=["GET"])
def get_num_matches(playerName):
    num_matches = execute_query(
        """SELECT P.PlayerName, P.Position, T.TeamName,
                COUNT(DISTINCT PM.MatchID) AS NumMatches
               FROM FantasyFootball.Player P
               INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
               INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
               INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
               INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
               WHERE P.PlayerName = ?
                   AND PM.MinutesPlayed >= 20
               GROUP BY P.PlayerName, P.Position, T.TeamName""",
        (playerName,),
    )
    return jsonify(num_matches)


@match_bp.route("/top/<int:team_season_id>", methods=["GET"])
def get_top_matches_for_team(team_season_id):
    top_matches = execute_query(
        """SELECT TOP 5
                M.MatchID, M.MatchDate, M.MatchLocation,
                HT.TeamName AS HomeTeam,
                AT.TeamName AS AwayTeam,
                COALESCE(HMP.Goals, 0) AS HomeGoals,
                COALESCE(AMP.Goals, 0) AS AwayGoals,
                CASE
                    WHEN HMT.Winner = N'Draw' THEN 'Draw'
                    WHEN HMT.TeamSeasonID = ? AND HMT.Winner = N'Winner' THEN HT.TeamName
                    WHEN HMT.TeamSeasonID = ? AND HMT.Winner = N'Loser'  THEN AT.TeamName
                    WHEN AMT.TeamSeasonID = ? AND AMT.Winner = N'Winner' THEN AT.TeamName
                    WHEN AMT.TeamSeasonID = ? AND AMT.Winner = N'Loser'  THEN HT.TeamName
                END AS Winner
           FROM FantasyFootball.Match M
           INNER JOIN FantasyFootball.MatchTeam HMT ON HMT.MatchID = M.MatchID AND HMT.TeamTypeID = 1
           INNER JOIN FantasyFootball.TeamSeason HTS ON HTS.TeamSeasonID = HMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team HT ON HT.TeamID = HTS.TeamID
           INNER JOIN FantasyFootball.MatchTeam AMT ON AMT.MatchID = M.MatchID AND AMT.TeamTypeID = 2
           INNER JOIN FantasyFootball.TeamSeason ATS ON ATS.TeamSeasonID = AMT.TeamSeasonID
           INNER JOIN FantasyFootball.Team AT ON AT.TeamID = ATS.TeamID
           LEFT JOIN (
                SELECT PM.MatchID, PM.TeamSeasonID, SUM(PM.Goals) AS Goals
                FROM FantasyFootball.PlayerMatch PM
                GROUP BY PM.MatchID, PM.TeamSeasonID
           ) HMP ON HMP.MatchID = M.MatchID AND HMP.TeamSeasonID = HMT.TeamSeasonID
           LEFT JOIN (
                SELECT PM.MatchID, PM.TeamSeasonID, SUM(PM.Goals) AS Goals
                FROM FantasyFootball.PlayerMatch PM
                GROUP BY PM.MatchID, PM.TeamSeasonID
           ) AMP ON AMP.MatchID = M.MatchID AND AMP.TeamSeasonID = AMT.TeamSeasonID
           WHERE HMT.TeamSeasonID = ? OR AMT.TeamSeasonID = ?
           ORDER BY
                CASE
                    WHEN HMT.TeamSeasonID = ?
                        THEN COALESCE(HMP.Goals, 0) - COALESCE(AMP.Goals, 0)
                    ELSE
                        COALESCE(AMP.Goals, 0) - COALESCE(HMP.Goals, 0)
                END DESC""",
        (
            team_season_id,
            team_season_id,
            team_season_id,
            team_season_id,
            team_season_id,
            team_season_id,
            team_season_id,
        ),
    )
    return jsonify(top_matches)


@match_bp.route("/team-season/<int:team_id>/<int:season_id>", methods=["GET"])
def get_team_season_id(team_id, season_id):
    result = execute_query(
        """SELECT TS.TeamSeasonID
             FROM FantasyFootball.TeamSeason TS
             WHERE TS.TeamID = ? AND TS.SeasonID = ?""",
        (team_id, season_id),
    )
    return jsonify(result[0] if result else {})
