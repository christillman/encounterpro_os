﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_patient_care_team_list]
Print 'Drop Procedure [dbo].[jmj_patient_care_team_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_care_team_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_care_team_list]
GO

-- Create Procedure [dbo].[jmj_patient_care_team_list]
Print 'Create Procedure [dbo].[jmj_patient_care_team_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_patient_care_team_list (
	@ps_cpr_id varchar(24),
	@ps_show_users_flag char(1) = 'Y',
	@ps_other_actor_class varchar(24) = '%' )
AS

DECLARE @ls_authority_id varchar(24)

DECLARE @actor_class TABLE (
	actor_class varchar(24) NOT NULL)

IF @ps_show_users_flag = 'Y'
	INSERT INTO @actor_class (
		actor_class )
	VALUES (
		'User')

IF @ps_other_actor_class IS NOT NULL
	INSERT INTO @actor_class (
		actor_class )
	SELECT actor_class
	FROM c_Actor_Class
	WHERE actor_class LIKE @ps_other_actor_class
	AND actor_class <> 'User'


SELECT ct.user_id,
	ct.user_full_name,
	ct.user_short_name,
	ct.color,
	ct.icon,
	selected_flag=CONVERT(int, 0),
	ct.user_status,
	ct.type,
	ct.user_key,
	ct.email_address,
	ct.specialty_id,
	ct.specialty_description,
	ct.preferred_provider,
	ct.pretty_address,
	ct.actor_class,
	primary_actor_flag= CASE WHEN ct.primary_actor = 1 THEN 'Y' ELSE 'N' END
FROM dbo.fn_patient_care_team_list(@ps_cpr_id) ct
	INNER JOIN @actor_class ac
	ON ct.actor_class = ac.actor_class


GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_care_team_list]
	TO [cprsystem]
GO
