-- ============================================================================
-- File: 04_metadata.sql
-- Description: DDL for metadata tables supporting the Analytics Copilot
-- Schema: ANALYTICS_COPILOT.METADATA
-- ============================================================================

USE DATABASE ANALYTICS_COPILOT;
USE SCHEMA METADATA;

-- ============================================================================
-- TABLE_DESCRIPTIONS
-- Purpose: Store detailed metadata about tables and columns for schema understanding
-- This table helps the LLM understand what data is available and how to use it
-- ============================================================================

CREATE OR REPLACE TABLE TABLE_DESCRIPTIONS (
    -- Composite Primary Key
    TABLE_NAME VARCHAR(200),
    COLUMN_NAME VARCHAR(200),

    -- Metadata fields
    DESCRIPTION VARCHAR(1000),           -- Human-readable description of the column
    SYNONYMS VARCHAR(500),                -- Alternative names or terms (comma-separated)
    DATA_TYPE VARCHAR(100),               -- Snowflake data type
    SAMPLE_VALUES VARCHAR(500),           -- Example values to help LLM understand content

    -- Define composite primary key
    PRIMARY KEY (TABLE_NAME, COLUMN_NAME)
);

-- Add table comment
COMMENT ON TABLE TABLE_DESCRIPTIONS IS 'Metadata repository for table and column descriptions used by Analytics Copilot for semantic understanding';

-- Add column comments
COMMENT ON COLUMN TABLE_DESCRIPTIONS.TABLE_NAME IS 'Fully qualified table name (SCHEMA.TABLE)';
COMMENT ON COLUMN TABLE_DESCRIPTIONS.COLUMN_NAME IS 'Name of the column';
COMMENT ON COLUMN TABLE_DESCRIPTIONS.DESCRIPTION IS 'Detailed description of what the column contains and how it should be used';
COMMENT ON COLUMN TABLE_DESCRIPTIONS.SYNONYMS IS 'Alternative names, abbreviations, or related terms (comma-separated)';
COMMENT ON COLUMN TABLE_DESCRIPTIONS.DATA_TYPE IS 'Snowflake data type of the column';
COMMENT ON COLUMN TABLE_DESCRIPTIONS.SAMPLE_VALUES IS 'Example values from the column to provide context';

-- ============================================================================
-- GOLDEN_QUERIES
-- Purpose: Store verified question-SQL pairs for few-shot learning
-- These examples help the LLM generate better SQL by learning from patterns
-- ============================================================================

CREATE OR REPLACE TABLE GOLDEN_QUERIES (
    -- Primary Key
    ID INTEGER AUTOINCREMENT PRIMARY KEY,

    -- Query information
    QUESTION VARCHAR(1000),               -- Natural language question
    SQL_QUERY VARCHAR(5000),              -- Corresponding SQL query
    DIFFICULTY VARCHAR(20),               -- Complexity level (easy, medium, hard)
    TABLES_USED VARCHAR(500),             -- Tables referenced (comma-separated)
    VERIFIED BOOLEAN DEFAULT FALSE        -- Whether the query has been tested

    -- Note: Snowflake doesn't enforce CHECK constraints, validation done in application layer
);

-- Add table comment
COMMENT ON TABLE GOLDEN_QUERIES IS 'Repository of verified question-SQL query pairs used for few-shot learning and query pattern matching';

-- Add column comments
COMMENT ON COLUMN GOLDEN_QUERIES.ID IS 'Auto-incrementing unique identifier for each golden query';
COMMENT ON COLUMN GOLDEN_QUERIES.QUESTION IS 'Natural language question that a user might ask';
COMMENT ON COLUMN GOLDEN_QUERIES.SQL_QUERY IS 'Verified SQL query that answers the question';
COMMENT ON COLUMN GOLDEN_QUERIES.DIFFICULTY IS 'Complexity level: easy (simple SELECT), medium (joins/aggregations), hard (complex analytics)';
COMMENT ON COLUMN GOLDEN_QUERIES.TABLES_USED IS 'Comma-separated list of tables referenced in the query';
COMMENT ON COLUMN GOLDEN_QUERIES.VERIFIED IS 'Flag indicating whether the query has been tested and produces correct results';
