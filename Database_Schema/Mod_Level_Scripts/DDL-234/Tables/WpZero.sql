IF (
select count(*) from p_Patient_WP
where patient_workplan_id = 0) = 0
INSERT INTO [p_Patient_WP]
           ([cpr_id]
           ,[workplan_id]
           ,[workplan_type]
           ,[description]
           ,[ordered_by]
           ,[status]
           ,[created_by])
     VALUES
           (0
           ,0
           ,'General'
           ,'Generic Workplan'
           ,'#SYSTEM'
           ,'Current'
           ,'#SYSTEM'
		   )
GO