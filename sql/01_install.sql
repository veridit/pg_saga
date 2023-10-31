CREATE EXTENSION sql_saga VERSION '1.0' CASCADE;

SELECT extversion
FROM pg_extension
WHERE extname = 'sql_saga';

DROP ROLE IF EXISTS sql_saga_unprivileged_user;
CREATE ROLE sql_saga_unprivileged_user;

/* Make tests work on PG 15+ */
GRANT CREATE ON SCHEMA public TO PUBLIC;
