-- =============================================================================
-- V1.0.2 — Testimonials
-- =============================================================================
-- Adds the testimonials table: DB-backed, admin-managed storefront testimonials
-- (testimonials-management spec). Published rows are served publicly ordered by
-- sort_order; the (is_published, sort_order) index covers that read path.
-- =============================================================================

CREATE TABLE IF NOT EXISTS testimonials (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quote        TEXT          NOT NULL,
    author_name  VARCHAR(255)  NOT NULL,
    author_title VARCHAR(255),
    is_published BOOLEAN       NOT NULL DEFAULT false,
    sort_order   INTEGER       NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_testimonials_published_sort
    ON testimonials (is_published, sort_order);
