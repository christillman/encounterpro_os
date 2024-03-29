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

-- Drop Procedure [dbo].[sp_patient_search]
Print 'Drop Procedure [dbo].[sp_patient_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_patient_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_patient_search]
GO

-- Create Procedure [dbo].[sp_patient_search]
Print 'Create Procedure [dbo].[sp_patient_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE sp_patient_search
(
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_employer varchar(40) = NULL,
	@ps_employeeid varchar(24) = NULL,
	@ps_ssn varchar(24) = NULL,
	@ps_patient_status varchar(24) = NULL
)
WITH RECOMPILE
AS

IF ISNULL( @ps_billing_id, '' ) = ''
	SET @ps_billing_id = '%'

IF ISNULL( @ps_ssn, '' ) = ''
	SET @ps_ssn = '%'

IF ISNULL( @ps_last_name, '' ) = ''
	SET @ps_last_name = '%'

IF ISNULL( @ps_first_name, '' ) = ''
	SET @ps_first_name = '%'

IF ISNULL( @ps_employer, '' ) = ''
	SET @ps_employer = '%'

IF ISNULL( @ps_employeeid, '' ) = ''
	SET @ps_employeeid = '%'

IF ISNULL( @ps_patient_status, '' ) = ''
	SET @ps_patient_status = '%'



IF @ps_billing_id <> '%'
BEGIN
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE	p.billing_id like @ps_billing_id
	AND	ISNULL(p.ssn,'') like @ps_ssn
	AND	ISNULL(p.last_name,'') like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
END
ELSE IF @ps_ssn <> '%'
BEGIN
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE p.ssn like @ps_ssn
	AND	ISNULL(p.last_name, '') like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
END
ELSE IF @ps_last_name <> '%'
	SELECT
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		INNER JOIN (SELECT TOP 100 cpr_id FROM p_Patient WITH (NOLOCK) WHERE last_name like @ps_last_name AND first_name like @ps_first_name ORDER BY last_name) x
		ON p.cpr_id = x.cpr_id
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE p.last_name like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
ELSE
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
GO
GRANT EXECUTE
	ON [dbo].[sp_patient_search]
	TO [cprsystem]
GO

