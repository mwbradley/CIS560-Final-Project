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


@league_bp.route("/rankings/<int:season_id>", methods=["GET"])
def get_rankings(season_id):
    results = execute_query(
        """SELECT T.TeamName, S.SeasonName,
               SUM(
                    CASE 
                        WHEN MT.Winner = TS.TeamSeasonID THEN 1 
                        ELSE 0 
                END) AS Wins,
                SUM(
                    CASE 
                        WHEN MT.Winner IS NOT NULL AND MT.Winner <> TS.TeamSeasonID THEN 1 
                        ELSE 0 
                END) AS Losses,
                SUM(
                    CASE 
                        WHEN MT.Winner IS NULL THEN 1 
                        ELSE 0 
                END) AS Draws,
               COUNT(DISTINCT MT.MatchID) AS Played,
               SUM(
                    CASE 
                        WHEN MT.Winner = TS.TeamSeasonID THEN 3 
                        ELSE 0 
                    END) + 
                    SUM(
                        CASE 
                            WHEN MT.Winner IS NULL THEN 1 
                            ELSE 0 
                END) AS Points
           FROM FantasyFootball.League L
           INNER JOIN FantasyFootball.Season S ON S.LeagueID = L.LeagueID
           INNER JOIN FantasyFootball.TeamSeason TS ON TS.SeasonID = S.SeasonID
           INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
           INNER JOIN FantasyFootball.MatchTeam MT ON MT.TeamSeasonID = TS.TeamSeasonID
           WHERE S.SeasonID = ?
           GROUP BY T.TeamName, S.SeasonName
           ORDER BY Points DESC, Wins DESC""",
        (season_id,),
    )
    return jsonify(results)
