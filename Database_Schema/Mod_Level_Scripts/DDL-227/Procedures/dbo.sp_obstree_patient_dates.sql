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

-- Drop Procedure [dbo].[sp_obstree_patient_dates]
Print 'Drop Procedure [dbo].[sp_obstree_patient_dates]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_obstree_patient_dates]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_obstree_patient_dates]
GO

-- Create Procedure [dbo].[sp_obstree_patient_dates]
Print 'Create Procedure [dbo].[sp_obstree_patient_dates]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_obstree_patient_dates (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
	)
AS

IF @pdt_begin_date IS NULL
	SET @pdt_begin_date = CAST('1/1/1900' AS datetime)

IF @pdt_end_date IS NULL
	SET @pdt_end_date = dbo.get_client_datetime()

DECLARE @tmp_patient_results TABLE
(	 record_type varchar(12) NOT NULL
	,display_flag char(1) NULL DEFAULT ('Y')
	,history_sequence int IDENTITY (1,1) NOT NULL
	,parent_history_sequence int NOT NULL
	,observation_id varchar(24) NOT NULL
	,observation_description varchar(80) NULL
	,observation_sequence int NULL
	,observation_type varchar(24) NULL
	,composite_flag char(1) NULL
	,in_context_flag char(1) NULL
	,display_style varchar(255) NULL
	,perform_location_domain varchar(24) NULL
	,treatment_id int NULL
	,parent_observation_sequence int NULL
	,observation_comment_id int NULL
	,comment_user_id varchar(24) NULL
	,comment_title varchar(48) NULL
	,comment varchar(max) NULL
	,attachment_id int NULL
	,location_result_sequence int NULL
	,location varchar(24) NULL
	,location_description varchar(40) NULL
	,result_sequence smallint NULL
	,result_date_time datetime NULL
	,result varchar(80) NULL
	,result_value varchar(40) NULL
	,result_unit varchar(12) NULL
	,result_amount_flag char(1) NULL
	,print_result_flag char(1) NULL
	,print_result_separator varchar(8) NULL
	,abnormal_flag char(1) NULL
	,severity smallint NULL
	,result_type varchar(12) NULL
	,unit_preference varchar(24) NULL
	,display_mask varchar(40) NULL
	,sort_sequence smallint NULL
	,edit_service varchar(24) NULL
	,stage int NULL
	,stage_description varchar(32) NULL
	,branch_id int NULL
	,results_level int NOT NULL DEFAULT (0) 
	,default_view char(1) DEFAULT ('R')
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
	,id uniqueidentifier NULL
)

DECLARE @tmp_equiv_observations TABLE
(	 history_sequence int NOT NULL
	,observation_id varchar(24) NOT NULL
	,observation_description varchar(80) NULL
	,default_view char(1) DEFAULT ('R')
)

-- Insert the root

INSERT INTO @tmp_patient_results 
(	 record_type
	,observation_id
	,observation_description
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
	,parent_history_sequence
	,results_level
	,default_view
	,id
)
SELECT	 'Root'
	,observation_id
	,description
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
	,0
	,1000
	,default_view
	,id
FROM 	c_Observation WITH (NOLOCK)
WHERE	observation_id = @ps_observation_id

-- Insert the first level children from the tree

INSERT INTO @tmp_patient_results 
(	 record_type
	,observation_id
	,observation_description
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
	,parent_history_sequence
	,sort_sequence
	,edit_service
	,branch_id
	,results_level
	,location
	,result_sequence
	,default_view
	,id
)
SELECT   'Observation'
	,t.child_observation_id
	,COALESCE(t.description, o.description)
	,o.observation_type
	,o.composite_flag
	,o.in_context_flag
	,o.display_style
	,o.perform_location_domain
	,x.history_sequence
	,t.sort_sequence
	,t.edit_service
	,t.branch_id
	,999
	,t.location
	,t.result_sequence
	,o.default_view
	,o.id
FROM 	c_Observation_Tree t WITH (NOLOCK)
INNER JOIN c_Observation o WITH (NOLOCK)
ON 	t.child_observation_id = o.observation_id
INNER JOIN @tmp_patient_results x
ON 	x.observation_id = t.parent_observation_id
ORDER BY
	 t.sort_sequence
	,t.branch_id

-- Now get the equivalence observations, if any
INSERT INTO @tmp_equiv_observations (
	history_sequence ,
	observation_id ,
	observation_description ,
	default_view )
SELECT DISTINCT t.history_sequence ,
	o.observation_id ,
	o.description ,
	o.default_view
FROM @tmp_patient_results t
	INNER JOIN c_Equivalence g
	ON t.id = g.object_id
	INNER JOIN c_Equivalence e
	ON g.equivalence_group_id = e.equivalence_group_id
	INNER JOIN c_Observation o
	ON e.object_id = o.id

-- Add in the observations which have no equivalences
INSERT INTO @tmp_equiv_observations (
	history_sequence ,
	observation_id ,
	observation_description ,
	default_view )
SELECT DISTINCT t.history_sequence ,
	t.observation_id ,
	t.observation_description ,
	t.default_view
FROM @tmp_patient_results t
WHERE NOT EXISTS (
	SELECT 1
	FROM @tmp_equiv_observations e
	WHERE t.history_sequence = e.history_sequence
	AND t.observation_id = e.observation_id )



-- Now that we have a list of the observations, get all the results for them
-- Get the property results

INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_id
	,observation_description
	,result_sequence
	,result
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,unit_preference
	,display_mask
	,sort_sequence
	,results_level
	,default_view
)
SELECT   'Result'
	,o.history_sequence
	,c.observation_id
	,o.observation_description
	,c.result_sequence
	,c.result
	,c.result_unit
	,c.abnormal_flag
	,c.severity
	,c.result_type
	,c.result_amount_flag
	,c.print_result_flag
	,COALESCE(c.print_result_separator, '=')
	,c.unit_preference
	,c.display_mask
	,c.sort_sequence
	,998
	,o.default_view
FROM 	@tmp_patient_results o
INNER JOIN c_Observation_Tree t WITH (NOLOCK)
ON 	o.branch_id = t.branch_id
INNER JOIN c_Observation_Result c WITH (NOLOCK)
ON 	t.child_observation_id = c.observation_id
AND 	t.result_sequence = c.result_sequence
WHERE 	c.result_type = 'PROPERTY'
ORDER BY o.history_sequence, c.sort_sequence, c.result_sequence

-- Then get the actual results

INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,observation_id
	,observation_description
	,location
	,result_sequence
	,location_result_sequence
	,result_date_time
	,result
	,result_value
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,unit_preference
	,display_mask
	,sort_sequence
	,location_description
	,results_level
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
)
SELECT   'Result'
	,o.history_sequence
	,p.observation_sequence
	,p.observation_id
	,o.observation_description
	,p.location
	,p.result_sequence
	,p.location_result_sequence
	,t.begin_date
	,p.result
	,p.result_value
	,p.result_unit
	,p.abnormal_flag
	,p.severity
	,p.result_type
	,c.result_amount_flag
	,c.print_result_flag
	,COALESCE(c.print_result_separator, '=')
	,c.unit_preference
	,c.display_mask
	,c.sort_sequence
	,l.description
	,998
	,o.default_view
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
FROM 	@tmp_equiv_observations o
INNER JOIN p_Observation_Result p WITH (NOLOCK)
ON 	o.observation_id = p.observation_id
LEFT OUTER JOIN p_Treatment_Item t WITH (NOLOCK)
ON p.cpr_id = t.cpr_id
AND p.treatment_id = t.treatment_id
INNER JOIN c_Observation_Result c WITH (NOLOCK)
ON 	p.observation_id = c.observation_id
AND 	p.result_sequence = c.result_sequence
INNER JOIN c_Location l WITH (NOLOCK)
ON 	p.location = l.location
WHERE 	p.cpr_id = @ps_cpr_id
AND	p.current_flag = 'Y'
AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
AND p.result_date_time >= @pdt_begin_date
AND p.result_date_time <= @pdt_end_date
AND p.result_type NOT IN ('Comment', 'Attachment')
ORDER BY o.history_sequence, c.sort_sequence, c.result_sequence

-- Finally, get the comments
-------------------------------------------------------------------------------------------
-- THIS SCRIPT TRUNCATES COMMENTS TO 37 CHARACTERS (AND ADDS "...") IF COMMENT GREATER THAN
-- 40 CHARACTERS IN LENGTH.  THE REASON FOR TRUNCATION IS THE APPEARANCE OF THE GRID.
-- A FUTURE BUILD IS INTENDED TO PUT A CHARACTER IN PLACE OF THE TRUNCATED COMMENT AND TO DISPLAY LONGER
-- COMMENTS BELOW THE GRID
--------------------------------------------------------------------------------------------


INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,observation_id
	,observation_description
	,location
	,result_sequence
	,location_result_sequence
	,result_date_time
	,result
	,result_value
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,sort_sequence
	,location_description
	,results_level
	,default_view
	,observed_by
)
SELECT   'Result'
	,o.history_sequence
	,c.observation_sequence
	,c.observation_id
	,o.observation_description
	,'NA'
	, -999
	,c.observation_comment_id
	,c.comment_date_time
	,CASE c.comment_type WHEN 'Comment' THEN COALESCE(c.comment_title, c.comment_type)
		ELSE CASE WHEN c.comment_title IS NULL THEN c.comment_type ELSE c.comment_type + ': ' + c.comment_type END
		END
	,CASE WHEN LEN(
			COALESCE(
			c.short_comment,CAST(c.comment AS VARCHAR (42))
			)) < 41 THEN COALESCE(
			c.short_comment,CAST(c.comment AS VARCHAR (40))
			)
	ELSE 	LEFT(
			COALESCE(
			c.short_comment,CAST(c.comment AS VARCHAR (40))
			), 37
		) + '...'
			END
	,'TEXT'
	,c.abnormal_flag
	,c.severity
	,'PERFORM'
	,result_amount_flag = 'Y'
	,print_result_flag = 'N'
	,print_result_separator = '='
	,c.observation_comment_id % 32768
	,'NA'
	,997
	,o.default_view
	,c.user_id
FROM 	@tmp_equiv_observations o
INNER JOIN p_Observation_Comment c WITH (NOLOCK)
ON 	o.observation_id = c.observation_id
LEFT OUTER JOIN p_treatment_item t WITH (NOLOCK)
ON c.treatment_id = t.treatment_id
AND c.cpr_id = t.cpr_id
INNER JOIN c_Observation_Result r WITH (NOLOCK)
ON r.observation_id = c.observation_id
AND r.result = c.comment_title
AND r.status = 'OK'
WHERE 	c.cpr_id = @ps_cpr_id
AND	c.current_flag = 'Y'
AND c.comment_date_time >= @pdt_begin_date
AND c.comment_date_time <= @pdt_end_date





-- Get all the result records, preserving any records with results or that are on the top two levels

SELECT	 t.record_type
	,t.history_sequence
	,t.parent_history_sequence
	,t.observation_sequence
	,t.parent_observation_sequence
	,t.observation_id
	,t.observation_type
	,t.composite_flag
	,t.in_context_flag
	,t.display_style
	,t.perform_location_domain
	,t.observation_description
	,t.location
	,t.result_sequence
	,t.location_result_sequence
	,t.result_date_time
	,t.result
	,t.result_value
	,t.result_unit
	,t.abnormal_flag
	,t.severity
	,t.result_type
	,l.description as location_description
	,t.result_amount_flag
	,t.print_result_flag
	,t.print_result_separator
	,t.observation_comment_id
	,t.comment_user_id
	,t.comment_title
	,t.comment
	,t.attachment_id
	,t.unit_preference
	,t.display_mask
	,t.sort_sequence
	,t.edit_service
	,t.display_flag
	,t.stage
	,t.stage_description
	,t.results_level AS [level]
	,t.treatment_id
	,t.default_view
	,t.abnormal_nature
	,t.normal_range
	,t.observed_by
FROM 	@tmp_patient_results t
LEFT OUTER JOIN c_location l WITH (NOLOCK)
ON 	t.location = l.location
ORDER BY
	 t.history_sequence


GO
GRANT EXECUTE
	ON [dbo].[sp_obstree_patient_dates]
	TO [cprsystem]
GO

