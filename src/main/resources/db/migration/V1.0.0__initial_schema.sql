CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- V1.0.0__create_products_table.sql
CREATE TABLE test (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 1. Categories
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    parent_id UUID REFERENCES categories(id),
    description TEXT,
    image_url VARCHAR(500)
);

CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo_url VARCHAR(500),
    description TEXT
);

-- 2. Products (The Parent)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    product_type VARCHAR(20) DEFAULT 'SIMPLE', -- SIMPLE or VARIABLE
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Product Variants (Handles Color/Size via JSONB)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(100) UNIQUE NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    sale_price DECIMAL(12, 2),
    sale_start_date TIMESTAMP,
    sale_end_date TIMESTAMP,
    stock_quantity INTEGER DEFAULT 0,
    attributes JSONB, -- Stores {"color": "Red", "size": "XL"}
    weight_kg DECIMAL(5,2)
);

-- 4. Product Gallery (Multiple Images)
CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE
);

-- 5. Customer Profiles & Base Address
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shopper_type VARCHAR(20) DEFAULT 'GUEST',
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    address_line_1 TEXT,
    address_line_2 TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(10),
    password_hash VARCHAR(255) NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Orders / Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id  UUID        NOT NULL,
    customer_id UUID REFERENCES customers(id),
    total_amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    shipping_phone VARCHAR(20),
    shipping_address_line1 VARCHAR(255),
    shipping_address_line2 VARCHAR(255),
    shipping_city VARCHAR(100),
    shipping_province VARCHAR(100),
    shipping_postal_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Order Items (Line Items)
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL
);

CREATE TABLE payment_gateway_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,

    -- Gateway Identification
    gateway_name VARCHAR(50) NOT NULL, -- 'PAYFAST', 'IKHOKHA', 'FASTPAY'

    -- Mapping IDs
    external_reference VARCHAR(100), -- The ID from the gateway (e.g., pf_payment_id)
    internal_reference VARCHAR(100), -- Your unique ID (e.g., m_payment_id or UUID)

    -- Universal Financial Data
    amount_gross DECIMAL(12, 2) NOT NULL,
    amount_fee DECIMAL(12, 2) DEFAULT 0,
    amount_net DECIMAL(12, 2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'ZAR',

    -- Status and Raw Data
    status VARCHAR(50) NOT NULL, -- 'INITIATED', 'SUCCESS', 'FAILED', 'REFUNDED'
    raw_response VARCHAR(1024),  -- Stores the unique JSON body from EACH gateway

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE store_settings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value TEXT NOT NULL,
    description TEXT
);

-- 2. Shipping Options & Fees
CREATE TABLE shipping_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL, -- 'Pick up', 'Courier'
    is_active BOOLEAN DEFAULT TRUE,
    base_fee DECIMAL(12, 2) DEFAULT 0.00,
    estimated_days VARCHAR(50)
);

-- 3. Country-Specific Fees (for Courier)
CREATE TABLE shipping_zones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipping_method_id UUID REFERENCES shipping_methods(id),
    country_code CHAR(2) NOT NULL, -- 'ZA', 'US'
    additional_fee DECIMAL(12, 2) DEFAULT 0.00
);


-- CREATE SEQUENCE IF NOT EXISTS orders_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
--
-- -- Align the sequence to be ahead of the current max(id) in orders
-- -- If there are no rows, this will set it to 1 and the first nextval will return 1
-- SELECT setval('orders_seq', COALESCE((SELECT MAX(id) FROM orders), 0) + 1, false);
--
