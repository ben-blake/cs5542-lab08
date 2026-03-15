-- ============================================================================
-- File: 03_superstore.sql
-- Description: DDL for Superstore Sales dataset
-- Schema: ANALYTICS_COPILOT.RAW
-- ============================================================================

USE DATABASE ANALYTICS_COPILOT;
USE SCHEMA RAW;

-- Create the SUPERSTORE_SALES table
-- This table contains sales transaction data from the Kaggle Superstore dataset
CREATE OR REPLACE TABLE SUPERSTORE_SALES (
    -- Primary Key
    ROW_ID INTEGER PRIMARY KEY,

    -- Order Information
    ORDER_ID VARCHAR(50),
    ORDER_DATE DATE,
    SHIP_DATE DATE,
    SHIP_MODE VARCHAR(50),

    -- Customer Information
    CUSTOMER_ID VARCHAR(50),
    CUSTOMER_NAME VARCHAR(100),
    SEGMENT VARCHAR(50),

    -- Location Information
    COUNTRY VARCHAR(50),
    CITY VARCHAR(100),
    STATE VARCHAR(50),
    POSTAL_CODE VARCHAR(20),
    REGION VARCHAR(50),

    -- Product Information
    PRODUCT_ID VARCHAR(50),
    CATEGORY VARCHAR(50),
    SUB_CATEGORY VARCHAR(50),
    PRODUCT_NAME VARCHAR(500),

    -- Transaction Metrics
    SALES FLOAT,
    QUANTITY INTEGER,
    DISCOUNT FLOAT,
    PROFIT FLOAT
);

-- Add comment to table
COMMENT ON TABLE SUPERSTORE_SALES IS 'Sales transaction data from Superstore dataset containing order, customer, product, and financial information';

-- Add comments to columns for better documentation
COMMENT ON COLUMN SUPERSTORE_SALES.ROW_ID IS 'Unique identifier for each transaction record';
COMMENT ON COLUMN SUPERSTORE_SALES.ORDER_ID IS 'Unique order identifier (can have multiple rows per order)';
COMMENT ON COLUMN SUPERSTORE_SALES.ORDER_DATE IS 'Date when the order was placed';
COMMENT ON COLUMN SUPERSTORE_SALES.SHIP_DATE IS 'Date when the order was shipped';
COMMENT ON COLUMN SUPERSTORE_SALES.SHIP_MODE IS 'Shipping method used (e.g., Standard Class, First Class)';
COMMENT ON COLUMN SUPERSTORE_SALES.CUSTOMER_ID IS 'Unique customer identifier';
COMMENT ON COLUMN SUPERSTORE_SALES.CUSTOMER_NAME IS 'Full name of the customer';
COMMENT ON COLUMN SUPERSTORE_SALES.SEGMENT IS 'Customer segment (Consumer, Corporate, Home Office)';
COMMENT ON COLUMN SUPERSTORE_SALES.COUNTRY IS 'Country where the order was placed';
COMMENT ON COLUMN SUPERSTORE_SALES.CITY IS 'City where the order was delivered';
COMMENT ON COLUMN SUPERSTORE_SALES.STATE IS 'State/Province where the order was delivered';
COMMENT ON COLUMN SUPERSTORE_SALES.POSTAL_CODE IS 'Postal/ZIP code of delivery location';
COMMENT ON COLUMN SUPERSTORE_SALES.REGION IS 'Geographic region (e.g., East, West, Central, South)';
COMMENT ON COLUMN SUPERSTORE_SALES.PRODUCT_ID IS 'Unique product identifier';
COMMENT ON COLUMN SUPERSTORE_SALES.CATEGORY IS 'Product category (Furniture, Office Supplies, Technology)';
COMMENT ON COLUMN SUPERSTORE_SALES.SUB_CATEGORY IS 'Product sub-category (e.g., Chairs, Phones, Binders)';
COMMENT ON COLUMN SUPERSTORE_SALES.PRODUCT_NAME IS 'Full product name/description';
COMMENT ON COLUMN SUPERSTORE_SALES.SALES IS 'Sale amount in dollars';
COMMENT ON COLUMN SUPERSTORE_SALES.QUANTITY IS 'Number of items ordered';
COMMENT ON COLUMN SUPERSTORE_SALES.DISCOUNT IS 'Discount percentage applied (0-1)';
COMMENT ON COLUMN SUPERSTORE_SALES.PROFIT IS 'Profit amount in dollars (can be negative for losses)';
