-- REVOKE example_ro_role FROM car_api;
-- REVOKE example_ro_role FROM car_api;
DROP USER IF EXISTS car_api;
--never would need to do in practice, this just helps with the local dev process
DROP ROLE IF EXISTS rds_iam;

REVOKE CONNECT ON DATABASE EXAMPLEDB FROM example_ro_role;
REVOKE USAGE ON SCHEMA EXAMPLE FROM example_ro_role;
DROP ROLE IF EXISTS example_ro_role;

--TODO some kind of psql means of doing this safely
REVOKE ALL PRIVILEGES ON DATABASE EXAMPLEDB FROM example_role;
REVOKE ALL PRIVILEGES ON SCHEMA example FROM example_role;
REVOKE CONNECT ON DATABASE exampledb FROM example_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA example REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM example_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA example REVOKE USAGE ON SEQUENCES FROM example_role;
REVOKE ALL ON ALL TABLES IN SCHEMA example from example_role;

DROP ROLE IF EXISTS example_role;
DROP ROLE IF EXISTS example_ro_role;


--additional step because this is made by go-migrate
DROP TABLE EXAMPLE.SCHEMA_MIGRATIONS;

DROP SCHEMA example;
-- below is handled by init script - we'll never want to do this anyhow:  
/* 
REVOKE create on tablespace example_data FROM example;
REVOKE create on tablespace example_index FROM example;
DROP USER IF EXISTS example; */


--cannot do this if the databsae is the one we are connected to right?
-- DROP DATABASE IF EXISTS  exampledb;
-- --depends on the above :( )
-- DROP TABLESPACE IF EXISTS example_data;
-- DROP TABLESPACE IF EXISTS example_index;
