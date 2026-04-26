import { useEffect, useState } from "react"

export default function Matches()
{
    const [matches, setMatches] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/matches/")
        .then(res => res.json())
        .then(data => {
            setMatches(data)
            setLoading(false)  // Added this because of the slight delay
        })
        .catch(err => console.error("Failed to fetch matches:", err));
    }, []);

    if (loading) return <p>Loading matches...</p>

    return (
        <div>
            <h1>
                Matches
            </h1>
            {matches.map(m => <p key={m.MatchID}>{m.MatchDate} | {m.MatchLocation} | {m.HomeTeam} vs. {m.AwayTeam} | Winner: {m.Winner} |</p>)}
        </div>
    );
}