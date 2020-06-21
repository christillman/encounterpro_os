-- Revising Dosage Forms spread sheet

-- Administer methods
-- default for Oral
UPDATE c_Package SET administer_method = 'Subcut'
WHERE administer_method = 'SQ'

UPDATE vw_dose_unit SET administer_method = 'PO'
WHERE form_descr like '% Oral %'
AND dosage_form NOT IN ('MucousMemSoln','Mouthwash')

UPDATE vw_dose_unit SET administer_method = 'SPRAYORAL'
WHERE form_descr like '%Mucosal Spray%'

UPDATE vw_dose_unit SET administer_method = 'SL'
WHERE (form_descr like '%Mucosal Spray%' OR dosage_form = 'Mucosal Spray')
AND form_descr like '%ACTUAT%'

UPDATE vw_dose_unit SET administer_method = 'NEBULIZER'
WHERE form_descr like '%inhalant Solution%' 
OR form_descr like '%Inhalation Solution%' 
OR form_descr like '%inhalant suspension%'
OR form_descr like '%inhalation suspension%'

UPDATE vw_dose_unit SET administer_method = 'DROPNOSTRIL'
WHERE form_descr like '%Nasal Solution%'
AND dose_unit like 'DROP%'

UPDATE vw_dose_unit SET administer_method = 'SPRAYNOSTRIL'
WHERE form_descr like '%Nasal Solution%'
AND dose_unit like 'SPRAY%'

UPDATE vw_dose_unit SET administer_method = 'SPRAYNOSTRIL'
WHERE form_descr like '%Nasal Spray%'

UPDATE vw_dose_unit SET administer_method = 'BUCCAL'
WHERE form_descr like '%Buccal%'

UPDATE vw_dose_unit SET administer_method = 'CHEW'
WHERE form_descr like '%Chewable%'
OR form_descr like '%soft chew%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%Dental %'

UPDATE vw_dose_unit SET administer_method = 'AFFECTED EAR'
WHERE form_descr like '% Otic %'
AND form_descr NOT LIKE '% Otic Lotion%'

UPDATE vw_dose_unit SET administer_method = 'APPLY'
WHERE form_descr LIKE '% Otic Lotion%'

UPDATE vw_dose_unit SET administer_method = 'PO'
WHERE dosage_form = 'ER Suspension'

UPDATE vw_dose_unit SET administer_method = 'EACH EYE'
WHERE form_descr LIKE '%eyelash%'

UPDATE vw_dose_unit SET administer_method = 'TO TEETH'
WHERE form_descr LIKE '%toothpaste%'

UPDATE vw_dose_unit SET administer_method = 'INTRAUTERINE'
WHERE form_descr LIKE '%INTRAUTERINE%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%irrigation%'
and form_descr not like '%ophthalmic%'
and form_descr not like '%dental%'

UPDATE vw_dose_unit SET administer_method = 'AFFECTED EYE'
WHERE form_descr LIKE '%Ophthalmic Irrigation%'

UPDATE vw_dose_unit SET administer_method = 'SHAMPOO'
WHERE dosage_form = 'Med Shampoo' -- includes conditioner

UPDATE vw_dose_unit SET administer_method = 'TO SCALP'
WHERE form_descr LIKE '%medical shampoo%'

UPDATE vw_dose_unit SET administer_method = 'APPLY'
WHERE  form_descr like '%medicated %' 
AND dosage_form NOT IN ('Douche', 'Med Shampoo')

UPDATE vw_dose_unit SET administer_method = 'SWISHSPIT'
WHERE dosage_form = 'Mouthwash'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%mucous membrane gel%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%mucous membrane topical solution%'
and form_descr like '%lidocaine%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%nasal gel%'
and form_descr not like '%ACTUAT%'

UPDATE vw_dose_unit SET administer_method = 'EACH NOSTRIL'
WHERE form_descr like '%nasal OINTMENT%'

UPDATE vw_dose_unit SET administer_method = 'INHALE'
WHERE form_descr like '%nasal powder%'

UPDATE vw_dose_unit SET administer_method = 'SUCK'
WHERE form_descr like '%lozenge%'

UPDATE vw_dose_unit SET administer_method = 'APPLY'
WHERE form_descr like '%oral paste%'

UPDATE vw_dose_unit SET administer_method = 'SPRAYORAL'
WHERE dosage_form = 'Oral Spray'

UPDATE vw_dose_unit SET administer_method = 'APPLY'
WHERE  form_descr like '%paste%' or form_descr like '%patch%'

UPDATE vw_dose_unit SET administer_method = 'TO TEETH'
WHERE dosage_form != 'Mouthwash'
AND (form_descr like '%tooth%' or form_descr like '%stannous%')

UPDATE vw_dose_unit SET administer_method = 'ON SKIN'
WHERE dosage_form != 'Topical Gel'
and form_descr like '%transdermal%'

UPDATE vw_dose_unit SET administer_method = 'IN OFFICE'
WHERE form_descr like '%periodontal gel%'

UPDATE vw_dose_unit SET administer_method = 'IMPLANT-SINUS'
WHERE form_descr like '%sinus drug implant%'

UPDATE vw_dose_unit SET administer_method = 'IMPLANT-SUBCUT'
WHERE form_descr like '%subcutaneous%drug implant%'

UPDATE vw_dose_unit SET administer_method = 'IMPLANT SUBDERMAL'
WHERE form_descr like '%subderm%'

UPDATE vw_dose_unit SET administer_method = 'SL'
WHERE form_descr like '%sublingual%'

UPDATE vw_dose_unit SET administer_method = 'APPLY'
WHERE dosage_form not in ('Liquid Soap','Oral Gel','Vag Cream','Oral Ointment') 
and form_descr like '%Topical%'

UPDATE vw_dose_unit SET administer_method = 'TO UPPER ARMS AND SHOULDERS'
WHERE form_descr like '%transdermal gel%'
and (form_descr like '%androgel%'
or form_descr like '%vogelxo%'
or form_descr like '%testim%')

UPDATE vw_dose_unit SET administer_method = 'TO THIGHS'
WHERE form_descr like '%transdermal gel%'
and form_descr like '%fortesta%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%urethral suppository%'

UPDATE vw_dose_unit SET administer_method = 'INTRAVAGINAL'
WHERE dosage_form like 'Vag%'

UPDATE vw_dose_unit SET administer_method = 'TO SCALP'
WHERE form_descr like '%scalp%'
or form_descr like '%rogaine%'

UPDATE vw_dose_unit SET administer_method = 'ON SKIN'
WHERE form_descr like '% skin %'
and form_descr not like '%injectable%'

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_descr like '%topical solution%'
and (form_descr like '%hemox A%' 
or form_descr like '%lumicain%')


UPDATE vw_dose_unit SET administer_method = 'TO ARMPITS'
WHERE form_descr like '%topical solution%'
and (form_descr like '%axiron%'
or form_descr like '%testosterone%'
or form_descr like '%drysol%' 
or form_descr like '%hypercare%'
or form_descr like '%xerac%')

-- Specific RXCUI

UPDATE vw_dose_unit SET administer_method = 'ASDIR'
WHERE form_rxcui IN ('582096',
'582098',
'686497',
'891441',
'999683',
'1722107',
'1144131')

UPDATE vw_dose_unit SET [administer_method] = 'INHALE' WHERE form_rxcui = '250983'
UPDATE vw_dose_unit SET [administer_method] = 'INHALE' WHERE form_rxcui = '1046920'
UPDATE vw_dose_unit SET [administer_method] = 'INHALE' WHERE form_rxcui = '857795'
UPDATE vw_dose_unit SET [administer_method] = 'INHALE' WHERE form_rxcui = '857799'
UPDATE vw_dose_unit SET [administer_method] = 'VAPORIZER' WHERE form_rxcui = '701961'

-- Mucous Membrane Topical Solution = APPLY except for these
UPDATE vw_dose_unit SET [administer_method] = 'SWISHSPIT' 
WHERE form_rxcui IN (
'1251788',
'1251772',
'1244729',
'582808',
'1048144',
'205336',
'213499'
)

UPDATE vw_dose_unit SET [administer_method] = 'EACH NOSTRIL', dose_unit = 'MG' WHERE form_rxcui = '1995288'
UPDATE vw_dose_unit SET [administer_method] = 'EACH NOSTRIL', dose_unit = 'MG' WHERE form_rxcui = '1995293'
UPDATE vw_dose_unit SET [administer_method] = 'NASAL IRRIGATION', dose_unit = 'ML' WHERE form_rxcui = '1014132'
UPDATE vw_dose_unit SET [administer_method] = 'NASAL IRRIGATION', dose_unit = 'ML' WHERE form_rxcui = '1014137'
UPDATE vw_dose_unit SET [administer_method] = 'NASAL IRRIGATION', dose_unit = 'PACKE' WHERE form_rxcui = '1542919'
UPDATE vw_dose_unit SET [administer_method] = 'NASAL IRRIGATION', dose_unit = 'PACKE' WHERE form_rxcui = '1804375'
UPDATE vw_dose_unit SET [administer_method] = 'ONE NOSTRIL', dose_unit = 'ML' WHERE form_rxcui = '849520'
UPDATE vw_dose_unit SET [administer_method] = 'ONE NOSTRIL', dose_unit = 'ML' WHERE form_rxcui = '849522'

UPDATE vw_dose_unit SET [administer_method] = 'AFFECTED NOSTRIL', dose_unit = 'ML' WHERE form_rxcui = '757669'
UPDATE vw_dose_unit SET [administer_method] = 'AFFECTED NOSTRIL', dose_unit = 'ML' WHERE form_rxcui = '1243786'

-- Injectables sheet

-- Note that for this release where there are multiple routes I 
-- am leaving them blank ("Choose one" below)
-- Also the " ONLY" suffix is not represented in c_Administration_Method

-- 313919
-- 688596
-- 1305910
-- 1305908
-- 1305892
-- 1305888
-- 1305909
-- 1305891
-- 1305907
-- 2003660
-- 2003669
-- 2003663
-- 2003667
-- 2003670
-- 2003664
-- 2003668
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1190538'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1190540'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1190542'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1495298'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1855732'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544378'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441402'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544385'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1747179'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544387'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441411'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544389'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1747185'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441416'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1747192'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544395'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441422'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544397'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544399'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544401'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544403'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1594757'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1495293'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1855730'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '891437'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '891438'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '997024'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1190608'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1190611'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1190614'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1190620'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '727415'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1190536'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1991329'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1305268'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1305269'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1807452'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '809819'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1870225'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1870230'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1991328'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1870232'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1870205'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '727316'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1870207'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '727347'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '727386'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1665895'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441407'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1747181'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441413'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1747187'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441418'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1441424'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1594759'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '727631'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544383'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544386'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544388'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544390'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544394'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544396'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544398'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544400'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544402'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1544404'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1665900'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1738576'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1793916'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1657151'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1738581'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '996559'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '763489'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234236'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234239'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234241'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234238'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234240'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '1234242'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1801319'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '758523'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '860088'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1665675'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1665679'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1665682'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1801322'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '996558'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '763488'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1657173'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1657160'
-- Choose one 1361021
-- Choose one 1361019
-- Choose one 1735488
-- 1041495
-- 1041497
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801644'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801395'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800563'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801403'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800611'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '238719'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '805127'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '805131'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1654849'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801405'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801398'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '200317'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1799697'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '200318'
-- 198412
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801648'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1189640'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1189645'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1926818'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1926825'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1599836'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1926823'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1926827'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1599841'
-- Choose one 1731999
-- Choose one 892652
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1484927'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '856789'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1657178'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1657167'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '727505'
-- 1788947
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1114874'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743877'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743879'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1292887'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743938'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743941'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743950'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743953'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743869'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743871'
-- Choose one 238212
-- Choose one 240912
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '898578'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '898572'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '731380'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '727507'
-- Choose one 1790512
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '731381'
-- Choose one 1790506
-- Choose one 1117759
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1790353'
-- Choose one 1790374
-- Choose one 1790382
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '312814'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '731383'
-- Choose one 1117765
-- Choose one 205885
-- Choose one 1790513
-- Choose one 1790508
-- Choose one 1790379
-- Choose one 1790383
-- Choose one 312807
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '242690'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '242691'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '226921'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '199596'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '103956'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '226922'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '105569'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '239179'
-- Choose one 1605172
-- Choose one 730046
-- Choose one 352047
-- Choose one 731231
-- Choose one 1654951
-- Choose one 731235
-- Choose one 1654955
-- Choose one 731245
-- Choose one 352044
-- Choose one 731229
-- Choose one 352262
-- Choose one 731227
-- Choose one 352045
-- Choose one 731241
-- Choose one 731250
-- Choose one 352046
-- Choose one 731167
-- Choose one 1605171
-- Choose one 730044
-- Choose one 349276
-- Choose one 731171
-- Choose one 1654949
-- Choose one 731174
-- Choose one 1654954
-- Choose one 349273
-- Choose one 731179
-- Choose one 351247
-- Choose one 731181
-- Choose one 349274
-- Choose one 731184
-- Choose one 349275
-- Choose one 731176
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1868473'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727995'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '792577'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '792582'
-- 1728050
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '583218'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '313812'
-- Choose one 1490057
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1799310'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '213841'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791703'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '833532'
-- Choose one 789980
-- Choose one 213093
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085998'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085994'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '2002739'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '308395'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '206289'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '966768'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718913'
-- Choose one 1190551
-- Choose one 1190793
-- Choose one 1666781
-- Choose one 1190776
-- Choose one 1190552
-- Choose one 1190795
-- Choose one 1190546
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1490667'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '208325'
-- 1726097
-- 1726102
-- Choose one 578803
-- Choose one 1429282
-- Choose one 1429284
-- Choose one 282486
-- Choose one 886627
-- Choose one 1728351
-- Choose one 886622
-- Choose one 1728355
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '240738'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '828527'
-- 197435
-- Choose one 201860
-- Choose one 239208
-- Choose one 313920
-- Choose one 309065
-- Choose one 1722916
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1739890'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '309072'
-- Choose one 242800
-- Choose one 309090
-- Choose one 309101
-- Choose one 578806
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '239200'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '206344'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '199211'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1730194'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '309311'
-- Choose one 105174
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '199710'
-- Choose one 706461
-- Choose one 205964
-- Choose one 1117522
-- Choose one 1117525
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204536'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1608815'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1942743'
-- Choose one 240416
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '856698'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '856696'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835811'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '206620'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '206715'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '206813'
-- Choose one 1242106
-- Choose one 1665687
-- Choose one 1665702
-- Choose one 861520
-- Choose one 1665700
-- Choose one 1242503
-- Choose one 861529
-- Choose one 1665698
-- Choose one 861522
-- Choose one 861617
-- Choose one 1665691
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '206417'
-- Choose one 1358512
-- Choose one 1358612
-- Choose one 1358619
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1000133'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835831'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835842'
-- Choose one 309845
-- Choose one 309914
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '309915'
-- Choose one 1723776
-- Choose one 1723740
-- Choose one 1049289
-- Choose one 1049633
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1093280'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1861411'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1870937'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1860480'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1860619'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1001405'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1918045'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1860485'
-- Choose one 200101
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1191138'
-- Choose one 1191126
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '253014'
-- Choose one 1191128
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854255'
-- Choose one 310132
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '310187'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '310189'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '310190'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '310191'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310248'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204441'
-- 251934
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204508'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '239177'
-- Choose one 859824
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '865129'
-- Choose one 199317
-- Choose one 237786
-- Choose one 206422
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1734377'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1734383'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '855613'
-- Choose one 252484
-- 1998783
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762833'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762836'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762839'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762843'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762875'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762849'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762852'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762859'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762868'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762897'
-- Choose one 239204
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1870686'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '242816'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '197736'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1870631'
-- Choose one 1870676
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '313996'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1870633'
-- Choose one 1870681
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310476'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310473'
-- Choose one 1870650
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310477'
-- Choose one 1870685
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310474'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '204416'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '859871'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '859867'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1922518'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '806575'
-- Choose one 582971
-- Choose one 582976
-- Choose one 207834
-- Choose one 729234
-- Choose one 637550
-- Choose one 1433251
-- Choose one 1724383
-- Choose one 897653
-- Choose one 897756
-- Choose one 1724338
-- Choose one 1724644
-- Choose one 1724276
-- Choose one 897757
-- Choose one 897745
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724352'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '897758'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '897753'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1872271'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724340'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724341'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1087964'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1794552'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '995270'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1794554'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '995285'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1747294'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '615882'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858057'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858055'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858053'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858074'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858051'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650968'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650972'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650974'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650976'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1608811'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '204430'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085752'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085756'
-- Choose one 206967
-- Choose one 206970
-- Choose one 206972
-- Choose one 238082
-- Choose one 238083
-- Choose one 238084
-- Choose one 860096
-- Choose one 311282
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '545835'
-- Choose one 102787
-- Choose one 239212
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '897122'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854256'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '545837'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '308260'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '311422'
-- Choose one 829762
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1087968'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '604806'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1000131'
-- Choose one 861447
-- Choose one 861493
-- Choose one 1665685
-- Choose one 1665701
-- Choose one 861459
-- Choose one 1665699
-- Choose one 861494
-- Choose one 861476
-- Choose one 861473
-- Choose one 1665697
-- Choose one 861463
-- Choose one 860792
-- Choose one 1665690
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204870'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '899350'
-- Choose one 864714
-- Choose one 245256
-- Choose one 1655956
-- Choose one 311625
-- Choose one 1655967
-- Choose one 1655968
-- Choose one 1946772
-- Choose one 1655959
-- Choose one 1655960
-- Choose one 996828
-- Choose one 314099
-- Choose one 1358510
-- Choose one 1358610
-- Choose one 1358617
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1491629'
-- 197989
-- Choose one 1728792
-- Choose one 1728801
-- Choose one 1728806
-- Choose one 1728784
-- Choose one 892489
-- Choose one 892473
-- Choose one 1731537
-- Choose one 1728791
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '894911'
-- Choose one 1731995
-- Choose one 1731993
-- Choose one 894912
-- Choose one 1728800
-- Choose one 892531
-- Choose one 1731520
-- Choose one 1733080
-- Choose one 1731530
-- Choose one 1232113
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1728789'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1732138'
-- Choose one 1729197
-- Choose one 2003714
-- Choose one 998212
-- Choose one 1728805
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1731545'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1731998'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1731517'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1728999'
-- Choose one 1732014
-- Choose one 1732006
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1491634'
-- Choose one 239189
-- Choose one 1866543
-- Choose one 904415
-- Choose one 1866551
-- Choose one 904440
-- Choose one 1191234
-- Choose one 1659929
-- Choose one 1191222
-- Choose one 1191250
-- Choose one 207468
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '637197'
-- Choose one 311935
-- Choose one 311936
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '210677'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847348'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847245'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '849851'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847247'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735501'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735537'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735490'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735496'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '992403'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854302'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '864110'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '645884'
-- Choose one 283504
-- Choose one 312128
-- Choose one 1743547
-- Choose one 312127
-- Choose one 240637
-- Choose one 1743549
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '312199'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858056'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858054'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858052'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650966'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858073'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650971'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650973'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '858048'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1650975'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '832086'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '832082'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1859009'
-- Choose one 237210
-- Choose one 238133
-- Choose one 238090
-- Choose one 245385
-- Choose one 312370
-- Choose one 199407
-- Choose one 198368
-- 1232651
-- Choose one 199408
-- Choose one 990982
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '312447'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '205821'
-- Choose one 857886
-- Choose one 857962
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '312644'
-- Choose one 312736
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '853004'
-- Choose one 312772
-- 352211
-- 352214
-- 352212
-- 352213
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1012465'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '248110'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657864'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657868'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657862'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657867'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1234995'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1544758'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '796918'
-- Choose one 207836
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '897044'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1598268'
-- Choose one 198207
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '751568'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '751570'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '751566'
-- Choose one 207193
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '284989'
-- Choose one 542438
-- Choose one 241975
-- Choose one 248288
-- Choose one 284019
-- Choose one 857237
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1860482'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1860486'
-- Choose one 206423
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '722289'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835829'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835840'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '835809'
-- Choose one 313324
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '860751'
-- Choose one 313416
-- Choose one 597823
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '206831'
-- Choose one 637549
-- Choose one 1799424
-- Choose one 1799416
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '725108'
-- 349407
-- 349408
-- 349409
-- 349410
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085750'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085754'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085996'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1085992'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '860749'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '239209'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '313572'
-- 1542385
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '859437'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '897126'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '239178'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1992160'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1942748'
-- Choose one 104084
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1242617'
-- Choose one 212075
-- Choose one 104897
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1648160'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1648162'
-- Choose one 582984
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '884254'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '984078'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '672540'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1659818'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1602604'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1659814'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1602607'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1734934'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1734932'
-- Choose one 1660016
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1799305'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '2001102'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1799308'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1799307'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '2001100'
-- Choose one 1659592
-- Choose one 1659598
-- Choose one 1721475
-- Choose one 240984
-- Choose one 308207
-- Choose one 1721476
-- Choose one 1721473
-- Choose one 1721474
-- Choose one 1790819
-- Choose one 1790815
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1602163'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1659812'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1602171'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '672356'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1925262'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1673269'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1673277'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1673279'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '860777'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1668238'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1927672'
-- Choose one 1665050
-- Choose one 1665060
-- Choose one 1665052
-- Choose one 1665093
-- Choose one 1665088
-- Choose one 1665097
-- Choose one 1665021
-- Choose one 1665046
-- Choose one 309092
-- Choose one 1665005
-- Choose one 1665444
-- Choose one 1665449
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '199388'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665214'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665210'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665227'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665212'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665229'
-- Choose one 1737244
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '309339'
-- Choose one 1737578
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '309335'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '309336'
-- Choose one 1737581
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1111642'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1487363'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '404652'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '209029'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204528'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '205743'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1996246'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '403920'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1927667'
-- Choose one 1807459
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1790818'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1790812'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790131'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790128'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790097'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790103'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790099'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1872062'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790100'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790095'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790115'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790127'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '544840'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310027'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1998483'
-- Choose one 206819
-- Choose one 206820
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '401981'
-- Choose one 1989112
-- Choose one 1660014
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727373'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1668267'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1668264'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '486499'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '486501'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1721310'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1721315'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1721314'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310414'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '404460'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1999531'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1872065'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '310442'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1111641'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1487361'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1654630'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '2000007'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791499'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791495'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791501'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791498'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791493'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1791500'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1988652'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1988660'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665508'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665516'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665497'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665507'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665517'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665515'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1665519'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790181'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1790177'
-- Choose one 1665095
-- Choose one 1665091
-- Choose one 1665099
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '207358'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '317127'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1740900'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1740898'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1740894'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '351156'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1812480'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1812482'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1812484'
-- Choose one 1721458
-- Choose one 1721460
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1492047'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '283669'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1598082'
-- 1361023
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659131'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659137'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659149'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1492043'
-- Choose one 312576
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1988657'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1988661'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '885257'
-- Choose one 208969
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '876203'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '705875'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '108396'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1736337'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1736329'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735536'
-- Choose one 582969
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847243'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1735494'
-- Choose one 582974
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '849850'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1736267'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1736262'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '885385'
-- Choose one 346494
-- Choose one 729232
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '249453'
-- Choose one 897042
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '313115'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1809083'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '313137'
-- Choose one 1989117
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '581531'
-- Choose one 242825
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '584201'
-- Choose one 205843
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807508'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807513'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807511'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807516'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807510'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1807518'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '352220'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '211248'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '351209'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204534'
-- Choose one 1665447
-- Choose one 1665451
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1668240'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1114085'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '351114'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1865665'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '705824'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1114087'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '351945'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659134'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659139'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659151'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1922516'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '806573'
-- Choose one 1872752
-- Choose one 1872265
-- Choose one 897747
-- Choose one 1872269
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '897755'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1872272'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724356'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724358'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1724359'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '984082'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '896771'
-- Choose one 238100
-- Choose one 238101
-- Choose one 311700
-- Choose one 311702
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1659816'
-- Choose one 1735500
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1939299'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1939348'
-- Choose one 998213
-- Choose one 1732136
-- Choose one 1442790
-- Choose one 1728783
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1939296'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1939346'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657066'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657073'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '849932'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '854187'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657658'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657663'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657660'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657664'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657068'
UPDATE vw_dose_unit SET administer_method = 'IV ONLY' WHERE form_rxcui = '1657074'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '261105'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1731522'
-- Choose one 1732003
-- Choose one 1732011
-- Choose one 894914
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '854183'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '849931'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '597195'
-- Choose one 1655032
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1300191'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1858963'
-- 801019
-- 801029
-- 801032
-- 800434
-- 800440
-- 800445
-- 830731
-- 830680
-- 830651
-- 800584
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801067'
-- 847781
-- 831426
-- 801013
-- 801010
-- 800396
-- 800269
-- 800209
-- 800341
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1014427'
-- 831290
-- 800216
-- 801016
-- 800998
-- 800401
-- 800406
-- 800411
-- 800416
-- 831074
-- 800237
-- 1304559
-- 1304564
-- 1305200
-- 1305205
-- 1305217
-- 1305222
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1192860'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1192862'
UPDATE vw_dose_unit SET administer_method = 'INTRADERMAL' WHERE form_rxcui = '798408'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '855856'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801907'
-- 801881
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1189683'
-- 1547459
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012724'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012739'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1946730'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '992801'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1794184'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '992805'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '992809'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '792847'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '835715'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '849820'
-- 803058
-- 803062
-- 803239
-- 800588
-- Choose one 1812079
-- Choose one 309696
-- Choose one 1812194
-- Choose one 1812095
-- Choose one 1116927
-- 801177
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795481'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795480'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795477'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '237649'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727518'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '237650'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795609'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795612'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795621'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795618'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795610'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795616'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795607'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '309778'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795519'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795514'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727517'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795518'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795496'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1795498'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '237656'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800808'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800786'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1244205'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1190748'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801364'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800633'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801005'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800644'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1190750'
-- 1190179
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1801611'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1928537'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1801193'
-- Choose one 388911
-- Choose one 415314
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800862'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1014431'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1597103'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '849822'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801868'
-- 807396
-- 807379
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658060'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '798479'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658066'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '798482'
-- Choose one 1658159
-- Choose one 1658423
-- Choose one 1658707
-- Choose one 1362048
-- Choose one 1658637
-- Choose one 1361568
-- Choose one 1658719
-- Choose one 1362057
-- Choose one 1656760
-- Choose one 1658659
-- Choose one 1362059
-- Choose one 1362052
-- Choose one 1362060
-- Choose one 1658647
-- Choose one 1361577
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1362054'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1362062'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1362055'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1362063'
-- Choose one 1658634
-- Choose one 1659263
-- Choose one 1798389
-- Choose one 1362065
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658058'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '798477'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658065'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '798481'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658100'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '727782'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658105'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '836635'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658147'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658125'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658163'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '825160'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '825157'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658174'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1597101'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658165'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '825161'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '825159'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658175'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '830470'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1794440'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1794448'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1928532'
UPDATE vw_dose_unit SET administer_method = 'INTRADERMAL' WHERE form_rxcui = '485193'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800637'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800648'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800790'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800812'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1190439'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800928'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '847630'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '847627'
-- Choose one 1010745
-- Choose one 1010900
-- Choose one 1010751
-- Choose one 1012066
-- Choose one 1010033
-- Choose one 1010759
-- Choose one 1012068
-- Choose one 1010671
-- 200238
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '800925'
-- 801109
-- 800985
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012381'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012400'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012388'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012406'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012722'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012737'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658127'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658148'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1996298'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1996293'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '992803'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '992807'
-- 880859
-- 801009
-- 1189629
-- 800988
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '807371'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801357'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1189668'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '801112'
-- 1601982
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012726'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012741'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1656595'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1490491'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1656599'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1490493'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '847626'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1866559'
UPDATE vw_dose_unit SET administer_method = 'INTRADERMAL' WHERE form_rxcui = '313532'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '830463'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '830467'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '830460'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '847629'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '847617'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1927890'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1927894'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1927885'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1927893'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1996297'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1996291'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '543688'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '347043'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012413'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012455'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012417'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012457'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1986830'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727820'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727634'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '804981'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '859203'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727821'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '727822'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '747260'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '313002'
-- Choose one 313016
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1091719'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1091721'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1091723'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1091725'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204490'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204491'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '543732'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '543739'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1876710'
-- 1362072
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1190916'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1190919'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '807277'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '807273'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '205259'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1300189'
UPDATE vw_dose_unit SET administer_method = 'INTRADERMAL' WHERE form_rxcui = '485356'
UPDATE vw_dose_unit SET administer_method = 'INTRADERMAL' WHERE form_rxcui = '798415'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1486496'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '807225'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '807239'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '807222'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658102'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '836634'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1658106'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '836636'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1986825'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1098122'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1098124'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1098137'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '540930'
-- Choose one 1010749
-- Choose one 1010902
-- Choose one 1010755
-- Choose one 1010035
-- Choose one 1010763
-- Choose one 1010673
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1876705'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1658239'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1292826'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1292828'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '763470'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '763473'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '237212'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '855858'
-- Choose one 1665190
-- Choose one 1665327
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '763472'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '763474'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1665904'
-- Choose one 727759
-- Choose one 1735003
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1735008'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1735007'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1735013'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1735006'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854787'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854788'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '854790'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1098139'
-- Choose one 1361853
-- Choose one 1659260
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1190112'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1190113'
-- Choose one 860092
-- Choose one 860113
-- Choose one 1665461
-- Choose one 860114
-- Choose one 1665459
-- Choose one 860115
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1234256'
-- Choose one 763028
-- Choose one 1665188
-- Choose one 763029
-- Choose one 1665326
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1744259'
-- Choose one 1666823
-- Choose one 1551393
-- Choose one 1666777
-- Choose one 1666798
-- Choose one 998211
-- Choose one 1666821
-- Choose one 1666814
-- Choose one 1551395
-- Choose one 1666800
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '855911'
UPDATE vw_dose_unit SET administer_method = 'CAVERNOSAL' WHERE form_rxcui = '105467'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1665906'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1190122'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762830'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762834'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762837'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762841'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762873'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762846'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762850'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762857'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762866'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '762895'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '313165'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '727339'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1192858'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1192861'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012377'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012396'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012384'
UPDATE vw_dose_unit SET administer_method = 'NERVE BLOCK' WHERE form_rxcui = '1012404'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1245423'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1245424'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1245976'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1245982'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1245985'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1246592'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1246594'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1246615'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1246618'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1246822'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1246829'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1369805'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1369810'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1537106'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1537107'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1721082'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1734865'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1804513'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1869318'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1869320'
UPDATE vw_dose_unit SET administer_method = 'INTRAOCULAR' WHERE form_rxcui = '1869344'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1869381'
UPDATE vw_dose_unit SET administer_method = 'INTRA-ARTICULAR' WHERE form_rxcui = '1999408'
-- 248009
-- 199947
-- 801024
-- 205296
-- 151114
-- 251817
-- 199584
-- 199585
-- 282533
-- 199965
-- 245961
-- 1189657
-- 801145
-- 1189673
-- 801391
-- 315188
-- 248661
-- 413132
-- 199727
-- 801142
-- 807383
-- Choose one 1928862
-- Choose one 1928853
-- Choose one 1928858
-- Choose one 1928864
-- 800976
-- 800188
-- 801413
-- 801133
-- 800858
-- 800929
-- 1743994
-- 1594591
-- Suppress 1244638
-- 1547445
-- 1100742
-- 1100746
-- 2003344
-- 1293736
-- Suppress 1293739
-- Suppress 562675
-- Suppress 262197
-- Suppress 309279
-- 1667993
-- Choose one 1666831
-- 315105
-- 800933
-- Choose one 1666837
-- 199958
-- Suppress 1244233
-- 1293446
-- 1293466
-- 800979
-- 1547450
-- 801417
-- 801136
-- 1594593
-- 435151
-- 1594589
-- 1293443
-- 1293464
-- 1549708
-- 1090635
-- 1094083
-- 1486165
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1789956'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1789950'
-- Choose one 1040025
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '207351'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1992171'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1992169'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719225'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1741409'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1796384'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '307816'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1661345'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '542925'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1722407'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1722406'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1741407'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1796379'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1661332'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718962'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719222'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718993'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1720165'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1593154'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659998'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847261'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '803194'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '210972'
-- Choose one 150889
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '209704'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '562411'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1736863'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1233622'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1666317'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '867381'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731541'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '836307'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731568'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731571'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731566'
-- Choose one 1726673
-- Choose one 1726676
-- Choose one 860195
-- Choose one 897368
-- Choose one 1726313
-- Choose one 1726296
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '795144'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1729336'
-- Choose one 308866
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1726260'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1726268'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '896854'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '310587'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '809871'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1666311'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1488302'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1095283'
-- Choose one 309541
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978738'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978755'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978759'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978740'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978744'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978746'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978777'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978725'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978733'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978736'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1789958'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1789953'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1292881'
-- Choose one 1721684
-- Choose one 240000
-- Choose one 241999
-- Choose one 239998
-- Choose one 240377
-- Choose one 242706
-- Choose one 239999
-- Choose one 1721685
-- Choose one 205912
-- Choose one 212218
-- Choose one 205917
-- Choose one 205921
-- Choose one 205923
-- Choose one 1232190
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1670387'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1095281'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1660001'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1986356'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1986354'
-- Choose one 604377
-- Choose one 1361563
-- Choose one 1361569
-- Choose one 604379
-- Choose one 1361572
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1654171'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1654179'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '351125'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '562724'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1654184'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978739'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978757'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978760'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978741'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978745'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978747'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978778'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978727'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978735'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978737'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1242131'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '351993'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '284419'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1594432'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1594418'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1594334'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719228'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718965'
-- Choose one 1361029
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1658720'
-- Choose one 1362831
-- Choose one 1361048
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1658692'
-- Choose one 1361226
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659197'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1361607'
-- Choose one 1361574
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1658690'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1658717'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1659195'
-- Choose one 1361615
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1361038'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1652640'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '865098'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1652242'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1926332'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '731281'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '752388'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847254'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1661352'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '106892'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '847199'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1731317'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '351859'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '311036'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '238271'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '630936'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1809535'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1809531'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1809538'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1809542'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1809545'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '486166'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '615869'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '630939'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1087395'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1726257'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1726266'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '830477'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1009456'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1000107'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1009459'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978715'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1653202'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '311040'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '351297'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1860167'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1670011'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1670021'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1994311'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847239'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '484322'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1858995'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847230'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '311041'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1604539'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '2002419'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847259'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '485210'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1654862'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847187'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1652639'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1926331'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '242120'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1652239'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '260265'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '259111'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '311048'
-- Choose one 1720878
-- Choose one 545289
-- Choose one 1232574
-- Choose one 311078
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '204445'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1720881'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '545293'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1251596'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '207035'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '207029'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1484963'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718970'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719231'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1743374'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847232'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '285018'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '847241'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '616238'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '753990'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '314097'
-- Choose one 213570
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718975'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736646'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736642'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736648'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '415379'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '251272'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '896872'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1865295'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719246'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '213442'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '311033'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '1653204'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '351926'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '977842'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1729091'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1593156'
-- Choose one 860192
-- Choose one 897366
-- Choose one 1726293
-- Choose one 213040
-- Choose one 1791721
-- Choose one 238013
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '312249'
-- Choose one 240906
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731538'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '836306'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731567'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731570'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '731564'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '207390'
-- Choose one 863538
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '204466'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '207391'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '745462'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '745560'
-- Choose one 745302
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '745309'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '995906'
-- Choose one 1791723
-- Choose one 207315
-- Choose one 204509
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '896856'
-- Choose one 1721690
-- Choose one 205913
-- Choose one 212219
-- Choose one 205918
-- Choose one 205922
-- Choose one 213475
-- Choose one 205924
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1670392'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '105648'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1484958'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1719243'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1731315'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '249220'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '311034'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '763141'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '763138'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736645'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736640'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1736647'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1994316'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1729086'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1859000'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1292879'
UPDATE vw_dose_unit SET administer_method = 'IM ONLY' WHERE form_rxcui = '1087391'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '978713'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1604544'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '2002420'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1670016'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1670023'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1488304'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1737559'
UPDATE vw_dose_unit SET administer_method = 'Subcut' WHERE form_rxcui = '795143'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '252016'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1365979'
-- Choose one 313578
-- Choose one 1593738
-- 901808
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '313650'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '582692'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1812593'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1812598'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1242136'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '901812'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1661335'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1732161'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1732165'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1732157'
UPDATE vw_dose_unit SET administer_method = 'Subcut ONLY' WHERE form_rxcui = '1860172'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1718996'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1720166'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '311683'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1652834'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1652830'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '2043308'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '2043312'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1992538'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1992536'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1652833'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '1652827'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '2043306'
UPDATE vw_dose_unit SET administer_method = 'IM' WHERE form_rxcui = '2043311'
UPDATE vw_dose_unit SET administer_method = 'IV' WHERE form_rxcui = '1722719'
-- 1442605
-- 706943
