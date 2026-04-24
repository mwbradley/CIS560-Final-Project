from flask import Blueprint, jsonify, request
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token
from db import execute_query

auth_bp = Blueprint("auth", __name__)
bcrypt = Bcrypt()

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    hashed = bcrypt.generate_password_hash(data["password"]).decode("utf-8")
    execute_query(
        "INSERT INTO FantasyFootball.AppUser (Username, PasswordHash, Email) VALUES (?, ?, ?)",
        params=(data["username"], hashed, data["email"]),
        fetchall=False
    )
    return jsonify({"message": "User registered successfully"}), 201

@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    user = execute_query(
        "SELECT * FROM FantasyFootball.AppUser WHERE Username = ?",
        params=(data["username"],)
    )
    if not user or not bcrypt.check_password_hash(user[0]["PasswordHash"], data["password"]):
        return jsonify({"message": "Invalid credentials"}), 401
    token = create_access_token(identity=str(user[0]["UserID"]))
    return jsonify({"token": token}), 200