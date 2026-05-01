import { useState } from "react"
import { useNavigate } from "react-router-dom";

export default function Register() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [email, setEmail] = useState("");
    const navigate = useNavigate();

    const handleRegister = () => {
        fetch("http://localhost:5000/api/auth/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password, email })
        })
            .then(res => res.json())
            .then(data => {
                console.log(data.message);
                navigate("/login");
            });
    }

    const handleKeyDown = (event) => {
        if (event.key === 'Enter') {
            handleRegister();
        }
    }

    return (
        <div className="auth-container">
            <h1 className="page-title">Register</h1>
            <p className="page-subtitle">Create a new account</p>

            <div className="auth-card">
                <div style={{display: 'flex', gap: '15px', justifyContent: 'center'}}>
                    <input className="auth-input" placeholder="Username" onChange={e => setUsername(e.target.value)} />
                    <input className="auth-input" placeholder="Email" type="email" onChange={e => setEmail(e.target.value)} />
                    <input 
                    className="auth-input" 
                    placeholder="Password" 
                    type="password" 
                    onKeyDown={handleKeyDown}
                    onChange={e => setPassword(e.target.value)
                    } />
                </div>
                <div style={{paddingTop: '10px'}}>
                    <button className="auth-button" onClick={handleRegister}>Register</button>
                </div>
                <p className="auth-link">
                    Already have an account? <a href="/login">Login</a>
                </p>
            </div>
        </div>
    );
}