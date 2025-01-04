
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[HM_Add_PatientClass_Patients]
Print 'Drop Procedure [dbo].[HM_Add_PatientClass_Patients]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[HM_Add_PatientClass_Patients]') AND [type]='P'))
DROP PROCEDURE [dbo].[HM_Add_PatientClass_Patients]
GO

-- Create Procedure [dbo].[HM_Add_PatientClass_Patients]
Print 'Create Procedure [dbo].[HM_Add_PatientClass_Patients]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[HM_Add_PatientClass_Patients]
	@pl_maintenance_rule_id int,
	@pl_PatientCount int,
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
AS
BEGIN
SET NOCOUNT ON;

DECLARE @ls_time_amount nvarchar(12),
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

IF @@ERROR <> 0
	RETURN -1	

IF @ll_Parent_maintenance_rule_id IS NULL
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
	,dbo.get_client_datetime()
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
GO

