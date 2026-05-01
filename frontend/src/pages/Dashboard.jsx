import { useEffect, useState, useMemo } from "react"

export default function Dashboard() {
    const username = sessionStorage.getItem("username");
    const token = sessionStorage.getItem("token");

    const [userTeamPlayers, setUserTeamPlayers] = useState([]);
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

    const selectedSeasonIDs = useMemo(() => {
        if (!selectedSeason) return [];
        return seasons
            .filter(s => s.SeasonName.includes(selectedSeason))
            .map(s => s.SeasonID);
    }, [selectedSeason, seasons]);

    const isReady = selectedLeague !== null && selectedSeasonIDs.length > 0 && selectedTeam !== null;

    const fetchRoster = (currentSeasonIDs = selectedSeasonIDs) => {
        fetch(`http://localhost:5000/api/userteam/`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${token}`
            },
            body: JSON.stringify({ seasonID: currentSeasonIDs })
        })
        .then(res => res.json())
        .then(data => {
            setUserTeamPlayers(Array.isArray(data) ? data : []);
            setLoading(false);
        })
        .catch(err => {
            console.error("Failed to fetch roster:", err);
            setLoading(false);
        });
    }

    useEffect(() => {
        if (selectedSeasonIDs.length > 0) {
            fetchRoster(selectedSeasonIDs);
        }
    }, [selectedSeasonIDs]);

    const handleSearch = () => {
        fetch("http://localhost:5000/api/players/search/", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                playerName,
                teamID: selectedTeam,
                leagueID: selectedLeague,
                seasonID: selectedSeasonIDs,
                pageNumber
            })
        })
        .then(res => res.json())
        .then(data => setPlayers(data))
        .catch(err => console.error("Failed to fetch players:", err))
        .finally(() => setLoading(false));
    }

    useEffect(() => {
        if (!selectedLeague) return;
        if (!selectedSeasonIDs.length) return;
        if (!selectedTeam) return;
        handleSearch();
    }, [pageNumber, selectedLeague, selectedSeasonIDs, selectedTeam, userTeamPlayers]);

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
        fetch("http://localhost:5000/api/seasons/")
            .then(res => res.json())
            .then(data => setSeasons(data));
    }, []);

    useEffect(() => {
        if (!selectedLeague || seasons.length === 0 || allLeagues.length === 0) return;
        setSelectedSeason(null);
        setSelectedTeam(null);
        setSelectedTeamName("");
        setTeams([]);

        const leagueName = allLeagues.find(l => l.LeagueID === selectedLeague)?.LeagueName;
        const leagueSeasons = seasons.filter(s => s.LeagueName === leagueName);
        if (leagueSeasons.length > 0) {
            const yearPart = leagueSeasons[0].SeasonName.split(" ").pop();
            setSelectedSeason(yearPart);
        }
    }, [selectedLeague, seasons, allLeagues]);

    useEffect(() => {
        if (!selectedSeason || !selectedLeague) return;

        const leagueName = allLeagues.find(l => l.LeagueID === selectedLeague)?.LeagueName;
        const seasonObj = seasons.find(s =>
            s.SeasonName.includes(selectedSeason) && s.LeagueName === leagueName
        );
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
    }, [selectedSeason, selectedLeague, seasons, allLeagues]);

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

    const handleAddPlayer = (teamPlayerID) => {
        fetch("http://localhost:5000/api/userteam/add/", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${token}`
            },
            body: JSON.stringify({ teamPlayerID })
        })
        .then(res => res.json())
        .then(data => {
            console.log(data.message);
            fetchRoster(selectedSeasonIDs);
        });
    }

    const handleRemovePlayer = (teamPlayerID) => {
        fetch("http://localhost:5000/api/userteam/remove/", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${token}`
            },
            body: JSON.stringify({ teamPlayerID })
        })
        .then(res => res.json())
        .then(data => {
            console.log(data.message);
            fetchRoster(selectedSeasonIDs);
        });
    }

    const handleKeyDown = (event) => {
        handleSearch();
    }

    const incrementPage = () => setPageNumber(prev => prev + 1);
    const decrementPage = () => setPageNumber(prev => prev - 1);

    if (loading) return <p className="loading">Loading...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Welcome, {username}!</h1>
            <p className="page-subtitle">Manage your fantasy roster</p>

            {/* Roster */}
            <div className="card-dark">
                <div className="card-title">My Roster</div>
                {userTeamPlayers.length === 0
                    ? <p style={{ color: 'var(--text-muted)', fontSize: 13 }}>No players on your roster yet.</p>
                    : <table className="table-dark-custom">
                        <thead>
                            <tr>
                                <th>Player</th>
                                <th>Position</th>
                                <th>Team</th>
                                <th>Remove</th>
                            </tr>
                        </thead>
                        <tbody>
                            {userTeamPlayers.map(u => (
                                <tr key={u.PlayerID}>
                                    <td>{u.PlayerName}</td>
                                    <td>{u.Position}</td>
                                    <td>{u.TeamName}</td>
                                    <td>
                                        <button onClick={() => handleRemovePlayer(u.TeamPlayerID)}>Remove</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                }
            </div>

            {/* Search */}
            <div className="card-dark">
                <div className="card-title">Search Players</div>
                <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginBottom: 12 }}>
                    <input
                        className="auth-input"
                        placeholder="Player name"
                        onChange={e => setPlayerName(e.target.value)}
                        style={{ flex: 1, minWidth: 140 }}
                        type="text"
                        onKeyDown={handleKeyDown}
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
                            seasons
                                .filter(s => s.LeagueName === allLeagues.find(l => l.LeagueID === selectedLeague)?.LeagueName)
                                .map(s => (
                                    <option key={s.SeasonID} value={s.SeasonName.split(" ").pop()}>
                                        {s.SeasonName.split(" ").pop()}
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
                <div>
                    <button onClick={() => handleSearch()}>Search</button>
                </div>
                {players.length > 0 && (
                    <table className="table-dark-custom" style={{ marginTop: 16 }}>
                        <thead>
                            <tr>
                                <th>Player</th>
                                <th>Position</th>
                                <th>Age</th>
                                <th>Add</th>
                            </tr>
                        </thead>
                        <tbody>
                            {players
                                .filter(p => !userTeamPlayers.some(u => u.PlayerID === p.PlayerID))
                                .map(p => (
                                    <tr key={p.TeamPlayerID}>
                                        <td>{p.PlayerName}</td>
                                        <td>{p.Position}</td>
                                        <td>{p.PlayerAge}</td>
                                        <td>
                                            <button
                                                onClick={() => handleAddPlayer(p.TeamPlayerID)}
                                                disabled={userTeamPlayers.length === 11}
                                            >Add</button>
                                        </td>
                                    </tr>
                                ))}
                        </tbody>
                    </table>
                )}
                <div style={{ display: 'flex', gap: 10, marginTop: 16, justifyContent: "center" }}>
                    <button onClick={decrementPage} disabled={pageNumber === 1}>Previous Page</button>
                    <button onClick={incrementPage} disabled={players.length < 20}>Next Page</button>
                </div>
            </div>
        </div>
    );
}