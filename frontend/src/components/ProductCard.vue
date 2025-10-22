<template>
  <div class="product-card">
    <!-- Product image (optional/fallback) -->
    <img
      v-if="product.image"
      :src="product.image"
      :alt="product.name"
      class="product-image"
    />
    <div v-else class="product-placeholder">No Image</div>

    <!-- Product info -->
    <h3 class="product-name">{{ product.name || "Unnamed Product" }}</h3>
    <p class="product-description">
      {{ product.description || "No description available." }}
    </p>

    <!-- Price -->
    <p class="product-price">
      <strong>
        {{
          isFinite(Number(product.price))
            ? `$${Number(product.price).toFixed(2)}`
            : "Price unavailable"
        }}
      </strong>
    </p>

    <!-- Stock -->
    <p
      v-if="Number(product.stock) > 0"
      class="product-stock"
    >
      Stock: {{ product.stock }}
    </p>
    <p v-else class="out-of-stock">Out of stock</p>

    <!-- Add to cart -->
    <button
      :disabled="!Number(product.stock)"
      @click="handleAddToCart"
    >
      Add to Cart
    </button>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";
import { Product } from "../types";

export default defineComponent({
  name: "ProductCard",
  props: {
    product: {
      type: Object as PropType<Product>,
      required: true,
    },
  },
  emits: ["add-to-cart"],
  setup(props, { emit }) {
    const handleAddToCart = () => {
      emit("add-to-cart", props.product);
    };

    return { handleAddToCart };
  },
});
</script>

<style scoped>
.product-card {
  border: 1px solid #e5e7eb;
  padding: 1rem;
  border-radius: 0.75rem;
  width: 220px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  background-color: #fff;
  transition: box-shadow 0.2s ease, transform 0.1s ease;
}

.product-card:hover {
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.product-image {
  width: 100%;
  height: 140px;
  object-fit: cover;
  border-radius: 0.5rem;
}

.product-placeholder {
  width: 100%;
  height: 140px;
  background: #f3f4f6;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #9ca3af;
  font-size: 0.9rem;
}

.product-name {
  font-size: 1rem;
  font-weight: 600;
  text-align: center;
}

.product-description {
  font-size: 0.875rem;
  color: #6b7280;
  text-align: center;
}

.product-price {
  font-weight: 700;
  color: #111827;
}

.product-stock {
  font-size: 0.875rem;
  color: #16a34a;
}

.out-of-stock {
  color: #dc2626;
  font-weight: 600;
}

button {
  background-color: #4f46e5;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

button:hover:not(:disabled) {
  background-color: #4338ca;
}

button:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}
</style>
