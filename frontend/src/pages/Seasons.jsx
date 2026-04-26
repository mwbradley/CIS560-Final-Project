import { useEffect, useState } from "react"

export default function Seasons()
{
    const [seasons, setSeasons] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/seasons/")
        .then(res => res.json())
        .then(data => {
            setSeasons(data)
            setLoading(false)  // Added this because of the slight delay
        })
        .catch(err => console.error("Failed to fetch seasons:", err));
    }, []);

    if (loading) return <p>Loading seasons...</p>

    return (
        <div>
            <h1>
                Seasons
            </h1>
            {seasons.map(s => <p key={s.SeasonID}>{s.SeasonName} | {s.LeagueName} | {s.SeasonStartDate} - {s.SeasonEndDate}</p>)}
        </div>
    );
}