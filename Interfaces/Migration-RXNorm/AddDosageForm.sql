
UPDATE c_Drug_Formulation SET 
	RXN_available_strength = NULL, 
	dosage_form = NULL, 
	dose_amount = NULL, 
	dose_unit = NULL

UPDATE f
SET RXN_available_strength = a.ATV
FROM c_Drug_Formulation f
JOIN interfaces..rxnsat a on a.rxcui = f.form_rxcui
where a.ATN = 'RXN_AVAILABLE_STRENGTH'
-- 20708

UPDATE f
SET dosage_form = d.dosage_form
FROM c_Drug_Formulation f
JOIN interfaces..rxnrel r ON r.RXCUI2 = f.form_RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN c_Dosage_Form d ON d.rxcui = c1.RXCUI
WHERE r.rela = 'has_dose_form'
AND c1.TTY = 'DF'
AND c1.SAB = 'RXNORM' 
-- (20734 row(s) affected)

-- Kenya drugs

UPDATE f
SET dosage_form = d.dosage_form
FROM c_Drug_Formulation f
JOIN c_Dosage_Form d ON d.rxcui = dbo.fn_dosage_form_from_descr (form_descr)
WHERE f.dosage_form IS NULL
-- 1199


UPDATE f
SET dosage_form = CASE 
	WHEN form_descr LIKE '%Oral Caplet%' THEN 'Caplets'
	WHEN form_descr LIKE '%Dispersible%' THEN 'DisOral Tab'
	WHEN form_descr LIKE '%Vaginal Pessary%' THEN 'Vaginal Ring'
	WHEN form_descr LIKE '%Vaginal Capsule%' THEN 'Vaginal Tablet'
	WHEN form_descr LIKE '%Metered Dose Inhaler%' OR form_descr LIKE '%HFA Inhaler%' THEN 'Metered Inhaler'
	WHEN form_descr LIKE '%Dry Powder Inhaler%' THEN 'DryPwdrInhaler'
	WHEN form_descr LIKE '%Inhalation Powder%' OR form_descr LIKE '%Inhalant Powder%' THEN 'Inhalant Powder'
	WHEN form_descr LIKE '%Solution for Injection%' OR form_descr LIKE '%Injection Solution%' THEN 'Injectable Soln'
	WHEN form_descr LIKE '%Suspension for Injection%' THEN 'Injectable Susp'
	WHEN form_descr LIKE '%Dry Powder Inhaler%' THEN 'DryPwdrInhaler'
	WHEN form_descr LIKE '% Syrup%' OR form_descr LIKE '% Elixir%' THEN 'Syrup'
	WHEN form_descr LIKE '% Patch%' THEN 'Patch'
	WHEN form_descr LIKE '%Eye Drops%' THEN 'Eye Drops'
	WHEN form_descr LIKE '%Eye Suspension%' THEN 'Ophthalmic Susp'
	WHEN form_descr LIKE '%Ophthalmic Solution%' THEN 'Ophthalmic Soln'
	WHEN form_descr LIKE '%Opthalmic Solution%' THEN 'Ophthalmic Soln'
	WHEN form_descr LIKE '%Ear Suspension%' THEN 'Otic Suspension'
	WHEN form_descr LIKE '%Otic Drops%' THEN 'Drops Ear'
	WHEN form_descr LIKE '%Eye Ointment%' THEN 'Ophthalmic Oint'
	WHEN form_descr LIKE '%Oral Suspension%' THEN 'Oral Suspension'
	WHEN form_descr LIKE '%Effervescent%' THEN 'Effervescent'
	WHEN form_descr LIKE '%Inhalation Solution%' THEN 'Inhalant Soln'
	WHEN form_descr LIKE '%Respirator Solution%' THEN 'Inhalant Soln'
	WHEN form_descr LIKE '%Accuhaler%' OR form_descr LIKE '%Turbuhaler%' THEN 'Metered Inhaler'
	WHEN form_descr LIKE '% Tablet%' THEN 'Tab'
	WHEN form_descr LIKE '% Capsule%' THEN 'Cap'
	WHEN form_descr LIKE '% Retard%' THEN 'SR Caps'
	WHEN form_descr LIKE '%Neonatal Drops%' THEN 'Drops Or'
	WHEN form_descr LIKE '%Organogel%' THEN 'Rectal Gel'
	END
FROM c_Drug_Formulation f
WHERE f.dosage_form IS NULL
-- (172 row(s) affected)


-- Populate dose columns

DECLARE @pat varchar(100), @pre varchar(20), @post varchar(20), @all varchar(100)
DECLARE @cnt int
SET @cnt = 1
SET @pre = '% '
SET @pat = '[0-9]'
SET @post = ' MG[ /]%'
SET @all = @pre + @pat + @post
WHILE @cnt < 8
	BEGIN
		print @all
		UPDATE c_Drug_Formulation
		SET dose_amount = convert(real, left(substring(form_descr, patindex(@all, form_descr), @cnt + 4),@cnt + 2)),
			dose_unit = 'MG'
		WHERE dose_amount is null and dose_unit is null
		AND form_descr not like '% / %'
		AND patindex(@all, form_descr) > 0 

		SET @cnt = @cnt + 1
		SET @pat = @pat + '[0-9.]'
		SET @all = @pre + @pat + @post
	END


DECLARE @pat varchar(100), @pre varchar(20), @post varchar(20), @all varchar(100)
DECLARE @cnt int
SET @cnt = 1
SET @pre = '% '
SET @pat = '[0-9]'
SET @post = ' GM[ /]%'
SET @all = @pre + @pat + @post
WHILE @cnt < 8
	BEGIN
		print @all
		UPDATE c_Drug_Formulation
		SET dose_amount = convert(real, left(substring(form_descr, patindex(@all, form_descr), @cnt + 4),@cnt + 2)),
			dose_unit = 'GM'
		WHERE dose_amount is null and dose_unit is null
		AND form_descr not like '% / %'
		AND patindex(@all, form_descr) > 0 

		SET @cnt = @cnt + 1
		SET @pat = @pat + '[0-9.]'
		SET @all = @pre + @pat + @post
	END


DECLARE @pat varchar(100), @pre varchar(20), @post varchar(20), @all varchar(100)
DECLARE @cnt int
SET @cnt = 1
SET @pre = '% '
SET @pat = '[0-9]'
SET @post = ' \%[ /]%'
SET @all = @pre + @pat + @post
WHILE @cnt < 8
	BEGIN
		print @all
		UPDATE c_Drug_Formulation
		SET dose_amount = convert(real, left(substring(form_descr, patindex(@all, form_descr), @cnt + 4),@cnt + 2)),
			dose_unit = 'GM'
		WHERE dose_amount is null and dose_unit is null
		AND form_descr not like '% / %'
		AND patindex(@all, form_descr) > 0 

		SET @cnt = @cnt + 1
		SET @pat = @pat + '[0-9.]'
		SET @all = @pre + @pat + @post
	END

UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9] _ %', form_descr), 4),2)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9] \% %' ESCAPE '\'

UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9]_ %', form_descr), 4),2)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9]\% %' ESCAPE '\'

UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9][0-9] _ %', form_descr), 5),3)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9][0-9] \% %' ESCAPE '\'


UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9].[0-9] _ %', form_descr), 6),4)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9].[0-9] \% %' ESCAPE '\'

UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9].[0-9]_ %', form_descr), 6),4)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9].[0-9]\% %' ESCAPE '\'


UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9][0-9].[0-9] _ %', form_descr), 7),5)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9][0-9].[0-9] \% %' ESCAPE '\'


UPDATE c_Drug_Formulation
SET dose_amount = convert(real, left(substring(form_descr, patindex('% [0-9].[0-9][0-9] _ %', form_descr), 7),5)),
	dose_unit = '%'
from c_Drug_Formulation
where dose_amount is null and dose_unit is null
and form_descr not like '% / %'
and form_descr like '% [0-9].[0-9][0-9] \% %' ESCAPE '\'


UPDATE c_Drug_Formulation 
SET dose_amount = dose_amount * 1000, dose_unit = 'MCG'
WHERE dose_unit = 'MG' and form_descr like '% MCG%'
-- (358 row(s) affected)

UPDATE c_Drug_Formulation 
SET dose_amount = dose_amount / 1000.0, dose_unit = 'GM'
WHERE dose_unit = 'MG' and form_descr like '% GM%'
-- (215 row(s) affected)