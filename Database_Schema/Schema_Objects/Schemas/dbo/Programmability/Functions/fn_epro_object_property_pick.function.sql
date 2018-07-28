CREATE FUNCTION fn_epro_object_property_pick (
	@ps_epro_object varchar(64),
	@pb_display_user_defined bit = 0,
	@ps_property_value_object varchar(24) = NULL)

RETURNS @properties TABLE (
	[property_id] [int] NOT NULL,
	[property_name] [varchar](64) NOT NULL,
	[property_type] [varchar](12) NULL,
	[return_data_type] [varchar](12) NULL,
	[function_name] [varchar](64) NULL,
	[description] [varchar](80) NULL,
	[sort_sequence] [int] NULL
	)
AS

BEGIN


-- First add the properties listed in c_Property where the property type is 'SQL', 'built in', or 'object'
INSERT INTO @properties (
	property_id,
	property_name,
	property_type,
	return_data_type,
	function_name,
	description,
	sort_sequence)   
SELECT p.property_id,
	p.property_name,
	p.property_type,
	p.return_data_type,
	p.function_name,
	p.description,
	p.sort_sequence
FROM c_Property p
WHERE p.epro_object = @ps_epro_object 
AND p.property_type IN ('SQL', 'built in', 'object', 'User Defined')
AND (@pb_display_user_defined = 1 OR p.property_type IN ('SQL', 'built in', 'object'))
AND (@ps_property_value_object IS NULL OR p.property_value_object = @ps_property_value_object)
AND  p.status = 'OK' 



RETURN

END

