CREATE TABLE if not exists wholesale_applications (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        company_name VARCHAR(255) NOT NULL,
        vat_number VARCHAR(50),
        contact_email VARCHAR(255) UNIQUE NOT NULL,
        contact_phone VARCHAR(50),
        status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
        notes TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

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
        postal_postal_code VARCHAR(10)
);