
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[itvf_interval_compare]
Print 'Drop Function [dbo].[itvf_interval_compare]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[itvf_interval_compare]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[itvf_interval_compare]
GO

-- Create Function [dbo].[itvf_interval_compare]
Print 'Create Function [dbo].[itvf_interval_compare]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.itvf_interval_compare (
	@pl_interval_amount int,
	@ps_interval_unit varchar(24),
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS TABLE
-- optimized from fn_interval_compare
RETURN
-- Clear out any time values with convert(datetime, convert(varchar,@x, 112)

SELECT
CASE WHEN convert(datetime, convert(varchar,@pdt_end_date, 112)) < end_date.adjusted_date
	THEN -1

WHEN convert(datetime, convert(varchar,@pdt_end_date, 112)) = end_date.adjusted_date
	THEN 0

WHEN convert(datetime, convert(varchar,@pdt_end_date, 112)) > end_date.adjusted_date
	THEN 1
END as cmp_value
FROM dbo.itvf_date_add_interval(convert(datetime, convert(varchar,@pdt_begin_date, 112)), @pl_interval_amount, @ps_interval_unit) as end_date


GO
GRANT SELECT
	ON [dbo].[itvf_interval_compare]
	TO [cprsystem]
GO

