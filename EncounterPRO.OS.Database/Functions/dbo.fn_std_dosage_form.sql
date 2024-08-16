IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_std_dosage_form') AND type in (N'FN'))
DROP FUNCTION dbo.fn_std_dosage_form
GO

CREATE FUNCTION dbo.fn_std_dosage_form (@form_descr varchar(2000), @generic_descr varchar(2000))
RETURNS varchar(30) -- dosage_form 
AS BEGIN

DECLARE @dosage_form varchar(30)
DECLARE @matches int
DECLARE @g_descr varchar(2000)
DECLARE @f_descr varchar(2000)

-- Translate those where form descriptions use terminology different from dosage form description

SELECT TOP 1 @f_descr = REPLACE(@form_descr, term, alternate)
FROM c_Synonym 
WHERE @form_descr LIKE '%' + term + '%'
AND term_type = 'dosage_form'
ORDER BY LEN(alternate) desc, LEN(term) desc

IF @@rowcount = 0 SET @f_descr = @form_descr

SELECT TOP 1 @g_descr = REPLACE(CASE WHEN @generic_descr IS NULL THEN 'zzz' ELSE @generic_descr END, term, alternate)
FROM c_Synonym 
WHERE CASE WHEN @generic_descr IS NULL THEN 'zzz' ELSE @generic_descr END LIKE '%' + term + '%'
AND term_type = 'dosage_form'
ORDER BY LEN(alternate) desc, LEN(term) desc

IF @@rowcount = 0 SET @g_descr = CASE WHEN @generic_descr IS NULL THEN 'zzz' ELSE @generic_descr END

-- Insulin has special preference: instead of Inhalant Powder it should be Cartridge
IF @f_descr LIKE '%insulin%' OR @g_descr LIKE '%insulin%'
	BEGIN
	SET @f_descr = REPLACE(@f_descr, 'Inhalant Powder', 'Cartridge')
	SET @g_descr = REPLACE(@g_descr, 'Inhalant Powder', 'Cartridge')
	END

-- Some metered inhalers have metered elsewhere in the form descr
IF (@f_descr LIKE '%Inhaler%' AND @f_descr LIKE '%Metered%'
	AND @f_descr NOT LIKE '%Metered Dose Inhaler%')
	OR (@g_descr LIKE '%Inhaler%' AND @g_descr LIKE '%Metered%'
		AND @g_descr NOT LIKE '%Metered Dose Inhaler%')
	BEGIN
	SET @f_descr = REPLACE(@f_descr, 'Inhaler', 'Metered Dose Inhaler')
	SET @g_descr = REPLACE(@g_descr, 'Inhaler', 'Metered Dose Inhaler')
	END

SELECT @matches = count(*) 
	FROM c_Dosage_Form
	WHERE dosage_form NOT IN ('Oil', 'Pens') -- this gets misinterpreted within "oil of" and "suspension"
	AND (@g_descr LIKE '%' + [description] + '%'
		OR @f_descr LIKE '%' + [description] + '%')

IF @matches > 1
	-- Choose the longest match
	BEGIN
		WITH descrs AS (
			SELECT dosage_form, len([description]) AS leng 
			FROM c_Dosage_Form
			WHERE dosage_form NOT IN ('Oil', 'Pens') -- this gets misinterpreted within "oil of" and "suspension"
			AND (@g_descr LIKE '%' + [description] + '%'
				OR @f_descr LIKE '%' + [description] + '%')
			GROUP BY dosage_form, [description]
		)
		SELECT TOP 1 @dosage_form = dosage_form
		FROM descrs
		ORDER BY leng DESC, dosage_form
		RETURN @dosage_form
	END

IF @matches = 1 
	RETURN (SELECT dosage_form 
	FROM c_Dosage_Form
	WHERE dosage_form NOT IN ('Oil', 'Pens') -- this gets misinterpreted within "oil of" and "suspension"
	AND (@g_descr LIKE '%' + [description] + '%'
		OR @f_descr LIKE '%' + [description] + '%')
	)

SET @dosage_form = convert(varchar(30),@matches)

RETURN NULL --@dosage_form

END


GO
GRANT EXECUTE ON [dbo].[fn_std_dosage_form] TO [cprsystem]
GO
