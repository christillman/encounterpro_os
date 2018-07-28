CREATE PROCEDURE sp_folder_workplan
	(
	@ps_folder varchar(40)
	)
AS

DECLARE @ll_sort_sequence int,
	@ll_workplan_sequence int

SELECT @ll_sort_sequence = min(sort_sequence)
FROM c_Folder_Workplan
WHERE folder = @ps_folder

IF @ll_sort_sequence IS NULL
	SELECT @ll_workplan_sequence = min(workplan_sequence)
	FROM c_Folder_Workplan
	WHERE folder = @ps_folder
ELSE
	SELECT @ll_workplan_sequence = min(workplan_sequence)
	FROM c_Folder_Workplan
	WHERE folder = @ps_folder
	AND sort_sequence = @ll_sort_sequence

RETURN @ll_workplan_sequence

