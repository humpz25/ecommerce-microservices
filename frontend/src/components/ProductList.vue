<template>
  <div>
    <h2>Products</h2>
    <div v-if="loading">Loading...</div>
    <div v-else>
      <ProductCard
        v-for="product in products"
        :key="product.id"
        :product="product"
      />
    </div>
  </div>
</template>

<script>
import axios from "axios";
import ProductCard from "./ProductCard.vue";

export default {
  components: { ProductCard },
  data() {
    return {
      products: [],
      loading: true,
    };
  },
  async mounted() {
    try {
      const res = await axios.get("http://localhost:8001/api/products");
      this.products = res.data;
    } catch (err) {
      console.error(err);
    } finally {
      this.loading = false;
    }
  },
};
</script>
