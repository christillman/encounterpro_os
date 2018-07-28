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

-- Drop Procedure [dbo].[jmj_order_document]
Print 'Drop Procedure [dbo].[jmj_order_document]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_order_document]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_order_document]
GO

-- Create Procedure [dbo].[jmj_order_document]
Print 'Create Procedure [dbo].[jmj_order_document]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_order_document
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@ps_context_object varchar(24),
	@pl_object_key int = NULL,
	@ps_report_id varchar(40),
	@ps_dispatch_method varchar(24) = NULL,
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int = 0,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24),
	@pl_material_id int = NULL
	)
AS

-- This procedure is depricated.  Use jmj_order_document2 in order to provide a [purpose] when ordering a document.



DECLARE @li_count smallint,
	@ls_object_key varchar(12),
	@ll_patient_workplan_item_id int,
	@ls_object_key_attribute varchar(24),
	@ls_material_id varchar(12)

-- If the ordered_for is not supplied, then choose a default
IF @ps_ordered_for IS NULL
	BEGIN
	SET @ps_ordered_for = '#PATIENT'
	END

IF @ps_description IS NULL
	BEGIN
	SET @ps_description = dbo.fn_patient_object_description(@ps_cpr_id, @ps_context_object, @pl_object_key)
	
	-- If the description contains a CR, truncate there
	IF CHARINDEX(CHAR(13), @ps_description) > 0
		SET @ps_description = LEFT(@ps_description, CHARINDEX(CHAR(13), @ps_description) - 1)
	END

INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	cpr_id,
	encounter_id,
	item_type,
	description,
	dispatch_method,
	ordered_by,
	ordered_for,
	status,
	created_by,
	context_object)
VALUES	(
	@pl_patient_workplan_id,
	0,
	@ps_cpr_id,
	@pl_encounter_id,
	'Document',
	@ps_description,
	@ps_dispatch_method,
	@ps_ordered_by,
	@ps_ordered_for,
	'Ordered',
	@ps_created_by ,
	@ps_context_object)
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ll_patient_workplan_item_id = @@identity

IF @pl_material_id IS NOT NULL
	BEGIN
	SET @ls_material_id = CAST(@pl_material_id AS varchar(12))
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'material_id',
		@ps_value = @ls_material_id,
		@ps_created_by = @ps_created_by
	END

IF @ps_report_id IS NOT NULL
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'report_id',
		@ps_value = @ps_report_id,
		@ps_created_by = @ps_created_by

EXEC sp_add_workplan_item_attribute
	@ps_cpr_id = @ps_cpr_id,
	@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
	@ps_attribute = 'context_object',
	@ps_value = @ps_context_object,
	@ps_created_by = @ps_created_by

IF @pl_object_key IS NOT NULL
	BEGIN
	SET @ls_object_key_attribute = CASE @ps_context_object WHEN 'Assessment' THEN 'problem_id'
															WHEN 'observation' THEN 'observation_sequence'
															ELSE @ps_context_object + '_id' END
	SET @ls_object_key = CAST(@pl_object_key AS varchar(12))
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = @ls_object_key_attribute,
		@ps_value = @ls_object_key,
		@ps_created_by = @ps_created_by
	END

RETURN @ll_patient_workplan_item_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_order_document]
	TO [cprsystem]
GO

