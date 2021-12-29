
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[build_generic_equivalents]') AND [type]='P'))
	DROP PROCEDURE [dbo].[build_generic_equivalents]
GO

CREATE PROCEDURE build_generic_equivalents AS BEGIN

DECLARE @bn_rxcui varchar(20), @last_bn_rxcui varchar(20)
DECLARE @ingredient_name varchar(500), @generic_equiv varchar(900)
DECLARE @trial_count int, @trial_length int

-- Build generic equivalent relations of brand name multi ingredient drugs
DECLARE build_generic CURSOR FOR 
	SELECT bi.brand_name_rxcui, g.generic_name 
	FROM c_Drug_Brand_Ingredient bi
	JOIN c_Drug_Brand b ON b.brand_name_rxcui = bi.brand_name_rxcui
	JOIN c_Drug_Generic g ON g.generic_rxcui = bi.generic_rxcui_ingredient
	WHERE b.is_single_ingredient = 0
	AND b.generic_rxcui IS NULL
	ORDER BY bi.brand_name_rxcui, g.generic_name 

SET @generic_equiv = ''
SET @last_bn_rxcui = ''
OPEN build_generic  

FETCH NEXT FROM build_generic INTO @bn_rxcui, @ingredient_name
WHILE @@FETCH_STATUS = 0  
	BEGIN
		IF @bn_rxcui != @last_bn_rxcui AND @last_bn_rxcui != ''
			BEGIN
				UPDATE c_Drug_Brand 
				SET generic_rxcui = g.generic_rxcui
				FROM c_Drug_Generic g
				JOIN c_Drug_Brand b ON b.brand_name_rxcui = @last_bn_rxcui
				WHERE g.generic_name = @generic_equiv
				AND g.is_single_ingredient = 0

				SET @trial_count = @@ROWCOUNT

				IF @trial_count = 0
					BEGIN
						-- Single partial match?
						SET @trial_length = 12
						SELECT @trial_count = count(*) 
						FROM c_Drug_Generic
						WHERE generic_name LIKE LEFT(@generic_equiv,@trial_length) + '%'

						WHILE @trial_count > 1 AND @trial_length < len(@generic_equiv)
							BEGIN
							SET @trial_length = @trial_length + 12
							SELECT @trial_count = count(*) 
							FROM c_Drug_Generic
							WHERE generic_name LIKE LEFT(@generic_equiv,@trial_length) + '%'
							AND is_single_ingredient = 0
							END

						IF @trial_count = 1
							UPDATE c_Drug_Brand 
							SET generic_rxcui = g.generic_rxcui
							FROM c_Drug_Generic g
							JOIN c_Drug_Brand b ON b.brand_name_rxcui = @last_bn_rxcui
							WHERE g.generic_name LIKE LEFT(@generic_equiv,@trial_length)
							AND g.is_single_ingredient = 0

					END

				IF @trial_count = 0
					BEGIN
						-- Add a new generic; these will have to be cleaned up once in a while
						INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, is_single_ingredient)
						VALUES ('G' + @last_bn_rxcui, @generic_equiv, 0)

						UPDATE c_Drug_Brand 
						SET generic_rxcui = 'G' + @last_bn_rxcui
						WHERE brand_name_rxcui = @last_bn_rxcui
					END
			END

		IF @bn_rxcui != @last_bn_rxcui
			BEGIN
				SET @generic_equiv = @ingredient_name
				SET @last_bn_rxcui = @bn_rxcui
			END
		ELSE
			SET @generic_equiv = @generic_equiv + ' / ' + @ingredient_name

		FETCH NEXT FROM build_generic INTO @bn_rxcui, @ingredient_name
	END

-- pick up the last one
UPDATE c_Drug_Brand 
SET generic_rxcui = g.generic_rxcui
FROM c_Drug_Generic g
JOIN c_Drug_Brand b ON b.brand_name_rxcui = @bn_rxcui
WHERE g.generic_name = @generic_equiv
AND g.is_single_ingredient = 0

IF @@ROWCOUNT = 0
	BEGIN
		-- Add a new generic
		INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, is_single_ingredient)
		VALUES ('G' + @bn_rxcui, @generic_equiv, 0)

		UPDATE c_Drug_Brand 
		SET generic_rxcui = 'G' + @bn_rxcui
		WHERE brand_name_rxcui = @bn_rxcui
	END

CLOSE build_generic  
DEALLOCATE build_generic  

END
