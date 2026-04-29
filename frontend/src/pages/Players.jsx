import { useEffect, useState } from "react"

export default function Players() {
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [pageNumber, setPageNumber] = useState(1);

    // Reset loading when page changes
    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:5000/api/players/", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ pageNumber })
        })
            .then(res => res.json())
            .then(data => setPlayers(data))
            .catch(err => console.error("Failed to fetch players:", err))
            .finally(() => setLoading(false));
    }, [pageNumber]);

    const incrementPage = () => {
        setPageNumber(prevCount => prevCount + 1);
    }

    const decrementPage = () => {
        setPageNumber(prevCount => prevCount - 1);
    }

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
                            <th>Goals</th>
                            <th>Assists</th>
                        </tr>
                    </thead>
                    <tbody>
                        {players.map(p => (
                            <tr key={p.PlayerID}>
                                <td>{p.PlayerName}</td>
                                <td>{p.PlayerAge}</td>
                                <td>{p.Position}</td>
                                <td>{p.TotalGoals}</td>
                                <td>{p.TotalAssists}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                <div style={{ display: 'flex', gap: 10, marginTop: 16, justifyContent: "center" }}>
                    <button onClick={() => decrementPage()} disabled={pageNumber === 1}>Previous Page</button>
                    <button onClick={() => incrementPage()} disabled={players.length < 20}>Next Page</button>
                </div>
            </div>
        </div>
    );
}