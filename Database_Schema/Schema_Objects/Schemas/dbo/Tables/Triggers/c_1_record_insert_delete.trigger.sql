CREATE TRIGGER c_1_record_insert_delete ON c_1_record
FOR
	 INSERT
	,DELETE
AS
	IF (SELECT count(*) FROM c_1_record) <> 1
	BEGIN
		RAISERROR ( 'One Record Required', 16, 1 )
		ROLLBACK TRAN
	END
