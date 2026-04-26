import { useState } from "react"
import { useNavigate } from "react-router-dom";

export default function Login() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();

    const handleLogin = () => {
        fetch("http://localhost:5000/api/auth/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password })
        })
            .then(res => res.json())
            .then(data => {
                localStorage.setItem("token", data.token);
                localStorage.setItem("username", data.username);
                navigate("/home");
            });
    }

    return (
        <div className="auth-container">
            <h1 className="page-title">Login</h1>
            <p className="page-subtitle">Sign in to your account</p>

            <div className="auth-card">
                <input className="auth-input" placeholder="Username" onChange={e => setUsername(e.target.value)} />
                <input className="auth-input" placeholder="Password" type="password" onChange={e => setPassword(e.target.value)} />
                <button className="auth-button" onClick={handleLogin}>Login</button>
                <p className="auth-link">
                    Don't have an account? <a href="/register">Register</a>
                </p>
            </div>
        </div>
    );
}