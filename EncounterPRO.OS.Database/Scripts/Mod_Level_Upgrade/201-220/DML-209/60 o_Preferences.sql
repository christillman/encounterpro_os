
INSERT INTO [dbo].[o_Preferences]
           ([preference_type]
           ,[preference_level]
           ,[preference_key]
           ,[preference_id]
           ,[preference_value])
SELECT 'MEDICATION','Global','Global','Formulation List','Single'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM [o_Preferences] p2
	WHERE p2.[preference_id] = 'Formulation List')

