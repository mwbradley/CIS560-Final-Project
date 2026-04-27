import pandas as pd
import pyodbc
import os
import glob
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

# =============================================
# Database Connection
# =============================================

def get_connection():
    conn = pyodbc.connect(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={os.getenv('DB_SERVER')};"
        f"DATABASE={os.getenv('DB_NAME')};"
        f"Trusted_Connection=yes;"
    )
    return conn

def execute_query(query, params=(), fetchall=True):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    if fetchall:
        rows = cursor.fetchall()
        columns = [col[0] for col in cursor.description]
        conn.close()
        return [dict(zip(columns, row)) for row in rows]
    conn.commit()
    conn.close()

# =============================================
# Helper: get or insert a row, return its ID
# =============================================

def get_or_insert(check_query, insert_query, check_params, insert_params):
    """Check if a row exists, insert if not, return the ID either way."""
    result = execute_query(check_query, check_params)
    if result:
        return list(result[0].values())[0]
    execute_query(insert_query, insert_params, fetchall=False)
    result = execute_query(check_query, check_params)
    return list(result[0].values())[0]

# =============================================
# Parse league and season from filename
# e.g. Bundesliga_2022_23_player_match.csv
#   -> league_name = "Bundesliga"
#   -> season_name = "Bundesliga 2022/23"
# =============================================

def parse_filename(filepath):
    filename = os.path.basename(filepath).replace(".csv", "")
    parts = filename.split("_")
    # parts = ["Bundesliga", "2022", "23", "player", "match"]
    league_name = parts[0]
    season_name = f"{parts[1]}/{parts[2]}"
    #season_name = f"{season_label}"
    return league_name, season_name

# =============================================
# Parse match date from CSV string
# e.g. "Friday August 5, 2022" -> date object
# =============================================

def parse_date(date_str):
    try:
        # Remove day name (Friday, Saturday, etc.)
        parts = date_str.strip().split(" ", 1)
        date_part = parts[1] if len(parts) > 1 else parts[0]
        return datetime.strptime(date_part, "%B %d, %Y").date()
    except Exception:
        return None

# =============================================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
# Parse minutes played
# CSV has values like "45", "90", "26-324"
# We only want the first number
# =============================================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1

def parse_minutes(min_val):
    try:
        return int(str(min_val).split("-")[0])
    except Exception:
        return 0

# =============================================
# Parse position - normalize to simple values
# =============================================

def parse_position(pos_str):
    pos_str = str(pos_str).strip()
    if "Goalkeeper" in pos_str:
        return "Goalkeeper"
    elif "Forward" in pos_str:
        return "Forward"
    elif "Midfielder" in pos_str or "Midfielder" in pos_str:
        return "Midfielder"
    elif "Defender" in pos_str or "Back" in pos_str:
        return "Defender"
    return pos_str

# =============================================
# Main seeding function for one CSV file
# =============================================

def seed_file(filepath):
    league_name, season_name = parse_filename(filepath)
    print(f"\n{'='*50}")
    print(f"Processing: {os.path.basename(filepath)}")
    print(f"League: {league_name} | Season: {season_name}")
    print(f"{'='*50}")

    # Load CSV
    df = pd.read_csv(filepath)

    # Drop summary rows (e.g. "16 Players", NaN player names)
    df = df[pd.to_numeric(df["#"], errors="coerce").notna()]
    df = df[df["Player"].notna()]
    df = df[~df["Player"].str.contains("Players", na=False)]

    # Parse match dates
    df["parsed_date"] = df["match_date"].apply(parse_date)
    df = df[df["parsed_date"].notna()]

    # -----------------------------------------------
    # 1. League
    # -----------------------------------------------
    league_id = get_or_insert(
        "SELECT LeagueID FROM FantasyFootball.League WHERE LeagueName = ?",
        "INSERT INTO FantasyFootball.League (LeagueName) VALUES (?)",
        (league_name,),
        (league_name,)
    )
    print(f"LeagueID: {league_id}")

    # -----------------------------------------------
    # 2. Season - derive start/end from match dates
    # -----------------------------------------------
    season_start = df["parsed_date"].min()
    season_end = df["parsed_date"].max()

    season_id = get_or_insert(
        "SELECT SeasonID FROM FantasyFootball.Season WHERE SeasonName = ?",
        """INSERT INTO FantasyFootball.Season 
           (LeagueID, SeasonName, SeasonStartDate, SeasonEndDate) 
           VALUES (?, ?, ?, ?)""",
        (season_name,),
        (league_id, season_name, season_start, season_end)
    )
    print(f"SeasonID: {season_id} | {season_start} to {season_end}")

    # -----------------------------------------------
    # 3. Teams
    # -----------------------------------------------
    all_teams = set(df["home_team"].dropna().unique()) | set(df["away_team"].dropna().unique())
    team_id_map = {}

    for team_name in all_teams:
        team_id = get_or_insert(
            "SELECT TeamID FROM FantasyFootball.Team WHERE TeamName = ?",
            "INSERT INTO FantasyFootball.Team (SeasonID, TeamName) VALUES (?, ?)",
            (team_name,),
            (season_id, team_name)
        )
        team_id_map[team_name] = team_id

    print(f"Teams inserted: {len(team_id_map)}")

    # -----------------------------------------------
    # 4. TeamSeason
    # -----------------------------------------------
    team_season_id_map = {}

    for team_name, team_id in team_id_map.items():
        ts_id = get_or_insert(
            """SELECT TeamSeasonID FROM FantasyFootball.TeamSeason 
               WHERE TeamID = ? AND SeasonID = ?""",
            """INSERT INTO FantasyFootball.TeamSeason (TeamID, SeasonID) 
               VALUES (?, ?)""",
            (team_id, season_id),
            (team_id, season_id)
        )
        team_season_id_map[team_name] = ts_id

    print(f"TeamSeasons inserted: {len(team_season_id_map)}")

    # -----------------------------------------------
    # 5. Players
    # -----------------------------------------------
    player_id_map = {}
    unique_players = df[["Player", "Birthdate", "Pos"]].drop_duplicates(subset=["Player"])

    for _, row in unique_players.iterrows():
        player_name = str(row["Player"]).strip()
        birthdate = row["Birthdate"] if pd.notna(row["Birthdate"]) else None
        position = parse_position(row["Pos"]) if pd.notna(row["Pos"]) else None

        player_id = get_or_insert(
            "SELECT PlayerID FROM FantasyFootball.Player WHERE PlayerName = ?",
            """INSERT INTO FantasyFootball.Player (PlayerName, BirthDate, Position) 
               VALUES (?, ?, ?)""",
            (player_name,),
            (player_name, birthdate, position)
        )
        player_id_map[player_name] = player_id

    print(f"Players inserted: {len(player_id_map)}")

    # -----------------------------------------------
    # 6. TeamPlayer - link player to their team's TeamSeason
    # -----------------------------------------------
    team_player_id_map = {}

    for _, row in df[["Player", "squad_side", "home_team", "away_team"]].drop_duplicates(subset=["Player"]).iterrows():
        player_name = str(row["Player"]).strip()
        team_name = row["home_team"] if row["squad_side"] == "home" else row["away_team"]

        if player_name not in player_id_map or team_name not in team_season_id_map:
            continue

        player_id = player_id_map[player_name]
        ts_id = team_season_id_map[team_name]

        tp_id = get_or_insert(
            """SELECT TeamPlayerID FROM FantasyFootball.TeamPlayer 
               WHERE TeamSeasonID = ? AND PlayerID = ?""",
            """INSERT INTO FantasyFootball.TeamPlayer (TeamSeasonID, PlayerID) 
               VALUES (?, ?)""",
            (ts_id, player_id),
            (ts_id, player_id)
        )
        team_player_id_map[player_name] = tp_id

    print(f"TeamPlayers inserted: {len(team_player_id_map)}")

    # -----------------------------------------------
    # 7. TeamType (Home / Away) - ensure they exist
    # -----------------------------------------------
    home_type_id = get_or_insert(
        "SELECT TeamTypeID FROM FantasyFootball.TeamType WHERE TeamName = ?",
        "INSERT INTO FantasyFootball.TeamType (TeamName) VALUES (?)",
        ("Home",), ("Home",)
    )
    away_type_id = get_or_insert(
        "SELECT TeamTypeID FROM FantasyFootball.TeamType WHERE TeamName = ?",
        "INSERT INTO FantasyFootball.TeamType (TeamName) VALUES (?)",
        ("Away",), ("Away",)
    )

    # -----------------------------------------------
    # 8. Matches + MatchTeam + PlayerMatch
    # -----------------------------------------------
    match_id_map = {}
    unique_matches = df[["match_url", "match_date", "home_team", "away_team", "parsed_date"]].drop_duplicates(subset=["match_url"])

    for _, match_row in unique_matches.iterrows():
        match_url = match_row["match_url"]
        match_date = match_row["parsed_date"]
        home_team = match_row["home_team"]
        away_team = match_row["away_team"]

        # Insert Match
        match_id = get_or_insert(
            "SELECT MatchID FROM FantasyFootball.Match WHERE MatchLocation = ?",
            """INSERT INTO FantasyFootball.Match (MatchDate, MatchLocation) 
               VALUES (?, ?)""",
            (match_url,),
            (match_date, match_url)
        )
        match_id_map[match_url] = match_id

        # Determine winner from score column
        score_str = str(df[df["match_url"] == match_url]["score"].iloc[0])
        home_winner = None
        away_winner = None
        try:
            # score may be garbled by Excel (e.g. "6-Jan" instead of "6-1")
            # try to parse it
            parts = score_str.split("-")
            if len(parts) == 2 and parts[0].strip().isdigit() and parts[1].strip().isdigit():
                home_score = int(parts[0].strip())
                away_score = int(parts[1].strip())
                # home_winner = "Winner" if home_score > away_score else "Loser"
                # away_winner = "Winner" if away_score > home_score else "Loser"
                if home_score > away_score:
                    home_winner = "Winner"
                elif home_score < away_score:
                    home_winner = "Loser"
                if away_score > home_winner:
                    away_winner = "Winner"
                elif away_score < home_winner:
                    away_winner = "Loser"
                
        except Exception:
            pass  # leave winner as None if score can't be parsed

        # Insert MatchTeam for home
        if home_team in team_season_id_map:
            home_ts_id = team_season_id_map[home_team]
            existing = execute_query(
                """SELECT MatchTeamID FROM FantasyFootball.MatchTeam 
                   WHERE MatchID = ? AND TeamTypeID = ? AND TeamSeasonID = ?""",
                (match_id, home_type_id, home_ts_id)
            )
            if not existing:
                execute_query(
                    """INSERT INTO FantasyFootball.MatchTeam 
                       (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (?, ?, ?, ?)""",
                    (match_id, home_type_id, home_ts_id, home_winner),
                    fetchall=False
                )

        # Insert MatchTeam for away
        if away_team in team_season_id_map:
            away_ts_id = team_season_id_map[away_team]
            existing = execute_query(
                """SELECT MatchTeamID FROM FantasyFootball.MatchTeam 
                   WHERE MatchID = ? AND TeamTypeID = ? AND TeamSeasonID = ?""",
                (match_id, away_type_id, away_ts_id)
            )
            if not existing:
                execute_query(
                    """INSERT INTO FantasyFootball.MatchTeam 
                       (MatchID, TeamTypeID, TeamSeasonID, Winner) VALUES (?, ?, ?, ?)""",
                    (match_id, away_type_id, away_ts_id, away_winner),
                    fetchall=False
                )

    print(f"Matches inserted: {len(match_id_map)}")

    # -----------------------------------------------
    # 9. PlayerMatch stats
    # -----------------------------------------------
    player_match_count = 0

    for _, row in df.iterrows():
        player_name = str(row["Player"]).strip()
        match_url = row["match_url"]

        if player_name not in team_player_id_map or match_url not in match_id_map:
            continue

        tp_id = team_player_id_map[player_name]
        match_id = match_id_map[match_url]

        team_name = row["home_team"] if row["squad_side"] == "home" else row["away_team"]
        if team_name not in team_season_id_map:
            continue
        ts_id = team_season_id_map[team_name]

        # Check if already inserted
        existing = execute_query(
            """SELECT PlayerMatchID FROM FantasyFootball.PlayerMatch 
               WHERE MatchID = ? AND TeamPlayerID = ?""",
            (match_id, tp_id)
        )
        if existing:
            continue

        execute_query(
            """INSERT INTO FantasyFootball.PlayerMatch 
               (MatchID, TeamPlayerID, TeamSeasonID, MinutesPlayed, Goals, Assists, 
                ChancesCreated, YellowCards, RedCards)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                match_id,
                tp_id,
                ts_id,
                parse_minutes(row["Min"]),
                int(row["Performance_Gls"]) if pd.notna(row["Performance_Gls"]) else 0,
                int(row["Performance_Ast"]) if pd.notna(row["Performance_Ast"]) else 0,
                int(row["Performance_Crs"]) if pd.notna(row["Performance_Crs"]) else 0,
                int(row["Performance_CrdY"]) if pd.notna(row["Performance_CrdY"]) else 0,
                int(row["Performance_CrdR"]) if pd.notna(row["Performance_CrdR"]) else 0,
            ),
            fetchall=False
        )
        player_match_count += 1

    print(f"PlayerMatch rows inserted: {player_match_count}")
    print(f"Done: {os.path.basename(filepath)}")


# =============================================
# Run for all CSV files in the data/ folder
# =============================================

if __name__ == "__main__":
    # Put all your CSV files in a folder called data/ next to this script
    csv_files = glob.glob("data/*.csv")

    if not csv_files:
        print("No CSV files found in data/ folder.")
        print("Place your CSV files in a folder called data/ next to this script.")
    else:
        print(f"Found {len(csv_files)} CSV files to process:")
        for f in csv_files:
            print(f"  - {f}")

        for filepath in csv_files:
            try:
                seed_file(filepath)
            except Exception as e:
                print(f"ERROR processing {filepath}: {e}")

        print("\nAll files processed!")