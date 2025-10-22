<template>
  <div id="app">
    <header class="header">
      <h1>My E-commerce Store</h1>
    </header>

    <main>
      <RouterView />
    </main>

    <footer class="footer">
      <p>&copy; 2025 Ecommerce</p>
    </footer>
  </div>
</template>

<script lang="ts" setup>
</script>

<style scoped>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  margin: 0;
  padding: 0;
}

.header {
  background-color: #4f46e5;
  color: white;
  padding: 1rem;
  text-align: center;
}

.footer {
  text-align: center;
  padding: 1rem;
  background-color: #e5e7eb;
  margin-top: 2rem;
}
</style>
