-- Durable tracking for bulk image ingest. Bytes land (or a zip is staged) on the
-- request; a worker thumbnails and SKU-links each item. Separate from product_import_*
-- (review-then-commit). CREATE IF NOT EXISTS so environments that already applied a
-- local copy of this schema stay compatible.

CREATE TABLE IF NOT EXISTS image_bulk_jobs
(
    id                    UUID PRIMARY KEY     DEFAULT gen_random_uuid(),
    destination_directory VARCHAR(255),
    status                VARCHAR(50) NOT NULL,
    uploaded_count        INTEGER     NOT NULL DEFAULT 0,
    skipped_count         INTEGER     NOT NULL DEFAULT 0,
    failed_count          INTEGER     NOT NULL DEFAULT 0,
    created_at            TIMESTAMPTZ          DEFAULT CURRENT_TIMESTAMP,
    completed_at          TIMESTAMPTZ,
    uploaded_by           UUID REFERENCES staff_users (id)
);

CREATE TABLE IF NOT EXISTS image_bulk_job_items
(
    id            UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    job_id        UUID         NOT NULL REFERENCES image_bulk_jobs (id) ON DELETE CASCADE,
    relative_path VARCHAR(512) NOT NULL,
    status        VARCHAR(50)  NOT NULL,
    error         TEXT,
    CONSTRAINT uq_image_bulk_job_items_job_path UNIQUE (job_id, relative_path)
);

CREATE INDEX IF NOT EXISTS idx_image_bulk_job_items_pending ON image_bulk_job_items (id) WHERE status = 'PENDING';

CREATE INDEX IF NOT EXISTS idx_image_bulk_job_items_job_status ON image_bulk_job_items (job_id, status);
