import { useContext } from "react";
import { CartContext } from "../context/CartContext";
import { Link } from "react-router-dom";

export default function Cart() {
  const { cart } = useContext(CartContext);

  const groupedCart = cart.reduce((acc, item) => {
    if (acc[item.id]) {
      acc[item.id].quantity += 1;
    } else {
      acc[item.id] = { ...item, quantity: 1 };
    }
    return acc;
  }, {});

  const cartItems = Object.values(groupedCart);

  return (
    <div>
      <h2>Koszyk</h2>
      {cartItems.length === 0 ? (
        <p>Koszyk jest pusty</p>
      ) : (
        cartItems.map((item) => (
          <div key={item.id}>
            {item.name} - {item.price} zł x {item.quantity} 
          </div>
        ))
      )}
      <Link to="/platnosci">
        <button disabled={cartItems.length === 0}>Przejdź do płatności</button>
      </Link>
    </div>
  );
}
