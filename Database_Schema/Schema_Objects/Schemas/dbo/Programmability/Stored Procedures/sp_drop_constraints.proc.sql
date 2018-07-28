CREATE PROCEDURE sp_drop_constraints (
	@ps_table varchar(64),
	@pb_keep_triggers bit = 1 )
AS

-- MSC changed default keep_triggers to 1 because most common usage is to rebuild the constraints only
-- and we don't want to remove the triggers unless the caller explicitely requests that.

--- Drop All Constraints Which Reference table
DECLARE @ConstraintName sysname,
	@TableName sysname,
	@IndexName sysname,
	@IndexString nvarchar (357)

DECLARE lc_other_constraint CURSOR LOCAL FAST_FORWARD FOR
	select soct.name, soc.name
	from sysreferences sr WITH (NOLOCK),
		sysobjects soc WITH (NOLOCK),
		sysobjects sort WITH (NOLOCK), 
		sysobjects soct WITH (NOLOCK), 
		sysconstraints sc WITH (NOLOCK)
	where sc.constid  = sr.constid
	and sc.id = soct.id
	and sc.constid = soc.id
	and sr.rkeyid = sort.id
	and sort.name = @ps_table
OPEN lc_other_constraint
FETCH NEXT FROM lc_other_constraint INTO @TableName, @ConstraintName
WHILE (@@fetch_status = 0)
BEGIN
	EXEC ('ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName)
	FETCH NEXT FROM lc_other_constraint INTO @TableName, @ConstraintName
END
DEALLOCATE lc_other_constraint


--- Drop All Constraints on table itself
/* DROP Foreign Key Constraints First*/
DECLARE lc_constraint CURSOR LOCAL FAST_FORWARD FOR
	select so.name
	from sysconstraints sc WITH (NOLOCK)
		LEFT OUTER JOIN sysreferences sr WITH (NOLOCK)
		ON sc.constid = sr.constid
		INNER JOIN sysobjects so WITH (NOLOCK)
		ON sc.constid = so.id
		INNER JOIN sysobjects so2 WITH (NOLOCK)
		ON sc.id = so2.id
	where so2.name = @ps_table
	order by isnull(sr.fkeyid,0) desc
OPEN lc_constraint
FETCH NEXT FROM lc_constraint INTO @ConstraintName
WHILE (@@fetch_status = 0)
BEGIN
	EXEC ('ALTER TABLE ' + @ps_table + ' DROP CONSTRAINT ' + @ConstraintName)
	FETCH NEXT FROM lc_constraint INTO @ConstraintName
END
DEALLOCATE lc_constraint


IF @pb_keep_triggers = 0
	BEGIN
	-- Drop triggers
	DECLARE @Trigger sysname
	DECLARE lc_triggers CURSOR FOR
		select o.name
		from sysobjects o WITH (NOLOCK), 
			sysobjects d WITH (NOLOCK)
		where o.type = 'TR'
		and d.type = 'U'
		and o.deltrig = d.id
		and d.name = @ps_table
	OPEN lc_triggers
	FETCH NEXT FROM lc_triggers INTO @Trigger
	WHILE (@@fetch_status = 0)
	BEGIN
		IF EXISTS (	SELECT *
				FROM sysobjects WITH (NOLOCK)
				WHERE id = object_id(@Trigger)
				AND sysstat & 0xf = 8
				)
		BEGIN
			EXEC ('DROP TRIGGER ' + @Trigger)
		END
		FETCH NEXT FROM lc_triggers INTO @Trigger
	END
	DEALLOCATE lc_triggers
	END

-- Drop simple indexes

DECLARE lc_indexes CURSOR FOR
SELECT
	 si.name
FROM
	 sysindexes si WITH (NOLOCK)
	,sysobjects so WITH (NOLOCK)
WHERE
	so.id = si.id
AND	so.xtype = 'U'
AND	si.indid BETWEEN 1 and 254
AND 	si.name NOT LIKE '/_WA/_Sys/_%' ESCAPE '/'
AND	so.name = @ps_table
ORDER BY
	si.name

OPEN lc_indexes

FETCH NEXT FROM lc_indexes INTO @IndexName

WHILE (@@fetch_status = 0)
BEGIN
	SET @IndexString = 'DROP INDEX '+ @ps_table + '.' + @IndexName

	EXEC ( @IndexString )

	FETCH NEXT FROM lc_indexes INTO @IndexName
END

DEALLOCATE lc_indexes
