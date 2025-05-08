import { useContext } from "react";
import { CartContext } from "../context/CartContext";
import axios from "axios";

export default function Checkout() {
  const { cart, clearCart } = useContext(CartContext);
  const sum = cart.reduce((acc, item) => acc + item.price, 0);

  const handleCheckout = async () => {
    try {
      await axios.post('http://localhost:8080/checkout', cart, {
        headers: { 'Content-Type': 'application/json' }
      });
      clearCart();
      alert("Płatność zakończona!");
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div>
      <h2>Płatności</h2>
      <h3>Suma: {sum.toFixed(2)} zł</h3>
      <button onClick={handleCheckout} disabled={cart.length === 0}>
        Zapłać teraz
      </button>
    </div>
  );
}
