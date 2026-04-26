import { useState } from "react"
import { useNavigate } from "react-router-dom";

export default function Login()
{
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
            sessionStorage.setItem("token", data.token);
            sessionStorage.setItem("username", data.username);
            navigate("/dashboard"); // this is different than than our start page which is /
      });
    }

    return (
        <div>
            <h1>Login</h1>
            <input placeholder="Username" onChange={e => setUsername(e.target.value)} />
            <input placeholder="Password" type="password" onChange={e => setPassword(e.target.value)} />
            <button onClick={handleLogin}>Login</button>
        </div>
    );
}