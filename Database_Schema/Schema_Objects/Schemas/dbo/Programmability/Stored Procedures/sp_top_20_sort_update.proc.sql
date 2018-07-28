CREATE PROCEDURE sp_top_20_sort_update (
	@ps_top_20_user_id varchar(24),
	@ps_top_20_code varchar(64) ,
	@pl_top_20_sequence int ,
	@pl_new_sort_sequence int)
AS

UPDATE u_Top_20
SET sort_sequence = @pl_new_sort_sequence
WHERE user_id = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code
AND top_20_sequence = @pl_top_20_sequence

