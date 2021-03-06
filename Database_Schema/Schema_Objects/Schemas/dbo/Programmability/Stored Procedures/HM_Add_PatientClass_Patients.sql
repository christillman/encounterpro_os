DROP PROCEDURE [dbo].[HM_Add_PatientClass_Patients]
GO

CREATE PROCEDURE [dbo].[HM_Add_PatientClass_Patients]
	@pl_maintenance_rule_id int,
	@pl_PatientCount int,
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
AS
BEGIN
SET NOCOUNT ON;

DECLARE @ll_error int,
		@ll_rowcount int,
		@ls_time_amount nvarchar(12),
		@ll_time_amount int,
		@ls_time_unit nvarchar(12),
		@ldt_measuredate datetime,
		@ls_measurename nvarchar(80),
		@ll_key int,
		@ll_Parent_maintenance_rule_id int,
		@ll_PatientCount int

DECLARE @data TABLE (
	[cpr_id] [varchar](12) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NULL
	)

IF @pl_maintenance_rule_id IS NULL
	BEGIN
	RAISERROR ('Null @pl_maintenance_rule_id (%d)', 16, -1, @pl_maintenance_rule_id)
	RETURN -1
	END

-- Get the random patients from the parent class
SELECT @ll_Parent_maintenance_rule_id = filter_from_maintenance_rule_id
FROM dbo.c_Maintenance_Patient_Class
WHERE maintenance_rule_id = @pl_maintenance_rule_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1	

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('Invalid _maintenance_rule_id (%d)', 16, -1, @pl_maintenance_rule_id)
	RETURN -1
	END


DELETE FROM @data
	
INSERT INTO @data (
	cpr_id,
	begin_date,
	end_date)
EXECUTE dbo.hm_random_patients @ll_Parent_maintenance_rule_id, @pl_PatientCount
	
INSERT INTO dbo.p_Maintenance_Class (
	maintenance_rule_id
	,cpr_id
	,status_date
	,in_class_flag
	,on_protocol_flag
	,is_controlled
	,current_flag)
SELECT @pl_maintenance_rule_id
	,cpr_id
	,GETDATE()
	,'Y'
	,'Y'
	,'Y'
	,'Y'
FROM @data x
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.p_Maintenance_Class p
	WHERE p.maintenance_rule_id = @pl_maintenance_rule_id
	AND p.cpr_id = x.cpr_id
	)



END