--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
SET QUOTED_IDENTIFIER OFF
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
	@ls_abnormal_flag char(1),
	@li_severity smallint

SELECT @ls_observation_id = observation_id
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence 

IF @@ROWCOUNT <> 1
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

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Cannot find observation result (%s, %d)', 16, -1, @ls_observation_id, @pi_result_sequence )
	ROLLBACK TRANSACTION
	RETURN
	END

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
	@ps_result_value,
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

