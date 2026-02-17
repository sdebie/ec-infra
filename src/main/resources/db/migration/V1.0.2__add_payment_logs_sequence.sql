-- Create the sequence for the primary key
CREATE SEQUENCE IF NOT EXISTS payment_gateway_logs_seq
    START WITH 1
    INCREMENT BY 50; -- Matches Quarkus/Hibernate default allocation size

-- Create the logs table if it doesn't exist yet
CREATE TABLE IF NOT EXISTS payment_gateway_logs (
        id BIGINT PRIMARY KEY DEFAULT nextval('payment_gateway_logs_seq'),
        m_payment_id VARCHAR(50),
        pf_payment_id VARCHAR(50),
        payment_status VARCHAR(20),
        amount_gross DECIMAL(10,2),
        log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);