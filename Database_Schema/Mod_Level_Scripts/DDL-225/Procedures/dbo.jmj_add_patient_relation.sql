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

-- Drop Procedure [dbo].[jmj_add_patient_relation]
Print 'Drop Procedure [dbo].[jmj_add_patient_relation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_add_patient_relation]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_add_patient_relation]
GO

-- Create Procedure [dbo].[jmj_add_patient_relation]
Print 'Create Procedure [dbo].[jmj_add_patient_relation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_add_patient_relation (
	@ps_cpr_id varchar(12),
	@ps_relation_cpr_id varchar(12),
	@ps_relationship varchar(24) ,
	@ps_created_by varchar(24) )
AS

DECLARE	@ls_maternal_sibling_flag char(1) ,
		@ls_paternal_sibling_flag char(1) ,
		@ls_parent_flag char(1) ,
		@ls_guardian_flag char(1) ,
		@ls_guarantor_flag char(1) ,
		@ls_payor_flag char(1) ,
		@ls_primary_decision_maker_flag char(1) 


SET	@ls_maternal_sibling_flag = 'N'
SET	@ls_paternal_sibling_flag = 'N'
SET	@ls_parent_flag = 'N'
SET	@ls_guardian_flag = 'N'
SET	@ls_guarantor_flag = 'N'
SET	@ls_payor_flag = 'N'
SET	@ls_primary_decision_maker_flag = 'N'

IF @ps_relationship IN ('sibling', 'maternal sibling', 'maternal half sibling', 'Sister', 'Brother')
	SET @ls_maternal_sibling_flag = 'Y'

IF @ps_relationship IN ('sibling', 'paternal sibling', 'paternal half sibling', 'Sister', 'Brother')
	SET @ls_paternal_sibling_flag = 'Y'

IF @ps_relationship IN ('parent', 'Mother', 'Father', 'Biological Mother', 'Biological Father')
	SET @ls_parent_flag = 'Y'

IF @ps_relationship = 'guardian'
	SET @ls_guardian_flag = 'Y'


INSERT INTO dbo.p_Patient_Relation (
	[cpr_id]
	,[relation_cpr_id]
	,[relationship]
	,[maternal_sibling_flag]
	,[paternal_sibling_flag]
	,[parent_flag]
	,[guardian_flag]
	,[guarantor_flag]
	,[payor_flag]
	,[primary_decision_maker_flag]
	,[created]
	,[created_by]
	,[status]
	,[status_date])
VALUES (
	@ps_cpr_id ,
	@ps_relation_cpr_id ,
	@ps_relationship ,
	@ls_maternal_sibling_flag ,
	@ls_paternal_sibling_flag ,
	@ls_parent_flag ,
	@ls_guardian_flag ,
	@ls_guarantor_flag ,
	@ls_payor_flag ,
	@ls_primary_decision_maker_flag ,
	dbo.get_client_datetime(),
	@ps_created_by,
	'OK',
	dbo.get_client_datetime())




GO
GRANT EXECUTE
	ON [dbo].[jmj_add_patient_relation]
	TO [cprsystem]
GO

