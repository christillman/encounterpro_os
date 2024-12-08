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

-- Drop Function [dbo].[fn_observation_result_range]
Print 'Drop Function [dbo].[fn_observation_result_range]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_observation_result_range]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_observation_result_range]
GO

-- Create Function [dbo].[fn_observation_result_range]
Print 'Create Function [dbo].[fn_observation_result_range]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_observation_result_range (
	@ps_cpr_id varchar(12),
	@ps_ordered_by varchar(24),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_sex char(1),
	@pdt_date_of_birth datetime,
	@ps_result_value varchar(40),
	@ps_result_unit varchar(12),
	@pdt_current_date datetime )

RETURNS @abnormal TABLE (
	[normal_range] [varchar] (40) NULL ,
	[abnormal_flag] [char] (1) NULL ,
	[abnormal_nature] [varchar] (8) NULL ,
	[severity] [smallint] NULL,
	[workplan_id] [int] NULL )

AS

BEGIN

DECLARE @ls_unit_id varchar (12) ,
	@lr_low_limit real ,
	@lr_low_normal real ,
	@lr_high_normal real ,
	@lr_high_limit real ,
	@ls_inclusive_flag char (1) ,
	@ls_low_nature varchar (8) ,
	@ls_high_nature varchar (8) ,
	@li_low_severity smallint ,
	@li_high_severity smallint ,
	@ls_normal_range varchar (40) ,
	@ll_reference_material_id int ,
	@lr_original_value real ,
	@lr_result_value real ,
	@ll_workplan_id int

IF ISNUMERIC(@ps_result_value) <> 1 OR LTRIM(RTRIM(@ps_result_value)) = '.'
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

-- See if there's a custom range rule for this result
INSERT INTO @abnormal (
	[normal_range] ,
	[abnormal_flag] ,
	[abnormal_nature] ,
	[severity] )
SELECT [normal_range] ,
	[abnormal_flag] ,
	[abnormal_nature] ,
	[severity]
FROM dbo.fn_observation_custom_range(@ps_cpr_id,
									@ps_observation_id ,
									@pi_result_sequence ,
									@ps_sex ,
									@pdt_date_of_birth ,
									@ps_result_value ,
									@ps_result_unit ,
									@pdt_current_date )

IF @@ROWCOUNT > 0
	RETURN

SET @lr_original_value = CAST(@ps_result_value AS real)
SET @ps_cpr_id = ISNULL(@ps_cpr_id, '@')
SET @ps_ordered_by = ISNULL(@ps_ordered_by, '@')
SET @ps_sex = ISNULL(@ps_sex, '@')

SELECT 	TOP 1 @ls_unit_id = unit_id,
		@lr_low_limit = low_limit,
		@lr_low_normal = low_normal,
		@lr_high_normal = high_normal,
		@lr_high_limit = high_limit,
		@ls_inclusive_flag = inclusive_flag,
		@ls_low_nature = low_nature,
		@ls_high_nature = high_nature,
		@li_low_severity = low_severity,
		@li_high_severity = high_severity,
		@ls_normal_range = normal_range,
		@ll_reference_material_id = reference_material_id,
		@ll_workplan_id = abnormal_workplan_id
FROM c_Observation_Result_Range
WHERE observation_id = @ps_observation_id
AND result_sequence = @pi_result_sequence
AND (cpr_id IS NULL OR ISNULL(cpr_id, '@') = @ps_cpr_id)
AND (ordered_by IS NULL OR ISNULL(ordered_by, '@') = @ps_ordered_by)
AND (sex IS NULL OR ISNULL(sex, '@') = @ps_sex)
AND (age_range_id IS NULL OR dbo.fn_age_range_compare(age_range_id, @pdt_date_of_birth, @pdt_current_date) = 0)
AND dbo.fn_is_unit_convertible (unit_id, @ps_result_unit) = 1
ORDER BY search_sequence

-- If we don't find a record then just return nulls
IF @@ROWCOUNT = 0
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

SET @lr_result_value = dbo.fn_convert_units(@lr_original_value, @ps_result_unit, @ls_unit_id)

-- If we can't make the conversion then return nulls
IF @lr_result_value IS NULL
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

IF @lr_result_value < @lr_low_normal
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] ,
		[workplan_id] )
	VALUES (
		@ls_normal_range,
		'Y',
		@ls_low_nature,
		@li_low_severity,
		@ll_workplan_id )
	END
ELSE IF @lr_result_value > @lr_high_normal
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] ,
		[workplan_id] )
	VALUES (
		@ls_normal_range,
		'Y',
		@ls_high_nature,
		@li_high_severity,
		@ll_workplan_id )
	END
ELSE
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		@ls_normal_range,
		'N',
		NULL ,
		NULL )
	END


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_observation_result_range] TO [cprsystem]
GO

