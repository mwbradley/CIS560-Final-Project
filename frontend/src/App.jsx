import { Routes, Route } from 'react-router-dom'
//import Sidebar from './components/Sidebar'
//import Dashboard from './pages/Home'
//import Leagues from './pages/Leagues'
//import Seasons from './pages/Seasons'
//import Teams from './pages/Teams'
//import Players from './pages/Players'
//import Matches from './pages/Matches'
//import styles from './App.module.css'
import Register from './pages/Register'
import Login from './pages/Login'

export default function App() {
  return (
    <div>
      <Routes>
        <Route path="/register" element={<Register/>}/>
        <Route path="/login" element={<Login/>}/>
      </Routes>
      <Leagues/>
    </div>
  )
}