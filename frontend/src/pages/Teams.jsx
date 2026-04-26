import { useEffect, useState } from "react"
import { BarChart, Bar, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer } from "recharts"

export default function Teams() {
    const [teams, setTeams] = useState([]);
    const [winsLosses, setWinsLosses] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        Promise.all([
            fetch("http://localhost:5000/api/teams/stats/1").then(res => res.json()),
            fetch("http://localhost:5000/api/teams/wins-losses/1").then(res => res.json())
        ])
            .then(([statsData, wlData]) => {
                setTeams(statsData);
                setWinsLosses(wlData);
            })
            .catch(err => console.error("Failed to fetch teams:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading teams...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Teams</h1>
            <p className="page-subtitle">Team stats for the current season</p>

            {/* Stats Table */}
            <div className="card-dark">
                <div className="card-title">Team Stats</div>
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

            {/* Wins/Losses Chart */}
            <div className="card-dark">
                <div className="card-title">Wins & Losses by Team</div>
                <ResponsiveContainer width="100%" height={350}>
                    <BarChart data={winsLosses} margin={{ top: 10, right: 20, left: 0, bottom: 60 }}>
                        <XAxis
                            dataKey="TeamName"
                            tick={{ fill: '#6b7280', fontSize: 11 }}
                            angle={-35}
                            textAnchor="end"
                        />
                        <YAxis tick={{ fill: '#6b7280', fontSize: 11 }} />
                        <Tooltip
                            contentStyle={{
                                background: '#1a2030',
                                border: '1px solid rgba(255,255,255,0.12)',
                                borderRadius: 8,
                                color: '#e8eaf0'
                            }}
                        />
                        <Legend wrapperStyle={{ color: '#6b7280', paddingTop: 20 }} />
                        <Bar dataKey="Wins" fill="#22c97a" radius={[4, 4, 0, 0]} />
                        <Bar dataKey="Losses" fill="#ef4444" radius={[4, 4, 0, 0]} />
                        <Bar dataKey="Draws" fill="#f59e0b" radius={[4, 4, 0, 0]} />
                    </BarChart>
                </ResponsiveContainer>
            </div>
        </div>
    );
}