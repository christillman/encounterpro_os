CREATE PROCEDURE sp_top_20_delete (
	@ps_top_20_user_id varchar(24),
	@ps_top_20_code varchar(64) ,
	@pl_top_20_sequence int )
AS

DELETE u_Top_20
WHERE user_id = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code
AND top_20_sequence = @pl_top_20_sequence

