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

