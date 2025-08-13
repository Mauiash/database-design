-- ================================================================
-- SQL CODE TO CREATE DATABASE TABLES
-- Based on the Business Rules and ERD Design
-- ================================================================

-- Create VENDOR table first (no dependencies)
CREATE TABLE VENDOR (
    vendor_id INT PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(200),
    address TEXT
);

-- Create PRODUCT table (depends on VENDOR)
CREATE TABLE PRODUCT (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0),
    description TEXT,
    vendor_id INT NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES VENDOR(vendor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create CATEGORY table with self-referencing relationship
CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES CATEGORY(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create PRODUCT_CATEGORY junction table (many-to-many relationship)
CREATE TABLE PRODUCT_CATEGORY (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create DELIVERY table (depends on VENDOR)
CREATE TABLE DELIVERY (
    delivery_id INT PRIMARY KEY,
    delivery_date DATE NOT NULL,
    delivery_address TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    vendor_id INT NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES VENDOR(vendor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create DELIVERY_PRODUCT junction table (many-to-many relationship)
CREATE TABLE DELIVERY_PRODUCT (
    delivery_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (delivery_id, product_id),
    FOREIGN KEY (delivery_id) REFERENCES DELIVERY(delivery_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ================================================================
-- CREATE INDEXES FOR BETTER PERFORMANCE
-- ================================================================

-- Index on foreign keys for better join performance
CREATE INDEX idx_product_vendor ON PRODUCT(vendor_id);
CREATE INDEX idx_category_parent ON CATEGORY(parent_category_id);
CREATE INDEX idx_delivery_vendor ON DELIVERY(vendor_id);
CREATE INDEX idx_delivery_date ON DELIVERY(delivery_date);

-- ================================================================
-- ADDITIONAL CONSTRAINTS (Optional)
-- ================================================================

-- Ensure category names are unique within the same parent category
CREATE UNIQUE INDEX idx_unique_category_name 
ON CATEGORY(category_name, COALESCE(parent_category_id, 0));

-- Ensure vendor names are unique
CREATE UNIQUE INDEX idx_unique_vendor_name ON VENDOR(vendor_name);

-- Ensure product names are unique per vendor
CREATE UNIQUE INDEX idx_unique_product_per_vendor 
ON PRODUCT(product_name, vendor_id);
