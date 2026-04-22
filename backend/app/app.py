from flask import Flask
from flask_cors import CORS
# the routes should be imported as well.
from routes.players import players_bp
from routes.matches import avg_goals_match_bp

app = Flask(__name__)
CORS(app)

app.register_blueprint(players_bp, url_prefix="/api/players")
app.register_blueprint(avg_goals_match_bp, url_prefix="/api/avg_goals")

if __name__ == "__main__":
    app.run(debug=True)