import { useEffect, useState } from "react"

export default function Matches() {
    const [matches, setMatches] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("http://localhost:5000/api/matches/")
            .then(res => res.json())
            .then(data => setMatches(data))
            .catch(err => console.error("Failed to fetch matches:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading matches...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Matches</h1>
            <p className="page-subtitle">5 most recent matches</p>

            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Location</th>
                            <th>Home</th>
                            <th>Away</th>
                            <th>Winner</th>
                        </tr>
                    </thead>
                    <tbody>
                        {matches.map(m => (
                            <tr key={m.MatchID}>
                                <td>{m.MatchDate}</td>
                                <td>{m.MatchLocation}</td>
                                <td>{m.HomeTeam}</td>
                                <td>{m.AwayTeam}</td>
                                <td><span className="badge-green">{m.Winner}</span></td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}