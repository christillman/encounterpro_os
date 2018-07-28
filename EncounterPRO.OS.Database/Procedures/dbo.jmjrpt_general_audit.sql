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

-- Drop Procedure [dbo].[jmjrpt_general_audit]
Print 'Drop Procedure [dbo].[jmjrpt_general_audit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_general_audit]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_general_audit]
GO

-- Create Procedure [dbo].[jmjrpt_general_audit]
Print 'Create Procedure [dbo].[jmjrpt_general_audit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE jmjrpt_general_audit (
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
	)
AS

Declare @ldt_begin_date datetime,
		@ldt_end_date datetime

IF @ps_begin_date IS NULL OR @ps_begin_date = ''
	SET @ps_begin_date = '1/1/1900'
SET @ldt_begin_date = CAST(@ps_begin_date AS datetime)

IF @ps_end_date IS NULL OR @ps_end_date = ''
	SET @ps_end_date = '1/1/2100'
SET @ldt_end_date = CAST(@ps_end_date + ' 23:59:59' AS datetime)


SELECT Patient = dbo.fn_pretty_name(p.last_name
									,p.first_name
									,p.middle_name
									,p.name_suffix
									,p.name_prefix
									,p.degree
									) 
	,Patient_ID=p.billing_id
	,Provider = u.user_full_name
	,Service=i.description
	,Action=lower(ip.progress_type)
	,Time=ip.created
FROM	p_patient p WITH (NOLOCK)
	INNER JOIN p_patient_wp_item i WITH (NOLOCK)
	ON	p.cpr_id = i.cpr_id 
	INNER JOIN p_patient_wp_item_progress ip WITH (NOLOCK)
	ON	i.patient_workplan_item_id = ip.patient_workplan_item_id
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ip.user_id = u.user_id
WHERE ip.user_id = @ps_user_id
AND ip.progress_type NOT IN ('Runtime_Configured', 'dispatched', 'clicked')
AND	ip.created >= @ldt_begin_date
AND	ip.created <= @ldt_end_date
ORDER BY ip.patient_workplan_item_prog_id


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_general_audit]
	TO [cprsystem]
GO

