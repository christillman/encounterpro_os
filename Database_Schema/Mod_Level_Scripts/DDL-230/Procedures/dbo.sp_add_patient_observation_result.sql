
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_add_patient_observation_result]
Print 'Drop Procedure [dbo].[sp_add_patient_observation_result]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_add_patient_observation_result]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_patient_observation_result]
GO

-- Create Procedure [dbo].[sp_add_patient_observation_result]
Print 'Create Procedure [dbo].[sp_add_patient_observation_result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_add_patient_observation_result
	(
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@pl_treatment_id int = NULL,
	@pl_encounter_id int = NULL,
	@ps_location varchar(24),
	@pi_result_sequence smallint,
	@pdt_result_date_time datetime,
	@ps_result_value varchar(40) = NULL,
	@ps_result_unit varchar(24) = NULL,
	@ps_observed_by varchar(24),
	@ps_created_by varchar(24),
	@pl_location_result_sequence int OUTPUT
	)
AS

DECLARE @ls_observation_id varchar(24),
	@ls_result_type varchar(12),
	@ls_result varchar(80),
	@ls_result_value varchar(80),
	@ls_abnormal_flag char(1),
	@li_severity smallint

SELECT @ls_observation_id = observation_id
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence 

IF @ls_observation_id IS NULL
	BEGIN
	RAISERROR ('Cannot find observation (%s, %d)', 16, -1, @ps_cpr_id, @pl_observation_sequence )
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ls_result_type = result_type ,
	@ls_result = result ,
	@ls_abnormal_flag = abnormal_flag ,
	@li_severity = severity 
FROM c_Observation_Result
WHERE observation_id = @ls_observation_id
AND result_sequence = @pi_result_sequence

IF @ls_result_type IS NULL
	BEGIN
	RAISERROR ('Cannot find observation result (%s, %d)', 16, -1, @ls_observation_id, @pi_result_sequence )
	ROLLBACK TRANSACTION
	RETURN
	END

SET @ls_result_value = CASE WHEN @ps_result_value LIKE char(13) + char(10) + '%' THEN substring(@ps_result_value,3,100) ELSE @ps_result_value END
SET @ls_result_value = CASE WHEN @ls_result_value LIKE '%' + char(13) + char(10) THEN left(@ls_result_value, len(@ls_result_value) - 2) ELSE @ls_result_value END

INSERT INTO p_Observation_Result (
	cpr_id,
	observation_sequence,
	observation_id,
	treatment_id,
	encounter_id,
	location,
	result_sequence,
	result_date_time,
	result_value,
	result_unit,
	result_type,
	result,
	abnormal_flag,
	severity,
	observed_by,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@pl_observation_sequence,
	@ls_observation_id,
	@pl_treatment_id,
	@pl_encounter_id,
	@ps_location,
	@pi_result_sequence,
	@pdt_result_date_time,
	TRIM(@ls_result_value),
	@ps_result_unit,
	@ls_result_type,
	@ls_result,
	@ls_abnormal_flag,
	@li_severity,
	@ps_observed_by,
	dbo.get_client_datetime(),
	@ps_created_by )

SELECT @pl_location_result_sequence = @@IDENTITY


GO
GRANT EXECUTE
	ON [dbo].[sp_add_patient_observation_result]
	TO [cprsystem]
GO

