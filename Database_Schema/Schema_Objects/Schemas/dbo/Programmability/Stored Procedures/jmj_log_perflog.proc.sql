CREATE PROCEDURE jmj_log_perflog (
	@ps_user_id varchar(24),
	@pl_computer_id int = NULL)
AS

DECLARE @ldt_last_updated datetime,
		@ll_count int,
		@ldt_current_datetime datetime

SET NOCOUNT ON

SET @ldt_current_datetime = getdate()

SELECT @ldt_last_updated = last_updated 
FROM c_Table_Update
WHERE table_name = 'Perflog DB Stats'

IF @ldt_last_updated > DATEADD(minute, -10, @ldt_current_datetime)
	RETURN 0

DECLARE @encounters TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	encounter_date datetime NOT NULL,
	open_class varchar(24) NULL )

INSERT INTO @encounters (
	cpr_id ,
	encounter_id ,
	encounter_date ,
	open_class)
SELECT cpr_id ,
	encounter_id ,
	encounter_date ,
	open_class = CASE WHEN encounter_date > DATEADD(hour, -2, @ldt_current_datetime) THEN 'Active' ELSE 'Delayed' END
FROM p_Patient_Encounter
WHERE encounter_status = 'OPEN'

UPDATE @encounters
SET open_class = 'Hold'
WHERE encounter_date < DATEADD(hour, -12, @ldt_current_datetime)

IF @pl_computer_id IS NULL
	SELECT @pl_computer_id = max(computer_id)
	FROM o_Server_Component
	WHERE component_id = 'JMJ_SERVERSERVICE'
	AND system_user_id = @ps_user_id

IF @pl_computer_id IS NULL
	SET @pl_computer_id = 0

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Active'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Active',
	@pd_value = @ll_count

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Delayed'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Delayed',
	@pd_value = @ll_count

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Hold'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Hold',
	@pd_value = @ll_count


-- Finally, update the perflog time
EXECUTE sp_table_update
	@ps_table_name = 'Perflog DB Stats',
	@ps_updated_by = @ps_user_id

