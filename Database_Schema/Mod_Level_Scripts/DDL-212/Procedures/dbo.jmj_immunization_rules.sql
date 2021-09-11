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

-- Drop Procedure [dbo].[jmj_immunization_rules]
Print 'Drop Procedure [dbo].[jmj_immunization_rules]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_immunization_rules]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_immunization_rules]
GO

-- Create Procedure [dbo].[jmj_immunization_rules]
Print 'Create Procedure [dbo].[jmj_immunization_rules]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_immunization_rules (
	@ps_disease_group varchar(24) = NULL,
	@pl_disease_id int = NULL)

AS

DECLARE @ll_disease_id int

IF @pl_disease_id = 0
	BEGIN
	SELECT TOP 1 @ll_disease_id = disease_id
	FROM c_Disease_Group_Item
	WHERE disease_group = @ps_disease_group
	END
ELSE
	SET @ll_disease_id = @pl_disease_id


SELECT s.dose_schedule_sequence ,
	description = CASE @pl_disease_id WHEN 0 THEN i.disease_group ELSE d.description END,
	s.disease_id ,
	s.dose_number ,
	s.sort_sequence ,
	s.dose_text
FROM c_Immunization_Dose_Schedule s
	INNER JOIN c_Disease_Group_Item i
	ON s.disease_id = i.disease_id
	INNER JOIn c_Disease d
	ON s.disease_id = d.disease_id			
	CROSS JOIN o_Office oo
	JOIN c_Office co ON co.office_id = oo.office_id
WHERE s.valid_in LIKE '%' + co.country + ';%'
AND s.disease_id = @ll_disease_id
AND i.disease_group = @ps_disease_group


GO
GRANT EXECUTE
	ON [dbo].[jmj_immunization_rules]
	TO [cprsystem]
GO

