CREATE PROCEDURE sp_get_objects (
	@ps_cpr_id varchar(12),
	@pdt_begin_date datetime,
	@pdt_end_date datetime)
AS

DECLARE @objects TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[object_key] [int] NOT NULL ,
	[description] [varchar] (255) NULL ,
	[first_touched] [datetime] NOT NULL ,
	[last_touched] [datetime] NULL )
	
SELECT 
	cpr_id ,
	context_object ,
	object_key ,
	max(description) as description ,
	min(progress_created) as first_touched,
	max(progress_created) as last_touched
FROM dbo.fn_patient_object_progress(@ps_cpr_id, @pdt_begin_date, @pdt_end_date)
GROUP BY cpr_id ,
	context_object ,
	object_key


