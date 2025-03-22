
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[itvf_date_add_interval]
Print 'Drop Function [dbo].[itvf_date_add_interval]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[itvf_date_add_interval]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[itvf_date_add_interval]
GO

-- Create Function [dbo].[itvf_date_add_interval]
Print 'Create Function [dbo].[itvf_date_add_interval]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.itvf_date_add_interval (
	@pdt_date datetime,
	@pl_interval_amount int,
	@ps_interval_unit varchar(24))

RETURNS TABLE 
-- optimized from dbo.fn_date_add_interval
RETURN
SELECT CASE WHEN @pl_interval_amount IS NULL OR @ps_interval_unit IS NULL
	THEN @pdt_date
ELSE
	CASE LEFT(@ps_interval_unit, 3)
				WHEN 'YEA' THEN dateadd(year, @pl_interval_amount, @pdt_date)
				WHEN 'MON' THEN dateadd(month, @pl_interval_amount, @pdt_date)
				WHEN 'WEE' THEN dateadd(week, @pl_interval_amount, @pdt_date)
				WHEN 'DAY' THEN dateadd(day, @pl_interval_amount, @pdt_date)
				WHEN 'HOU' THEN dateadd(hour, @pl_interval_amount, @pdt_date)
				WHEN 'MIN' THEN dateadd(minute, @pl_interval_amount, @pdt_date)
				WHEN 'SEC' THEN dateadd(second, @pl_interval_amount, @pdt_date)
	ELSE @pdt_date END 
END as adjusted_date

GO
GRANT SELECT
	ON [dbo].[itvf_date_add_interval]
	TO [cprsystem]
GO
