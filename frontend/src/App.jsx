import { Routes, Route } from 'react-router-dom'
import Nav from './components/Navigation'
//import Dashboard from './pages/Home'
import Leagues from './pages/Leagues'
import Seasons from './pages/Seasons'
import Teams from './pages/Teams'
import Players from './pages/Players'
import Matches from './pages/Matches'
import './App.css'
import Register from './pages/Register'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'

export default function App() {

  return (
    <div>
      <Nav />
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/leagues"   element={<Leagues />} />
        <Route path="/seasons"  element={<Seasons />} />
        <Route path="/players"   element={<Players />} />
        <Route path="/teams"    element={<Teams />} />
        <Route path="/matches"  element={<Matches />} />
        <Route path="/register"  element={<Register />} />
      </Routes>
    </div>
  )
}