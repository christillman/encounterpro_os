
DELETE FROM o_log
where log_date_time < dateadd(month,-9,getdate())

DELETE FROM [o_Event_Queue]

DELETE s
FROM c_Workplan_Step s
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan w
	WHERE w.workplan_id = s.workplan_id)

DELETE a
FROM c_Workplan_Item_Attribute a
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan_Item i
	WHERE a.workplan_id = i.workplan_id
	AND a.item_number = i.item_number)

EXECUTE jmjsys_Check_Equivalence

DELETE
FROM c_config_object_version
WHERE owner_id = 0
AND (objectdata IS NULL OR datalength(objectdata) = 0)

;with most_recent as (
	select config_object_id, max(version) as last_version
	from c_config_object_version
	group by config_object_id
	)
DELETE v
from c_config_object_version v
join most_recent r on r.config_object_id = v.config_object_id
	and v.version < r.last_version

DELETE
FROM c_config_object_version
WHERE owner_id = 0
AND (objectdata IS NULL OR datalength(objectdata) = 0)

DELETE v
FROM c_Config_Object_Version v
	INNER JOIN c_Database_Status d
	ON v.owner_id = d.customer_id
WHERE (v.objectdata IS NULL OR datalength(v.objectdata) = 0)
AND v.status = 'CheckedIn'

DELETE from c_Patient_Material
where title like 'EncounterPRO OS Schema - Mod Level 20%'
or title like 'EncounterPRO OS Schema - Mod Level 21%'


;with most_recent as (
	select component_id, max(version) as last_version
	from c_component_version
	group by component_id
	)
DELETE v
from c_component_version v
join most_recent r on r.component_id = v.component_id
	and v.version < r.last_version

DELETE from c_component_version
where description = 'SureScripts Prescriber Registration'
