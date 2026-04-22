from flask import Flask
from flask_cors import CORS
# the routes should be imported as well.
from routes.players import players_bp
from routes.matches import avg_goals_match_bp
from routes.teams import teams_bp
#from routes.leagues import
#from routes.referees import
#from routes.seasons import 

app = Flask(__name__)
CORS(app)

app.register_blueprint(players_bp, url_prefix="/api/players")
app.register_blueprint(avg_goals_match_bp, url_prefix="/api/matches")
app.register_blueprint(teams_bp, url_prefix="/api/teams")

if __name__ == "__main__":
    app.run(debug=True)