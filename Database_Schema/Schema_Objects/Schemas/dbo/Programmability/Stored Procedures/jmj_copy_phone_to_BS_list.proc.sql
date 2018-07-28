CREATE PROCEDURE jmj_copy_phone_to_BS_list
AS
--This script adds a Barton Telephone type to a site that is also using the regular telephone rooms.
--Note that you also need to hand-copy and paste Barton records from u_top 20 in older sites.

INSERT INTO c_menu_item
(
	menu_id,
	menu_item_type,
	menu_item,
	button_title,
	button,
	sort_sequence
)

SELECT 
	menu_id,
	menu_item_type,
	'BARTON',
	'Pick Barton',
	button,
	sort_sequence

FROM c_menu_item


WHERE menu_item = 'TelephoneTriage'
AND menu_item_type = 'TREATMENT_TYPE'


UPDATE c_menu_item
SET button = 'button_barton_schmitt.bmp'
WHERE menu_item = 'BARTON'
AND button = 'button_phone_large.bmp'



UPDATE c_treatment_type
SET status = 'OK'
WHERE treatment_type = 'BARTON'

INSERT INTO c_treatment_type_list

(	
	treatment_list_id,
	treatment_type
)

SELECT
	treatment_list_id,
	'BARTON'

FROM c_treatment_type_list

WHERE treatment_type = 'TelephoneTriage'
and treatment_list_id in ('!COMPOSITE','SINGLE','PICKLABS')




UPDATE c_treatment_type
SET status = 'OK'
WHERE treatment_type = 'BARTON'



INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'BARTON'
	,'BARTON'
	,'DEMO13165'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'BARTON'
AND observation_id = 'DEMO13165')

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'BARTON'
	,'BARTON'
	,'DEMO14203'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'BARTON'
AND observation_id = 'DEMO14203')



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
	,'TEST_BARTON'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_BARTON'
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
	,'TEST_BARTON'
	,'Telephone Call Message'
	,'DEMO13165'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_BARTON'
AND item_id = 'DEMO13165')


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
	,'TEST_BARTON'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_BARTON'
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
	,'TEST_BARTON'
	,'Telephone Call Message'
	,'DEMO13165'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_BARTON'
AND item_id = 'DEMO13165')


INSERT INTO u_chart_selection
(
	chart_id
	,specialty_id
	,workplan_id
	,sort_sequence
)

SELECT distinct
	22
	,'$PEDS'
	,1723
	,6

FROM u_chart_selection
WHERE NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 22 AND specialty_id = '$PEDS' AND workplan_id = 1723)
AND NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 1000022 AND specialty_id = '$PEDS' AND workplan_id = 1001723)


INSERT INTO u_chart_selection
(
	chart_id
	,specialty_id
	,workplan_id
	,sort_sequence
)

SELECT distinct
	22
	,'$PEDS'
	,1789
	,6

FROM u_chart_selection
WHERE NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 22 AND specialty_id = '$PEDS' AND workplan_id = 1789)
AND NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 1000022 AND specialty_id = '$PEDS' AND workplan_id = 1001789)


INSERT INTO u_chart_selection
(
	chart_id
	,specialty_id
	,workplan_id
	,sort_sequence
)

SELECT distinct
	33
	,'$FP'
	,1723
	,6

FROM u_chart_selection
WHERE NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 33 AND specialty_id = '$FP' AND workplan_id = 1723)
AND NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 1000033 AND specialty_id = '$FP' AND workplan_id = 1001723)


INSERT INTO u_chart_selection
(
	chart_id
	,specialty_id
	,workplan_id
	,sort_sequence
)

SELECT distinct
	33
	,'$FP'
	,1789
	,6

FROM u_chart_selection
WHERE NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 33 AND specialty_id = '$FP' AND workplan_id = 1789)
AND NOT EXISTS (SELECT workplan_id from u_chart_selection
WHERE chart_id = 1000033 AND specialty_id = '$FP' AND workplan_id = 1001789)



UPDATE c_workplan
SET description = 'Barton Schmitt Telephone Encounter WP Local'
WHERE description = 'Barton Schmitt Telephone Encounter WP'
AND owner_id > 1

UPDATE c_workplan
SET status = 'NA'
WHERE description = 'Barton Schmitt Telephone Encounter WP Local'

UPDATE c_workplan_selection
SET workplan_id = 1723
WHERE workplan_id = 1001723

UPDATE u_chart_selection
SET workplan_id = 1723
WHERE workplan_id = 1001723

UPDATE u_chart_selection
SET chart_id = 33
WHERE chart_id = 1000033

UPDATE u_chart_selection
SET chart_id = 22
WHERE chart_id = 1000022



INSERT INTO o_rooms
(
	room_id
	,room_name
	,room_sequence
	,room_type
	,office_id
	,status
	,default_encounter_type
)

SELECT	distinct
	'BARTON'
	,'Barton Schmitt'
	,900
	,'$TELEPHONE'
	,'0001'
	,'OK'
	,'BartonSchmittProvide'

FROM o_rooms

WHERE not exists
(select room_name from o_rooms where room_name like '%Barton%')


INSERT INTO o_group_rooms
(	
	group_id
	,room_id
)

SELECT distinct
	group_id
	,'BARTON'

FROM o_group_rooms
WHERE group_id = (select group_id where room_id like '%PHONE%')
and not exists (select room_id from o_group_rooms where room_id = 'BARTON')
	
	

INSERT INTO c_encounter_type
(
	encounter_type
	,description
	,sort_order
	,bill_flag
	,default_indirect_flag
	,status
	,close_encounter_workplan_id
)

SELECT 	distinct
	'BartonSchmittProvide'
	,'Barton Schmitt Provider-Initiated Call'
	,1
	,'N'
	,'I'
	,'OK'
	,1326

FROM c_encounter_type
WHERE NOT EXISTS (SELECT encounter_type FROM
c_encounter_type WHERE encounter_type = 'BartonSchmittProvide')


INSERT INTO c_workplan_selection
(	
	encounter_type
	,workplan_id
	,search_order
)

SELECT 	distinct
	'BartonSchmittProvide'
	,1789
	,1

FROM c_workplan_selection WHERE NOT exists (SELECT encounter_type FROM
c_workplan_selection WHERE encounter_type = 'BartonSchmittProvide')

UPDATE c_workplan
SET status = 'OK'
WHERE workplan_id = 1692

