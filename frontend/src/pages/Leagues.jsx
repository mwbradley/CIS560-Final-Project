import { useEffect, useState } from "react"

export default function Leagues() {
    const [leagues, setLeagues] = useState([]);
    const [loading, setLoading] = useState(true);
    const [leagueRankings, setRankings] = useState([]);

    useEffect(() => {
        Promise.all([
            fetch("http://localhost:5000/api/leagues/").then(res => res.json()),
            fetch("http://localhost:5000/api/leagues/rankings/1").then(res => res.json())
        ])
            .then(([leagueData, rankingsData]) => {
                console.log("Rankings:", rankingsData);
                setLeagues(leagueData);
                setRankings(rankingsData);
            })
            .catch(err => console.error("Failed to fetch leagues:", err))
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p className="loading">Loading leagues...</p>

    return (
        <div className="page-container">
            <h1 className="page-title">Leagues</h1>
            <p className="page-subtitle">All leagues in the database</p>

            {/* League Info */}
            <div className="card-dark">
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>League</th>
                            <th>Teams</th>
                        </tr>
                    </thead>
                    <tbody>
                        {leagues.map(l => (
                            <tr key={l.LeagueID}>
                                <td>{l.LeagueName}</td>
                                <td>{l.TeamCount}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            {/* League Standings */}
            <div className="card-dark">
                <div className="card-title">League Standings</div>
                <table className="table-dark-custom">
                    <thead>
                        <tr>
                            <th>Team</th>
                            <th>Season</th>
                            <th>Played</th>
                            <th>Wins</th>
                            <th>Draws</th>
                            <th>Losses</th>
                            <th>Points</th>
                        </tr>
                    </thead>
                    <tbody>
                        {leagueRankings.map(l => (
                            <tr key={l.TeamName}>
                                <td>{l.TeamName}</td>
                                <td>{l.SeasonName}</td>
                                <td>{l.Played}</td>
                                <td>{l.Wins}</td>
                                <td>{l.Draws}</td>
                                <td>{l.Losses}</td>
                                <td>{l.Points}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}