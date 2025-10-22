<template>
  <section class="home">
    <!-- Product Catalog -->
    <section class="products">
      <h2>Product Catalog</h2>
      <div v-if="loading">Loading products...</div>

      <div v-else-if="products.length" class="product-grid">
        <ProductCard
          v-for="product in products"
          :key="product.id"
          :product="product"
          @add-to-cart="addToCart"
        />
      </div>

      <div v-else class="no-products">
        No products found.
      </div>
    </section>

    <!-- Checkout Section -->
    <section class="checkout" v-if="cart.length > 0">
      <h2>Checkout</h2>
      <CheckoutForm :cart="cart" />
    </section>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from "vue";
import axios from "axios";
import ProductCard from "../components/ProductCard.vue";
import CheckoutForm from "../components/CheckoutForm.vue";
import type { Product, CartItem } from "../types";

export default defineComponent({
  name: "Home",
  components: { ProductCard, CheckoutForm },

  setup() {
    const products = ref<Product[]>([]);
    const loading = ref(true);
    const cart = ref<CartItem[]>([]);
    const catalogUrl = import.meta.env.VITE_API_CATALOG as string;

    /** 🛒 Add to cart handler */
    const addToCart = (product: Product) => {
      const existing = cart.value.find((item) => item.product_id === product.id);
      if (existing) {
        existing.quantity += 1;
      } else {
        cart.value.push({
          product_id: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
        });
      }
    };

    /** 🧩 Fetch product list */
    const fetchProducts = async () => {
      try {
        console.log("Fetching products from:", catalogUrl);
        const res = await axios.get(catalogUrl);

        // Handle APIs that wrap data in a `data` field
        const result = Array.isArray(res.data)
          ? res.data
          : res.data.data || [];

        console.log("Fetched products:", result);
        products.value = result;
      } catch (err) {
        console.error("❌ Failed to fetch products:", err);
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchProducts);

    return { products, loading, cart, addToCart };
  },
});
</script>

<style scoped>
.products {
  padding: 1rem;
}

.product-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.checkout {
  padding: 1rem;
  background-color: #f3f4f6;
  margin-top: 2rem;
}

.no-products {
  padding: 1rem;
  text-align: center;
  color: #9ca3af;
}
</style>
