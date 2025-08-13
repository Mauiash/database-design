-- ================================================================
-- SQL CODE TO INSERT SAMPLE DATA (2 records per table)
-- ================================================================

-- Insert data into VENDOR table
INSERT INTO VENDOR (vendor_id, vendor_name, contact_info, address) VALUES
(1, 'Music World Ltd', 'contact@musicworld.com, +1-555-0101', '123 Music Street, Los Angeles, CA 90210'),
(2, 'Digital Media Corp', 'info@digitalmedia.com, +1-555-0202', '456 Tech Avenue, San Francisco, CA 94105');

-- Insert data into PRODUCT table
INSERT INTO PRODUCT (product_id, product_name, price, description, vendor_id) VALUES
(1, 'Madonna - Like a Prayer', 19.99, 'Classic album by Madonna featuring hit songs', 1),
(2, 'The Beatles - Abbey Road', 24.99, 'Iconic Beatles album recorded at Abbey Road Studios', 1),
(3, 'Taylor Swift - 1989', 18.99, 'Pop album featuring Shake It Off and Blank Space', 2),
(4, 'Ed Sheeran - Divide', 16.99, 'Third studio album by English singer Ed Sheeran', 2);

-- Insert data into CATEGORY table (including parent-child relationships)
INSERT INTO CATEGORY (category_id, category_name, description, parent_category_id) VALUES
(1, 'Music', 'All music-related products', NULL),
(2, 'Album', 'Music albums and compilations', 1),
(3, 'Pop', 'Pop music genre', 2),
(4, 'Rock', 'Rock music genre', 2),
(5, 'Female Singer', 'Albums by female artists', 1),
(6, 'Male Singer', 'Albums by male artists', 1);

-- Insert data into PRODUCT_CATEGORY table (many-to-many relationships)
INSERT INTO PRODUCT_CATEGORY (product_id, category_id) VALUES
-- Madonna album: Pop, Album, Female Singer
(1, 2), (1, 3), (1, 5),
-- Beatles album: Rock, Album
(2, 2), (2, 4),
-- Taylor Swift album: Pop, Album, Female Singer
(3, 2), (3, 3), (3, 5),
-- Ed Sheeran album: Pop, Album, Male Singer
(4, 2), (4, 3), (4, 6);

-- Insert data into DELIVERY table
INSERT INTO DELIVERY (delivery_id, delivery_date, delivery_address, status, vendor_id) VALUES
(1, '2025-08-15', '789 Customer Lane, New York, NY 10001', 'Shipped', 1),
(2, '2025-08-16', '321 Buyer Street, Chicago, IL 60601', 'Processing', 1),
(3, '2025-08-17', '654 Purchase Blvd, Miami, FL 33101', 'Delivered', 2),
(4, '2025-08-18', '987 Order Avenue, Seattle, WA 98101', 'Pending', 2);

-- Insert data into DELIVERY_PRODUCT table (many-to-many relationships)
INSERT INTO DELIVERY_PRODUCT (delivery_id, product_id, quantity) VALUES
-- Delivery 1: Madonna and Beatles albums
(1, 1, 2), (1, 2, 1),
-- Delivery 2: Beatles album only
(2, 2, 3),
-- Delivery 3: Taylor Swift and Ed Sheeran albums
(3, 3, 1), (3, 4, 2),
-- Delivery 4: All products
(4, 1, 1), (4, 3, 1);

-- ================================================================
-- VERIFICATION QUERIES
-- ================================================================
-- Check if all data was inserted correctly
SELECT 'VENDOR' as Table_Name, COUNT(*) as Record_Count FROM VENDOR
UNION ALL
SELECT 'PRODUCT', COUNT(*) FROM PRODUCT
UNION ALL
SELECT 'CATEGORY', COUNT(*) FROM CATEGORY
UNION ALL
SELECT 'PRODUCT_CATEGORY', COUNT(*) FROM PRODUCT_CATEGORY
UNION ALL
SELECT 'DELIVERY', COUNT(*) FROM DELIVERY
UNION ALL
SELECT 'DELIVERY_PRODUCT', COUNT(*) FROM DELIVERY_PRODUCT;

-- ================================================================
-- SAMPLE QUERIES TO TEST THE RELATIONSHIPS
-- ================================================================
-- Query 1: Show all products with their vendors
SELECT p.product_name, v.vendor_name, p.price
FROM PRODUCT p
JOIN VENDOR v ON p.vendor_id = v.vendor_id;

-- Query 2: Show all products with their categories
SELECT p.product_name, c.category_name
FROM PRODUCT p
JOIN PRODUCT_CATEGORY pc ON p.product_id = pc.product_id
JOIN CATEGORY c ON pc.category_id = c.category_id
ORDER BY p.product_name, c.category_name;

-- Query 3: Show category hierarchy
SELECT 
    child.category_name as Child_Category,
    parent.category_name as Parent_Category
FROM CATEGORY child
LEFT JOIN CATEGORY parent ON child.parent_category_id = parent.category_id;

-- Query 4: Show deliveries with their products
SELECT 
    d.delivery_id,
    d.delivery_date,
    d.status,
    p.product_name,
    dp.quantity
FROM DELIVERY d
JOIN DELIVERY_PRODUCT dp ON d.delivery_id = dp.delivery_id
JOIN PRODUCT p ON dp.product_id = p.product_id
ORDER BY d.delivery_id, p.product_name;
