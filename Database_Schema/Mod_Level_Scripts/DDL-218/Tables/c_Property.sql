
-- Fix for a bug I ran across in fn_epro_object_properties
 UPDATE p 
  SET return_data_type = 
  CASE WHEN function_name like '%date%' or function_name like '%time%' THEN 'datetime'
	WHEN function_name like '%key%' THEN 'string'
	WHEN function_name like '%image%' or function_name like '%object%' THEN 'binary'
	WHEN function_name like '%seq%' THEN 'number'
	WHEN function_name like '%amount%' THEN 'number'
	WHEN function_name like '%flag%'  or function_name like '%ed' or function_name = 'default_grant' THEN 'boolean'
	WHEN function_name like '%instructions%'  or function_name like '%long_description%'  or function_name like '%text%' THEN 'text'
	ELSE 'string' END
	FROM c_Property p
	WHERE return_data_type IS NULL

ALTER TABLE c_Property ALTER COLUMN return_data_type varchar(12) NOT NULL