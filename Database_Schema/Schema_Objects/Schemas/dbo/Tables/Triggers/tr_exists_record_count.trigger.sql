CREATE TRIGGER tr_exists_record_count ON c_1_record
FOR
	 INSERT
	,DELETE
AS
	IF (SELECT count(*) FROM c_1_record) <> 1
	BEGIN
		RAISERROR ( 'One Record Required', 16, 1 )
		ROLLBACK TRAN
	END