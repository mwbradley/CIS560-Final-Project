import 'bootstrap/dist/css/bootstrap.css';
import { Nav, Navbar, Container } from "react-bootstrap";
import { Link, useLocation } from 'react-router-dom';

function Navigation() {
    const location = useLocation();

    return (
        <Navbar className="custom-nav" sticky="top" expand="lg" collapseOnSelect>
            <Container>
                <Navbar.Brand as={Link} to="/" className="fw-bold">
                    Fantasy FC Database
                </Navbar.Brand>
                <Navbar.Toggle />
                <Navbar.Collapse>
                    <Nav className="ms-auto fw-bold fs-6">
                        <Nav.Link as={Link} to="/dashboard" active={location.pathname === '/dashboard'}>Dashboard</Nav.Link>
                        <Nav.Link as={Link} to="/leagues" active={location.pathname === '/leagues'}>Leagues</Nav.Link>
                        <Nav.Link as={Link} to="/seasons" active={location.pathname === '/seasons'}>Seasons</Nav.Link>
                        <Nav.Link as={Link} to="/teams" active={location.pathname === '/teams'}>Teams</Nav.Link>
                        <Nav.Link as={Link} to="/players" active={location.pathname === '/players'}>Players</Nav.Link>
                        <Nav.Link as={Link} to="/matches" active={location.pathname === '/matches'}>Matches</Nav.Link>
                        <Nav.Link as={Link} to="/register" active={location.pathname === '/register'}>Register</Nav.Link>
                        <Nav.Link as={Link} to="/login" active={location.pathname === '/login'}>Login</Nav.Link>
                    </Nav>
                </Navbar.Collapse>
            </Container>
        </Navbar>
    );
}

export default Navigation;