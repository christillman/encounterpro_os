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

-- Drop Procedure [dbo].[sp_update_procedure]
Print 'Drop Procedure [dbo].[sp_update_procedure]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_procedure]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_update_procedure]
GO

-- Create Procedure [dbo].[sp_update_procedure]
Print 'Create Procedure [dbo].[sp_update_procedure]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_update_procedure (
	@ps_procedure_id varchar(24),
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@psm_charge smallmoney,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_vaccine_id varchar(24),
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL)
AS

IF @ps_default_bill_flag IS NULL
	SET @ps_default_bill_flag = 'Y'

UPDATE c_Procedure
SET	cpt_code = @ps_cpt_code,
	description = @ps_description,
	charge = @psm_charge,
	procedure_category_id = @ps_procedure_category_id,
	vaccine_id = @ps_vaccine_id,
	units = @pr_units,
	modifier = COALESCE(@ps_modifier, modifier),
	other_modifiers = COALESCE(@ps_other_modifiers, other_modifiers),
	billing_id = COALESCE(@ps_billing_id, billing_id),
	location_domain = COALESCE(@ps_location_domain, location_domain),
	risk_level = COALESCE(@pi_risk_level, risk_level),
	default_bill_flag = @ps_default_bill_flag
WHERE procedure_id = @ps_procedure_id

UPDATE u_Assessment_Treat_Definition
SET treatment_description = @ps_description
WHERE EXISTS (
	SELECT u_Assessment_Treat_Def_Attrib.definition_id
	FROM u_Assessment_Treat_Def_Attrib
	WHERE attribute like '%PROCEDURE_ID'
	AND value = @ps_procedure_id
	AND u_Assessment_Treat_Definition.definition_id = u_Assessment_Treat_Def_Attrib.definition_id
	)

UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_procedure_id
AND top_20_code = '%PROCEDURE%'


GO
GRANT EXECUTE
	ON [dbo].[sp_update_procedure]
	TO [cprsystem]
GO

