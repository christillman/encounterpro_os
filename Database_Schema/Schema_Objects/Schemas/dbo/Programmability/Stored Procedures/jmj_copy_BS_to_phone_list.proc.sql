CREATE PROCEDURE jmj_copy_BS_to_phone_list
AS
--This script converts BARTON Schmitt into TelephoneTriage.    
--After running this script you may need to set the rooms in the 
--two Telephone Encounter workplans.

UPDATE c_menu_item
SET menu_item = 'TelephoneTriage'
WHERE menu_item = 'BARTON'

UPDATE c_menu_item_attribute
SET value = 'TelephoneTriage'
WHERE value = 'BARTON'

UPDATE c_workplan_item
SET ordered_treatment_type = 'TelephoneTriage'
WHERE ordered_treatment_type = 'BARTON'

UPDATE c_workplan_item_attribute
SET value = 'TelephoneTriage'
WHERE value = 'BARTON'

UPDATE c_treatment_type
SET status = 'NA'
WHERE treatment_type = 'BARTON'

UPDATE c_treatment_type
SET status = 'OK'
WHERE treatment_type = 'TelephoneTriage'

UPDATE c_treatment_type_list
SET treatment_type = 'TelephoneTriage'
WHERE treatment_type = 'BARTON'

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'DEMO13165'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = 'DEMO13165')

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'DEMO14203'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = 'DEMO14203')

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'0^22738'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = '0^22738')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$FP'
	,'TEST_TelephoneTriage'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = 'DEMO14203')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$FP'
	,'TEST_TelephoneTriage'
	,'Call Information'
	,'0^22738'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = '0^22738')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$PEDS'
	,'TEST_TelephoneTriage'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = 'DEMO14203')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$PEDS'
	,'TEST_TelephoneTriage'
	,'Call Information'
	,'0^22738'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = '0^22738')

UPDATE c_menu_item
SET button = 'button_phone_large.bmp'
WHERE button = 'button_barton_schmitt.bmp'

UPDATE o_rooms
SET default_encounter_type = 'PHONE1'
WHERE default_encounter_type = 'BartonSchmittProvide'

UPDATE o_rooms
SET default_encounter_type = 'PHONE'
WHERE default_encounter_type = 'BartonSchmitt'

UPDATE p_treatment_item
SET treatment_type = 'TelephoneTriage'
WHERE treatment_type = 'BARTON'

