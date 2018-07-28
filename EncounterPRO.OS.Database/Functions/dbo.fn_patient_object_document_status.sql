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

-- Drop Function [dbo].[fn_patient_object_document_status]
Print 'Drop Function [dbo].[fn_patient_object_document_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_document_status]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_document_status]
GO

-- Create Function [dbo].[fn_patient_object_document_status]
Print 'Create Function [dbo].[fn_patient_object_document_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_patient_object_document_status (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(50),
	@pl_object_key int )

RETURNS int

AS
BEGIN

DECLARE @ll_status int,
		@ll_sum int

--
-- Returns integer:
--		0 = No documents
--		1 = Documents, but all are sent or cancelled
--		2 = Documents, at least one has not been sent
--

DECLARE @docs_by_status TABLE (
	status varchar(12) NOT NULL,
	doc_count int NOT NULL)

IF @ps_context_object = 'Encounter'
	BEGIN
	INSERT INTO @docs_by_status (
		status,
		doc_count)
	SELECT status,
			count(*)
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key
	AND item_type = 'Document'
	AND status IS NOT NULL
	GROUP BY status
	END

SELECT @ll_sum = SUM(doc_count)
FROM @docs_by_status
WHERE status IN ('Ordered', 'Created', 'Error')

IF @ll_sum > 0
	RETURN 2

SELECT @ll_sum = SUM(doc_count)
FROM @docs_by_status

IF @ll_sum > 0
	RETURN 1

RETURN 0

END
GO
GRANT EXECUTE
	ON [dbo].[fn_patient_object_document_status]
	TO [cprsystem]
GO

