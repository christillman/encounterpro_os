/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 7/25/2000 8:43:42 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 2/16/99 12:00:45 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 10/26/98 2:20:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 10/4/98 6:28:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 9/24/98 3:05:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_convertable_units    Script Date: 8/17/98 4:16:38 PM ******/
CREATE PROCEDURE sp_get_convertable_units (
	@ps_unit_id varchar(12) )
AS
SELECT	c_Unit.unit_id,
	c_Unit.description,
	selected_flag = 0
FROM	c_Unit_Conversion (NOLOCK),
	c_Unit (NOLOCK)
WHERE c_Unit_Conversion.unit_from = c_Unit.unit_id
AND c_Unit_Conversion.unit_to = @ps_unit_id
UNION
SELECT	c_Unit.unit_id,
	c_Unit.description,
	selected_flag = 0
FROM	c_Unit_Conversion (NOLOCK),
	c_Unit (NOLOCK)
WHERE c_Unit_Conversion.unit_to = c_Unit.unit_id
AND c_Unit_Conversion.unit_from = @ps_unit_id
UNION
SELECT	unit_id,
	description,
	selected_flag = 0
FROM c_Unit (NOLOCK)
WHERE unit_id = @ps_unit_id

