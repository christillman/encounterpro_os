CREATE FUNCTION dbo.fn_config_object_owner_pick ()

RETURNS @owners TABLE (
	owner_id int NOT NULL,
	owner_description varchar(80) NOT NULL,
	owner_type varchar(40) NULL)

AS
BEGIN

INSERT INTO @owners (
	owner_id,
	owner_description,
	owner_type)
SELECT interfaceserviceid,
	description,
	interfaceservicetype
FROM c_Component_Interface
WHERE status = 'OK'
AND interfaceserviceid > 0


INSERT INTO @owners (
	owner_id,
	owner_description,
	owner_type)
VALUES (
	0,
	dbo.fn_owner_description(0),
	'EncounterPRO')

INSERT INTO @owners (
	owner_id,
	owner_description,
	owner_type)
SELECT customer_id,
	dbo.fn_owner_description(customer_id),
	'Local'
FROM c_Database_Status

INSERT INTO @owners (
	owner_id,
	owner_description,
	owner_type)
VALUES (
	-1,
	'Shareware',
	'Shareware')


RETURN

END

