CREATE TRIGGER tr_c_Encounter_Type_insert ON dbo.c_Encounter_Type
FOR INSERT
AS

INSERT INTO c_encounter_type_progress_type (
    encounter_type
    ,progress_type
    ,display_flag
    ,progress_key_required_flag
    ,progress_key_enumerated_flag )
 SELECT i.encounter_type
        ,d.domain_item
        ,'Y'
        ,'N'
        ,d.domain_item_description
FROM inserted i
	CROSS JOIN c_domain d
WHERE d.domain_id = 'Auto_Enc_Progress_Type'

INSERT INTO c_encounter_type_progress_key (
    encounter_type
    ,progress_type
    ,progress_key
    ,sort_sequence )
SELECT i.encounter_type
    ,d.domain_item
    ,d.domain_item_description
    ,d.domain_sequence
FROM inserted i
	CROSS JOIN c_domain d
WHERE d.domain_id = 'Auto_Enc_Progress_Key'


