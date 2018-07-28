CREATE PROCEDURE sp_set_patient_folder_selection
AS


-- msc  Removed functionality because this sp is called from the "Finished" button of the Folder
-- configuration screen, and it's causing our customer specific folder selection records
-- to disappear.

/*
DELETE c_Folder_Selection
WHERE context_object = 'Patient'

INSERT INTO c_Folder_Selection (
	context_object,
	folder,
	auto_select_flag,
	sort_sequence)
SELECT 'Patient',
	folder,
	'N',
	sort_sequence
FROM c_Folder
*/


