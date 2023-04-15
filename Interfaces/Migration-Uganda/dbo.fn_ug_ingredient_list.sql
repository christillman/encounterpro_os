IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_ug_ingredient_list') AND type in (N'TF'))
DROP FUNCTION dbo.fn_ug_ingredient_list
GO

CREATE FUNCTION dbo.fn_ug_ingredient_list (@ingredients varchar(1000), @strengths varchar(1000))
RETURNS @t TABLE(sort_order int, ingredient varchar(1000), strength varchar(1000))
AS 
BEGIN
	DECLARE @next_slash_ingr int, @index int
	DECLARE @next_digit_strg int, @nds1 int, @nds2 int
	DECLARE @ingr_left varchar(1000), @strg_left varchar(1000)
	DECLARE @per varchar(1000) = ''
	SET @ingr_left = @ingredients
	SET @strg_left = REPLACE(REPLACE(REPLACE(@strengths,' ML','ML'),'M G','MG'),'M L','ML')
	-- PER usually comes at the end, applying to all listed strengths
	IF charindex('PER',@strg_left) > 0
		BEGIN 
		SET @per = ' ' + substring(@strg_left,charindex('PER',@strg_left),1000)
		SET @strg_left = LEFT(@strg_left,charindex('PER',@strg_left) - 1)
		END
	IF patindex('%)/%ML',@strg_left) > 0
		BEGIN 
		SET @per = substring(@strg_left,patindex('%)/%ML',@strg_left) + 1,1000)
		SET @strg_left = REPLACE(LEFT(@strg_left,patindex('%)/%ML',@strg_left) - 1),'(','')
		END
	SET @index = 1
	SET @next_slash_ingr = charindex('/', @ingr_left)
	SET @nds1 = patindex('%/[0-9]%', @strg_left)
	SET @nds2 = patindex('%/ [0-9]%', @strg_left)
	IF @nds1 = 0 
		SET @next_digit_strg = @nds2
	ELSE IF @nds2 = 0
		SET @next_digit_strg = @nds1
	ELSE IF @nds2 >= @nds1
		SET @next_digit_strg = @nds1
	ELSE 
		SET @next_digit_strg = @nds2
	WHILE @next_digit_strg > 0 AND @next_slash_ingr > 0
		BEGIN
		INSERT INTO @t VALUES (
			@index,
			CASE WHEN LTRIM(RTRIM(LEFT(@ingr_left, @next_slash_ingr-1))) LIKE 'VITAMIN %' 
					THEN 'vitamin ' + SUBSTRING(LTRIM(RTRIM(LEFT(@ingr_left, @next_slash_ingr-1))), 9, 100)
				ELSE LOWER(LTRIM(RTRIM(LEFT(@ingr_left, @next_slash_ingr-1))))
				END, 
			REPLACE(REPLACE(
				LTRIM(RTRIM(REPLACE(LEFT(@strg_left, @next_digit_strg-1),'/','')))
				,'MG',' MG'),'  ',' ') + @per
			)
		SET @ingr_left = LTRIM(SUBSTRING(@ingr_left, @next_slash_ingr+1, 1000))
		SET @strg_left = LTRIM(SUBSTRING(@strg_left, @next_digit_strg+1, 1000))
		SET @next_slash_ingr = charindex('/', @ingr_left)

		-- Correct if xxML has been separated from parent
		IF patindex('%[0-9]ML%/%M%', @strg_left) > 0
			IF patindex('%[0-9]ML%/%M%', @strg_left) < charindex('/', @strg_left)
				BEGIN
				SET @next_digit_strg = patindex('%[0-9]ML%/%M%', @strg_left)
				UPDATE @t SET strength = strength + '/' 
					+ LEFT(@strg_left,@next_digit_strg + 2)
				WHERE sort_order = @index
				SET @strg_left = substring(@strg_left,charindex('/', @strg_left) + 1,1000)
				END

		SET @nds1 = patindex('%/[0-9]%', @strg_left)
		SET @nds2 = patindex('%/ [0-9]%', @strg_left)
		IF @nds1 = 0 
			SET @next_digit_strg = @nds2
		ELSE IF @nds2 = 0
			SET @next_digit_strg = @nds1
		ELSE IF @nds2 >= @nds1
			SET @next_digit_strg = @nds1
		ELSE 
			SET @next_digit_strg = @nds2
		SET @index = @index + 1
		END
	INSERT INTO @t VALUES (
		@index,
		CASE WHEN LTRIM(RTRIM(@ingr_left)) LIKE 'VITAMIN %' 
				THEN 'vitamin ' + SUBSTRING(LTRIM(RTRIM(@ingr_left)), 9, 1)
					  + SUBSTRING(LOWER(LTRIM(RTRIM(@ingr_left))), 10, 100)
			ELSE LOWER(LTRIM(RTRIM(@ingr_left)))
			END, 
		REPLACE(REPLACE(LTRIM(RTRIM(@strg_left)),'MG',' MG'),'  ',' ') + @per
		)

	UPDATE @t SET ingredient = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
		ingredient, ' CREAM',''),
		' CAPSULES',''),
		' GEL',''),
		' INFUSION',''),
		' INTRAVENOUS',''),
		' SOLUTION',''),
		' TABLETS',''),
		' TABLET','')
	WHERE ingredient LIKE '% CREAM%'
		OR ingredient LIKE '% CAPSULES%'
		OR ingredient LIKE '% GEL%'
		OR ingredient LIKE '% INFUSION%'
		OR ingredient LIKE '% INTRAVENOUS%'
		OR ingredient LIKE '% SOLUTION%'
		OR ingredient LIKE '% TABLET%'

	UPDATE @t SET ingredient = 'alginic acid' 
	WHERE ingredient = 'alginic'
	UPDATE @t SET ingredient = 'folic acid' 
	WHERE ingredient = 'folic aci'
	UPDATE @t SET ingredient = 'polymyxin B' 
	WHERE ingredient = 'polymyxin b'
	UPDATE @t SET ingredient = 'tenofovir disoproxil' 
	WHERE ingredient IN ('tenofovir', 'tenofovir df')

	RETURN
END
/*

select *
from dbo.fn_ug_ingredient_list('GUAIFENESIN / PSEUDOEPHEDRINE / TRIPROLIDINE','1.25MG / 30MG / 100MG')

select *
from dbo.fn_ug_ingredient_list('PSEUDOEPHEDRINE / GUAIFENESIN / TRIPROLIDINE','30MG / 1.25MG / 100MG')

*/
