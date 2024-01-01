
-- Reapply whenever imports / updates from RXNORM
-- These have multiple ingredients stated in non-standard way
UPDATE c_Drug_Formulation 
SET form_descr = 'camphor 3 % / menthol 1.25 % Medicated Patch'
WHERE form_rxcui = '968694'

UPDATE c_Drug_Formulation 
SET form_descr = 'insulin lispro protamine 75 % / insulin lispro 25 % Injectable Suspension'
WHERE form_rxcui = '259111'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin lispro protamine 50 % / insulin lispro 50 % Injectable Suspension'
WHERE form_rxcui = '260265'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin, human isophane 70 % / insulin regular 30 % Injectable Suspension'
WHERE form_rxcui = '311048'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin aspart protamine 70 % / insulin aspart 30 % Injectable Suspension'
WHERE form_rxcui = '351297'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin aspart protamine 70 % / insulin aspart 30 % in 3 ML Pen Injector'
WHERE form_rxcui = '847191'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin lispro protamine 50 % / insulin lispro 50 % in 3 ML Pen Injector'
WHERE form_rxcui = '847211'
UPDATE c_Drug_Formulation 
SET form_descr = 'insulin lispro protamine 75 % / insulin lispro 25 % in 3 ML Pen Injector'
WHERE form_rxcui = '847252'

UPDATE c_Drug_Formulation 
SET form_descr = 'penicillin G benzathine 600,000 UNT / penicillin G procaine 600,000 UNT in 2 ML Prefilled Syringe'
WHERE form_rxcui = '731538'
UPDATE c_Drug_Formulation 
SET form_descr = 'penicillin G benzathine 900,000 UNT / penicillin G procaine 300,000 UNT in 2 ML Prefilled Syringe'
WHERE form_rxcui = '836306'

-- crashes the app when chosen, EPSign not available
  DELETE FROM [c_Component_Registry]
  WHERE [component_id] = 'DOC_JMJ_Signature'