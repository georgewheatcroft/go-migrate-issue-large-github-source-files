CREATE TABLESPACE example_data LOCATION '/var/lib/postgresql/tablespaces/pgdata/example_data';
CREATE TABLESPACE example_index LOCATION '/var/lib/postgresql/tablespaces/pgdata/example_index';

CREATE USER example WITH PASSWORD 'password123';
ALTER ROLE example CREATEROLE;

GRANT CREATE ON TABLESPACE example_data to example;
GRANT CREATE ON TABLESPACE example_index to example;

CREATE DATABASE exampledb OWNER example;
GRANT ALL PRIVILEGES ON DATABASE exampledb TO example;

REVOKE ALL ON DATABASE exampledb FROM PUBLIC;



