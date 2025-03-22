
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_order_service_workplan]
Print 'Drop Procedure [dbo].[sp_order_service_workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_order_service_workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_order_service_workplan]
GO

-- Create Procedure [dbo].[sp_order_service_workplan]
Print 'Create Procedure [dbo].[sp_order_service_workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_order_service_workplan
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int,
	@ps_in_office_flag char(1) = NULL,
	@ps_ordered_by varchar(24),
	@ps_owned_by varchar(24) = NULL,
	@ps_created_by varchar(24),
	@pl_patient_workplan_id int OUTPUT
	)
AS

DECLARE @ls_indirect_flag char(1)

-- If the in_office_flag is not null, then inherit from the encounter
IF @ps_in_office_flag IS NULL
	BEGIN
	SELECT @ls_indirect_flag = indirect_flag
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id

	IF @ls_indirect_flag = 'D'
		SELECT @ps_in_office_flag = 'Y'
	ELSE
		SELECT @ps_in_office_flag = 'N'

	END

INSERT INTO p_Patient_WP
	(
	cpr_id,
	workplan_id,
	workplan_type,
	encounter_id,
	treatment_id,
	description,
	in_office_flag,
	ordered_by,
	owned_by,
	created_by)
VALUES	(
	@ps_cpr_id,
	0,
	'Treatment',
	@pl_encounter_id,
	@pl_treatment_id,
	'Treatment',
	@ps_in_office_flag,
	@ps_ordered_by,
	COALESCE(@ps_owned_by, @ps_ordered_by),
	@ps_created_by )

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END
SELECT @pl_patient_workplan_id = @@identity

GO
GRANT EXECUTE
	ON [dbo].[sp_order_service_workplan]
	TO [cprsystem]
GO

