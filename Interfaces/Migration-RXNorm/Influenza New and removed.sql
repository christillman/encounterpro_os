/*
-- brand name vaccines
select distinct 'exec sp_add_rxnorm_drug 0, ''' 
	+ fb.form_rxcui + ''', '''
	+ fb.form_descr + ''', '''
	+ b.brand_name + ''', '''
	+ b.brand_name_rxcui + ''', '''
	+ g.generic_rxcui + ''', '''
	+ fg.form_rxcui + ''', '''
	+ fg.form_descr + ''', '''
	+ g.generic_name + ''', '''
	+ 'Vaccine''' -- select *
 from c_Drug_Formulation fb
JOIN c_Drug_Brand b ON b.brand_name_rxcui = fb.ingr_rxcui
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
JOIN c_Drug_Formulation fg ON fg.form_rxcui = fb.generic_form_rxcui
WHERE fb.form_tty IN ('SBD','SBD_PSN')
and (fb.form_descr like '%vaccine%' or fg.form_descr like '%vaccine%')
and not exists (select 1 
	from Form_Brand b where b.form_rxcui = fb.form_rxcui)
*/

exec sp_add_rxnorm_drug 0, '2050059', 'HEPLISAV-B 20 MCG in 0.5 ML Prefilled Syringe', 'Heplisav-B', '1994348', '797752', '2050057', 'hepatitis B surface antigen vaccine 20 MCG in 0.5 ML Prefilled Syringe', 'Hepatitis B Surface Antigen Vaccine', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2106334', 'TDVAX vaccine 0.5 mL Injection', 'Tdvax', '2106330', '1007589', '205259', 'tetanus toxoid vaccine, inactivated 2 UNT / diphtheria toxoid vaccine, inactivated (Td) 2 UNT in 0.5 ML Injection', 'diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177398', 'FLUARIX QUADRIVALENT 2019-2020 vaccine 0.5 mL Prefilled Syringe', 'Fluarix Quadrivalent 2019-2020', '2177394', '2177392', '2177393', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177495', 'Fluzone Quadrivalent 2019-2020 vaccine 0.5 mL Prefilled Syringe', 'Fluzone Quadrivalent 2019-2020', '2177491', '2177392', '2177393', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177500', 'Fluzone Quadrivalent 2019-2020 vaccine 0.5 mL Injection', 'Fluzone Quadrivalent 2019-2020', '2177491', '2177392', '2177498', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Injection', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177504', 'Fluzone Quadrivalent 2019-2020 vaccine 0.25 mL Prefilled Syringe', 'Fluzone Quadrivalent 2019-2020', '2177491', '2177392', '2177503', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.25 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177592', 'Fluzone Quadrivalent 2019-2020 vaccine Injectable Suspension', 'Fluzone Quadrivalent 2019-2020', '2177491', '2177392', '2177590', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) Injectable Suspension', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177697', 'Fluzone 2019-2020 high-dose vaccine 0.5 mL Prefilled Syringe', 'Fluzone 2019-2020', '2177693', '1657138', '2177692', 'influenza virus vaccine 2019-2020 high-dose (trivalent - Brisbane/Kansas/Maryland) 0.5 mL Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177794', 'FLULAVAL QUADRIVALENT 2019-2020 vaccine Injectable Suspension', 'Flulaval Quadrivalent 2019-2020', '2177790', '2177392', '2177590', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) Injectable Suspension', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2177797', 'FLULAVAL QUADRIVALENT 2019-2020 vaccine 0.5 mL Prefilled Syringe', 'Flulaval Quadrivalent 2019-2020', '2177790', '2177392', '2177393', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2178093', 'FLUBLOK QUADRIVALENT 2019-2020 vaccine 0.5 ML Prefilled Syringe', 'Flublok Quadrivalent 2019-2020', '2178082', '2177392', '2178091', 'influenza virus vaccine 2019-2020 (quadrivalent generic for Flublok - Brisbane/Kansas/Maryland/Phuket) 0.5 ML Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2178362', 'FLUAD 2019-2020 vaccine 0.5 mL Injection', 'Fluad 2019-2020', '2178358', '1657138', '2178357', 'influenza virus vaccine 2019-2020 (generic for Fluad- Brisbane/Kansas/Maryland) 0.5 ML Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2178785', 'Afluria Quadrivalent 2019-2020 vaccine 0.5 ML Prefilled Syringe', 'Afluria Quadrivalent 2019-2020', '2178781', '2177392', '2177393', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2178787', 'Afluria Quadrivalent 2019-2020 vaccine 0.25 ML Prefilled Syringe', 'Afluria Quadrivalent 2019-2020', '2178781', '2177392', '2177503', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.25 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2178789', 'Afluria Quadrivalent 2019-2020 vaccine Injectable Suspension', 'Afluria Quadrivalent 2019-2020', '2178781', '2177392', '2177590', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) Injectable Suspension', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2180406', 'FLUCELVAX Quadrivalent 2019-2020 vaccine 0.5 ML Prefilled Syringe', 'Flucelvax Quadrivalent 2019-2020', '2180402', '2180400', '2180401', 'influenza virus vaccine 2019-2020 (quadrivalent - Idaho/Indiana/Iowa/Singapore) 0.5 ML Prefilled Syringe', 'influenza A virus A/Idaho/07/2018 (H1N1) antigen / influenza A virus A/Indiana/08/2018 (H3N2) antigen / influenza B virus B/Iowa/06/2017 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2180411', 'FLUCELVAX Quadrivalent 2019-2020 vaccine Injectable Suspension', 'Flucelvax Quadrivalent 2019-2020', '2180402', '2180400', '2180409', 'influenza virus vaccine 2019-2020 (quadrivalent - Idaho/Indiana/Iowa/Singapore) Injectable Suspension', 'influenza A virus A/Idaho/07/2018 (H1N1) antigen / influenza A virus A/Indiana/08/2018 (H3N2) antigen / influenza B virus B/Iowa/06/2017 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2197703', 'dengvaxia tetravalent vaccine live 0.5 ML Injection', 'Dengvaxia', '2197691', '2197300', '2197701', 'dengue tetravalent vaccine live 0.5 mL Injection', 'dengue virus live antigen, CYD serotype 1 / dengue virus live antigen, CYD serotype 2 / dengue virus live antigen, CYD serotype 3 / dengue virus live antigen, CYD serotype 4', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2280756', 'Fluzone Quadrivalent 2020 Southern Hemisphere vaccine 0.5 ML Prefilled Syringe', 'Fluzone Quadrivalent 2020 Southern Hemisphere', '2280743', '2280741', '2280755', 'influenza virus vaccine 2020 (quadrivalent - Brisbane/South Australia/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/South Australia/34/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2281669', 'Fluzone Quadrivalent 2020 Southern Hemisphere vaccine Injectable Suspension', 'Fluzone Quadrivalent 2020 Southern Hemisphere', '2280743', '2280741', '2281668', 'influenza virus vaccine 2020 (quadrivalent - Brisbane/South Australia/Phuket/Washington) Injectable Suspension, southern hemisphere', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/South Australia/34/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2360588', 'MenQuadfi vaccine 0.5 ML Injection', 'Menquadfi', '2360584', '2360582', '2360583', 'meningococcal (groups A, C, Y and W-135) polysaccharide tetanus toxoid conjugate vaccine 0.5 ML Injection', 'Neisseria meningitidis serogroup A capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide tetanus toxoid protein conjugate vaccine', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2379638', 'FLUARIX QUADRIVALENT 2020-2021 vaccine 0.5 mL Prefilled Syringe', 'Fluarix Quadrivalent 2020-2021', '2379634', '2379632', '2379633', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2379736', 'FLULAVAL QUADRIVALENT 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Flulaval Quadrivalent 2020-2021', '2379732', '2379632', '2379633', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380581', 'Fluzone Quadrivalent 2020-2021 vaccine Injectable Suspension', 'Fluzone Quadrivalent 2020-2021', '2380577', '2379632', '2380576', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) Injectable Suspension', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380584', 'Fluzone Quadrivalent 2020-2021 vaccine 0.25 mL Prefilled Syringe', 'Fluzone Quadrivalent 2020-2021', '2380577', '2379632', '2380582', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.25 mL Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380588', 'Fluzone Quadrivalent 2020-2021 vaccine 0.5 mL Injection', 'Fluzone Quadrivalent 2020-2021', '2380577', '2379632', '2380586', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 mL Injection', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380591', 'Fluzone Quadrivalent 2020-2021 vaccine 0.5 mL Prefilled Syringe', 'Fluzone Quadrivalent 2020-2021', '2380577', '2379632', '2379633', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380600', 'Afluria Quadrivalent 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Afluria Quadrivalent 2020-2021', '2380596', '2380594', '2380595', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) 0.5 ML Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380604', 'Afluria Quadrivalent 2020-2021 vaccine 0.25 ML Prefilled Syringe', 'Afluria Quadrivalent 2020-2021', '2380596', '2380594', '2380603', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) 0.25 ML Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380607', 'Afluria Quadrivalent 2020-2021 vaccine Injectable Suspension', 'Afluria Quadrivalent 2020-2021', '2380596', '2380594', '2380605', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) Injectable Suspension', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380848', 'FLUCELVAX Quadrivalent 2020-2021 vaccine Injectable Suspension', 'Flucelvax Quadrivalent 2020-2021', '2380844', '2380842', '2380843', 'influenza virus vaccine 2020-2021 (quadrivalent - Delaware/Nebraska/Darwin/Singapore) Injectable Suspension', 'influenza A virus A/Delaware/39/2019 (H3N2) antigen / influenza A virus A/Nebraska/14/2019 (H1N1) antigen / influenza B virus B/Darwin/7/2019 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380851', 'FLUCELVAX Quadrivalent 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Flucelvax Quadrivalent 2020-2021', '2380844', '2380842', '2380849', 'influenza virus vaccine 2020-2021 (quadrivalent - Delaware/Nebraska/Darwin/Singapore) 0.5 ML Prefilled Syringe', 'influenza A virus A/Delaware/39/2019 (H3N2) antigen / influenza A virus A/Nebraska/14/2019 (H1N1) antigen / influenza B virus B/Darwin/7/2019 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2380863', 'FLUBLOK QUADRIVALENT 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Flublok Quadrivalent 2020-2021', '2380859', '2380857', '2380858', 'influenza virus vaccine 2020-2021 (quadrivalent generic for Flublok - Hawaii/Minnesota/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Hawaii/70/2019 (H1N1) antigen / influenza A virus A/Minnesota/41/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2381150', 'FLUAD 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Fluad 2020-2021', '2381146', '1657138', '2381145', 'influenza virus vaccine 2020-2021 (Hong Kong/Victoria/Victoria) 0.5 ML Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2382439', 'FLUAD Quadrivalent 2020-2021 vaccine 0.5 ML Prefilled Syringe', 'Fluad Quadrivalent 2020-2021', '2382435', '2380594', '2380595', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) 0.5 ML Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2383548', 'Fluzone Quadrivalent 2020-2021 high-dose vaccine 0.7 ML Prefilled Syringe', 'Fluzone Quadrivalent 2020-2021', '2380577', '2379632', '2383546', 'influenza virus vaccine 2020-2021 high-dose (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.7 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2389313', 'FluMist Quadrivalent, 2020-2021 Formula Nasal Spray', 'Flumist Quadrivalent 2020-2021', '2389314', '2389311', '2389317', 'influenza virus vaccine, 2020-2021 Quadrivalent Nasal Spray', 'influenza A virus A/Hawaii/66/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2479030', 'Fluzone Quadrivalent 2021 Southern Hemisphere vaccine Injectable Suspension', 'Fluzone Quadrivalent 2021 Southern Hemisphere', '2479031', '2479044', '2479043', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) Injectable Suspension', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2479038', 'Fluzone Quadrivalent 2021 Southern Hemisphere vaccine 0.25 mL Prefilled Syringe', 'Fluzone Quadrivalent 2021 Southern Hemisphere', '2479031', '2479044', '2479034', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) 0.25 mL Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 0, '2479041', 'Fluzone Quadrivalent 2021 Southern Hemisphere vaccine 0.5 mL Prefilled Syringe', 'Fluzone Quadrivalent 2021 Southern Hemisphere', '2479031', '2479044', '2479045', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) 0.5 mL Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'

/*
-- generic vaccines
select distinct 'exec sp_add_rxnorm_drug 1, ''' 
	+ 'x' + ''', '''
	+ 'x' + ''', '''
	+ 'No Brand Name' + ''', '''
	+ 'x' + ''', '''
	+ g.generic_rxcui + ''', '''
	+ fg.form_rxcui + ''', '''
	+ fg.form_descr + ''', '''
	+ g.generic_name + ''', '''
	+ 'Vaccine''' -- select *
 from c_Drug_Formulation fg
JOIN c_Drug_Generic g ON g.generic_rxcui = fg.ingr_rxcui
WHERE fg.form_tty IN ('SCD','SCD_PSN')
and fg.form_descr like '%vaccine%'
and fg.generic_form_rxcui IS NULL
and not exists (select 1 
	from Form_Generic fg_old where fg_old.form_rxcui = fg.form_rxcui)
*/

/*
No need, these will already be inserted by the brand_name inserrtions above
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '1657138', '2177692', 'influenza virus vaccine 2019-2020 high-dose (trivalent - Brisbane/Kansas/Maryland) 0.5 mL Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '1657138', '2178357', 'influenza virus vaccine 2019-2020 (generic for Fluad- Brisbane/Kansas/Maryland) 0.5 ML Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '1657138', '2381145', 'influenza virus vaccine 2020-2021 (Hong Kong/Victoria/Victoria) 0.5 ML Prefilled Syringe', 'influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2177392', '2177393', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2177392', '2177498', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.5 mL Injection', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2177392', '2177503', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) 0.25 mL Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2177392', '2177590', 'influenza virus vaccine 2019-2020 (quadrivalent - Brisbane/Kansas/Maryland/Phuket) Injectable Suspension', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2177392', '2178091', 'influenza virus vaccine 2019-2020 (quadrivalent generic for Flublok - Brisbane/Kansas/Maryland/Phuket) 0.5 ML Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kansas/14/2017 (H3N2) antigen / influenza B virus B/Maryland/15/2016 antigen / influenza B virus B/Phuket/3073/2013 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2180400', '2180401', 'influenza virus vaccine 2019-2020 (quadrivalent - Idaho/Indiana/Iowa/Singapore) 0.5 ML Prefilled Syringe', 'influenza A virus A/Idaho/07/2018 (H1N1) antigen / influenza A virus A/Indiana/08/2018 (H3N2) antigen / influenza B virus B/Iowa/06/2017 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2180400', '2180409', 'influenza virus vaccine 2019-2020 (quadrivalent - Idaho/Indiana/Iowa/Singapore) Injectable Suspension', 'influenza A virus A/Idaho/07/2018 (H1N1) antigen / influenza A virus A/Indiana/08/2018 (H3N2) antigen / influenza B virus B/Iowa/06/2017 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2197300', '2197701', 'dengue tetravalent vaccine live 0.5 mL Injection', 'dengue virus live antigen, CYD serotype 1 / dengue virus live antigen, CYD serotype 2 / dengue virus live antigen, CYD serotype 3 / dengue virus live antigen, CYD serotype 4', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2280741', '2280755', 'influenza virus vaccine 2020 (quadrivalent - Brisbane/South Australia/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/South Australia/34/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2280741', '2281668', 'influenza virus vaccine 2020 (quadrivalent - Brisbane/South Australia/Phuket/Washington) Injectable Suspension, southern hemisphere', 'influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/South Australia/34/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2360582', '2360583', 'meningococcal (groups A, C, Y and W-135) polysaccharide tetanus toxoid conjugate vaccine 0.5 ML Injection', 'Neisseria meningitidis serogroup A capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide tetanus toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide tetanus toxoid protein conjugate vaccine', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2379632', '2379633', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2379632', '2380576', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) Injectable Suspension', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2379632', '2380582', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.25 mL Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2379632', '2380586', 'influenza virus vaccine 2020-2021 (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.5 mL Injection', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2379632', '2383546', 'influenza virus vaccine 2020-2021 high-dose (quadrivalent - Guangdong-Maonan/Hong Kong/Phuket/Washington) 0.7 ML Prefilled Syringe', 'influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380594', '2380595', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) 0.5 ML Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380594', '2380603', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) 0.25 ML Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380594', '2380605', 'influenza virus vaccine 2020-2021 (quadrivalent - Hong Kong/Victoria/Phuket/Victoria) Injectable Suspension', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2454/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Victoria/705/2018 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380842', '2380843', 'influenza virus vaccine 2020-2021 (quadrivalent - Delaware/Nebraska/Darwin/Singapore) Injectable Suspension', 'influenza A virus A/Delaware/39/2019 (H3N2) antigen / influenza A virus A/Nebraska/14/2019 (H1N1) antigen / influenza B virus B/Darwin/7/2019 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380842', '2380849', 'influenza virus vaccine 2020-2021 (quadrivalent - Delaware/Nebraska/Darwin/Singapore) 0.5 ML Prefilled Syringe', 'influenza A virus A/Delaware/39/2019 (H3N2) antigen / influenza A virus A/Nebraska/14/2019 (H1N1) antigen / influenza B virus B/Darwin/7/2019 antigen / influenza B virus B/Singapore/INFTT-16-0610/2016 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2380857', '2380858', 'influenza virus vaccine 2020-2021 (quadrivalent generic for Flublok - Hawaii/Minnesota/Phuket/Washington) 0.5 ML Prefilled Syringe', 'influenza A virus A/Hawaii/70/2019 (H1N1) antigen / influenza A virus A/Minnesota/41/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2389311', '2389317', 'influenza virus vaccine, 2020-2021 Quadrivalent Nasal Spray', 'influenza A virus A/Hawaii/66/2019 (H1N1) antigen / influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2479044', '2479034', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) 0.25 mL Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2479044', '2479043', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) Injectable Suspension', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '2479044', '2479045', 'influenza virus vaccine 2021 (quadrivalent - Hong Kong/Victoria/Phuket/Washington) 0.5 mL Prefilled Syringe', 'influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/Victoria/2570/2019 (H1N1) antigen / influenza B virus B/Phuket/3073/2013 antigen / influenza B virus B/Washington/02/2019 antigen', 'Vaccine'
exec sp_add_rxnorm_drug 1, 'x', 'x', 'No Brand Name', 'x', '797752', '2050057', 'hepatitis B surface antigen vaccine 20 MCG in 0.5 ML Prefilled Syringe', 'Hepatitis B Surface Antigen Vaccine', 'Vaccine'
*/


-- To remove
/*
select distinct 'exec sp_remove_rxnorm_drug ''' 
	+ 'RXNB' + fb.ingr_rxcui + ''' -- ' + b.brand_name
from Form_Brand fb
join c_Drug_Brand b ON b.brand_name_rxcui = fb.ingr_rxcui
where fb.form_descr like '%201%'
and fb.form_descr like '%vaccine%'
and fb.form_tty IN ('SBD','SBD_PSN') 
and not exists (select 1 
	from c_Drug_Formulation f
where fb.form_rxcui = f.form_rxcui)
*/

exec sp_remove_rxnorm_drug 'RXNB1799102' -- Flulaval Quadrivalent 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1799119' -- Fluarix Quadrivalent 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1799399' -- Afluria 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1801071' -- Fluzone Quadrivalent 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1801078' -- Fluad 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1801153' -- Fluvirin 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1801179' -- Fluzone 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1803020' -- Flublok 2016-2017
exec sp_remove_rxnorm_drug 'RXNB1858959' -- Afluria Quadrivalent 2016-2017 Formula
exec sp_remove_rxnorm_drug 'RXNB1928303' -- Fluarix Quadrivalent 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928313' -- Fluzone Quadrivalent 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928325' -- Flulaval Quadrivalent 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928340' -- Fluzone 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928347' -- Flublok Quadrivalent 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928533' -- Flucelvax Quadrivalent 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928876' -- Flublok 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928961' -- Fluad 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1928970' -- Fluvirin 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1942128' -- Afluria 2017-2018
exec sp_remove_rxnorm_drug 'RXNB1942162' -- 1942162 Quadrivalent 2017-2018

/*
select distinct 'exec sp_remove_rxnorm_drug ''' 
	+ 'RXNG' + fg.ingr_rxcui + ''' -- ' + g.generic_name
from Form_Generic fg
join c_Drug_Generic g ON g.generic_rxcui = fg.ingr_rxcui
where fg.form_descr like '%201%'
and fg.form_descr like '%vaccine%'
and fg.form_tty IN ('SCD','SCD_PSN') 
and not exists (select 1 
	from c_Drug_Formulation f
where fg.form_rxcui = f.form_rxcui)
*/

exec sp_remove_rxnorm_drug 'RXNG1657138' -- influenza A virus (H1N1) antigen / influenza A virus (H3N2) antigen / influenza B virus antigen
exec sp_remove_rxnorm_drug 'RXNG1657333' -- influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Switzerland/9715293/2013 (H3N2) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1794433' -- influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1799108' -- influenza A virus A/Christchurch/16/2010 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1801605' -- influenza A virus A/Brisbane/10/2010 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza B virus B/Hong Kong/259/2010 antigen / influenza B virus B/Utah/9/2014 antigen
exec sp_remove_rxnorm_drug 'RXNG1801823' -- influenza A virus A/Bolivia/559/2013 (H1N1) antigen / influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1928301' -- influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1928311' -- influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Michigan/45/2015 (H1N1) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1928531' -- influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza A virus A/Singapore/GP2050/2015 (H3N2) antigen / influenza B virus B/Hong Kong/259/2010 antigen / influenza B virus B/Utah/9/2014 antigen
exec sp_remove_rxnorm_drug 'RXNG1942160' -- influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza B virus B/Brisbane/46/2015 antigen / influenza B virus B/Phuket/3073/2013 antigen
exec sp_remove_rxnorm_drug 'RXNG1946968' -- influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza A virus A/Slovenia/2903/2015 (H1N1) antigen / influenza B virus B/Brisbane/60/2008 antigen / influenza B virus B/Phuket/3073/2013 antigen