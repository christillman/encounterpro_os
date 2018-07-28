CREATE PROCEDURE sp_get_preference_list
	(
	@ps_preference_type varchar(24))
AS

SELECT c.preference_type,
		c.preference_id,
		c.description,
		c.param_class,
		c.global_flag,
		c.office_flag,
		c.computer_flag,
		c.specialty_flag,
		c.user_flag,
		c.help,
		c.query,
		convert(varchar(12), NULL) as preference_level,
		convert(varchar(255), NULL) as preference_value,
		convert(int, 0) as selected_flag
FROM c_Preference c
WHERE c.preference_type = @ps_preference_type
		


