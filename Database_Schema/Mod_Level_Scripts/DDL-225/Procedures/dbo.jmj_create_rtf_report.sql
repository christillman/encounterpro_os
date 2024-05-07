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

-- Drop Procedure [dbo].[jmj_create_rtf_report]
Print 'Drop Procedure [dbo].[jmj_create_rtf_report]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_create_rtf_report]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_create_rtf_report]
GO

-- Create Procedure [dbo].[jmj_create_rtf_report]
Print 'Create Procedure [dbo].[jmj_create_rtf_report]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_create_rtf_report (
	@ps_report_name varchar(80),
	@ps_context_object varchar(24)
	)
AS

DECLARE @ll_customer_id int,
		@ls_current_user varchar(24),
		@ll_display_script_id int,
		@lui_report_id uniqueidentifier,
		@ldt_last_updated datetime

IF @ps_report_name IS NULL
	BEGIN
	RAISERROR ('Null report description',16,-1)
	RETURN
	END

-- See if the report already exists.  If it was created in the last 5 seconds,
-- assume it was created successfully in this attempt.  We do this because the
-- powerbuilder ad-hoc query engine will execute the query once to find out it's
-- SQL syntax and the execute it again to get the results
SELECT @ldt_last_updated = max(last_updated)
FROM c_Report_Definition
WHERE description = @ps_report_name

IF @ldt_last_updated IS NOT NULL
	BEGIN
	IF @ldt_last_updated > DATEADD(second, -5, dbo.get_client_datetime())
		BEGIN
		SELECT 'New ' + @ps_context_object + ' Report - "' + @ps_report_name + '" Successfully Created'
		RETURN
		END
	ELSE
		BEGIN
		RAISERROR ('Report description already exists (%s)',16,-1, @ps_report_name)
		RETURN
		END
	END


SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SET @lui_report_id = newid()

SET @ls_current_user = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

BEGIN TRANSACTION

INSERT INTO c_Report_Definition (
	report_id,
	description,
	report_type,
	component_id,
	status,
	owner_id)
VALUES (
	@lui_report_id,
	@ps_report_name,
	@ps_context_object,
	'RPT_RTF',
	'OK',
	@ll_customer_id)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

INSERT INTO c_Display_Script (
	context_object,
	display_script,
	description,
	status,
	updated_by,
	owner_id)
VALUES (
	@ps_context_object,
	@ps_report_name,
	@ps_report_name,
	'OK',
	@ls_current_user,
	@ll_customer_id)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

SET @ll_display_script_id = SCOPE_IDENTITY()

INSERT INTO c_Report_Attribute (
	report_id,
	attribute,
	value)
VALUES (
	@lui_report_id,
	'display_script_id',
	CAST(@ll_display_script_id AS varchar(12))
	)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

COMMIT TRANSACTION

SELECT 'New ' + @ps_context_object + ' Report - "' + @ps_report_name + '" Successfully Created'

GO
GRANT EXECUTE
	ON [dbo].[jmj_create_rtf_report]
	TO [cprsystem]
GO

