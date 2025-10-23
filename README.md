# Ecommerce Microservices

A microservices-based E-commerce platform built with Laravel and Vue 3 + TypeScript.

### Services included:
- **Catalog Service** (Laravel) – manages products API
- **Checkout Service** (Laravel) – handles orders and checkout
- **Email Service** (Laravel) – sends order summaries via Mailhog
- **Frontend** (Vue 3 + TS) – browse products, view details, and place orders
- **Mailhog** – captures outgoing emails for testing

---

## Prerequisites

Before you start, make sure you have:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Optional: Node.js and npm if you want to run frontend outside Docker

---

## Project Structure

ecommerce-microservices/
│
├─ catalog-service/ # Laravel service for products
├─ checkout-service/ # Laravel service for orders
├─ email-service/ # Laravel service for sending emails
├─ frontend/ # Vue 3 + TS frontend
├─ docker-compose.yml # Docker Compose configuration
└─ README.md


---

## Setup

1. Clone the repository:

```bash
git clone <repository-url>
cd ecommerce-microservices
```

2. Build and start all services:

```bash
docker-compose build
docker-compose up -d
docker exec -it catalog php artisan db:seed --class=ProductSeeder
```

This will:

Build Laravel and frontend services

Start MySQL databases for Catalog and Checkout

Start Mailhog for testing emails

Run migrations for Laravel services

Seed initial product data

Access services:
Frontend: http://localhost:5173
Mailhog: http://localhost:8025
Catalog API: http://localhost:8001/api/products
Checkout API: http://localhost:8002/api/checkout
Email Service API: http://localhost:8003/api/send-order-summary

Usage
Open the frontend in your browser.
Browse the Product Catalog.
Add products to your cart.
Place your order using a valid email.
Check Mailhog at http://localhost:8025 for order confirmation emails.

Development Notes
Hot Reload: Frontend changes are reflected instantly in the browser when using Docker volumes.
Cart: Items added to cart are tracked in frontend state (no backend persistence).
Checkout: Sends order data to the Checkout service, which stores orders in the database and sends an email via the Email service.

Database
Catalog DB: catalog_db (MySQL 8)
Checkout DB: checkout_db (MySQL 8)

Reset Databases

```bash
docker-compose down -v
docker-compose up -d
```

This removes all volumes and starts fresh.

API Endpoints
Catalog Service
GET /api/products – list all products
GET /api/products/:id – get product details

Checkout Service
POST /api/checkout – place an order

Email Service
POST /api/send-order-summary – sends order summary email

Environment Variables
Frontend: .env file
VITE_API_CATALOG=http://catalog:8000/api/products
VITE_API_CHECKOUT=http://checkout:8000/api/checkout

Laravel services: .env for database, email, and service URLs

Troubleshooting

Products not loading: Ensure catalog service is running and accessible at http://catalog:8000/api/products.

Email not sending: Check email service and Mailhog.

Database issues: Use docker-compose down -v to reset databases and start fresh.

Notes

This setup is for development/testing purposes.