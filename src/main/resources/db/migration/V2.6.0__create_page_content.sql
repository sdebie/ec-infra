CREATE TABLE IF NOT EXISTS page_content (
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

INSERT INTO page_content (slug, title, category) VALUES
    ('terms-and-conditions', 'Terms & Conditions', 'LEGAL'),
    ('privacy-policy',       'Privacy Policy',      'LEGAL'),
    ('delivery-and-returns', 'Delivery & Returns',  'LEGAL')
ON CONFLICT (slug) DO NOTHING;
