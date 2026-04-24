import { useEffect, useState } from "react"

export default function Leagues()
{
    const [leagues, setLeagues] = useState([]);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/leagues/")
        .then(res => res.json())
        .then(data => setLeagues(data))
        .catch (err => console.error("Failed to fetch leagues:", err));
    }, []);

    return (
        <div>
            <h1>
                Leagues
            </h1>
            {leagues.map(l => <p key={l.LeagueID}>{l.LeagueName} | {l.TeamCount}</p>)}
        </div>
    );
}