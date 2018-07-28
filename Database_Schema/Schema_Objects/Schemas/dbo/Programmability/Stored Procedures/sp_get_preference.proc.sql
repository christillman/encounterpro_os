CREATE PROCEDURE sp_get_preference (
	@ps_preference_type varchar(24),
	@ps_user_id varchar(40) = NULL,
	@pl_computer_id int = NULL,
	@ps_preference_id varchar(40),
	@ps_system_user_id varchar(24),
	@ps_preference_value varchar(255) OUTPUT)
AS

-- This stored procedure uses the old calling structure so that previous versions of
-- EncounterPRO can call it just enough to realize that the database version is changed.

SELECT @ps_preference_value = dbo.fn_get_preference (@ps_preference_type, @ps_preference_id, DEFAULT, DEFAULT)
