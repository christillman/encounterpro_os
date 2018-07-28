/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 7/25/2000 8:43:38 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 2/16/99 12:00:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 10/26/98 2:20:30 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 10/4/98 6:28:04 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 9/24/98 3:05:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_location    Script Date: 8/17/98 4:16:36 PM ******/
CREATE PROCEDURE sp_delete_location (
	@ps_location varchar(24))
AS
UPDATE c_Location
SET	status = 'NA'
WHERE	location = @ps_location

