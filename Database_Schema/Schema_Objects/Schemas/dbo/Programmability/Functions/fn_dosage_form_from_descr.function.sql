Print 'Drop Function dbo.fn_dosage_form_from_descr'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.fn_dosage_form_from_descr') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_dosage_form_from_descr
go
Print 'Create Function dbo.fn_dosage_form_from_descr'
GO

CREATE FUNCTION dbo.fn_dosage_form_from_descr (@description varchar(1000))
RETURNS varchar(1000)
AS BEGIN
	DECLARE @rxcui varchar(20)
	DECLARE @num_words integer
	SET @num_words = 4

	WHILE @num_words > 0 AND @rxcui IS NULL
		BEGIN
			SELECT @rxcui = rxcui
			FROM c_Dosage_Form
			WHERE rxcui IS NOT NULL
			AND [description] = dbo.fn_last_words(@description,@num_words)

			IF @rxcui IS NULL
				SET @num_words = @num_words - 1
		END

	IF @rxcui IS NULL
		RETURN 'Not Found'

	RETURN @rxcui
END

-- select dbo.fn_dosage_form_from_descr ('one two three four five')