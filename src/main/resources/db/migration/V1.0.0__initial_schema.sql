-- =============================================================================
-- V1.0.0 — Initial schema (consolidated baseline, 2026-07-19 re-baseline)
-- =============================================================================
-- Squashes the legacy migration history (archived in db/legacy-migrations/ —
-- note the archive reuses V1.x/V2.x numbers; those files must never run).
-- Every ALTER from legacy V1.0.1–V2.8.0 is folded into the CREATE statements
-- below.
-- Contains DDL only — all seed data lives in db/seed/default (platform) and
-- db/seed/<client> (client content), applied as repeatable migrations.
--
-- Existing databases: do NOT run this against a database that already carries
-- the V1.x/V2.x history. Follow the re-baseline runbook in ec-infra/README.md.
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ── Catalog ──────────────────────────────────────────────────────────────────

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
    slug VARCHAR(200) NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    product_type VARCHAR(20) DEFAULT 'SIMPLE', -- SIMPLE or VARIABLE
    status VARCHAR(20) DEFAULT 'ACTIVE',
    is_featured BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_is_featured ON products (name) WHERE is_featured = TRUE;

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(100) UNIQUE NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    attributes VARCHAR(254), -- Stores {"color": "Red", "size": "XL"}
    weight_kg DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE INDEX idx_product_variants_status ON product_variants(status);

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

CREATE TABLE product_categories (
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

CREATE INDEX idx_product_categories_category_id ON product_categories(category_id);
CREATE INDEX idx_product_categories_product_id ON product_categories(product_id);

-- ── Accounts ─────────────────────────────────────────────────────────────────

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Never store plain text
    roles TEXT[] DEFAULT '{RETAIL}',     -- PostgreSQL array for roles: ['WHOLESALE', 'RETAIL']
    is_active BOOLEAN DEFAULT TRUE,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Security tokens (account recovery)
    reset_token VARCHAR(255),
    reset_token_expiry TIMESTAMP WITH TIME ZONE,
    password_reset_code_hash TEXT,
    password_reset_code_expiry TIMESTAMPTZ,
    password_reset_code_attempts INTEGER NOT NULL DEFAULT 0,
    password_reset_code_locked_until TIMESTAMPTZ
);

CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- The Link
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    shopper_type VARCHAR(20) DEFAULT 'RETAIL',
    status VARCHAR(20) DEFAULT 'REGISTERING',
    additional_info VARCHAR(1025) NOT NULL DEFAULT '{}'
);

CREATE TABLE customer_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
    address_type VARCHAR(20), -- 'PHYSICAL', 'POSTAL', 'BILLING', 'SHIPPING'
    address_line_1 TEXT NOT NULL,
    address_line_2 TEXT,
    suburb VARCHAR(100),
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE wholesale_profiles (
    customer_id UUID PRIMARY KEY REFERENCES customers(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    vat_number VARCHAR(50),
    reg_number VARCHAR(100), -- CIPC Registration
    credit_limit DECIMAL(12, 2) DEFAULT 0.00,
    payment_terms_days INT DEFAULT 0 -- e.g., 30 for "Net 30"
);

CREATE TABLE customer_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
    contact_role VARCHAR(50), -- 'FINANCE', 'BUYER', 'MANAGER'
    full_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50)
);

CREATE TABLE customer_wishlist_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    variant_id  UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    created_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_customer_variant UNIQUE (customer_id, variant_id)
);

CREATE INDEX idx_wishlist_customer ON customer_wishlist_items(customer_id);

CREATE TABLE wholesale_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(255) NOT NULL,
    vat_number VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Applicant / account linkage
    applicant_email VARCHAR(255) NOT NULL,
    account_email VARCHAR(255),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    phone VARCHAR(20),
    reg_number VARCHAR(100),
    processed_at TIMESTAMP WITH TIME ZONE,
    customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,

    -- Company detail
    trading_name VARCHAR(255),
    company_phone VARCHAR(50),
    company_email VARCHAR(255),
    finance_contact_name VARCHAR(255),
    finance_contact_email VARCHAR(255),
    finance_contact_phone VARCHAR(50),
    purchase_order_required BOOLEAN DEFAULT false,

    physical_address_line1 VARCHAR(255),
    physical_address_line2 VARCHAR(255),
    physical_suburb VARCHAR(100),
    physical_city VARCHAR(100),
    physical_province VARCHAR(50),
    physical_postal_code VARCHAR(10),

    postal_address_line1 VARCHAR(255),
    postal_address_line2 VARCHAR(255),
    postal_suburb VARCHAR(100),
    postal_province VARCHAR(50),
    postal_city VARCHAR(100),
    postal_postal_code VARCHAR(10),
    rejection_reason TEXT,

    CONSTRAINT ck_wholesale_applications_status
        CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CONVERTED'))
);

CREATE UNIQUE INDEX ux_wholesale_applications_account_email_partial
    ON wholesale_applications (lower(account_email))
    WHERE account_email IS NOT NULL;

CREATE INDEX idx_wholesale_applications_customer_id
    ON wholesale_applications(customer_id);

CREATE INDEX idx_wholesale_applications_account_email
    ON wholesale_applications(lower(account_email));

-- ── Orders & payments ────────────────────────────────────────────────────────

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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Guest/contact checkout details
    contact_email       VARCHAR(255),
    contact_first_name  VARCHAR(255),
    contact_last_name   VARCHAR(255),
    shipping_method_id  UUID REFERENCES shipping_methods(id),
    street_address      VARCHAR(500),
    city                VARCHAR(255),
    province            VARCHAR(255),
    postal_code         VARCHAR(20)
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);

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

-- Order Status History (Audit Trail)
CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    status VARCHAR(30) NOT NULL,
    comment TEXT,
    changed_by VARCHAR(100), -- ID or name of staff member / 'SYSTEM'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_history
        FOREIGN KEY (order_id)
            REFERENCES orders(id)
            ON DELETE CASCADE
);

-- Critical for the 'Track My Order' page on your storefront
CREATE INDEX idx_order_status_history_order_id ON order_status_history(order_id);

-- ── Configuration ────────────────────────────────────────────────────────────

CREATE TABLE store_settings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value TEXT NOT NULL,
    description TEXT
);

CREATE TABLE country_settings (
    country_code CHAR(2) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    locale VARCHAR(20) NOT NULL,
    decimal_places SMALLINT NOT NULL DEFAULT 2,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ensure only one active default country can exist.
CREATE UNIQUE INDEX ux_country_settings_default_true
    ON country_settings (is_default)
    WHERE is_default = TRUE;

CREATE TABLE page_content (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug               VARCHAR(100) NOT NULL UNIQUE,
    title              VARCHAR(200) NOT NULL,
    category           VARCHAR(50)  NOT NULL,
    draft_content      TEXT,
    published_content  TEXT,
    published_at       TIMESTAMPTZ,
    created_at         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ── Staff & admin ────────────────────────────────────────────────────────────

CREATE TABLE staff_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(30) NOT NULL, -- Values: 'SUPER_ADMIN', 'CATALOG_MANAGER', 'ORDER_MANAGER', 'VIEWER'
    is_active BOOLEAN DEFAULT true,
    reset_password BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── CSV upload staging ───────────────────────────────────────────────────────

CREATE TABLE product_upload_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL, -- 'PENDING', 'PROCESSED', 'CANCELLED'
    uploaded_by UUID REFERENCES staff_users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_rows INTEGER DEFAULT 0,
    processed_rows INTEGER NOT NULL DEFAULT 0,
    skipped_rows   INTEGER NOT NULL DEFAULT 0,
    validation_error_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE product_upload_staged (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID NOT NULL REFERENCES product_upload_batches(id) ON DELETE CASCADE,
    sku VARCHAR(100) NOT NULL,
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
    category_slug VARCHAR(1024),
    brand_slug VARCHAR(255),
    stock INTEGER,
    images TEXT,
    attributes TEXT,
    is_valid_category BOOLEAN DEFAULT FALSE,
    is_valid_brand BOOLEAN DEFAULT FALSE,
    current_stock          INTEGER,
    current_images         TEXT,
    current_attributes     TEXT,
    current_name           VARCHAR(255),
    current_description    VARCHAR(255),
    current_short_description VARCHAR(100),
    current_retail_price    DECIMAL(12, 2),
    current_wholesale_price DECIMAL(12, 2)
);

CREATE TABLE product_price_upload_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL, -- 'PENDING', 'PROCESSED', 'CANCELLED'
    uploaded_by UUID REFERENCES staff_users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_rows INTEGER DEFAULT 0,
    processed_rows INTEGER NOT NULL DEFAULT 0,
    skipped_rows   INTEGER NOT NULL DEFAULT 0,
    validation_error_count INTEGER NOT NULL DEFAULT 0,
    completed_at TIMESTAMP,
    approved_by UUID REFERENCES staff_users(id)
);

CREATE TABLE product_price_upload_staged (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID NOT NULL REFERENCES product_price_upload_batches(id) ON DELETE CASCADE,
    sku VARCHAR(100) NOT NULL,
    retail_price DECIMAL(12, 2),
    wholesale_price DECIMAL(12, 2),
    current_retail_price DECIMAL(12, 2),
    current_wholesale_price DECIMAL(12, 2),

    -- Track state for the approval screen
    validation_status VARCHAR(50) DEFAULT 'PENDING', -- 'VALID', 'ERROR'
    validation_errors TEXT,
    image_errors TEXT,
    -- Store the original data for comparison
    has_changes BOOLEAN DEFAULT FALSE,
    processed BOOLEAN DEFAULT FALSE
);
