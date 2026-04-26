import { useEffect, useState } from "react"

export default function Leagues() {
    const [leagues, setLeagues] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("http://localhost:5000/api/leagues/")
            .then(res => res.json())
            .then(data => setLeagues(data))
            .catch(err => console.error("Failed to fetch leagues:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading leagues...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Leagues</h1>
            <p className="page-subtitle">All leagues in the database</p>

            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>League</th>
                            <th>Teams</th>
                        </tr>
                    </thead>
                    <tbody>
                        {leagues.map(l => (
                            <tr key={l.LeagueID}>
                                <td>{l.LeagueName}</td>
                                <td>{l.TeamCount}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}