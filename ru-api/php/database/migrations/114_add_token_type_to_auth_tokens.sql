-- Migration 114: Add token_type support to auth_tokens
-- Purpose: Distinguish session tokens from password reset tokens

SET @has_token_type := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'auth_tokens'
      AND COLUMN_NAME = 'token_type'
);

SET @sql_add_column := IF(
    @has_token_type = 0,
    'ALTER TABLE auth_tokens ADD COLUMN token_type VARCHAR(32) NOT NULL DEFAULT ''auth'' AFTER token',
    'SELECT 1'
);

PREPARE stmt_add_column FROM @sql_add_column;
EXECUTE stmt_add_column;
DEALLOCATE PREPARE stmt_add_column;

UPDATE auth_tokens
SET token_type = 'auth'
WHERE token_type IS NULL OR token_type = '';

SET @has_type_exp_idx := (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'auth_tokens'
      AND INDEX_NAME = 'idx_auth_tokens_type_expires'
);

SET @sql_add_index := IF(
    @has_type_exp_idx = 0,
    'ALTER TABLE auth_tokens ADD INDEX idx_auth_tokens_type_expires (token_type, expires_at, revoked_at)',
    'SELECT 1'
);

PREPARE stmt_add_index FROM @sql_add_index;
EXECUTE stmt_add_index;
DEALLOCATE PREPARE stmt_add_index;
