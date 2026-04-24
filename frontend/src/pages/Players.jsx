import { useEffect, useState } from "react"

export default function Leagues()
{
    const [players, setPlayers] = useState([]);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/players/")
        .then(res => res.json())
        .then(data => setPlayers(data))
        .catch (err => console.error("Failed to fetch players:", err));
    }, []);

    return (
        <div>
            <h1>
                Players
            </h1>
            {players.map(p => <p key={p.PlayerID}>{p.PlayerName} | {p.PlayerAge} | {p.Position}</p>)}
        </div>
    );
}