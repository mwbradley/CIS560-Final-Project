from flask import Flask
import os
from flask_cors import CORS
from flask_jwt_extended import JWTManager
# the routes should be imported as well.
from routes.players import players_bp
from routes.matches import match_bp
from routes.teams import teams_bp
from routes.seasons import season_bp
from routes.leagues import league_bp
from routes.auth import auth_bp
from routes.userteam import userteam_bp

app = Flask(__name__)
CORS(app)
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY")
JWTManager(app)

# Authorization
app.register_blueprint(auth_bp, url_prefix="/api/auth")

# Players
app.register_blueprint(players_bp, url_prefix="/api/players")

# Matches
app.register_blueprint(match_bp, url_prefix="/api/matches")

# Teams
app.register_blueprint(teams_bp, url_prefix="/api/teams")

# Seasons
app.register_blueprint(season_bp, url_prefix="/api/seasons")

# Leagues
app.register_blueprint(league_bp, url_prefix="/api/leagues")

# UserTeam
app.register_blueprint(userteam_bp, url_prefix="/api/userteam")

if __name__ == "__main__":
    app.run(debug=True)