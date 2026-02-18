-- Ensure a sequence exists with the name expected by Hibernate for OrderEntity
-- Hibernate is requesting nextval('orders_seq'), while the schema used SERIAL (orders_id_seq)
-- This migration creates the expected sequence and aligns its value with existing data

CREATE SEQUENCE IF NOT EXISTS orders_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

-- Align the sequence to be ahead of the current max(id) in orders
-- If there are no rows, this will set it to 1 and the first nextval will return 1
SELECT setval('orders_seq', COALESCE((SELECT MAX(id) FROM orders), 0) + 1, false);
