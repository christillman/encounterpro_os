
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_age_date]
Print 'Drop Procedure [dbo].[sp_get_age_date]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_age_date]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_age_date]
GO

-- Create Procedure [dbo].[sp_get_age_date]
Print 'Create Procedure [dbo].[sp_get_age_date]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_get_age_date (
	@pdt_from_date datetime,
	@pl_add_number int,
	@ps_add_unit varchar(12),
	@pdt_date datetime OUTPUT)
AS
IF @ps_add_unit = 'DAY'
	SELECT @pdt_date = dateadd(day, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = 'WEEK'
	SELECT @pdt_date = dateadd(week, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = 'MONTH'
	SELECT @pdt_date = dateadd(month, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = 'YEAR'
	SELECT @pdt_date = dateadd(year, @pl_add_number, @pdt_from_date)

GO
GRANT EXECUTE
	ON [dbo].[sp_get_age_date]
	TO [cprsystem]
GO

