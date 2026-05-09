-- Fix category names: replace HTML entity &amp; with ampersand &
UPDATE categories
SET name = REPLACE(name, '&amp;', '&')
WHERE name LIKE '%&amp;%';

