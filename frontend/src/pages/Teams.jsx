import { useEffect, useState } from "react"
import { BarChart, Bar, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer } from "recharts"

export default function Teams() {
    const [teams, setTeams] = useState([]);
    const [winsLosses, setWinsLosses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [leagues, setLeagues] = useState([]);
    const [selectedLeague, setSelectedLeague] = useState(null);
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState(null);

    // Gets the Leagues to allow for filtering
    useEffect(() => {
        fetch("http://localhost:5000/api/leagues")
            .then(res => res.json())
            .then(data => {
                setLeagues(data);
                if (data.length > 0) setSelectedLeague(data[0].LeagueID);
            })
            .catch(err => console.error("Failed to fetch leagues:", err));
    }, []);

    // Gets the filtered season for the selected league
    useEffect(() => {
        if (!selectedLeague) return;
        setSelectedSeason(null);
        setTeams([]);
        setWinsLosses([]);

        fetch(`http://localhost:5000/api/seasons/league/${selectedLeague}`)
            .then(res => res.json())
            .then(data => {
                setSeasons(data);
                if (data.length > 0) setSelectedSeason(data[0].SeasonID);
            })
            .catch(err => console.error("Failed to fetch seasons:", err));
    }, [selectedLeague]);

    // Gets the Seasons to allow for filtering
    useEffect(() => {
        fetch("http://localhost:5000/api/seasons")
            .then(res => res.json())
            .then(data => {
                setSeasons(data);
                if (data.length > 0) setSelectedSeason(data[0].SeasonID);
            })
            .catch(err => console.error("Failed to fetch seasons:", err));
    }, []);

    useEffect(() => {
        if (!selectedSeason) return;
        setLoading(true);
        Promise.all([
            fetch(`http://localhost:5000/api/teams/stats/${selectedSeason}`).then(res => res.json()),
            fetch(`http://localhost:5000/api/teams/wins-losses/${selectedSeason}`).then(res => res.json()),
        ])
            .then(([statsData, wlData]) => {
                setTeams(statsData);
                setWinsLosses(wlData);
            })
            .catch(err => console.error("Failed to fetch teams:", err))
            .finally(() => setLoading(false));
    }, [selectedSeason]); //allows for 2022/2023 season to be first selected season

    if (loading) return <p className="loading">Loading teams...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Teams</h1>
            <p className="page-subtitle">Team stats for the selected season</p>

            {/* Stats Table */}
            <div className="card-dark">
                <div className="card-title-row">
                    <div className="card-title">Team Stats</div>

                    <div style={{ display: "flex", gap: "10px" }}>
                        
                        {/* League Dropdown */}
                        <select
                            className="season-select"
                            value={selectedLeague ?? ""}
                            onChange={e => setSelectedLeague(Number(e.target.value))}
                        >
                            {leagues.map(l => (
                                <option key={l.LeagueID} value={l.LeagueID}>
                                    {l.LeagueName}
                                </option>
                            ))}
                        </select>

                        {/* Season Dropdown */}
                        <select
                            className="season-select"
                            value={selectedSeason ?? ""}
                            onChange={e => setSelectedSeason(Number(e.target.value))}
                        >
                            {seasons.length === 0 ? (
                                <option disabled value="">No seasons available</option>
                            ) : (
                                seasons.map(s => (
                                    <option key={s.SeasonID} value={s.SeasonID}>
                                        {s.SeasonName}
                                    </option>
                                ))
                            )}
                        </select>
                    </div>
                </div>

                {loading ? (
                    <p className="loading">Loading...</p>
                ) : teams.length === 0 ? (
                    <p className="loading">No data for this season.</p>
                ) : (
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
                                    <td>
                                        <span className="badge-amber">{t.TotalTeamYellowCards}</span>
                                    </td>
                                    <td>
                                        <span className="badge-red">{t.TotalTeamRedCards}</span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>

            {/* Wins/Losses Chart */}
            <div className="card-dark">
                <div className="card-title">Wins & Losses by Team</div>
                {loading ? (
                    <p className="loading">Loading...</p>
                ) : (
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
                )}
            </div>
        </div>
    );
}