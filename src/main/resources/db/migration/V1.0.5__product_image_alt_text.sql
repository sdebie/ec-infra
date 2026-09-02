-- Alt text for product images: accessibility (img alt) and image-search SEO.
-- Nullable: legacy images have no alt text and absence must not block product saves.
-- V1.0.4 is reserved by staff-password-reset.
ALTER TABLE product_images ADD COLUMN IF NOT EXISTS alt_text VARCHAR(500);
