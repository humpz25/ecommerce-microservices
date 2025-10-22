<template>
  <form class="checkout-form" @submit.prevent="placeOrder">
    <h3>Complete Your Order</h3>

    <!-- Email Input -->
    <input
      v-model="userEmail"
      type="email"
      placeholder="Enter your email"
      required
      class="input"
    />

    <!-- Cart Items List -->
    <div v-if="props.cart.length" class="cart-items">
      <h4>Items in Cart</h4>
      <ul>
        <li v-for="item in props.cart" :key="item.product_id">
          <span class="name">{{ item.name }}</span>
          <span class="qty">x{{ item.quantity }}</span>
          <span class="price">${{ (item.price * item.quantity).toFixed(2) }}</span>
          <button type="button" class="remove-btn" @click="removeItem(item.product_id)">
            &times;
          </button>
        </li>
      </ul>
      <p class="total">
        Total: $
        {{
          props.cart
            .reduce((sum, item) => sum + item.price * item.quantity, 0)
            .toFixed(2)
        }}
      </p>
    </div>

    <p v-else class="empty-cart">Your cart is empty.</p>

    <!-- Submit Button -->
    <button type="submit" :disabled="loading || !props.cart.length">
      {{ loading ? "Placing Order..." : "Place Order" }}
    </button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref, PropType } from "vue";
import axios from "axios";
import type { CartItem } from "../types";

export default defineComponent({
  name: "CheckoutForm",

  props: {
    cart: {
      type: Array as PropType<CartItem[]>,
      required: true,
    },
  },

  setup(props) {
    const userEmail = ref("");
    const loading = ref(false);
    const checkoutUrl = import.meta.env.VITE_API_CHECKOUT as string;

    /** Remove an item from the cart */
    const removeItem = (productId: number) => {
      const index = props.cart.findIndex((item) => item.product_id === productId);
      if (index !== -1) props.cart.splice(index, 1);
    };

    const placeOrder = async () => {
      if (!userEmail.value.trim()) {
        alert("Please enter your email.");
        return;
      }

      if (!props.cart.length) {
        alert("Your cart is empty!");
        return;
      }

      loading.value = true;

      try {
        const res = await axios.post(checkoutUrl, {
          user_email: userEmail.value,
          items: props.cart,
        });

        alert(
          `✅ Order placed! ID: ${res.data.order.id}\nCheck Mailhog at http://localhost:8025`
        );

        // Clear cart + form
        props.cart.splice(0);
        userEmail.value = "";
      } catch (err: any) {
        console.error("Checkout error:", err);
        alert(
          err.response?.data?.error ||
            "Error placing order. Please check the Checkout service connection."
        );
      } finally {
        loading.value = false;
      }
    };

    return { userEmail, loading, placeOrder, removeItem, props };
  },
});
</script>

<style scoped>
.checkout-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  background: #ffffff;
  padding: 1.5rem;
  border-radius: 0.5rem;
  border: 1px solid #e5e7eb;
  max-width: 450px;
}

h3 {
  margin-bottom: 0.5rem;
}

.input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #d1d5db;
  border-radius: 0.25rem;
  font-family: inherit;
  font-size: 0.95rem;
}

.cart-items {
  background-color: #f3f4f6;
  padding: 0.75rem;
  border-radius: 0.25rem;
}

.cart-items ul {
  list-style: none;
  padding: 0;
  margin: 0.5rem 0;
}

.cart-items li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.25rem 0;
}

.cart-items .name {
  flex: 1;
}

.cart-items .qty {
  width: 40px;
  text-align: center;
}

.cart-items .price {
  width: 60px;
  text-align: right;
}

.remove-btn {
  background: transparent;
  border: none;
  color: #dc2626;
  font-size: 1.2rem;
  cursor: pointer;
  margin-left: 0.5rem;
  line-height: 1;
}

.remove-btn:hover {
  color: #b91c1c;
}

.total {
  font-weight: 600;
  margin-top: 0.5rem;
}

.empty-cart {
  color: #9ca3af;
}

button[type="submit"] {
  background-color: #4f46e5;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s;
}

button[type="submit"]:hover:not(:disabled) {
  background-color: #4338ca;
}

button[type="submit"]:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}
</style>
