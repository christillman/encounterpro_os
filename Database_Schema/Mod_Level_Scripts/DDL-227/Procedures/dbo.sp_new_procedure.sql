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

-- Drop Procedure [dbo].[sp_new_procedure]
Print 'Drop Procedure [dbo].[sp_new_procedure]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_procedure]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_procedure]
GO

-- Create Procedure [dbo].[sp_new_procedure]
Print 'Create Procedure [dbo].[sp_new_procedure]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_procedure (
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@pdc_charge decimal = NULL,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_service varchar(24) = NULL,
	@ps_vaccine_id varchar(24) = NULL,
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL,
	@ps_long_description varchar(max) = NULL,
	@ps_default_location varchar(24)= NULL,
	@ps_bill_assessment_id varchar(24) = NULL,
	@ps_well_encounter_flag char(1) = NULL
	)
AS

DECLARE @ls_procedure_id varchar(24)

EXECUTE sp_new_procedure_record
		@ps_procedure_id = @ls_procedure_id OUTPUT,
		@ps_procedure_type = @ps_procedure_type,
		@ps_cpt_code = @ps_cpt_code,
		@pdc_charge = @pdc_charge,
		@ps_procedure_category_id = @ps_procedure_category_id,
		@ps_description = @ps_description,
		@ps_service = @ps_service,
		@ps_vaccine_id = @ps_vaccine_id,
		@pr_units = @pr_units,
		@ps_modifier = @ps_modifier,
		@ps_other_modifiers = @ps_other_modifiers,
		@ps_billing_id = @ps_billing_id,
		@ps_location_domain = @ps_location_domain,
		@pi_risk_level = @pi_risk_level,
		@ps_default_bill_flag = @ps_default_bill_flag,
		@ps_long_description = @ps_long_description,
		@ps_default_location = @ps_default_location,
		@ps_bill_assessment_id = @ps_bill_assessment_id,
		@ps_well_encounter_flag = @ps_well_encounter_flag
		

SELECT @ls_procedure_id AS procedure_id

GO
GRANT EXECUTE
	ON [dbo].[sp_new_procedure]
	TO [cprsystem]
GO

