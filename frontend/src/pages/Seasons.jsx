import { useEffect, useState } from "react"

export default function Leagues()
{
    const [seasons, setSeason] = useState([]);

    useEffect(() =>
    {
        fetch("http://localhost:5000/api/seasons/")
        .then(res => res.json())
        .then(data => setSeason(data))
        .catch (err => console.error("Failed to fetch seasons:", err));
    }, []);

    return (
        <div>
            <h1>
                Seasons
            </h1>
            {seasons.map(s => <p key={s.SeasonID}>{s.SeasonName} | {s.SeasonStartDate} | {s.SeasonEndDate}</p>)}
        </div>
    );
}