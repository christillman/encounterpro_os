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

-- Drop Procedure [dbo].[jmj_purge_freetext_picklists]
Print 'Drop Procedure [dbo].[jmj_purge_freetext_picklists]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_purge_freetext_picklists]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_purge_freetext_picklists]
GO

-- Create Procedure [dbo].[jmj_purge_freetext_picklists]
Print 'Create Procedure [dbo].[jmj_purge_freetext_picklists]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_purge_freetext_picklists
AS

DECLARE @ls_purge varchar(12),
		@ls_keep varchar(12),
		@ll_keep_count int

SET @ls_purge = dbo.fn_get_preference ('PREFERENCES', 'Purge Recent Picks', NULL, 0)
IF @ls_purge IS NULL OR LEFT(@ls_purge, 1) NOT IN ('T', 'Y')
	RETURN

SET @ls_keep = dbo.fn_get_preference ('PREFERENCES', 'Purge Recent Picks Keep', NULL, 0)

IF ISNUMERIC(@ls_keep) = 1
	SET @ll_keep_count = CAST(@ls_keep AS int)
ELSE
	SET @ll_keep_count = 30

DECLARE @lists TABLE (
	user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	first_item_index int NULL)

DECLARE @listitems TABLE (
	user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	top_20_sequence int NOT NULL,
	hits int NOT NULL,
	last_hit datetime NOT NULL,
	item_index int IDENTITY (1, 1) NOT NULL )

DECLARE @purgelists TABLE (
	user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	first_item_index int NOT NULL)

DECLARE @purgelistitems TABLE (
	user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	top_20_sequence int NOT NULL,
	purge_flag bit NOT NULL,
	item_index int NOT NULL)


INSERT INTO @lists (
	user_id,
	top_20_code)
SELECT DISTINCT user_id,
				top_20_code
FROM u_Top_20 WITH (NOLOCK)
WHERE hits > 0

INSERT INTO @listitems (
	user_id ,
	top_20_code ,
	top_20_sequence ,
	hits ,
	last_hit)
SELECT u.user_id ,
	u.top_20_code ,
	u.top_20_sequence ,
	ISNULL(u.hits, 0) ,
	ISNULL(u.last_hit, CAST('1/1/1900' AS datetime))
FROM @lists x
	INNER JOIN u_top_20 u WITH (NOLOCK)
	ON x.user_id = u.user_id
	AND x.top_20_code = u.top_20_code
ORDER BY u.user_id ,
	u.top_20_code ,
	u.hits desc ,
	u.last_hit desc

UPDATE l
SET first_item_index = x.first_item_index
FROM @lists l
	INNER JOIN (SELECT user_id ,
						top_20_code ,
						min(item_index) as first_item_index,
						max(item_index) as last_item_index
				FROM @listitems
				GROUP BY user_id ,
						top_20_code) x
	ON l.user_id = x.user_id
	AND l.top_20_code = x.top_20_code
WHERE x.last_item_index > x.first_item_index + @ll_keep_count

-- Build new lists to hold the purge lists/items because that's
-- much more efficient than deleting or joining with a sparse temp table
INSERT INTO @purgelists (
	user_id,
	top_20_code,
	first_item_index)
SELECT user_id,
		top_20_code,
		first_item_index
FROM @lists
WHERE first_item_index IS NOT NULL

INSERT INTO @purgelistitems (
	user_id,
	top_20_code,
	top_20_sequence,
	purge_flag,
	item_index)
SELECT i.user_id,
		i.top_20_code,
		i.top_20_sequence,
		CASE WHEN i.item_index > l.first_item_index + @ll_keep_count THEN 1 ELSE 0 END,
		i.item_index
FROM @listitems i
	INNER JOIN @lists l
	ON l.user_id = i.user_id
	AND l.top_20_code = i.top_20_code
WHERE l.first_item_index IS NOT NULL

-- Hold locks until we're done
BEGIN TRANSACTION

-- Delete the items that aren't high enough in the list
DELETE u
FROM u_top_20 u WITH (TABLOCKX)
	INNER JOIN @purgelistitems i
	ON i.user_id = u.user_id
	AND i.top_20_code = u.top_20_code
	AND i.top_20_sequence = u.top_20_sequence
WHERE i.purge_flag = 1

-- Scale back the hits so that it's not impossible for a new frequent item to climb up the list
UPDATE u
SET hits = (i.item_index - l.first_item_index + 1) * 2
FROM u_top_20 u
	INNER JOIN @purgelistitems i
	ON i.user_id = u.user_id
	AND i.top_20_code = u.top_20_code
	AND i.top_20_sequence = u.top_20_sequence
	INNER JOIN @purgelists l
	ON l.user_id = u.user_id
	AND l.top_20_code = u.top_20_code
WHERE i.purge_flag = 0

COMMIT TRANSACTION
GO
GRANT EXECUTE
	ON [dbo].[jmj_purge_freetext_picklists]
	TO [cprsystem]
GO

