-- ============================================================================
-- Olist E-commerce Tables DDL
-- ============================================================================
-- This script creates the 9 core tables for the Olist Brazilian e-commerce dataset
-- Tables are created in dependency order (parent tables before child tables)
-- PK/FK constraints are defined for Cortex Analyst relationship understanding
-- ============================================================================

USE SCHEMA ANALYTICS_COPILOT.RAW;

-- ============================================================================
-- PARENT TABLES (no foreign key dependencies)
-- ============================================================================

-- Customers table: stores customer information
-- One customer can have multiple orders
CREATE OR REPLACE TABLE CUSTOMERS (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR NOT NULL,
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR,
    customer_state VARCHAR(2)
);

-- Products table: stores product catalog information
-- One product can appear in multiple order items
CREATE OR REPLACE TABLE PRODUCTS (
    product_id VARCHAR PRIMARY KEY,
    product_category_name VARCHAR,
    product_name_lenght INTEGER,  -- Note: "lenght" is original spelling from dataset
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

-- Sellers table: stores seller/merchant information
-- One seller can sell multiple products across multiple orders
CREATE OR REPLACE TABLE SELLERS (
    seller_id VARCHAR PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR,
    seller_state VARCHAR(2)
);

-- Product category translation table: maps Portuguese category names to English
-- Provides human-readable category names for analysis
CREATE OR REPLACE TABLE PRODUCT_CATEGORY_TRANSLATION (
    product_category_name VARCHAR PRIMARY KEY,
    product_category_name_english VARCHAR
);

-- Geolocation table: stores latitude/longitude for Brazilian zip codes
-- No primary key - multiple lat/lng entries can exist per zip code
-- Used for geographic analysis and mapping
CREATE OR REPLACE TABLE GEOLOCATION (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR(2)
);

-- ============================================================================
-- CHILD TABLES (with foreign key dependencies)
-- ============================================================================

-- Orders table: stores order header information
-- FK to CUSTOMERS - each order belongs to one customer
CREATE OR REPLACE TABLE ORDERS (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR NOT NULL,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);

-- Order items table: stores line items for each order
-- Composite PK: order_id + order_item_id
-- FKs to ORDERS, PRODUCTS, SELLERS
CREATE OR REPLACE TABLE ORDER_ITEMS (
    order_id VARCHAR NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR NOT NULL,
    seller_id VARCHAR NOT NULL,
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id),
    FOREIGN KEY (seller_id) REFERENCES SELLERS(seller_id)
);

-- Order payments table: stores payment information for orders
-- Composite PK: order_id + payment_sequential (one order can have multiple payments)
-- FK to ORDERS
CREATE OR REPLACE TABLE ORDER_PAYMENTS (
    order_id VARCHAR NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR,
    payment_installments INTEGER,
    payment_value FLOAT,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);

-- Order reviews table: stores customer reviews and ratings
-- PK: review_id (unique review identifier)
-- FK to ORDERS - each review is for one order
CREATE OR REPLACE TABLE ORDER_REVIEWS (
    review_id VARCHAR PRIMARY KEY,
    order_id VARCHAR NOT NULL,
    review_score INTEGER,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);
