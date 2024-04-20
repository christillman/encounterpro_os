IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_std_dose_unit') AND type in (N'FN'))
DROP FUNCTION dbo.fn_std_dose_unit
GO

CREATE FUNCTION dbo.fn_std_dose_unit (@dosage_form varchar(30), @form_descr varchar(2000), @generic_descr varchar(2000))
RETURNS varchar(30) -- dose_unit 
AS BEGIN
RETURN 
CASE

-- Heparin and Insulin should be UNIT
WHEN @form_descr like '%heparin%'
	and @form_descr like '%injection%'
	THEN 'UNIT'
	
WHEN (@form_descr like '%insulin%' 
	OR IsNull(@generic_descr,@form_descr) like '%insulin%')
	THEN 'UNIT'
	
WHEN @dosage_form like ('%implant%')
	THEN 'IMPL'
	
WHEN @dosage_form IN ('Vaginal Foam', 'Vaginal Oint', 'Vag Gel')
	THEN 'APPLICATOR'

WHEN @dosage_form IN ('Vaginal Ring')
	THEN 'DEVI'

-- exceptions for tablet and capsule
WHEN (@dosage_form like 'vag%'
		or @form_descr like '%vaginal%'
		or ISNULL(@generic_descr, @form_descr)  like '%vaginal%')
	and @form_descr not like '%implant%'
	and ISNULL(@generic_descr, @form_descr) not like '%implant%'
	and (@form_descr like '%tablet%'
	or @form_descr  like '%capsule%'
	or @form_descr  like '%ovule%'
	or @form_descr  like '%suppository%'
	or @form_descr  like '%pessary%'
	or @form_descr  like '%insert%'
	or ISNULL(@generic_descr, @form_descr) like '%tablet%'
	or ISNULL(@generic_descr, @form_descr)  like '%capsule%'
	or ISNULL(@generic_descr, @form_descr)  like '%ovule%'
	or ISNULL(@generic_descr, @form_descr)  like '%suppository%'
	or ISNULL(@generic_descr, @form_descr)  like '%pessary%'
	or ISNULL(@generic_descr, @form_descr)  like '%insert%') 
	THEN 'INSERT'

WHEN @dosage_form like '%cap%'
	THEN 'CAP'

WHEN @dosage_form like '%tab%' 
	AND @dosage_form NOT like '%injectable%' 
	THEN 'TAB'
	 
WHEN @dosage_form = 'Enema' 
	THEN CASE WHEN @form_descr like '%197 ml%' 
	  or @form_descr like '%118 ml%' 
	  or @form_descr like '%30 ml%' 
	  or @form_descr like '%59 ml%' 
	  or @form_descr like '%60 ml%'
	THEN 'BOTTLE' ELSE 'ENEMA' END

WHEN @dosage_form IN ('GranuleOralSusp')
	THEN CASE WHEN ISNULL(@generic_descr, @form_descr) LIKE 'ML' THEN 'mL'
		ELSE 'PACKE' END

WHEN @form_descr like '%granules for oral solution%'
		and @form_descr like '%GM%'
		and @form_descr not like '%MG%'
	THEN 'TSP'

WHEN @dosage_form like ('%Granule%')
	THEN 'PACKE'
	
WHEN @dosage_form = 'Inhalant Powder'
	THEN 'CAP'

WHEN @dosage_form = 'Susp'
	THEN CASE WHEN @form_descr like '%enteral%' THEN 'mL'
		ELSE 'APPLY' END
		
WHEN @dosage_form = 'Oral Gel'
	THEN 'APPLY'

WHEN @dosage_form = 'Oral Solution'
	THEN CASE WHEN @form_descr like '%MG%' 
		AND @form_descr NOT like '%ML%' THEN 'mG'
	WHEN @form_descr like '%DROPS%' THEN 'DROP'
	ELSE 'mL' END

WHEN @dosage_form = 'Oral Suspension'
	THEN CASE WHEN @form_descr like '%DROPS%'
			AND @form_descr NOT like '%lozenge%'
			THEN 'DROP' 
		WHEN @form_descr like '%UNT%' OR @form_descr like '%UNITS%'
			THEN 'UNIT'
		ELSE 'mL' END
		
WHEN @dosage_form IN ('MucousMemSoln')
	THEN CASE WHEN @form_descr like '%mouth paint%' THEN 'DROP'
	ELSE 'mL' END

WHEN @dosage_form IN ('Nasal Gel')
	AND @form_descr like '%ACTUAT%'
	THEN 'ACTUATNOSTRIL'

WHEN @dosage_form IN ('Pen Injector')
	-- insulin handled above
	THEN CASE WHEN @form_descr like '%UNT%' THEN 'UNIT' 
		WHEN @form_descr like '%MCG%' THEN 'mcG' 
		ELSE 'mG' END
		
WHEN @dosage_form IN ('Pwdr Oral Soln')
	-- insulin handled above
	THEN CASE WHEN @form_descr like '%ML%' THEN 'mL' 
		WHEN @form_descr like '%GM%' 
			AND @form_descr NOT LIKE '%MG%' 
			AND IsNull(@generic_descr,@form_descr) LIKE '& / %' THEN 'LITER'
		WHEN @form_descr like '%GM%'
			AND @form_descr NOT LIKE '%MEQ%' THEN 'GRAM'
		ELSE 'PACKE' END

WHEN @dosage_form IN ('Pwdrr Oral Susp')
	THEN CASE WHEN @form_descr not like '%ML%'
		and @form_descr like '%MG%'
		THEN 'mG' ELSE 'mL' END

WHEN @form_descr like '%dental cream%'
	THEN 'APPLY'

WHEN @form_descr like '%eyelash topical solution%'
	THEN 'DROP'

WHEN @form_descr like '%follitropin%'
	THEN 'UNIT'

WHEN @form_descr like '%intrauterine%'
	THEN 'DEVI'
	
WHEN @form_descr LIKE'%otic lotion%'
	THEN 'DROPEAR'

WHEN @form_descr LIKE '% lotion%'
	THEN 'APPLY'

WHEN @form_descr like '%Nasal Spray%'
	OR @form_descr like '%Nose Spray%'
	THEN 'SPRAYNOSTRIL'

WHEN @form_descr like '%shampoo%' or @form_descr like '%conditioner%' or @form_descr like '%soap%'
	THEN 'APPLY'

WHEN @form_descr like '%Pad' 
OR @form_descr like '%Swab'
	THEN 'MEDICATEDPAD'

WHEN @form_descr like '%Periodontal Gel'
	THEN 'APPLY'

WHEN @form_descr like '%Nasal Inhalant'
	THEN 'INHALATION'

WHEN @form_descr like '%Nasal Powder'
	THEN 'NOSEPIECE'

WHEN @form_descr like '%drug implant%'
	THEN 'IMPL'

WHEN @form_descr like '%ophthalmic drug implant%'
	THEN 'INSERTEYE'

WHEN @form_descr like '%ophthalmic gel%'
OR @form_descr like '%ophthalmic ointment%'
	THEN 'APPLYEYE'

WHEN @form_descr like '%ophthalmic emulsion%'
OR @form_descr like '%ophthalmic gel forming solution%'
OR @form_descr like '%ophthalmic solution%'
OR @form_descr like '%ophthalmic suspension%'
	THEN 'DROPEYE'

WHEN @form_descr like '%oral cream%'
	THEN 'APPLY'

WHEN @form_descr like '%oral drops%'
	THEN 'DROP'

WHEN @form_descr like '%oral flakes%'
	THEN 'TBL'

WHEN @form_descr like '%lozenge%'
	THEN 'LOZG'

WHEN @form_descr like '%oral ointment%'
	THEN 'APPLY'

WHEN @form_descr like '%rectal suspension%'
	THEN 'mL'

WHEN @form_descr like '%oral paste%'
	THEN 'cM'

WHEN @form_descr like '%oral powder%'
AND @form_descr like '%GM %'
	THEN 'GRAM'

WHEN @form_descr like '%oral powder%'
AND @form_descr not like '%GM %'
	THEN 'PACKE'

WHEN @form_descr like '%oral rinse%'
OR @form_descr like '%mouthwash%'
	THEN 'TSP'

WHEN @form_descr like '%Powder for Inhalant Solution%'
OR @form_descr like '%Powder for Inhalation Solution%'
	THEN 'mG'
	
WHEN @dosage_form = 'Inhalant Soln'
	OR @form_descr like '%inhalant suspension%'
	OR @form_descr like '%inhalation suspension%'
	OR @form_descr like '%inhalant solution%'
	OR @form_descr like '%inhalation solution%'
	THEN CASE WHEN IsNull(@generic_descr,@form_descr) like '%nicotine%' THEN 'CARTRIDGE'
		WHEN IsNull(@generic_descr,@form_descr) like '%Nebuli%er%' THEN 'mL' 
		ELSE 'VIAL' END

WHEN @form_descr like '%Powder for Nasal Solution%'
	THEN 'PACKE'

WHEN @form_descr like '%rectal foam%'
AND @form_descr like '%actuat%'
	THEN 'ACTUAT'

WHEN @form_descr like '%rectal cream%'
OR @form_descr like '%rectal gel%'
	THEN 'APPLICATOR'

WHEN @form_descr like '%rectal foam%'
OR @form_descr like '%rectal lotion%'
OR @form_descr like '%rectal spray%'
	THEN 'APPLY'

WHEN @form_descr like '%rectal solution%'
	THEN 'mL'

WHEN @form_descr like '%sublingual powder%'
	THEN 'mcG'

WHEN @form_descr like '%Topical solution%'
AND @form_descr like '%ACTUAT%'
	THEN 'ACTUAT'

WHEN @form_descr like '%Topical solution%'
AND (@form_descr like '%wart%' 
	OR @form_descr like '%corn%' 
	OR @form_descr like '%callus%')
	THEN 'DROP'

WHEN @form_descr like '%Topical solution%'
AND (@form_descr like '%rogaine%' OR @form_descr like '%minoxidil%')
	THEN 'mL'
 
-- this case must come after wart remover case above
WHEN @form_descr like '% film%'
	THEN 'STRIP'

WHEN @form_descr like '%Topical spray%'
AND @form_descr like '%UNT in %'
	THEN 'APPLY'
	
WHEN @form_descr like '%Topical spray%'
	THEN 'SPRAY'

WHEN @form_descr like '%transdermal gel pump%'
	THEN 'ACTUAT'

WHEN @form_descr like '%transdermal gel%'
	THEN 'TUBEORPACKE'

WHEN @form_descr like '%transdermal sys%'
AND @form_descr not like '%activation%'
	THEN 'PATCH'
	
WHEN @form_descr like '%transdermal sys%'
AND @form_descr like '%activation%'
	THEN 'ACTIVATION'
	
WHEN @form_descr like '% spray%' 
AND (@form_descr like '%UNT in %' or @form_descr like '%rectal spray%')
	THEN 'APPLY'
	
WHEN @form_descr like '%inhalation spray%' 
	THEN 'PUFF'

WHEN @form_descr like '% spray%' 
	THEN 'SPRAY'

-- Injection forms are tricky; use caution if applying these
WHEN @dosage_form = 'Injectable Soln'
	AND @form_descr like '%extract%'
	THEN 'mL'

WHEN @form_descr like '%UNT Injection%'
	THEN 'UNIT'
	
WHEN (@form_descr like '%GM% injection%'
	OR @form_descr like '%GM% powder%')
and @form_descr not like '%ML%'
	THEN 'GRAM'

WHEN @form_descr like '%Injection%' 
and  @form_descr like '%MCG%'
and @form_descr not like '%ML%' 
and @form_descr not like '%extract%'
	THEN 'mcG'

WHEN @form_descr like '%inje%'
  and @form_descr like '%cells%'
  and @form_descr not like '%ML%'
	THEN 'CELLS'

WHEN @form_descr like '%inje%'
and @form_descr like '%immune globulin%'
AND @form_descr like '%MG%'
	THEN 'mG'

WHEN @form_descr like '%injection%'
and @form_descr like '%immune globulin%'
and (@form_descr like '%UNT in%' 
or @form_descr like '%UNT/ML%')
	THEN 'mL'

WHEN @form_descr like '%injection%'
and @form_descr like '%MG%' 
and @form_descr not like '%extract%' 
and @form_descr not like '%ML%'
	THEN 'mG'

WHEN @form_descr like '%prefilled%'
and @form_descr like '% UNT %' 
and @form_descr not like '%ML%' 
and @form_descr not like '%GM%' 
and @form_descr not like '%MG%' 
and @form_descr not like '%MCG%'
	THEN 'UNIT'

WHEN @form_descr like '%prefilled%'
and @form_descr like '%immune globulin%'
and @form_descr like '%MCG%'
	THEN 'mcG'

WHEN @form_descr like '%UNT prefilled%'
or @form_descr like '%UNT (%' 
	THEN 'UNIT'

WHEN @form_descr like '%prefilled%'
and @form_descr like '%MG%' 
and @form_descr not like '%extract%' 
and @form_descr not like '%ML%'
	THEN 'mG'

WHEN @form_descr like '%prefilled%'
and @form_descr like '%MCG%' 
and @form_descr not like '%extract%' 
and @form_descr not like '%ML%'
	THEN 'mcG'




ELSE (SELECT default_dose_unit 
	FROM c_Dosage_Form 
	WHERE dosage_form = @dosage_form)
END

END

GO
GRANT EXECUTE ON [dbo].[fn_std_dose_unit] TO [cprsystem]
GO
