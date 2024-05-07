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

-- Drop Procedure [dbo].[jmj_workplan_item_status]
Print 'Drop Procedure [dbo].[jmj_workplan_item_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_workplan_item_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_workplan_item_status]
GO

-- Create Procedure [dbo].[jmj_workplan_item_status]
Print 'Create Procedure [dbo].[jmj_workplan_item_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_workplan_item_status (
	@pl_patient_workplan_id int )

AS

DECLARE @wpitems TABLE (
	[level] [int] NOT NULL ,
	[step_number] [smallint] NULL ,
	[patient_workplan_id] [int] NULL ,
	[child_patient_workplan_id] [int] NULL ,
	[patient_workplan_item_id] [int] NULL ,
	[item_type] [varchar] (12) NOT NULL ,
	[description] [varchar] (80) NULL ,
	[child_workplan_status] [varchar] (12) NULL ,
	[item_status] [varchar] (12) NULL ,
	[owned_by] [varchar] (24) NULL ,
	[minutes] [int] NULL ,
	[insert_sequence] [int] IDENTITY(1,1) NOT NULL ,
	[workplan_id] [int] NULL
	)

DECLARE @ll_count int,
		@ll_level int

-- Don't allow for workplan_id = 0
IF @pl_patient_workplan_id = 0 OR @pl_patient_workplan_id IS NULL
	RETURN

SET @ll_level = 0

INSERT INTO @wpitems (
	level,
	child_patient_workplan_id,
	item_type,
	description,
	child_workplan_status,
	workplan_id)
SELECT @ll_level,
		patient_workplan_id,
		'Root',
		description,
		status,
		workplan_id
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SET @ll_Count = 1

WHILE @ll_count > 0
	BEGIN
	SET @ll_level = @ll_level + 1
	
	INSERT INTO @wpitems (
		level,
		step_number,
		patient_workplan_id,
		child_patient_workplan_id,
		patient_workplan_item_id,
		item_type,
		description,
		child_workplan_status,
		item_status,
		minutes,
		owned_by,
		workplan_id)
	SELECT @ll_level,
			i.step_number,
			i.patient_workplan_id,
			w.patient_workplan_id,
			i.patient_workplan_item_id,
			i.item_type,
			i.description,
			w.status,
			ISNULL(i.status, 'Pending'),
			DATEDIFF(minute, i.dispatch_date, dbo.get_client_datetime()) as minutes,
			i.owned_by,
			i.workplan_id
	FROM @wpitems t
		INNER JOIN p_Patient_WP_Item i
		ON t.child_patient_workplan_id = i.patient_workplan_id
		LEFT OUTER JOIN p_Patient_WP w
		ON i.patient_workplan_item_id = w.parent_patient_workplan_item_id
	WHERE t.level = @ll_level - 1
	AND ISNULL(i.status, 'Pending') NOT IN ('Skipped', 'Cancelled')
	AND (i.step_number > 0 OR t.workplan_id = 0) -- if it's a manual workplan then get all items
	ORDER BY i.patient_workplan_item_id
	
	SET @ll_count = @@ROWCOUNT

	END

-- Remove the parent records which have no children
DELETE t1
FROM @wpitems t1
WHERE t1.child_patient_workplan_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM @wpitems t2
	WHERE t1.child_patient_workplan_id = t2.patient_workplan_id
	AND t1.level = t2.level - 1 )

SELECT [level] ,
	[step_number] ,
	[patient_workplan_id] ,
	[child_patient_workplan_id] ,
	[patient_workplan_item_id] ,
	[item_type] ,
	[description] ,
	[child_workplan_status] ,
	[item_status] ,
	[owned_by] ,
	[minutes] ,
	[insert_sequence]  ,
	[workplan_id]
FROM @wpitems

GO
GRANT EXECUTE
	ON [dbo].[jmj_workplan_item_status]
	TO [cprsystem]
GO

