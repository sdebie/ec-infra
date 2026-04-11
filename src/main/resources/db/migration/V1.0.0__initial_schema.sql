CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE test (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(100) NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    product_type VARCHAR(20) DEFAULT 'SIMPLE', -- SIMPLE or VARIABLE
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(100) UNIQUE NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    attributes VARCHAR(254), -- Stores {"color": "Red", "size": "XL"}
    weight_kg DECIMAL(5,2)
);

CREATE TABLE variant_prices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    price_type VARCHAR(30) NOT NULL, -- 'RETAIL_PRICE', 'RETAIL_SALE_PRICE', 'WHOLESALE_PRICE', 'WHOLESALE_SALE_PRICE'
    price DECIMAL(12, 2) NOT NULL,
    price_start_date TIMESTAMP,
    price_end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID
);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE
);

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

CREATE TABLE shipping_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL, -- 'Pick up', 'Courier'
    is_active BOOLEAN DEFAULT TRUE,
    base_fee DECIMAL(12, 2) DEFAULT 0.00,
    estimated_days VARCHAR(50)
);

CREATE TABLE shipping_zones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipping_method_id UUID REFERENCES shipping_methods(id),
    country_code CHAR(2) NOT NULL, -- 'ZA', 'US'
    additional_fee DECIMAL(12, 2) DEFAULT 0.00
);

CREATE TABLE staff_users (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     email VARCHAR(100) UNIQUE NOT NULL,
     password_hash VARCHAR(255) NOT NULL,
     full_name VARCHAR(100),
     role VARCHAR(30) NOT NULL, -- Values: 'SUPER_ADMIN', 'CATALOG_MANAGER', etc.
     is_active BOOLEAN DEFAULT true,
     reset_password BOOLEAN DEFAULT false,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_upload_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL, -- 'PENDING', 'PROCESSED', 'CANCELLED'
    uploaded_by UUID REFERENCES staff_users(id), --
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_rows INTEGER DEFAULT 0,
    processed_rows INTEGER NOT NULL DEFAULT 0,
    skipped_rows   INTEGER NOT NULL DEFAULT 0,
    validation_error_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE product_upload_staged (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     batch_id UUID NOT NULL REFERENCES product_upload_batches(id) ON DELETE CASCADE,
     sku VARCHAR(100) NOT NULL, --
     name VARCHAR(255),
     description VARCHAR(255),
     short_description VARCHAR(100),
     retail_price DECIMAL(12, 2),
     wholesale_price DECIMAL(12, 2),
     retail_sale_price DECIMAL(12, 2),
     wholesale_sale_price DECIMAL(12, 2),

    -- Track state for the approval screen
     validation_status VARCHAR(50) DEFAULT 'PENDING', -- 'VALID', 'ERROR'
     validation_errors TEXT,
     image_errors TEXT,
     is_new_product BOOLEAN DEFAULT FALSE,
     is_new_variant BOOLEAN DEFAULT FALSE,
     has_changes BOOLEAN DEFAULT FALSE,

    -- Store the original data for comparison
     processed BOOLEAN DEFAULT FALSE,

     product_slug VARCHAR(255),
     category_slug VARCHAR(255),
     brand_slug VARCHAR(255),
     stock INTEGER,
     images TEXT,
     attributes TEXT,
     is_valid_category BOOLEAN DEFAULT FALSE,
     is_valid_brand BOOLEAN DEFAULT FALSE

);

CREATE TABLE product_price_upload_batches (
                                        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                        filename VARCHAR(255) NOT NULL,
                                        status VARCHAR(50) NOT NULL, -- 'PENDING', 'PROCESSED', 'CANCELLED'
                                        uploaded_by UUID REFERENCES staff_users(id), --
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        total_rows INTEGER DEFAULT 0,
                                        processed_rows INTEGER NOT NULL DEFAULT 0,
                                        skipped_rows   INTEGER NOT NULL DEFAULT 0,
                                        validation_error_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE product_price_upload_staged (
                                       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                       batch_id UUID NOT NULL REFERENCES product_price_upload_batches(id) ON DELETE CASCADE,
                                       sku VARCHAR(100) NOT NULL, --
                                       retail_price DECIMAL(12, 2),
                                       wholesale_price DECIMAL(12, 2),
                                       retail_sale_price DECIMAL(12, 2),
                                       wholesale_sale_price DECIMAL(12, 2),

    -- Track state for the approval screen
                                       validation_status VARCHAR(50) DEFAULT 'PENDING', -- 'VALID', 'ERROR'
                                       validation_errors TEXT,
                                       image_errors TEXT,
    -- Store the original data for comparison
                                       has_changes BOOLEAN DEFAULT FALSE,
                                       processed BOOLEAN DEFAULT FALSE


);