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

-- Drop Function [dbo].[fn_observation_custom_range]
Print 'Drop Function [dbo].[fn_observation_custom_range]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_observation_custom_range]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_observation_custom_range]
GO

-- Create Function [dbo].[fn_observation_custom_range]
Print 'Create Function [dbo].[fn_observation_custom_range]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_observation_custom_range (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_sex char(1),
	@pdt_date_of_birth datetime,
	@ps_result_value varchar(40) ,
	@ps_result_unit varchar(12),
	@pdt_current_date datetime )

RETURNS @abnormal TABLE (
	[normal_range] [varchar] (40) NULL ,
	[abnormal_flag] [char] (1) NULL ,
	[abnormal_nature] [varchar] (8) NULL ,
	[severity] [smallint] NULL )

AS

BEGIN

DECLARE @ls_result_value varchar(40) ,
		@ls_result_unit varchar(12) ,
		@lr_height real,
		@ll_peak_flow int,
		@ll_ideal int,
		@ls_normal_range varchar(40),
		@ll_green int,
		@ll_yellow int


-- Calculate the Peak Flow normal range using the patient height
IF @ps_observation_id = 'PEAK' AND @pi_result_sequence = -1
	BEGIN
	-- Get the last height
	SELECT @ls_result_value = result_value,
			@ls_result_unit = result_unit
	FROM dbo.fn_patient_observation_last_result(@ps_cpr_id, 'HGT', -1)
	WHERE result_date_time >= DATEADD(year, -1, @pdt_current_date)

	-- If there is no height then we're done
	IF @@ROWCOUNT <> 1 OR ISNUMERIC(@ls_result_value) <> 1
		BEGIN
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			'No Recent Height Available',
			'Y',
			'No Hgt',
			3 )
		
		RETURN
		END

	-- Convert the peak flow value to an integer
	SET @ll_peak_flow = CAST(@ps_result_value AS int)

	-- Convert to a real and then convert to CM
	SET @lr_height = dbo.fn_convert_units(CAST(@ls_result_value AS real), @ls_result_unit, 'CM')

	-- Calculate thresholds
	SET @ll_ideal = (@lr_height - 80) * 5
	SET @ll_green = 0.8 * @ll_ideal
	SET @ll_yellow = 0.5 * @ll_ideal

	-- Create the normal range string
	SET @ls_normal_range = CAST(@ll_green AS varchar(8)) + ' - ' + CAST(@ll_ideal AS varchar(8))
	SET @ls_normal_range = @ls_normal_range + ' (Hgt = ' + CAST(CAST(@lr_height AS decimal(6,1)) as varchar(8)) + 'cm)'
	
	IF @ll_peak_flow >= @ll_green
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'N',
			NULL,
			1 )
	ELSE IF @ll_peak_flow >= @ll_yellow
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'Y',
			'Yellow',
			3 )
	ELSE
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'Y',
			'Red',
			4 )
	
	END

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_observation_custom_range] TO [cprsystem]
GO

