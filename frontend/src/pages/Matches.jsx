import { useEffect, useState } from "react"

export default function Matches() {
    const [matches, setMatches] = useState([]);
    const [allLeagues, setAllLeagues] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [teams, setTeams] = useState([]);
    const [selectedLeague, setSelectedLeague] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(null);
    const [selectedTeam, setSelectedTeam] = useState(null);
    const [selectedTeamName, setSelectedTeamName] = useState("");
    const [loading, setLoading] = useState(false);

    // Fetch leagues on mount
    useEffect(() => {
        fetch("http://localhost:5000/api/leagues/")
            .then(res => res.json())
            .then(data => {
                setAllLeagues(data);
                if (data.length > 0) setSelectedLeague(data[0].LeagueID);
            })
            .catch(err => console.error("Failed to fetch leagues:", err));
    }, []);

    // Fetch seasons when league changes
    useEffect(() => {
        if (!selectedLeague) return;
        setSelectedSeason(null);
        setSelectedTeam(null);
        setSelectedTeamName("");
        setTeams([]);
        setMatches([]);

        fetch(`http://localhost:5000/api/seasons/league/${selectedLeague}`)
            .then(res => res.json())
            .then(data => {
                setSeasons(data);
                if (data.length > 0) setSelectedSeason(data[0].SeasonID);
            })
            .catch(err => console.error("Failed to fetch seasons:", err));
    }, [selectedLeague]);

    // Fetch teams when season changes
    useEffect(() => {
        if (!selectedSeason) return;
        setSelectedTeam(null);
        setSelectedTeamName("");
        setMatches([]);

        fetch(`http://localhost:5000/api/teams/by-season/${selectedSeason}`)
            .then(res => res.json())
            .then(data => {
                setTeams(data);
                if (data.length > 0) {
                    setSelectedTeam(data[0].TeamID);
                    setSelectedTeamName(data[0].TeamName);
                }
            })
            .catch(err => console.error("Failed to fetch teams:", err));
    }, [selectedSeason]);

    // Fetch top matches whenever selectedTeam changes
    useEffect(() => {
        if (!selectedTeam || !selectedSeason) return;
        setLoading(true);
        setMatches([]);

        fetch(`http://localhost:5000/api/matches/team-season/${selectedTeam}/${selectedSeason}`)
            .then(res => res.json())
            .then(tsData => {
                if (!tsData.TeamSeasonID) {
                    setMatches([]);
                    setLoading(false);
                    return;
                }
                return fetch(`http://localhost:5000/api/matches/top/${tsData.TeamSeasonID}`)
                    .then(res => res.json())
                    .then(data => setMatches(data));
            })
            .catch(err => console.error("Failed to fetch matches:", err))
            .finally(() => setLoading(false));
    }, [selectedTeam]); // <-- only selectedTeam here so it fires on every team change

    const handleTeamChange = (e) => {
        const teamID = Number(e.target.value);
        const team = teams.find(t => t.TeamID === teamID);
        setSelectedTeam(teamID);
        setSelectedTeamName(team?.TeamName ?? "");
    };

    return (
        <div className="page-container">
            <h1 className="page-title">Matches</h1>
            <p className="page-subtitle">
                Top 5 matches for {selectedTeamName ? ` for ${selectedTeamName}` : ""}
            </p>

            <div className="card-dark">
                <div className="card-title-row">
                    <div className="card-title">Match Results</div>
                    <div style={{ display: "flex", gap: "10px" }}>

                        {/* League Dropdown */}
                        <select
                            className="season-select"
                            value={selectedLeague ?? ""}
                            onChange={e => setSelectedLeague(Number(e.target.value))}
                        >
                            {allLeagues.map(l => (
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
                                <option disabled value="">No seasons</option>
                            ) : (
                                seasons.map(s => (
                                    <option key={s.SeasonID} value={s.SeasonID}>
                                        {s.SeasonName}
                                    </option>
                                ))
                            )}
                        </select>

                        {/* Team Dropdown */}
                        <select
                            className="season-select"
                            value={selectedTeam ?? ""}
                            onChange={handleTeamChange}
                        >
                            {teams.length === 0 ? (
                                <option disabled value="">No teams</option>
                            ) : (
                                teams.map(t => (
                                    <option key={t.TeamID} value={t.TeamID}>
                                        {t.TeamName}
                                    </option>
                                ))
                            )}
                        </select>
                    </div>
                </div>

                {loading ? (
                    <p className="loading">Loading matches...</p>
                ) : matches.length === 0 ? (
                    <p className="loading">No matches found for this selection.</p>
                ) : (
                    <table className="table-dark-custom">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Location</th>
                                <th>Home</th>
                                <th>Score</th>
                                <th>Away</th>
                                <th>Goal Diff</th>
                                <th>Winner</th>
                            </tr>
                        </thead>
                        <tbody>
                            {matches.map(m => {
                                const isHome = m.HomeTeam === selectedTeamName;
                                const teamGoals = isHome ? m.HomeGoals : m.AwayGoals;
                                const oppGoals = isHome ? m.AwayGoals : m.HomeGoals;
                                const diff = teamGoals - oppGoals;

                                return (
                                    <tr key={m.MatchID}>
                                        <td>
                                            {m.MatchDate
                                                ? new Date(m.MatchDate).toLocaleDateString("en-US", {
                                                    year: "numeric",
                                                    month: "short",
                                                    day: "numeric"
                                                })
                                                : "—"}
                                        </td>
                                        <td>{m.MatchLocation}</td>
                                        <td>{m.HomeTeam}</td>
                                        <td style={{ fontWeight: 600, color: "var(--text-h)" }}>
                                            {m.HomeGoals} – {m.AwayGoals}
                                        </td>
                                        <td>{m.AwayTeam}</td>
                                        <td>
                                            <span className={diff > 0 ? "badge-green" : diff < 0 ? "badge-red" : "badge-amber"}>
                                                {diff > 0 ? `+${diff}` : diff}
                                            </span>
                                        </td>
                                        <td>
                                            {m.Winner === "Draw"
                                                ? <span className="badge-amber">Draw</span>
                                                : <span className="badge-green">{m.Winner}</span>
                                            }
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                )}
            </div>
        </div>
    );
}