import { useEffect, useState, useMemo } from "react"

export default function Players() {
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(false);
    const [allLeagues, setAllLeagues] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [teams, setTeams] = useState([]);
    const [pageNumber, setPageNumber] = useState(1);
    const [playerName, setPlayerName] = useState("");
    const [selectedLeague, setSelectedLeague] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(null);
    const [selectedTeam, setSelectedTeam] = useState(null);
    const [selectedTeamName, setSelectedTeamName] = useState("");

    const selectedSeasonIDs = useMemo(() =>
        seasons.filter(s => s.SeasonName === selectedSeason).map(s => s.SeasonID),
        [seasons, selectedSeason]
    );

    const isReady = selectedLeague !== null && selectedSeasonIDs.length > 0;

    useEffect(() => {
        if (!isReady) return;
        setLoading(true);
        fetch("http://localhost:5000/api/players/search/", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                playerName,
                teamName: selectedTeamName,
                leagueID: selectedLeague,
                seasonID: selectedSeasonIDs,
                pageNumber
            })
        })
            .then(res => res.json())
            .then(data => setPlayers(data))
            .catch(err => console.error("Failed to fetch players:", err))
            .finally(() => setLoading(false));
    }, [isReady, pageNumber, selectedLeague, selectedSeasonIDs, selectedTeam, playerName]);

    useEffect(() => {
        fetch("http://localhost:5000/api/leagues/")
            .then(res => res.json())
            .then(data => {
                setAllLeagues(data);
                if (data.length > 0) setSelectedLeague(data[0].LeagueID);
            })
            .catch(err => console.error("Failed to fetch leagues:", err));
    }, []);

    useEffect(() => {
        if (!selectedLeague) return;
        setSelectedSeason(null);
        setSelectedTeam(null);
        setSelectedTeamName("");
        setTeams([]);

        fetch(`http://localhost:5000/api/seasons/league/${selectedLeague}`)
            .then(res => res.json())
            .then(data => {
                setSeasons(data);
                if (data.length > 0) setSelectedSeason(data[0].SeasonName);
            })
            .catch(err => console.error("Failed to fetch seasons:", err));
    }, [selectedLeague]);

    useEffect(() => {
        if (!selectedSeason) return;
        const seasonObj = seasons.find(s => s.SeasonName === selectedSeason);
        if (!seasonObj) return;

        setSelectedTeam(null);
        setSelectedTeamName("");

        fetch(`http://localhost:5000/api/teams/by-season/${seasonObj.SeasonID}`)
            .then(res => res.json())
            .then(data => {
                setTeams(data);
                if (data.length > 0) {
                    setSelectedTeam(data[0].TeamID);
                    setSelectedTeamName(data[0].TeamName);
                }
            })
            .catch(err => console.error("Failed to fetch teams:", err));
    }, [selectedSeason, seasons]);

    const handleSeasonChange = (seasonLabel) => {
        setSelectedSeason(seasonLabel);
        setPageNumber(1);
    };

    const handleTeamChange = (e) => {
        const teamID = Number(e.target.value);
        const team = teams.find(t => t.TeamID === teamID);
        setSelectedTeam(teamID);
        setSelectedTeamName(team?.TeamName ?? "");
    };

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
            <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginBottom: 12 }}>
                <input
                    className="auth-input"
                    placeholder="Player name"
                    onChange={e => setPlayerName(e.target.value)}
                    style={{ flex: 1, minWidth: 140 }}
                />
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
                <select
                    className="season-select"
                    value={selectedSeason ?? ""}
                    onChange={e => handleSeasonChange(e.target.value)}
                >
                    {seasons.length === 0 ? (
                        <option disabled value="">No seasons</option>
                    ) : (
                        seasons.map(s => (
                            <option key={s.SeasonID} value={s.SeasonName}>
                                {s.SeasonName}
                            </option>
                        ))
                    )}
                </select>
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
                        {players.map((p, index) => (
                            <tr key={`${p.PlayerID}-${index}`}>
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
                    <button onClick={decrementPage} disabled={pageNumber === 1}>Previous Page</button>
                    <button onClick={incrementPage} disabled={players.length < 20}>Next Page</button>
                </div>
            </div>
        </div>
    );
}