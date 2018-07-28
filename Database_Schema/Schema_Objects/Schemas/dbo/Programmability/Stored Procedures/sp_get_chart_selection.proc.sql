/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 7/25/2000 8:43:41 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 2/16/99 12:00:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 10/26/98 2:20:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 10/4/98 6:28:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 9/24/98 3:05:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chart_selection    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_chart_selection (
	@ps_user_id varchar(24),
	@pl_workplan_id int,
	@pl_chart_id int OUTPUT)
AS
DECLARE @li_count smallint,
	@ll_workplan_id int
SELECT @li_count = count(*),
	@ll_workplan_id = min(workplan_id),
	@pl_chart_id = min(chart_id)
FROM u_Chart_Selection
WHERE user_id = @ps_user_id
AND (workplan_id is null OR workplan_id = @pl_workplan_id)
IF @li_count = 1
	RETURN
ELSE IF @li_count > 1
	IF @ll_workplan_id IS NULL
		SELECT @pl_chart_id = chart_id
		FROM u_Chart_Selection
		WHERE user_id = @ps_user_id
		AND workplan_id is null
	ELSE
		SELECT @pl_chart_id = chart_id
		FROM u_Chart_Selection
		WHERE user_id = @ps_user_id
		AND workplan_id = @pl_workplan_id

