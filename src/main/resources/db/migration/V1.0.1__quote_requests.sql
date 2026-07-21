-- =============================================================================
-- V1.0.1 — Quote requests
-- =============================================================================
-- Adds the quote_requests and quote_request_items tables for the quote/RFQ
-- funnel. Line items reference product_variants with ON DELETE SET NULL plus
-- denormalised name/SKU snapshots so quotes survive catalogue changes.
-- =============================================================================

CREATE TABLE IF NOT EXISTS quote_requests (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name              VARCHAR(120)  NOT NULL,
    email             VARCHAR(254)  NOT NULL,
    phone             VARCHAR(40),
    company           VARCHAR(160),
    message           TEXT,
    status            VARCHAR(20)   NOT NULL DEFAULT 'NEW',
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    status_changed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS quote_request_items (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quote_request_id      UUID NOT NULL REFERENCES quote_requests(id) ON DELETE CASCADE,
    variant_id            UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    product_name_snapshot VARCHAR(255) NOT NULL,
    variant_sku_snapshot  VARCHAR(100),
    quantity              INTEGER NOT NULL CHECK (quantity >= 1)
);

CREATE INDEX IF NOT EXISTS idx_quote_requests_status_created
    ON quote_requests (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_quote_request_items_request
    ON quote_request_items (quote_request_id);
