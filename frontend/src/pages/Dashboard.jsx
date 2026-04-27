import { useEffect, useState } from "react"

export default function Dashboard() {
    const username = sessionStorage.getItem("username");
    const token = sessionStorage.getItem("token");

    console.log("TOKEN:", token);

    const [userTeamPlayers, setUserTeamPlayers] = useState([]);
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [toggle, setToggle] = useState(false);

    const [playerName, setPlayerName] = useState("");
    const [teamName, setTeamName] = useState("");
    const [leagueName, setLeagueName] = useState("");
    const [seasonDate, setSeasonDate] = useState("");

    const [seasonID, setSeasonID] = useState(1);
    const [pageNumber, setPageNumber] = useState(1);

    const fetchRoster = () => {
    fetch(`http://localhost:5000/api/userteam/`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({ seasonID })
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
        fetchRoster();
    }, [seasonID]);

    useEffect(() => {
    handleSearch();
    }, [pageNumber]);

    const handleDisplayPlayers = () => {
        fetch("http://localhost:5000/api/players/")
            .then(res => res.json())
            .then(data => {
                if (!toggle) setToggle(true)
                else setToggle(false)
                setPlayers(data);
            });
    }

    const handleSearch = () => {
        fetch("http://localhost:5000/api/players/search/", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ playerName, teamName, leagueName, seasonDate, seasonID, pageNumber })
        })
            .then(res => res.json())
            .then(data => {
                setToggle(true);
                setPlayers(data);
            });
    }

    const handleAddPlayer = (teamPlayerID) => {
        fetch("http://localhost:5000/api/userteam/add/", {
            method: "POST",
            headers: { 
                "Content-Type": "application/json",
                Authorization: `Bearer ${token}`
            },
            body: JSON.stringify({ teamPlayerID, seasonID })
        })
        .then(res => res.json())
        .then(data => {
            console.log(data.message);
            fetchRoster();
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
            fetchRoster();
        });
    }

    const incrementPage = () => {
        setPageNumber(prevCount => prevCount + 1);
    }

    const decrementPage = () => {
        setPageNumber(prevCount => prevCount - 1);
    }

    if (loading) return <p className="loading">Loading...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Welcome, {username}!</h1>
            <p className="page-subtitle">Manage your fantasy roster</p>

            {/* Roster */}
            <div className="card-dark">
                <div className="card-title">My Roster</div>
                <div className="roster-buttons">
                    <button onClick={() => setSeasonID(1)}>Season 2022</button>
                    <button onClick={() => setSeasonID(2)}>Season 2023</button>
                    <button onClick={() => setSeasonID(3)}>Season 2024</button>
                </div>
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
                {/* <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
                    <button className="auth-button" onClick={handleDisplayPlayers}
                        style={{ width: 'auto', padding: '8px 20px' }}>
                        {toggle ? 'Hide Players' : 'Add Player to Roster'}
                        Add Player to Roster
                    </button>
                </div> */}
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
                    />
                    <input
                        className="auth-input"
                        placeholder="Team name"
                        onChange={e => setTeamName(e.target.value)}
                        style={{ flex: 1, minWidth: 140 }}
                    />
                    <input
                        className="auth-input"
                        placeholder="League name"
                        onChange={e => setLeagueName(e.target.value)}
                        style={{ flex: 1, minWidth: 140 }}
                    />
                    <input
                        className="auth-input"
                        placeholder="Season"
                        type="date"
                        onChange={e => setSeasonDate(e.target.value)}
                        style={{ flex: 1, minWidth: 140 }}
                    />
                </div>
                <button className="auth-button" onClick={handleSearch}
                    style={{ width: 'auto', padding: '8px 20px' }}>
                    Search
                </button>

                {toggle && (
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
                                .filter(p => !userTeamPlayers.some(u => u.TeamPlayerID === p.TeamPlayerID))
                                .map(p => (
                                <tr key={p.PlayerID}>
                                    <td>{p.PlayerName}</td>
                                    <td>{p.Position}</td>
                                    <td>{p.PlayerAge}</td>
                                    <td>
                                        <button onClick={() => handleAddPlayer(p.TeamPlayerID)} disabled={userTeamPlayers.length === 11}>Add</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
                <div style={{ display: 'flex', gap: 10, marginTop: 16, justifyContent: "center" }}>
                    <button onClick={() => decrementPage()} disabled={pageNumber === 1}>Previous Page</button>
                    <button onClick={() => incrementPage()} disabled={players.length < 20}>Next Page</button>
                </div>
            </div>
        </div>
    );
}