
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_observation_update]
Print 'Drop Trigger [dbo].[tr_c_observation_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_observation_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_observation_update]
GO

-- Create Trigger [dbo].[tr_c_observation_update]
Print 'Create Trigger [dbo].[tr_c_observation_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_observation_update ON dbo.c_Observation
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

-- If the perform location domain changes, then remove the result/location
-- pair from all standard exams.
DELETE u_Exam_Default_Results
FROM inserted
JOIN deleted ON inserted.observation_id = deleted.observation_id
JOIN u_Exam_Default_Results ON inserted.observation_id = u_Exam_Default_Results.observation_id
WHERE inserted.perform_location_domain <> deleted.perform_location_domain

IF UPDATE(last_updated)
	BEGIN
	IF (SELECT count(*) FROM inserted) > 0
		UPDATE t
		SET last_updated = i.last_updated
		FROM c_Observation_Tree as t
			JOIN inserted as i
				ON t.child_observation_id = i.observation_id
	END
ELSE
	BEGIN
	UPDATE o
	SET last_updated = dbo.get_client_datetime()
	FROM c_Observation as o
		JOIN inserted as i
			ON o.observation_id = i.observation_id
	END


DECLARE @ls_updated_by varchar(24)

SELECT @ls_updated_by = min(updated_by)
FROM inserted

EXECUTE sp_table_update @ps_table_name = 'c_Observation', @ps_updated_by = @ls_updated_by

UPDATE e
SET object_key = o.observation_id,
	description = ISNULL(o.description, '<No Description>')
FROM c_Equivalence e
	INNER JOIN inserted o
	ON e.object_id = o.id

GO

