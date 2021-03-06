CREATE TABLE Characters (
   ID SERIAL PRIMARY KEY,
   CHARACTER VARCHAR(255),
   DESCRIPTION VARCHAR(1000),
   QUOTE VARCHAR(1000),
   LINKIMAGE VARCHAR(255),
   PICTURE BYTEA
);

CREATE TABLE Qualities (
   ID SERIAL PRIMARY KEY,
   CHARACTERID INT,
   QUALITY VARCHAR(255),
   SPECIAL SMALLINT,
   FOREIGN KEY (CHARACTERID) REFERENCES Characters (ID)
);

CREATE TABLE Works (
   ID SERIAL PRIMARY KEY,
   CHARACTERID INT,
   TITLE VARCHAR(255),
   CREATOR VARCHAR(255),
   YEARCREATED INT,
   YEARPERIOD VARCHAR(5),
   WORKSTYPE VARCHAR(255),
   COMPANY VARCHAR(255),
   OTHERCREATOR VARCHAR(255),
   FOREIGN KEY (CHARACTERID) REFERENCES Characters (ID)
);


-- FUNCTION TO IMPORT BYTEA DATA FROM FILE
-- CREDIT: @JackDouglas https://dba.stackexchange.com/a/2962

CREATE OR REPLACE FUNCTION bytea_import(p_path text, p_result out bytea) 

LANGUAGE plpgsql AS $$
DECLARE
  l_oid oid;
  r record;
BEGIN
  p_result := '';
  SELECT LO_IMPORT(p_path) into l_oid;
  FOR r IN ( SELECT data 
             FROM pg_largeobject 
             WHERE loid = l_oid 
             ORDER BY pageno ) LOOP
    p_result = p_result || r.data;
  END LOOP;
  PERFORM LO_UNLINK(l_oid);
END;$$;
