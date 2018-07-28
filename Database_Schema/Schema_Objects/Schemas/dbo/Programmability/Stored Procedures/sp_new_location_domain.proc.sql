/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 7/25/2000 8:44:15 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 2/16/99 12:01:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 10/26/98 2:20:45 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 10/4/98 6:28:17 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 9/24/98 3:06:11 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_location_domain    Script Date: 8/17/98 4:16:51 PM ******/
CREATE PROCEDURE sp_new_location_domain (
	@ps_location_domain varchar(12) OUTPUT,
	@ps_description varchar(80) )
AS
DECLARE @ll_key_value integer
EXECUTE sp_get_next_key
	@ps_cpr_id = '!CPR',
	@ps_key_id = 'LOCATION_DOMAIN',
	@pl_key_value = @ll_key_value OUTPUT
SELECT @ps_location_domain = office_id + ltrim(rtrim(convert(varchar(6),@ll_key_value)))
FROM o_Office
WHILE exists(select * from c_Location_Domain where location_domain = @ps_location_domain)
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'LOCATION_DOMAIN',
		@pl_key_value = @ll_key_value OUTPUT
	SELECT @ps_location_domain = office_id + ltrim(rtrim(convert(varchar(6),@ll_key_value)))
	FROM o_Office
	END
INSERT INTO c_Location_Domain (
	location_domain,
	description)
VALUES (
	@ps_location_domain,
	@ps_description )

