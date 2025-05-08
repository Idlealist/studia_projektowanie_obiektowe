import { useState, useEffect, useContext } from "react";
import axios from "axios";
import { CartContext } from "../context/CartContext";

export default function Products() {
  const [products, setProducts] = useState([]);
  const { addToCart } = useContext(CartContext);

  useEffect(() => {
    axios.get('http://localhost:8080/products')
      .then(res => setProducts(res.data))
      .catch(err => console.error(err));
  }, []);

  return (
    <div>
      <h2>Produkty</h2>
      {products.map(product => (
        <div key={product.id}>
          <h3>{product.name} - {product.price} zł</h3>
          <button onClick={() => addToCart(product)}>Dodaj do koszyka</button>
        </div>
      ))}
    </div>
  );
}
