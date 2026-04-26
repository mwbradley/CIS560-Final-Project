import { useEffect, useState } from "react"

export default function Seasons() {
    const [seasons, setSeasons] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("http://localhost:5000/api/seasons/")
            .then(res => res.json())
            .then(data => setSeasons(data))
            .catch(err => console.error("Failed to fetch seasons:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading seasons...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Seasons</h1>
            <p className="page-subtitle">All seasons across every league</p>

            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>Season</th>
                            <th>League</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        {seasons.map(s => (
                            <tr key={s.SeasonID}>
                                <td>{s.SeasonName}</td>
                                <td><span className="badge-green">{s.LeagueName}</span></td>
                                <td>{s.SeasonStartDate}</td>
                                <td>{s.SeasonEndDate}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}