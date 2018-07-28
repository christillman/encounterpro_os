CREATE PROCEDURE sp_update_u_top_20_sort_sequence (
	@ps_user_id varchar(24),
	@ps_top_20_code varchar(64),
	@pl_top_20_sequence int,
	@pl_sort_sequence int)
AS

UPDATE u_top_20
SET	sort_sequence = @pl_sort_sequence
WHERE user_id = @ps_user_id
AND top_20_code = @ps_top_20_code
AND top_20_sequence = @pl_top_20_sequence

