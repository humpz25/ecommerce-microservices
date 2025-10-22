export interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  stock: number;
  created_at?: string | null;
  updated_at?: string | null;
}

export interface CartItem {
  product_id: number;
  quantity: number;
}
