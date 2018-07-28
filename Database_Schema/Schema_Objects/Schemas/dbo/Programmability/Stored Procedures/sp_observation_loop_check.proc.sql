CREATE PROCEDURE sp_observation_loop_check (
	@ps_parent_observation_id varchar(24),
	@ps_new_observation_id varchar(24) = NULL,
	@pi_loop smallint OUTPUT )
AS


SET @pi_loop = dbo.fn_is_observation_loop(@ps_parent_observation_id, @ps_new_observation_id)


