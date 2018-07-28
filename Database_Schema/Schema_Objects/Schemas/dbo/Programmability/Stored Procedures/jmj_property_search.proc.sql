CREATE PROCEDURE jmj_property_search
	(
	@ps_context_object varchar(24) = NULL,
	@ps_description varchar(40) = NULL,
	@ps_property_name varchar(64) = NULL,
	@ps_property_type varchar(24) = NULL,
	@ps_property_category varchar(40) = NULL,
	@ps_status varchar(12) = NULL )
AS


DECLARE @ll_property_id int

DECLARE @property TABLE (
	property_id int NOT NULL,
	property_object varchar(24) NOT NULL,
	description varchar(80) NULL,
	property_type varchar(24) NOT NULL,
	function_name varchar(64) NOT NULL,
	status varchar(12) NOT NULL,
	id uniqueidentifier NOT NULL,
	owner_id int NOT NULL,
	property_type_bitmap varchar(255))

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_property_name IS NULL
	SELECT @ps_property_name = '%'

IF @ps_property_type IS NULL
	SELECT @ps_property_type = '%'

IF @ps_property_category IS NULL
	SELECT @ps_property_category = '%'

IF @ps_context_object IS NULL
	SELECT @ps_context_object = '%'

INSERT INTO @property (
	property_id ,
	property_object ,
	description ,
	property_type ,
	function_name ,
	status ,
	id ,
	owner_id )
SELECT property_id ,
	property_object ,
	description ,
	property_type ,
	function_name ,
	status ,
	id ,
	owner_id 
FROM c_Property
WHERE status like @ps_status
AND description like @ps_description
AND function_name like @ps_property_name
AND property_object like @ps_context_object
AND property_type like @ps_property_type

UPDATE p
SET property_type_bitmap = d.domain_item_bitmap
FROM @property p
	INNER JOIN c_Domain d
	ON d.domain_id = 'Property Type'
	AND d.domain_item = p.property_type

SELECT property_id ,
	property_object ,
	description ,
	property_type ,
	function_name ,
	status ,
	id ,
	owner_id ,
	property_type_bitmap ,
	selected_flag = 0
FROM @property


