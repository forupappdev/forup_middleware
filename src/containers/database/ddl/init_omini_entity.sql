CREATE SCHEMA omini_middleware AUTHORIZATION postgres;

CREATE ROLE forup_db_admin SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS PASSWORD 'N45fg98sd$@!';
COMMENT ON ROLE forup_db_admin IS 'ForUp Database Administrator';
--ALTER ROLE forup_db_admin WITH PASSWORD 'N45fg98sd#@!';

GRANT CREATE, USAGE ON SCHEMA omini_middleware TO forup_db_admin;