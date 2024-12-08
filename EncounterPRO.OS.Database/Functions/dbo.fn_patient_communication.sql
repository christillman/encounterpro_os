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

-- Drop Function [dbo].[fn_patient_communication]
Print 'Drop Function [dbo].[fn_patient_communication]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_communication]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_communication]
GO

-- Create Function [dbo].[fn_patient_communication]
Print 'Create Function [dbo].[fn_patient_communication]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_communication (
	@ps_cpr_id varchar(12) )

RETURNS @comm TABLE (
	communication_type varchar (24) NOT NULL ,
	communication_name varchar (24) NOT NULL ,
	communication_value varchar (80) NOT NULL ,
	sort_sequence int NULL)
AS
BEGIN

DECLARE @type TABLE (
	communication_type varchar(24) NOT NULL)

DECLARE @comm_name TABLE (
	communication_type varchar(24) NOT NULL,
	progress_type varchar(24) NOT NULL,
	progress_key varchar(40) NOT NULL,
	sort_sequence int NULL)

-- Get values from p_Patient
INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value )
SELECT 'Phone',
	'Phone',
	phone_number
FROM p_Patient
WHERE cpr_id = @ps_cpr_id
AND LEN(phone_number) > 0

INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value )
SELECT 'Email',
	'Email',
	email_address
FROM p_Patient
WHERE cpr_id = @ps_cpr_id
AND LEN(email_address) > 0

-- Get values from p_Patient_Progress
INSERT INTO @type (
	communication_type)
SELECT CAST(domain_item AS varchar(24))
FROM c_Domain
WHERE domain_id = 'Communication Type'

INSERT INTO @comm_name (
	communication_type,
	progress_type ,
	progress_key,
	sort_sequence)
SELECT t.communication_type,
	'Communication ' + t.communication_type,
	CAST(d.domain_item AS varchar(24)),
	d.sort_sequence
FROM @type t
	INNER JOIN c_Domain d
	ON d.domain_id = 'Communication ' + t.communication_type

INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value ,
	sort_sequence)
SELECT x.communication_type ,
	x.progress_key,
	COALESCE(p.progress_value, CAST(p.progress AS varchar(80))),
	x.sort_sequence
FROM p_Patient_Progress p
	INNER JOIN @comm_name x
	ON p.progress_type = x.progress_type
	AND p.progress_key = x.progress_key
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
AND (p.progress_value IS NOT NULL OR p.progress IS NOT NULL)

RETURN
END
GO
GRANT SELECT ON [dbo].[fn_patient_communication] TO [cprsystem]
GO

