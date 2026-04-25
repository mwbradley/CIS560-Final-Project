import { useState } from "react"


export default function Home()
{
    const username = localStorage.getItem("username");

    return (
        <div>
            <h1>Welcome, {username}, to our website</h1>
        </div>
    );
}