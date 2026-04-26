import { useEffect, useState } from "react"

export default function Teams() {
    const [teams, setTeams] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("http://localhost:5000/api/teams/stats/1")
            .then(res => res.json())
            .then(data => setTeams(data))
            .catch(err => console.error("Failed to fetch teams:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading teams...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Teams</h1>
            <p className="page-subtitle">Team stats for the current season</p>

            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>Team</th>
                            <th>Season</th>
                            <th>Goals</th>
                            <th>Assists</th>
                            <th>Yellow Cards</th>
                            <th>Red Cards</th>
                        </tr>
                    </thead>
                    <tbody>
                        {teams.map(t => (
                            <tr key={t.TeamName}>
                                <td>{t.TeamName}</td>
                                <td>{t.SeasonName}</td>
                                <td>{t.TotalTeamGoals}</td>
                                <td>{t.TotalTeamAssists}</td>
                                <td>{t.TotalTeamYellowCards}</td>
                                <td>{t.TotalTeamRedCards}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}