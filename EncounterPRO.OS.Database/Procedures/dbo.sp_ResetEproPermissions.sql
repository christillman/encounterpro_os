USE [EncounterPro_OS]
GO

/****** Object:  StoredProcedure [dbo].[sp_ResetEproPermissions]    Script Date: 17/07/2023 2:03:13 pm ******/
DROP PROCEDURE [dbo].[sp_ResetEproPermissions]
GO

/****** Object:  StoredProcedure [dbo].[sp_ResetEproPermissions]    Script Date: 17/07/2023 2:03:13 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[sp_ResetEproPermissions]
AS

DECLARE 
	 @object 	SYSNAME
	,@grantee	SYSNAME
	,@grantor	SYSNAME
	,@xtype		CHAR(2)
	,@command 	VARCHAR (256)
	,@error		INTEGER

-- First revoke all exisitng permissions. 

DECLARE c1 CURSOR LOCAL FAST_FORWARD
FOR
SELECT
	 o.xtype
	,o.name
	,u1.name AS grantee 
	,u2.name AS grantor
FROM syspermissions p
INNER JOIN sysobjects o
ON p.id = o.id
INNER JOIN sysusers u1
ON	u1.uid = p.grantee
INNER JOIN sysusers u2
ON	u2.uid = p.grantor
WHERE
(		  o.xtype = 'FN'
	OR	( o.xtype = 'V'  AND o.name NOT LIKE 'sys%' )
	OR	( o.xtype = 'U'  AND o.name LIKE '%__%' ESCAPE '_' )
	OR	( o.xtype = 'P'  AND o.name NOT LIKE 'dt%' )
)
ORDER BY
	 xtype
	,u1.name
	,o.name

SET @error = @@error
IF @error <> 0
	RETURN @error



-- Revoke statement privilges

REVOKE ALL FROM cprsystem

REVOKE ALL FROM PUBLIC

-- Revoke object priviliges

OPEN  c1

SET @error = @@error
IF @error <> 0
	RETURN @error

FETCH NEXT FROM c1
INTO
	 @xtype
	,@object
	,@grantee
	,@grantor

SET @error = @@error
IF @error <> 0
	RETURN @error

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @command = 'REVOKE ALL ON ' + @object + ' FROM ['

	EXEC ( @command + @grantee +']')

	SET @error = @@error
	IF @error <> 0
		RETURN @error

	FETCH NEXT FROM c1
	INTO
		 @xtype
		,@object
		,@grantee
		,@grantor

	SET @error = @@error
	IF @error <> 0
		RETURN @error
END

CLOSE c1

DEALLOCATE c1
	
-- Grant statement privileges

GRANT ALL TO cprsystem

SET @error = @@error
IF @error <> 0
	RETURN @error



-- Grant Object priviliges


DECLARE c2 CURSOR LOCAL FAST_FORWARD
FOR
SELECT
	 o.xtype
	,o.name
FROM  sysobjects o

WHERE
(		  o.xtype = 'FN'
	OR	( o.xtype = 'V'  AND o.name NOT LIKE 'sys%' )
	OR	( o.xtype = 'U'  AND o.name LIKE '%__%' ESCAPE '_' )
	OR	( o.xtype = 'P'  AND o.name NOT LIKE 'dt%' )
)
ORDER BY
	 xtype
	,o.name

SET @error = @@error
IF @error <> 0
	RETURN @error

set @grantee = 'cprsystem'

OPEN  c2

SET @error = @@error
IF @error <> 0
	RETURN @error

FETCH NEXT FROM c2
INTO
	 @xtype
	,@object

SET @error = @@error
IF @error <> 0
	RETURN @error

WHILE @@FETCH_STATUS = 0
BEGIN
	-- GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Vaccine] TO [cprsystem] 
	SET @command = 'GRANT ALL ON ' + @object + ' TO ' + @grantee

	EXEC ( @command )

	SET @error = @@error
	IF @error <> 0
		RETURN @error

	FETCH NEXT FROM c2
	INTO
		 @xtype
		,@object


	SET @error = @@error
	IF @error <> 0
		RETURN @error
END
CLOSE c2
DEALLOCATE c2

GO


