CREATE PROCEDURE sp_get_groups
	@ps_office_id varchar(4)
AS
SELECT group_id,
	description,
	sort_sequence
FROM o_Groups WITH (NOLOCK)
WHERE office_id = @ps_office_id
ORDER BY sort_sequence, group_id

