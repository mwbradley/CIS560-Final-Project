from flask import Flask
from flask_cors import CORS
# the routes should be imported as well.
from routes.players import players_bp
from routes.matches import avg_goals_match_bp, num_matches_bp
from routes.teams import teams_bp
#from routes.leagues import
#from routes.referees import
#from routes.seasons import 

app = Flask(__name__)
CORS(app)

# Players
app.register_blueprint(players_bp, url_prefix="/api/players")

# Matches
app.register_blueprint(avg_goals_match_bp, url_prefix="/api/matches")
app.register_blueprint(num_matches_bp, url_prefix="/api/matches")

# Teams
app.register_blueprint(teams_bp, url_prefix="/api/teams")

if __name__ == "__main__":
    app.run(debug=True)