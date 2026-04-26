import { useEffect, useState } from "react"


export default function Dashboard()
{
    const username = sessionStorage.getItem("username");
    const token = sessionStorage.getItem("token");

    const [userTeamPlayers, setUserTeamPlayers] = useState([]); // roster
    const [players, setPlayers] = useState([]); // players to select
    const [loading, setLoading] = useState(true);
    const [toggle, setToggle] = useState(false);

    const [playerName, setPlayerName] = useState("");
    const [teamName, setTeamName] = useState("");
    const [leagueName, setLeagueName] = useState("");
    const [seasonDate, setSeasonDate] = useState("");

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/userteam/", {
            headers: { Authorization: `Bearer ${token}` }
        })  
        .then(res => res.json())
        .then(data => {
            setUserTeamPlayers(data)
            setLoading(false);
        })
        .catch (err => console.error("Failed to fetch players:", err));
    }, []);

    // useEffect(() => {
    //     fetch("http://localhost:5000/api/players")
    //     .then(res => res.json())
    //     .then(data => {
    //         setPlayers(data)
    //     })
    // }, []);

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
            setToggle(true)
            setPlayers(data);
      });
    }

    // const handleAdd = () => {
    //     fetch("http://localhost:5000/api/userteam/add/", {
    //         method: "POST",
    //         headers: { "Content-Type": "application/json" },
    //         body: JSON.stringify({ TeamPlayerID })
    //     })
    //     .then(res => res.json())
    //     .then(data => {
    //         console.log(data.message);
    //   });
    // }


    // const handleRemove = () => {
    //     fetch("http://localhost:5000/api/userteam/remove/", {
    //         method: "POST",
    //         headers: { "Content-Type": "application/json" },
    //         body: JSON.stringify({ TeamPlayerID })
    //     })
    //     .then(res => res.json())
    //     .then(data => {
    //         console.log(data.message);
    //   });
    // }


    if (loading) return <p>Loading...</p>

    return (
        <div>
            <h1>Welcome, {username}, to our website</h1>
            <div>
                <div>
                    <h3>Roster</h3>
                    {userTeamPlayers.map(u => <p key={u.PlayerID}>{u.PlayerName} | {u.Position} | {u.TeamName}</p>)}
                </div>
                <button>Add Player to Roster</button>
                <button>Remove Player from Roster</button>
                <div>
                    <div>
                        <input placeholder="Player name" onChange={e => setPlayerName(e.target.value)} />
                        <input placeholder="Team name" onChange={e => setTeamName(e.target.value)} />
                        <input placeholder="League name" onChange={e => setLeagueName(e.target.value)} />
                        <input placeholder="Season" type="date" onChange={e => setSeasonDate(e.target.value)} />
                    </div>
                    <div>
                        <button onClick={handleSearch}>Search</button>
                    </div>
                    {toggle && (
                        players.map(p => <p key={p.PlayerID}>{p.PlayerName} | {p.Position} | {p.PlayerAge}</p>))}
                </div>
            </div>
        </div>
    );
}