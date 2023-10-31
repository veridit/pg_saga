/* Once support for 9.5 has passed, use CASCADE */
CREATE EXTENSION IF NOT EXISTS btree_gist;
/* Once support for 9.6 has passed, just create the extension */
CREATE EXTENSION periods VERSION '1.2';

SELECT extversion
FROM pg_extension
WHERE extname = 'periods';

DROP ROLE periods_unprivileged_user;
CREATE ROLE periods_unprivileged_user;

/* Make tests work on PG 15 */
GRANT CREATE ON SCHEMA public TO PUBLIC;
