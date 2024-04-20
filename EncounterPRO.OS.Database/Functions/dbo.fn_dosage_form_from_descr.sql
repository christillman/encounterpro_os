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
	DECLARE @dosage_form varchar(30)
	DECLARE @num_words integer
	SET @num_words = 4

	WHILE @num_words > 0 AND @dosage_form IS NULL
		BEGIN
			SELECT @dosage_form = dosage_form
			FROM c_Dosage_Form
			WHERE [description] = dbo.fn_last_words(@description,@num_words)

			IF @dosage_form IS NULL
				SET @num_words = @num_words - 1
		END

	IF @dosage_form IS NULL
		RETURN 'Not Found'

	RETURN @dosage_form
END

-- select dbo.fn_dosage_form_from_descr ('one two three four five')



GO
GRANT EXECUTE ON [dbo].[fn_dosage_form_from_descr] TO [cprsystem]
GO
