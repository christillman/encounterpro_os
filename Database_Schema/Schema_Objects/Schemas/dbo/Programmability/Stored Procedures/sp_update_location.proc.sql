/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 7/25/2000 8:44:13 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 2/16/99 12:01:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 10/26/98 2:20:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 10/4/98 6:28:25 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 9/24/98 3:06:19 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_location    Script Date: 8/17/98 4:17:01 PM ******/
CREATE PROCEDURE sp_update_location (
	@ps_location varchar(24),
	@pi_sort_sequence smallint,
	@ps_diffuse_flag char(1) )
AS
UPDATE c_Location
SET	sort_sequence = @pi_sort_sequence,
	diffuse_flag = @ps_diffuse_flag
WHERE	location = @ps_location

