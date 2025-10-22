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

    <!-- Cart Items JSON (auto-filled) -->
    <textarea
      v-model="itemsJson"
      placeholder="Order items (JSON)"
      readonly
      class="textarea"
    ></textarea>

    <!-- Submit Button -->
    <button type="submit" :disabled="loading">
      {{ loading ? "Placing Order..." : "Place Order" }}
    </button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref, PropType, watch } from "vue";
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
    const itemsJson = ref("");
    const loading = ref(false);
    const checkoutUrl = import.meta.env.VITE_API_CHECKOUT as string;

    // 🧩 Keep itemsJson synced with cart updates
    watch(
      () => props.cart,
      (newCart) => {
        itemsJson.value = JSON.stringify(newCart, null, 2);
      },
      { deep: true, immediate: true }
    );

    // 🧾 Place order via Checkout API
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
        console.log("Placing order to:", checkoutUrl);
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
        itemsJson.value = "";
      } catch (err: any) {
        console.error("❌ Checkout error:", err);
        alert(
          err.response?.data?.error ||
            "Error placing order. Please check the Checkout service connection."
        );
      } finally {
        loading.value = false;
      }
    };

    return { userEmail, itemsJson, loading, placeOrder };
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
  max-width: 400px;
}

h3 {
  margin-bottom: 0.5rem;
}

.input,
.textarea {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #d1d5db;
  border-radius: 0.25rem;
  font-family: inherit;
  font-size: 0.95rem;
}

.textarea {
  min-height: 120px;
  background-color: #f9fafb;
}

button {
  background-color: #4f46e5;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s;
}

button:hover {
  background-color: #4338ca;
}

button:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}
</style>
