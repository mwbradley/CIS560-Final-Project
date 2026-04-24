from flask import Flask
from flask_cors import CORS
# the routes should be imported as well.
from routes.players import players_bp, players_oldest_to_score_bp
from routes.matches import avg_goals_match_bp, num_matches_bp
from routes.teams import teams_bp, teams_redcard_bp
#from routes.leagues import
#from routes.referees import
from routes.seasons import get_season_bp

app = Flask(__name__)
CORS(app)

# Players
app.register_blueprint(players_bp, url_prefix="/api/players")
app.register_blueprint(players_oldest_to_score_bp, url_prefix="/api/players")

# Matches
app.register_blueprint(avg_goals_match_bp, url_prefix="/api/matches")
app.register_blueprint(num_matches_bp, url_prefix="/api/matches")

# Teams
app.register_blueprint(teams_bp, url_prefix="/api/teams")
app.register_blueprint(teams_redcard_bp, url_prefix="/api/teams")

# Seasons
app.register_blueprint(get_season_bp, url_prefix="/api/seasons")

if __name__ == "__main__":
    app.run(debug=True)