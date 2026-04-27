import { useEffect, useState } from "react"

export default function Leagues() {
    const [leagues, setLeagues] = useState([]);
    const [loading, setLoading] = useState(true);
    const [leagueRankings, setRankings] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [allLeagues, setAllLeagues] = useState([]);
    const [selectedLeague, setSelectedLeague] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(null);

    // Gets all leagues for the league dropdown on mount
    useEffect(() => {
        fetch("http://localhost:5000/api/leagues/")
            .then(res => res.json())
            .then(data => {
                setAllLeagues(data);
                if (data.length > 0) setSelectedLeague(data[0].LeagueID);
            })
            .catch(err => console.error("Failed to fetch leagues:", err));
    }, []);

    // Gets seasons filtered by selected league
    useEffect(() => {
        if (!selectedLeague) return;
        setSelectedSeason(null);
        setLeagues([]);
        setRankings([]);

        fetch(`http://localhost:5000/api/seasons/league/${selectedLeague}`)
            .then(res => res.json())
            .then(data => {
                setSeasons(data);
                if (data.length > 0) setSelectedSeason(data[0].SeasonID);
            })
            .catch(err => console.error("Failed to fetch seasons:", err));
    }, [selectedLeague]);

    // Gets league info and standings whenever season changes
    useEffect(() => {
        if (!selectedSeason) return;
        setLoading(true);
        Promise.all([
            fetch(`http://localhost:5000/api/leagues/info/${selectedSeason}`).then(res => res.json()),
            fetch(`http://localhost:5000/api/leagues/rankings/${selectedSeason}`).then(res => res.json()),
        ])
            .then(([leagueData, rankingsData]) => {
                setLeagues(leagueData);
                setRankings(rankingsData);
            })
            .catch(err => console.error("Failed to fetch league data:", err))
            .finally(() => setLoading(false));
    }, [selectedSeason]);

    if (loading) return <p className="loading">Loading leagues...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Leagues</h1>
            <p className="page-subtitle">All leagues in the database</p>

            {/* League Info */}
            <div className="card-dark">
                <div className="card-title-row">
                    <div className="card-title">League Info</div>
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
                ) : leagues.length === 0 ? (
                    <p className="loading">No data for this season.</p>
                ) : (
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
                )}
            </div>

            {/* League Standings */}
            <div className="card-dark">
                <div className="card-title">League Standings</div>
                {loading ? (
                    <p className="loading">Loading...</p>
                ) : leagueRankings.length === 0 ? (
                    <p className="loading">No standings for this season.</p>
                ) : (
                    <table className="table-dark-custom">
                        <thead>
                            <tr>
                                <th>Team</th>
                                <th>Season</th>
                                <th>Played</th>
                                <th>Wins</th>
                                <th>Draws</th>
                                <th>Losses</th>
                                <th>Points</th>
                            </tr>
                        </thead>
                        <tbody>
                            {leagueRankings.map(l => (
                                <tr key={l.TeamName}>
                                    <td>{l.TeamName}</td>
                                    <td>{l.SeasonName}</td>
                                    <td>{l.Played}</td>
                                    <td><span className="badge-green">{l.Wins}</span></td>
                                    <td><span className="badge-amber">{l.Draws}</span></td>
                                    <td><span className="badge-red">{l.Losses}</span></td>
                                    <td><strong>{l.Points}</strong></td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>
        </div>
    );
}