-- Modify Dosage Forms for consistency with RXNORM

DELETE FROM [c_Dosage_Form] 
WHERE rxcui is not null 
and default_dose_amount is null
and abbreviation = ''
-- 84

INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Auto-Injector', 'Auto-Injector', '', '1649570')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Buccal Film', 'Buccal Film', '', '858080')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Buccal Tablet', 'Buccal Tablet', '', '970789')
UPDATE [c_Dosage_Form] SET rxcui = '1649572' WHERE [dosage_form] = 'Cartridge'
UPDATE [c_Dosage_Form] SET rxcui = '91058' WHERE [dosage_form] = 'Chew Tab'
UPDATE [c_Dosage_Form] SET rxcui = '402499' WHERE [dosage_form] = 'Gum'
UPDATE [c_Dosage_Form] SET rxcui = '316995' WHERE [dosage_form] = 'DR Caps'
UPDATE [c_Dosage_Form] SET rxcui = '10312' WHERE [dosage_form] = 'DR Tabs'
UPDATE [c_Dosage_Form] SET rxcui = '316942' WHERE [dosage_form] = 'DS Tabs' -- Disintegrating Oral Tablet
UPDATE [c_Dosage_Form] SET rxcui = '479172' WHERE [dosage_form] = 'Douche'
UPDATE [c_Dosage_Form] SET rxcui = '657710' WHERE [dosage_form] = 'Implant'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('DryPwdrInhaler', 'Dry Powder Inhaler', '', '744995')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Effervescent', 'Effervescent Oral Tablet', '', '1535727')
UPDATE [c_Dosage_Form] SET rxcui = '317678' WHERE [dosage_form] = 'Enema'
UPDATE [c_Dosage_Form] SET rxcui = '316943' WHERE [dosage_form] = 'ER Caps'
UPDATE [c_Dosage_Form] SET rxcui = '316945' WHERE [dosage_form] = 'ER Tabs'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('ER Suspension', 'Extended Release Suspension', '', '316946')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Gas Inhalation', 'Gas for Inhalation', '', '316999')
UPDATE [c_Dosage_Form] SET rxcui = '1540453' WHERE [dosage_form] = 'Granules'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('GranuleOralSusp', 'Granules for Oral Suspension', '', '1540454')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Inhalant Powder', 'Inhalant Powder', '', '317000')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Inhalant Soln', 'Inhalant Solution', '', '346161')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Injectable Foam', 'Injectable Foam', '', '1484929')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Injectable Soln', 'Injectable Solution', '', '316949')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Injectable Susp', 'Injectable Suspension', '', '316950')
UPDATE [c_Dosage_Form] SET rxcui = '1540453' WHERE [dosage_form] = 'Granules'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Intraperitoneal', 'Intraperitoneal Solution', '', '316951')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Intratracheal', 'Intratracheal Suspension', '', '1732876')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Intrauterine', 'Intrauterine System', '', '1856271')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Irrigation Soln', 'Irrigation Solution', '', '152903')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Jet Injector', 'Jet Injector', '', '1649573')
UPDATE [c_Dosage_Form] SET rxcui = '316954' WHERE [dosage_form] = 'Soap'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Liquid Soap', 'Medicated Liquid Soap', '', '316955')
UPDATE [c_Dosage_Form] SET rxcui = '797271' WHERE [dosage_form] = 'Pads'
UPDATE [c_Dosage_Form] SET rxcui = '1792831' WHERE [dosage_form] = 'Patch'
UPDATE [c_Dosage_Form] SET rxcui = '106332' WHERE [dosage_form] = 'Shampoo'
UPDATE [c_Dosage_Form] SET rxcui = '797685' WHERE [dosage_form] = 'Tape'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Metered Inhaler', 'Metered Dose Inhaler', '', '721654')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('MeterNasalSpray', 'Metered Dose Nasal Spray', '', '1797831')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Mouthwash', 'Mouthwash', '', '7067')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Mucosal Spray', 'Mucosal Spray', '', '346163')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('MucousMemSoln', 'Mucous Membrane Topical Solution', '', '316956')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Nasal Gel', 'Nasal Gel', '', '316960')
UPDATE [c_Dosage_Form] SET rxcui = '316959' WHERE [dosage_form] = 'Inhaler'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Nasal Ointment', 'Nasal Ointment', '', '316961')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Nasal Powder', 'Nasal Powder', '', '1739329')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Nasal Solution', 'Nasal Solution', '', '316962')
UPDATE [c_Dosage_Form] SET rxcui = '126542' WHERE [dosage_form] = 'Nasal Spray'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Ophthalmic Gel', 'Ophthalmic Gel', '', '316963')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Ophthalmic Irri', 'Ophthalmic Irrigation Solution', '', '244286')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Ophthalmic Oint', 'Ophthalmic Ointment', '', '91344')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Ophthalmic Soln', 'Ophthalmic Solution', '', '7670')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Ophthalmic Susp', 'Ophthalmic Suspension', '', '316964')
UPDATE [c_Dosage_Form] SET rxcui = '316965' WHERE [dosage_form] = 'Cap'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Cream', 'Oral Cream', '', '316966')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Flakes', 'Oral Flakes', '', '316947')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Foam', 'Oral Foam', '', '346284')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Gel', 'Oral Gel', '', '346169')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Granules', 'Oral Granules', '', '317690')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Lozenge', 'Oral Lozenge', '', '316992')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Ointment', 'Oral Ointment', '', '346288')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Paste', 'Oral Paste', '', '346171')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Powder', 'Oral Powder', '', '346289')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Solution', 'Oral Solution', '', '316968')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Spray', 'Oral Spray', '', '346164')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Strip', 'Oral Strip', '', '704866')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Suspension', 'Oral Suspension', '', '316969')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Tab Sensor', 'Oral Tablet with Sensor', '', '1998426')
UPDATE [c_Dosage_Form] SET rxcui = '317541' WHERE [dosage_form] = 'Tab'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Oral Wafer', 'Oral Wafer', '', '316989')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Otic Solution', 'Otic Solution', '', '316973')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Otic Suspension', 'Otic Suspension', '', '316974')
UPDATE [c_Dosage_Form] SET rxcui = '746839' WHERE [dosage_form] = 'Packet'
UPDATE [c_Dosage_Form] SET rxcui = '402496' WHERE [dosage_form] = 'Paste'
UPDATE [c_Dosage_Form] SET rxcui = '1649571' WHERE [dosage_form] = 'Pens'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Pwdr Nasal Soln', 'Powder for Nasal Solution', '', '1540452')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Pwdr Oral Soln', 'Powder for Oral Solution', '', '1540455')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Pwdrr Oral Susp', 'Powder for Oral Suspension', '', '1540456')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Powder Spray', 'Powder Spray', '', '317004')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Prefilled Appl', 'Prefilled Applicator', '', '757352')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Prefilled Syrg', 'Prefilled Syringe', '', '721656')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Cream', 'Rectal Cream', '', '316975')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Foam', 'Rectal Foam', '', '317542')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Gel', 'Rectal Gel', '', '346170')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Ointment', 'Rectal Ointment', '', '317005')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Solution', 'Rectal Solution', '', '317006')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Spray', 'Rectal Spray', '', '316977')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Rectal Suppos', 'Rectal Suppository', '', '316978')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Sublingual Pwdr', 'Sublingual Powder', '', '1810682')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Sublingual Tab', 'Sublingual Tablet', '', '317007')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('TabletOralSusp', 'Tablet for Oral Suspension', '', '1861409')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Toothpaste', 'Toothpaste', '', '10652')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Cream', 'Topical Cream', '', '316982')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Foam', 'Topical Foam', '', '346285')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Gel', 'Topical Gel', '', '346286')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('TopicalLiquGas', 'Topical Liquefied Gas', '', '1788820')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Lotion', 'Topical Lotion', '', '316983')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Oil', 'Topical Oil', '', '316984')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('TopicalOintment', 'Topical Ointment', '', '316985')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Powder', 'Topical Powder', '', '317009')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Soln', 'Topical Solution', '', '316986')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Spray', 'Topical Spray', '', '346165')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Topical Susp', 'Topical Suspension', '', '1649353')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Transdermal Sys', 'Transdermal System', '', '316987')
UPDATE [c_Dosage_Form] SET rxcui = '317543' WHERE [dosage_form] = 'Urethral Suppos'
UPDATE [c_Dosage_Form] SET rxcui = '11103' WHERE [dosage_form] = 'Vag Cream'
UPDATE [c_Dosage_Form] SET rxcui = '11108' WHERE [dosage_form] = 'Vag Gel'
UPDATE [c_Dosage_Form] SET rxcui = '337840' WHERE [dosage_form] = 'Vaginal Suppos'
UPDATE [c_Dosage_Form] SET rxcui = '11110' WHERE [dosage_form] = 'Vag Tabs'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Vaginal Film', 'Vaginal Film', '', '1788819')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Vaginal Foam', 'Vaginal Foam', '', '11107')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Vaginal Oint', 'Vaginal Ointment', '', '317010')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[abbreviation],rxcui) VALUES ('Vaginal Ring', 'Vaginal Ring', '', '11109')

-- select * from [c_Dosage_Form]
