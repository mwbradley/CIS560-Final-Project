import { useEffect, useState } from "react"

export default function Players() {
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("http://localhost:5000/api/players/")
            .then(res => res.json())
            .then(data => setPlayers(data))
            .catch(err => console.error("Failed to fetch players:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading players...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Players</h1>
            <p className="page-subtitle">All players in the database</p>

            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>Player</th>
                            <th>Age</th>
                            <th>Position</th>
                        </tr>
                    </thead>
                    <tbody>
                        {players.map(p => (
                            <tr key={p.PlayerID}>
                                <td>{p.PlayerName}</td>
                                <td>{p.PlayerAge}</td>
                                <td>{p.Position}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}