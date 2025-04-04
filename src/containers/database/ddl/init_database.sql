CREATE SCHEMA authservice AUTHORIZATION postgres;

CREATE ROLE forup_db_admin SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS PASSWORD 'N45fg98sd$@!';
COMMENT ON ROLE forup_db_admin IS 'ForUp Database Administrator';

GRANT CREATE, USAGE ON SCHEMA authservice TO forup_db_admin;

CREATE TABLE authservice.login (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	email varchar(200) NOT NULL,
	passwd varchar(255) NOT NULL,
	gmail_auth varchar(255) NULL,
	meta_auth varchar(255) NULL,
	forup_auth varchar(255) NULL,
	CONSTRAINT login_pk PRIMARY KEY (id),
	CONSTRAINT login_unique UNIQUE (email)
);
CREATE INDEX login_email_idx ON authservice.login (email);


CREATE TABLE authservice.conn_profile (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	client_id uuid NOT NULL,
	modules JSONB NULL,
	db_access JSONB NULL,
	CONSTRAINT conn_profile_pk PRIMARY KEY (id)
);

CREATE TABLE authservice.client (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar(255) NULL,
	organization_name varchar(255) NULL,
	doc_number varchar(30) NULL,
	contact_email varchar(255) NULL,
    "address" JSONB NULL
	CONSTRAINT client_pk PRIMARY KEY (id)
);

ALTER TABLE authservice.conn_profile ADD CONSTRAINT conn_profile_client_fk FOREIGN KEY (client_id) REFERENCES authservice.client(id);