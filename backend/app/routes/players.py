from db import execute_query
from flask import Blueprint, jsonify, request

players_bp = Blueprint("players", __name__)

# Get all players across all leagues and teams
@players_bp.route("/", methods=["GET"])
def get_players():
    players = execute_query("""SELECT P.PlayerID, P.PlayerName,  
                                 (YEAR(SYSDATETIMEOFFSET()) - YEAR(P.BirthDate)) AS PlayerAge, 
                                 P.Position, TeamPlayerID
                             FROM FantasyFootball.Player P
                                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                             ORDER BY P.PlayerName ASC""")
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
                P.Position, TP.TeamPlayerID
               FROM FantasyFootball.Player P
                INNER JOIN FantasyFootball.TeamPlayer TP ON TP.PlayerID = P.PlayerID
                INNER JOIN FantasyFootball.TeamSeason TS ON TS.TeamSeasonID = TP.TeamSeasonID
                INNER JOIN FantasyFootball.Team T ON T.TeamID = TS.TeamID
                INNER JOIN FantasyFootball.Season S ON S.SeasonID = TS.SeasonID
                INNER JOIN FantasyFootball.League L ON L.LeagueID = S.LeagueID
               WHERE 1=1"""

    params = []

    if data["playerName"]:
        query += " AND P.PlayerName LIKE ?"
        params.append(f"%{data['playerName']}%")
    if data["teamName"]:
        query += " AND T.TeamName LIKE ?"
        params.append(f"%{data['teamName']}%")
    if data["leagueName"]:
        query += " AND L.LeagueName LIKE ?"
        params.append(f"%{data['leagueName']}%")
    if data["seasonDate"]:
      query += " AND S.SeasonStartDate >= CONVERT(date, ?, 23)"
      params.append(data['seasonDate'])

    query += " ORDER BY P.PlayerName ASC"

    print(f"seasonDate value: '{data['seasonDate']}'")
    print(f"params: {params}")

    search_results = execute_query(query, params)
    return jsonify(search_results)