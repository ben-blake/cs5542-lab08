-- ============================================================================
-- File: 05_cortex_search.sql
-- Description: Create Cortex Search Service for semantic schema retrieval
-- Schema: ANALYTICS_COPILOT.METADATA
-- ============================================================================

USE DATABASE ANALYTICS_COPILOT;
USE SCHEMA METADATA;

-- ============================================================================
-- SCHEMA_SEARCH_SERVICE
-- Purpose: Cortex Search Service for semantic matching of natural language
--          queries to relevant table and column metadata
--
-- How it works:
--   - Indexes the DESCRIPTION field for semantic search
--   - Returns relevant table/column metadata based on user questions
--   - Enables the LLM to find the right tables/columns to use in SQL
--   - Updates automatically with 1 hour lag
-- ============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE SCHEMA_SEARCH_SERVICE
    ON description                         -- Primary search field (semantic matching)
    ATTRIBUTES table_name,                 -- Return these fields with search results
               column_name,
               synonyms,
               data_type
    WAREHOUSE = COPILOT_WH                 -- Compute warehouse for indexing
    TARGET_LAG = '1 hour'                  -- Refresh frequency for index updates
AS (
    SELECT
        table_name,
        column_name,
        description,
        synonyms,
        data_type,
        sample_values
    FROM TABLE_DESCRIPTIONS
);

-- Add comment to search service
COMMENT ON CORTEX SEARCH SERVICE SCHEMA_SEARCH_SERVICE IS
    'Semantic search service for finding relevant tables and columns based on natural language queries. Used by Analytics Copilot to dynamically retrieve schema information for SQL generation.';

-- ============================================================================
-- Usage Example:
--
-- SELECT * FROM TABLE(
--   SCHEMA_SEARCH_SERVICE!SEARCH(
--     query => 'customer purchase history',
--     limit => 5
--   )
-- );
--
-- This will return the most relevant table/column metadata for generating
-- SQL queries about customer purchase history.
-- ============================================================================
