/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 7/25/2000 8:43:52 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 2/16/99 12:00:53 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 10/26/98 2:20:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 10/4/98 6:28:11 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 9/24/98 3:06:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_resource    Script Date: 8/17/98 4:16:45 PM ******/
CREATE PROCEDURE sp_get_resource (
	@ps_resource varchar(24),
	@ps_encounter_type varchar(24) OUTPUT,
	@ps_new_flag char(1) OUTPUT,
	@ps_user_id varchar(24) OUTPUT )
AS
SELECT @ps_encounter_type = encounter_type,
	@ps_new_flag = new_flag,
	@ps_user_id = user_id
FROM b_Resource
WHERE resource = @ps_resource
IF @@ROWCOUNT = 0
	SELECT @ps_encounter_type = null,
		@ps_new_flag = null,
		@ps_user_id = null

