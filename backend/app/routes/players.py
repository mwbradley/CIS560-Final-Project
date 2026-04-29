from db import execute_query
from flask import Blueprint, jsonify, request

players_bp = Blueprint("players", __name__)


# Get all players across all leagues and teams
@players_bp.route("/", methods=["POST"])
def get_players():
    data = request.get_json()
    players = execute_query(
        """SELECT P.PlayerID, P.PlayerName,  
                (YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
                P.Position,
                SUM(PM.Goals)   AS TotalGoals,
                SUM(PM.Assists) AS TotalAssists
           FROM FantasyFootball.Player P
                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
           GROUP BY P.PlayerID, P.PlayerName, P.BirthDate, P.Position
           ORDER BY TotalGoals DESC, TotalAssists DESC
           OFFSET (20 * (? - 1)) ROWS FETCH NEXT 20 ROWS ONLY""",
        data["pageNumber"],
    )
    return jsonify(players)


@players_bp.route("/oldest-scorer/", methods=["GET"])
def get_oldest_player():
    playersAge = execute_query("""SELECT TOP(1)
                                    P.PlayerName,
                                    MAX((YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate))) AS PlayerAge,
                                    SUM(PM.Goals) AS TotalGoals
                                  FROM FantasyFootball.Player P
                                    INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                    INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                                    INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                    INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                                  GROUP BY P.PlayerName, P.BirthDate, PM.Goals
                                  ORDER BY TotalGoals DESC
   """)
    return jsonify(playersAge)


@players_bp.route("/search/", methods=["POST"])
def get_search_results():
    data = request.get_json()

    query = """SELECT P.PlayerID, P.PlayerName,  
                (YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
                P.Position, TP.TeamPlayerID, S.SeasonID,
                SUM(PM.Goals)   AS TotalGoals,
                SUM(PM.Assists) AS TotalAssists
               FROM FantasyFootball.Player P
                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                INNER JOIN FantasyFootball.PlayerMatch PM ON PM.TeamPlayerID = TP.TeamPlayerID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
               WHERE 1=1"""

    params = []

    if data["playerName"]:
        query += " AND P.PlayerName LIKE ?"
        params.append(f"%{data['playerName']}%")
    if data["teamID"]:
        query += " AND T.TeamID = ?"
        params.append(data['teamID'])
    if data["leagueID"]:
        query += " AND L.LeagueID = ?"
        params.append(data['leagueID'])
    if data["seasonID"]:
        placeholders = ",".join(["?" for _ in data["seasonID"]])
        query += f" AND S.SeasonID IN ({placeholders})"
        params.extend(data["seasonID"])

    query += " GROUP BY P.PlayerID, P.PlayerName, P.BirthDate, P.Position, TP.TeamPlayerID, S.SeasonID"
    query += " ORDER BY TotalGoals DESC, TotalAssists DESC"
    query += " OFFSET (20 * (? - 1)) ROWS FETCH NEXT 20 ROWS ONLY"
    params.append(int(data['pageNumber']))

    search_results = execute_query(query, tuple(params))
    return jsonify(search_results)