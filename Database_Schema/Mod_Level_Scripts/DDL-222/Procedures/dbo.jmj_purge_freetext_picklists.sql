
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
	INNER JOIN (SELECT [user_id] ,
						top_20_code ,
						min(item_index) as first_item_index,
						max(item_index) as last_item_index
				FROM @listitems
				GROUP BY [user_id] ,
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

