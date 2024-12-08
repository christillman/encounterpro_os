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

-- Drop Function [dbo].[fn_documents_for_object]
Print 'Drop Function [dbo].[fn_documents_for_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_documents_for_object]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_documents_for_object]
GO

-- Create Function [dbo].[fn_documents_for_object]
Print 'Create Function [dbo].[fn_documents_for_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_documents_for_object (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int)

RETURNS @documents TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(24) NOT NULL,
	actor_id int NULL,
	actor_class varchar(24) NULL,
	communication_type varchar(24) NULL,
	description varchar(80) NULL,
	ordered_for varchar(24) NULL,
	user_full_name varchar(64) NULL,
	dispatch_method varchar(24) NULL,
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12) NULL,
	display_status varchar(12) NULL,
	sent_status varchar(12) NULL,
	retries int NULL,
	escalation_date datetime NULL,
	expiration_date datetime NULL,
	report_id varchar(40) NULL,
	attachment_id int NULL,
	via_address varchar(255) NULL,
	via_address_display varchar(255) NULL,
	via_address_choices int NOT NULL DEFAULT 0,
	get_signature varchar(12) NOT NULL DEFAULT ('Optional'),
	get_ordered_for varchar(12) NOT NULL DEFAULT ('Optional'),
	material_id int NULL,
	document_type varchar(12) NULL,
	treatment_id int NULL,
	problem_id int NULL,
	document_context_object varchar(24) NULL,
	document_object_key int NULL,
	error_message varchar(255) NULL,
	purpose varchar(40) NULL)
AS
BEGIN

DECLARE @ldt_begin_date datetime,
		@ldt_end_date datetime

SET @ldt_begin_date = NULL
SET @ldt_end_date = NULL

INSERT INTO @documents (
	cpr_id ,
	encounter_id ,
	patient_workplan_item_id ,
	ordered_by ,
	actor_id ,
	actor_class ,
	communication_type ,
	description ,
	ordered_for ,
	user_full_name ,
	dispatch_method ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	display_status ,
	sent_status ,
	retries ,
	escalation_date ,
	expiration_date ,
	report_id ,
	attachment_id ,
	via_address ,
	via_address_display ,
	via_address_choices ,
	get_signature ,
	get_ordered_for ,
	material_id ,
	document_type ,
	treatment_id ,
	problem_id ,
	document_context_object ,
	document_object_key ,
	error_message ,
	purpose )
SELECT cpr_id ,
	encounter_id ,
	patient_workplan_item_id ,
	ordered_by ,
	actor_id ,
	actor_class ,
	communication_type ,
	description ,
	ordered_for ,
	user_full_name ,
	dispatch_method ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	display_status ,
	sent_status ,
	retries ,
	escalation_date ,
	expiration_date ,
	report_id ,
	attachment_id ,
	via_address ,
	via_address_display ,
	via_address_choices ,
	get_signature ,
	get_ordered_for ,
	material_id ,
	document_type ,
	treatment_id ,
	problem_id ,
	document_context_object ,
	document_object_key ,
	error_message ,
	purpose
FROM dbo.fn_documents_for_object_2(@ps_context_object, @ps_cpr_id, @pl_object_key, @ldt_begin_date, @ldt_end_date)

RETURN

END
GO
GRANT SELECT ON [dbo].[fn_documents_for_object] TO [cprsystem]
GO

