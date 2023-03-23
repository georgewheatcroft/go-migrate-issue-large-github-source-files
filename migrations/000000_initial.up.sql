/* schema */

CREATE SCHEMA example;

/* base roles */

--to be used in read/write circumstances
create role example_role;
grant connect on database exampledb to example_role;
GRANT USAGE, CREATE ON SCHEMA example TO example_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA example GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO example_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA example GRANT USAGE ON SEQUENCES TO example_role;


--to be used when only read is required
create role example_ro_role;
grant connect on database exampledb to example_ro_role;
grant usage on schema example to example_ro_role;
GRANT SELECT ON ALL TABLES IN SCHEMA example TO example_ro_role;

-- create user car_api with password 'foobar';
-- grant example_ro_role to car_api;

/* users - TODO configure this in an rds appropriate way */
-- CREATE USER IF NOT EXISTS car_api with password 'foobar';
CREATE USER car_api with password 'foobar';
-- CREATE USER car_api;
GRANT example_ro_role TO car_api;

--workaround for when we may/may not be running in rds
DO $$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'rds_iam') THEN
      RAISE NOTICE 'Role "rds_iam" already exists - must be running in rds. Skipping.';
   ELSE
      CREATE ROLE rds_iam;
   END IF;
END $$;


-- GRANT rds_iam TO car_api;
