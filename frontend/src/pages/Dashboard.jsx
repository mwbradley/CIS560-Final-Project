import { useEffect, useState } from "react"

export default function Dashboard() {
    const username = sessionStorage.getItem("username");
    const token = sessionStorage.getItem("token");

    const [userTeamPlayers, setUserTeamPlayers] = useState([]);
    const [players, setPlayers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [toggle, setToggle] = useState(false);

    const [playerName, setPlayerName] = useState("");
    const [teamName, setTeamName] = useState("");
    const [leagueName, setLeagueName] = useState("");
    const [seasonDate, setSeasonDate] = useState("");

    const fetchRoster = () => {
        fetch("http://localhost:5000/api/userteam/", {
            headers: { Authorization: `Bearer ${token}` }
        })
        .then(res => res.json())
        .then(data => {
            setUserTeamPlayers(data);
            setLoading(false);
        })
        .catch(err => console.error("Failed to fetch players:", err));
    }

    useEffect(() => {
        fetchRoster();
    }, []);

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
            body: JSON.stringify({ playerName, teamName, leagueName, seasonDate })
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
            body: JSON.stringify({ teamPlayerID })
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
                            </tr>
                        </thead>
                        <tbody>
                            {players.map(p => (
                                <tr key={p.PlayerID}>
                                    <td>{p.PlayerName}</td>
                                    <td>{p.Position}</td>
                                    <td>{p.PlayerAge}</td>
                                    <td>
                                        <button onClick={() => handleAddPlayer(p.TeamPlayerID)}>Add</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>
        </div>
    );
}