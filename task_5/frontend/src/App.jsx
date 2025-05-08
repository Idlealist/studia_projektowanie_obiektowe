import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import Products from "./components/Products";
import Cart from "./components/Cart";
import Checkout from "./components/Checkout";
import { CartProvider } from "./context/CartContext";

function App() {
  return (
    <CartProvider>
      <Router>
        <nav>
          <Link to="/produkty">Produkty</Link> |{" "}
          <Link to="/koszyk">Koszyk</Link> |{" "}
          <Link to="/platnosci">Płatności</Link>
        </nav>
        <Routes>
          <Route path="/produkty" element={<Products />} />
          <Route path="/koszyk" element={<Cart />} />
          <Route path="/platnosci" element={<Checkout />} />
        </Routes>
      </Router>
    </CartProvider>
  );
}

export default App;
