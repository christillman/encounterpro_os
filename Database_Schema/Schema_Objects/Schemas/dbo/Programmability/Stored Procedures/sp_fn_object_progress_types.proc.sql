CREATE PROCEDURE sp_fn_object_progress_types
AS

SELECT context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence
FROM dbo.fn_object_progress_types()


