import { useEffect, useState } from "react"

export default function Players()
{
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/players/")
        .then(res => res.json())
        .then(data => {
            setPlayers(data)
            setLoading(false)  // Added this because of the slight delay
        })
        .catch (err => console.error("Failed to fetch players:", err));
    }, []);

    if (loading) return <p>Loading players...</p>

    return (
        <div>
            <h1>
                Players
            </h1>
            {players.map(p => <p key={p.PlayerID}>{p.PlayerName} | {p.PlayerAge} | {p.Position}</p>)}
        </div>
    );
}