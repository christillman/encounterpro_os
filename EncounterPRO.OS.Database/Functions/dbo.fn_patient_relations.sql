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

-- Drop Function [dbo].[fn_patient_relations]
Print 'Drop Function [dbo].[fn_patient_relations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_relations]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_relations]
GO

-- Create Function [dbo].[fn_patient_relations]
Print 'Create Function [dbo].[fn_patient_relations]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION dbo.fn_patient_relations (
	@ps_cpr_id varchar(12),
	@ps_relationship varchar(24) )

RETURNS @patient_relations TABLE (
		[cpr_id] [varchar] (12) NOT NULL ,
		[relation_sequence] [int] NOT NULL ,
		[relation_cpr_id] [varchar] (12) NOT NULL ,
		[relationship] [varchar] (24) NOT NULL ,
		[maternal_sibling_flag] [char] (1) NOT NULL ,
		[paternal_sibling_flag] [char] (1) NOT NULL ,
		[parent_flag] [char] (1) NOT NULL ,
		[guardian_flag] [char] (1) NOT NULL ,
		[guarantor_flag] [char] (1) NOT NULL ,
		[payor_flag] [char] (1) NOT NULL ,
		[created] [datetime] NOT NULL ,
		[created_by] [varchar] (24) NOT NULL ,
		[modified] [datetime] NULL ,
		[modified_by] [varchar] (24) NULL ,
		[status] [varchar] (8) NOT NULL ,
		[status_date] [datetime] NOT NULL ,
		[primary_decision_maker_flag] [char] (1) NOT NULL DEFAULT ('N') ,
		[relation_order] [int] NULL ,
		[attachment_id] [int] NULL )

AS
BEGIN

DECLARE @temp_relations TABLE (
	cpr_id varchar(12) NOT NULL,
	relation_sequence int NOT NULL,
	relation_cpr_id varchar(12) NOT NULL)

DECLARE @ll_rowcount int

-- Check for certain pre-defined relationship identifiers
IF @ps_relationship = 'Parent'
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT cpr_id ,
			relation_sequence ,
			relation_cpr_id
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND parent_flag = 'Y'
IF @ps_relationship = 'Mother'
	BEGIN
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT r.cpr_id ,
			r.relation_sequence ,
			r.relation_cpr_id
	FROM p_Patient_Relation r
		INNER JOIN p_Patient p
		ON r.relation_cpr_id = p.cpr_id
	WHERE r.cpr_id = @ps_cpr_id
	AND r.parent_flag = 'Y'
	AND p.sex = 'F'
	END
IF @ps_relationship = 'Father'
	BEGIN
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT r.cpr_id ,
			r.relation_sequence ,
			r.relation_cpr_id
	FROM p_Patient_Relation r
		INNER JOIN p_Patient p
		ON r.relation_cpr_id = p.cpr_id
	WHERE r.cpr_id = @ps_cpr_id
	AND r.parent_flag = 'Y'
	AND p.sex = 'M'
	END
ELSE IF @ps_relationship = 'Guardian'
	BEGIN
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT cpr_id ,
			relation_sequence ,
			relation_cpr_id
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND guardian_flag = 'Y'
	SET @ll_rowcount = @@ROWCOUNT
	IF @ll_rowcount = 0
		BEGIN
		-- If no relation is labeled "Guardian", see if a relation is labeled "Parent"
		INSERT INTO @temp_relations (
			cpr_id ,
			relation_sequence ,
			relation_cpr_id )
		SELECT cpr_id ,
				relation_sequence ,
				relation_cpr_id
		FROM p_Patient_Relation
		WHERE cpr_id = @ps_cpr_id
		AND parent_flag = 'Y'
		ORDER BY relation_order
		SET @ll_rowcount = @@ROWCOUNT
		END
	END
ELSE IF @ps_relationship = 'Primary Guardian'
	BEGIN
	-- First see if a relation is labeled primary-decision-maker
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT TOP 1 cpr_id ,
			relation_sequence ,
			relation_cpr_id
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND primary_decision_maker_flag = 'Y'
	ORDER BY relation_order
	SET @ll_rowcount = @@ROWCOUNT
	IF @ll_rowcount = 0
		BEGIN
		-- If no primary-decision-maker, see if a relation is labeled "Guardian"
		INSERT INTO @temp_relations (
			cpr_id ,
			relation_sequence ,
			relation_cpr_id )
		SELECT TOP 1 cpr_id ,
				relation_sequence ,
				relation_cpr_id
		FROM p_Patient_Relation
		WHERE cpr_id = @ps_cpr_id
		AND guardian_flag = 'Y'
		ORDER BY relation_order
		SET @ll_rowcount = @@ROWCOUNT
		IF @ll_rowcount = 0
			BEGIN
			-- If no relation is labeled "Guardian", see if a relation is labeled "Parent"
			INSERT INTO @temp_relations (
				cpr_id ,
				relation_sequence ,
				relation_cpr_id )
			SELECT TOP 1 cpr_id ,
					relation_sequence ,
					relation_cpr_id
			FROM p_Patient_Relation
			WHERE cpr_id = @ps_cpr_id
			AND parent_flag = 'Y'
			ORDER BY relation_order
			SET @ll_rowcount = @@ROWCOUNT
			END
		END
	END
ELSE IF @ps_relationship = 'Sibling'
	INSERT INTO @temp_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id )
	SELECT cpr_id ,
			relation_sequence ,
			relation_cpr_id
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND (maternal_sibling_flag = 'Y'
		OR paternal_sibling_flag = 'Y')

-- Finally get any relation that matches the relationship and hasn't already been got
INSERT INTO @temp_relations (
	cpr_id ,
	relation_sequence ,
	relation_cpr_id )
SELECT cpr_id ,
		relation_sequence ,
		relation_cpr_id
FROM p_Patient_Relation
WHERE cpr_id = @ps_cpr_id
AND relationship = @ps_relationship
AND relation_sequence NOT IN (SELECT relation_sequence FROM @temp_relations)

INSERT INTO @patient_relations (
		cpr_id ,
		relation_sequence ,
		relation_cpr_id ,
		relationship ,
		maternal_sibling_flag ,
		paternal_sibling_flag ,
		parent_flag ,
		guardian_flag ,
		guarantor_flag ,
		payor_flag ,
		created ,
		created_by ,
		modified ,
		modified_by ,
		status ,
		status_date ,
		primary_decision_maker_flag ,
		relation_order ,
		attachment_id )
SELECT r.cpr_id ,
		r.relation_sequence ,
		r.relation_cpr_id ,
		r.relationship ,
		r.maternal_sibling_flag ,
		r.paternal_sibling_flag ,
		r.parent_flag ,
		r.guardian_flag ,
		r.guarantor_flag ,
		r.payor_flag ,
		r.created ,
		r.created_by ,
		r.modified ,
		r.modified_by ,
		r.status ,
		r.status_date ,
		r.primary_decision_maker_flag ,
		r.relation_order ,
		r.attachment_id
FROM p_Patient_Relation r
	INNER JOIN @temp_relations x
	ON r.cpr_id = x.cpr_id
	AND r.relation_sequence = x.relation_sequence
ORDER BY r.relation_order

RETURN
END



GO
GRANT SELECT
	ON [dbo].[fn_patient_relations]
	TO [cprsystem]
GO

