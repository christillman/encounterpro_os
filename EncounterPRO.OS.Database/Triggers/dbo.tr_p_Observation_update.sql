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

-- Drop Trigger [dbo].[tr_p_Observation_update]
Print 'Drop Trigger [dbo].[tr_p_Observation_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_Observation_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_Observation_update]
GO

-- Create Trigger [dbo].[tr_p_Observation_update]
Print 'Create Trigger [dbo].[tr_p_Observation_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_Observation_update ON dbo.p_Observation
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @obs TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	parent_observation_sequence int NULL,
	abnormal_flag char(1) NULL,
	severity smallint NULL,
	parent_level int NOT NULL )

DECLARE @ll_rowcount int,
		@ll_parent_level int

-- If the abnormal_flag or severity is updated then bubble the values all the way up through the observation tree
IF UPDATE (abnormal_flag) OR UPDATE (severity)
	BEGIN
	SET @ll_rowcount = 1
	SET @ll_parent_level = 1

	INSERT INTO @obs (
		cpr_id ,
		observation_sequence ,
		parent_observation_sequence,
		abnormal_flag,
		severity,
		parent_level )
	SELECT cpr_id ,
		observation_sequence ,
		parent_observation_sequence ,
		abnormal_flag ,
		severity ,
		@ll_parent_level
	FROM inserted


	WHILE @ll_rowcount > 0
		BEGIN
		UPDATE o
		SET abnormal_flag = CASE WHEN o.abnormal_flag = 'Y' OR x.abnormal_flag = 'Y' THEN 'Y' ELSE 'N' END,
			severity = CASE WHEN o.severity < x.severity THEN x.severity ELSE o.severity END
		FROM p_Observation o
			INNER JOIN @obs x
			ON o.cpr_id = x.cpr_id
			AND o.observation_sequence = x.parent_observation_sequence
		WHERE x.parent_level = @ll_parent_level


		INSERT INTO @obs (
			cpr_id ,
			observation_sequence ,
			parent_observation_sequence,
			abnormal_flag,
			severity,
			parent_level )
		SELECT o.cpr_id ,
			o.observation_sequence ,
			o.parent_observation_sequence ,
			o.abnormal_flag,
			o.severity,
			@ll_parent_level + 1
		FROM @obs x
			INNER JOIN p_Observation o
			ON x.cpr_id = o.cpr_id
			AND x.parent_observation_sequence = o.observation_sequence
		WHERE x.parent_level = @ll_parent_level
		
		SET @ll_rowcount = @@ROWCOUNT
		SET @ll_parent_level = @ll_parent_level + 1
		END
	END

GO

