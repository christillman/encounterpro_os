
Print 'Drop Trigger [dbo].[tr_o_Office_insert_delete]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_Office_insert_delete]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_Office_insert_delete]
GO

DELETE FROM o_Office
WHERE office_id != (SELECT min(office_id) FROM o_Office)

Print 'Create Trigger [dbo].[tr_o_Office_insert_delete]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_Office_insert_delete ON o_Office
FOR
	 INSERT
	,DELETE
AS
	IF (SELECT count(*) FROM o_Office) <> 1
	BEGIN
		RAISERROR ( 'One Record Required in o_Office; only UPDATE is allowed', 16, 1 )
		ROLLBACK TRAN
	END
GO

