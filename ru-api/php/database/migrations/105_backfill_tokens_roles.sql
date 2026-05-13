-- 105_backfill_tokens_roles.sql
-- Phase 2 / Backfill
-- Populate auth_tokens and user_roles from legacy token and guerreros_roles.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO auth_tokens (
    user_id,
    token,
    expires_at,
    created_at,
    revoked_at
)
SELECT
    u.id AS user_id,
        CONVERT(t.token USING utf8mb4) COLLATE utf8mb4_unicode_ci AS token,
    t.expires AS expires_at,
    t.created AS created_at,
    NULL AS revoked_at
FROM token t
INNER JOIN users u ON u.legacy_user_id = t.id_guerrero
WHERE t.token IS NOT NULL
    AND CONVERT(TRIM(t.token) USING utf8mb4) COLLATE utf8mb4_unicode_ci <> ''
  AND NOT EXISTS (
      SELECT 1
      FROM auth_tokens at
      WHERE at.user_id = u.id
                AND at.token = CONVERT(t.token USING utf8mb4) COLLATE utf8mb4_unicode_ci
  );

INSERT IGNORE INTO user_roles (
    user_id,
    role,
    created_at
)
SELECT
    u.id AS user_id,
        LOWER(CONVERT(TRIM(gr.rol) USING utf8mb4)) COLLATE utf8mb4_unicode_ci AS role,
    NOW() AS created_at
FROM guerreros_roles gr
INNER JOIN users u ON u.legacy_user_id = gr.guerrero_id
WHERE gr.rol IS NOT NULL
    AND CONVERT(TRIM(gr.rol) USING utf8mb4) COLLATE utf8mb4_unicode_ci <> '';
