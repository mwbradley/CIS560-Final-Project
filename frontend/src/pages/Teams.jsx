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

    if (loading) return <p>Loading teams...</p>

    return (
        <div>
            <h1>Teams</h1>
            <table>
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
    );
}