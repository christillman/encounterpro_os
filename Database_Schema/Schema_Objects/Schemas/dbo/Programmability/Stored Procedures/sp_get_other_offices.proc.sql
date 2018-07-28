/****** Object:  Stored Procedure dbo.sp_get_other_offices    Script Date: 7/25/2000 8:43:49 AM ******/
CREATE PROCEDURE sp_get_other_offices
	@ps_office_id varchar(4)
AS
SELECT	office_id,
	description,
	status,
	server,
	dbname,
	dbms
FROM c_Office WITH (NOLOCK)
WHERE office_id <> @ps_office_id
AND status = 'OK'
AND server IS NOT NULL

