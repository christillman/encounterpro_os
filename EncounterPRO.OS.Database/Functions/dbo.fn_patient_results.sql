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

-- Drop Function [dbo].[fn_patient_results]
Print 'Drop Function [dbo].[fn_patient_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_results]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_results]
GO

-- Create Function [dbo].[fn_patient_results]
Print 'Create Function [dbo].[fn_patient_results]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_results (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint)

RETURNS @patient_results TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	treatment_id int NULL,
	encounter_id int NULL,
	result_sequence smallint NOT NULL,
	result_type varchar(12) NOT NULL,
	location varchar(24) NOT NULL,
	result_date_time datetime NOT NULL,
	result varchar(80) NOT NULL,
	result_value varchar(40) NULL,
	result_long_value varchar(max) NULL,
	result_unit varchar(12) NULL,
	abnormal_flag char(1) NULL,
	abnormal_nature varchar(8) NULL,
	severity smallint NULL ,
	observed_by varchar(24) NULL ,
	normal_range varchar(40) NULL ,
	root_observation_sequence int NULL,
	result_amount_flag char(1) NOT NULL ,
	print_result_flag char(1) NOT NULL ,
	print_result_separator varchar(8) NOT NULL ,
	unit_preference varchar(24) NULL ,
	sort_sequence int NULL ,
	display_mask varchar(40) NULL ,
	created datetime NULL ,
	created_by varchar(24) NULL ,
	attachment_id int NULL ,
	location_description varchar(40) NULL
	)
AS


BEGIN

DECLARE @ll_depth int,
	@ll_count int

DECLARE @tmp_results TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	observation_sequence int NOT NULL,
	location varchar(24) NOT NULL,
	result_sequence smallint NOT NULL,
	location_result_sequence int NOT NULL)

DECLARE @tmp_comments TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	observation_sequence int NOT NULL,
	comment_type varchar(24) NOT NULL,
	comment_title varchar(48) NOT NULL,
	observation_comment_id int NOT NULL)


-- Get all the distinct results
IF @pi_result_sequence IS NULL
	BEGIN
	INSERT INTO @tmp_results (
		cpr_id,
		treatment_id,
		observation_sequence,
		location,
		result_sequence,
		location_result_sequence )
	SELECT r.cpr_id,
		r.treatment_id,
		r.observation_sequence,
		r.location,
		r.result_sequence,
		max(r.location_result_sequence) as location_result_sequence
	FROM p_Observation_Result r
			INNER JOIN dbo.fn_equivalent_observations(@ps_observation_id) q
			ON r.observation_id = q.observation_id
	WHERE r.cpr_id = @ps_cpr_id	
	AND r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	AND r.treatment_id IS NOT NULL
	GROUP BY r.cpr_id,
		r.treatment_id,
		r.observation_sequence,
		r.location,
		r.result_sequence

	INSERT INTO @tmp_comments (
		cpr_id,
		treatment_id,
		observation_sequence,
		comment_type,
		comment_title,
		observation_comment_id )
	SELECT c.cpr_id,
		c.treatment_id,
		c.observation_sequence,
		c.comment_type,
		COALESCE(c.comment_title, c.comment_type) ,
		max(c.observation_comment_id) as observation_comment_id
	FROM p_Observation_Comment c
			INNER JOIN dbo.fn_equivalent_observations(@ps_observation_id) q
			ON c.observation_id = q.observation_id
	WHERE c.cpr_id = @ps_cpr_id	
	AND c.current_flag = 'Y'
	AND c.treatment_id IS NOT NULL
	GROUP BY c.cpr_id,
		c.treatment_id,
		c.observation_sequence,
		c.comment_type,
		c.comment_title
	END
ELSE
	BEGIN
	INSERT INTO @tmp_results (
		cpr_id,
		treatment_id,
		observation_sequence,
		location,
		result_sequence,
		location_result_sequence )
	SELECT r.cpr_id,
		r.treatment_id,
		r.observation_sequence,
		r.location,
		r.result_sequence,
		max(r.location_result_sequence) as location_result_sequence
	FROM p_Observation_Result r
			INNER JOIN dbo.fn_equivalent_observation_results(@ps_observation_id, @pi_result_sequence) q
			ON r.observation_id = q.observation_id
			AND r.result_sequence = q.result_sequence
	WHERE r.cpr_id = @ps_cpr_id	
	AND r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	AND r.treatment_id IS NOT NULL
	GROUP BY r.cpr_id,
		r.treatment_id,
		r.observation_sequence,
		r.location,
		r.result_sequence
	END

-- Get the final list of results
INSERT INTO @patient_results (
	cpr_id,
	observation_sequence,
	location_result_sequence ,
	treatment_id ,
	observation_id,
	encounter_id,
	result_sequence ,
	r.result_type ,
	location ,
	result ,
	result_date_time ,
	result_value ,
	result_unit ,
	abnormal_flag ,
	abnormal_nature ,
	severity ,
	observed_by ,
	normal_range ,
	root_observation_sequence ,
	result_amount_flag ,
	print_result_flag ,
	print_result_separator ,
	unit_preference ,
	sort_sequence ,
	display_mask ,
	created ,
	created_by ,
	attachment_id ,
	location_description )
SELECT 	r.cpr_id,
	r.observation_sequence,
	r.location_result_sequence ,
	r.treatment_id ,
	r.observation_id ,
	r.encounter_id ,
	r.result_sequence ,
	r.result_type ,
	r.location ,
	r.result ,
	r.result_date_time ,
	r.result_value ,
	r.result_unit ,
	r.abnormal_flag ,
	r.abnormal_nature ,
	r.severity ,
	r.observed_by ,
	r.normal_range ,
	r.root_observation_sequence ,
	result_amount_flag  = CASE ISNULL(r.result_unit, 'NA') WHEN 'NA' THEN 'N' ELSE 'Y' END ,
	print_result_flag = ISNULL(c.print_result_flag, 'N') ,
	print_result_separator = ISNULL(c.print_result_separator, '=') ,
	c.unit_preference ,
	c.sort_sequence ,
	c.display_mask ,
	r.created ,
	r.created_by ,
	r.attachment_id ,
	l.description
FROM @tmp_results t
	INNER JOIN p_Treatment_Item ti
	ON t.cpr_id = ti.cpr_id
	AND t.treatment_id = ti.treatment_id
	INNER JOIN p_Observation_Result r
	ON t.cpr_id = r.cpr_id
	AND t.observation_sequence = r.observation_sequence
	AND t.location_result_sequence = r.location_result_sequence
	INNER JOIN c_Location l
	ON t.location = l.location
	LEFT OUTER JOIN c_Observation_Result c
	ON r.observation_id = c.observation_id
	AND r.result_sequence = c.result_sequence
WHERE r.result_date_time IS NOT NULL
AND r.cpr_id = @ps_cpr_id
AND COALESCE(ti.treatment_status, 'OPEN') <> 'CANCELLED'


-- Add the final list of comments
INSERT INTO @patient_results (
	cpr_id,
	observation_sequence,
	location_result_sequence ,
	treatment_id ,
	observation_id,
	encounter_id,
	result_sequence ,
	result_type ,
	location ,
	result ,
	result_date_time ,
	result_value ,
	result_long_value ,
	result_unit ,
	abnormal_flag ,
	abnormal_nature ,
	severity ,
	observed_by ,
	root_observation_sequence ,
	result_amount_flag ,
	print_result_flag ,
	print_result_separator ,
	sort_sequence ,
	display_mask ,
	created ,
	created_by ,
	attachment_id ,
	location_description )
SELECT 	c.cpr_id,
	c.observation_sequence,
	c.observation_comment_id ,
	c.treatment_id ,
	c.observation_id ,
	c.encounter_id ,
	-999 ,
	'PERFORM' ,
	'NA' ,
	CASE c.comment_type WHEN 'Comment' THEN COALESCE(c.comment_title, c.comment_type)
						WHEN 'Attachment' THEN COALESCE(c.comment_title, c.comment_type)
						ELSE CASE WHEN c.comment_title IS NULL THEN c.comment_type ELSE c.comment_type + ': ' + c.comment_type END
						END ,
	c.comment_date_time ,
	c.short_comment ,
	c.comment ,
	'TEXT' ,
	c.abnormal_flag ,
	NULL ,
	c.severity ,
	c.user_id ,
	c.root_observation_sequence ,
	result_amount_flag = 'Y' ,
	print_result_flag = 'N' ,
	print_result_separator = '=' ,
	c.observation_comment_id ,
	CAST(NULL AS varchar(40)) ,
	c.created ,
	c.created_by ,
	c.attachment_id ,
	'NA'
FROM @tmp_comments t
	INNER JOIN p_Treatment_Item ti
	ON t.cpr_id = ti.cpr_id
	AND t.treatment_id = ti.treatment_id
	INNER JOIN p_Observation_Comment c
	ON t.cpr_id = c.cpr_id
	AND t.observation_sequence = c.observation_sequence
	AND t.observation_comment_id = c.observation_comment_id
WHERE c.cpr_id = @ps_cpr_id
AND COALESCE(ti.treatment_status, 'OPEN') <> 'CANCELLED'



RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_results] TO [cprsystem]
GO

