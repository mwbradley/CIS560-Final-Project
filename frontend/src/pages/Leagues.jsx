import { useEffect, useState } from "react"

export default function Leagues()
{
    const [leagues, setLeagues] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/leagues/")
        .then(res => res.json())
        .then(data => {
            setLeagues(data)
            setLoading(false)  // Added this because of the slight delay
        })
        .catch(err => console.error("Failed to fetch leagues:", err));
    }, []);

    if (loading) return <p>Loading leagues...</p>

    return (
        <div>
            <h1>
                Leagues
            </h1>
            {leagues.map(l => <p key={l.LeagueID}>{l.LeagueName} | {l.TeamCount}</p>)}
        </div>
    );
}