/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 7/25/2000 8:43:52 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 2/16/99 12:00:52 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 10/26/98 2:20:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 10/4/98 6:28:11 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 9/24/98 3:06:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_service_list    Script Date: 8/17/98 4:16:44 PM ******/
CREATE PROCEDURE sp_get_procedure_service_list
AS
SELECT	service,
	description,
	button,
	selected_flag=0
FROM o_Service
WHERE service in ('ENCOUNTER', 'PROCEDURE', 'MEDICATION', 'TEST', 'IMMUNIZATION')

