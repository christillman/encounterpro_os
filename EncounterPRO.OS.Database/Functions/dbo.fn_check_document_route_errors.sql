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

-- Drop Function [dbo].[fn_check_document_route_errors]
Print 'Drop Function [dbo].[fn_check_document_route_errors]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_check_document_route_errors]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_check_document_route_errors]
GO

-- Create Function [dbo].[fn_check_document_route_errors]
Print 'Create Function [dbo].[fn_check_document_route_errors]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_check_document_route_errors (
	@pl_patient_workplan_item_id int,
	@ps_ordered_for varchar(24),
	@ps_document_route varchar(24))

RETURNS @route_errors TABLE (
	error_id int NOT NULL,
	severity int NOT NULL,
	severity_text varchar(12) NOT NULL,
	error_text varchar(1024) NOT NULL,
	allow_override char(1) DEFAULT ('Y'))
AS

BEGIN


DECLARE @ls_context_object varchar(24),
		@ll_object_key int,
		@ls_purpose varchar(24),
		@ls_cpr_id varchar(12),
		@ls_dea_schedule varchar(6),
		@lr_dispense_amount real,
		@ls_dispense_unit varchar(12),
		@ls_purpose_context_object varchar(24)

SET @ls_context_object = dbo.fn_wp_item_context_object(@pl_patient_workplan_item_id)
SET @ll_object_key = dbo.fn_wp_item_object_key(@pl_patient_workplan_item_id)

SELECT @ls_cpr_id = cpr_id
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ls_purpose = CAST(value as varchar(24))
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute_sequence = (SELECT MAX(attribute_sequence) FROM p_Patient_WP_Item_Attribute WHERE patient_workplan_item_id = @pl_patient_workplan_item_id AND attribute = 'purpose')

-- If there is a purpose, make sure it is consistent with the context object
IF @ls_purpose IS NOT NULL
	BEGIN
	SELECT @ls_purpose_context_object = context_object
	FROM c_Document_Purpose
	WHERE purpose = @ls_purpose
	
	IF @@ROWCOUNT = 0
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'Invalid Purpose (' + @ls_purpose + ')')

	IF @ls_purpose_context_object <> @ls_context_object
		BEGIN
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'Document Purpose (' + @ls_purpose + ') is not compatible with document context (' + @ls_context_object + ')')

		-- We won't even process if the purpose context object is wrong, so go ahead and exit here
		RETURN
		END
	END


--------------------------------------------------------------------------------
-- SureScripts checks
--------------------------------------------------------------------------------

IF @ps_document_route = 'SureScripts'
	BEGIN
	IF @ls_purpose IS NULL
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'All documents sent via SureScripts must have a Purpose')

	IF @ls_purpose = 'NewRX'
		BEGIN
		SELECT @ls_dea_schedule = dd.dea_schedule,
				@lr_dispense_amount = t.dispense_amount,
				@ls_dispense_unit = t.dispense_unit
		FROM p_Treatment_Item t
			LEFT OUTER JOIN c_Drug_Definition dd
			ON t.drug_id = dd.drug_id
		WHERE cpr_id = @ls_cpr_id
		AND treatment_id = @ll_object_key

		IF dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Dosing Instructions') IS NULL
		  AND dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Patient Instructions') IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have any dosing instructions')

		IF dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Admin Instructions') IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have any administration instructions')

		IF @lr_dispense_amount IS NULL OR @ls_dispense_unit IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have a dispense amount/unit specified')

		IF @ls_dea_schedule = 'I'
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text,
				allow_override)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'Schedule I Drugs may not be prescribed',
				'N')

		IF @ls_dea_schedule IN ('II', 'III', 'IV', 'V')
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text,
				allow_override)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'Prescriptions for Schedule II-V drugs may not be sent electronically.  The prescription must printed and signed by the provider.',
				'N')





		END
	END



RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_check_document_route_errors]
	TO [cprsystem]
GO
