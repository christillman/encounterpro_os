
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_growth_percentile]
Print 'Drop Procedure [dbo].[sp_growth_percentile]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_growth_percentile]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_growth_percentile]
GO

-- Create Procedure [dbo].[sp_growth_percentile]
Print 'Create Procedure [dbo].[sp_growth_percentile]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_growth_percentile (
	@ps_measurement varchar(12),
	@ps_sex char(1),
	@pi_age_months smallint,
	@pr_value real,
	@pr_percentile real OUTPUT)
AS
DECLARE @lr_percentile_5 real
DECLARE @lr_percentile_10 real
DECLARE @lr_percentile_25 real
DECLARE @lr_percentile_50 real
DECLARE @lr_percentile_75 real
DECLARE @lr_percentile_90 real
DECLARE @lr_percentile_95 real

SELECT @lr_percentile_5 = percentile_5 ,
	@lr_percentile_10 = percentile_10 ,
	@lr_percentile_25 = percentile_25 , 	
	@lr_percentile_50 = percentile_50 ,
	@lr_percentile_75 = percentile_75 ,
	@lr_percentile_90 = percentile_90 ,
	@lr_percentile_95 = percentile_95  
FROM c_Growth_Data (NOLOCK)
WHERE	measurement = @ps_measurement
AND	sex = @ps_sex
AND	age_months = @pi_age_months

IF @lr_percentile_5 IS NULL
	BEGIN
	RAISERROR ('Percentile not found (%s, %s, %d)',16,-1, @ps_measurement, @ps_sex, @pi_age_months)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @pr_value < @lr_percentile_5
	BEGIN
	IF @pr_value < @lr_percentile_5 + @lr_percentile_5 - @lr_percentile_10
		SELECT @pr_percentile = 1
	ELSE
		SELECT @pr_percentile = 3
	END
ELSE IF @pr_value < @lr_percentile_10
	SELECT @pr_percentile = 5 + (5 * (@pr_value - @lr_percentile_5)/(@lr_percentile_10 - @lr_percentile_5))
ELSE IF @pr_value < @lr_percentile_25
	SELECT @pr_percentile = 10 + (15 * (@pr_value - @lr_percentile_10)/(@lr_percentile_25 - @lr_percentile_10))
ELSE IF @pr_value < @lr_percentile_50
	SELECT @pr_percentile = 25 + (25 * (@pr_value - @lr_percentile_25)/(@lr_percentile_50 - @lr_percentile_25))
ELSE IF @pr_value < @lr_percentile_75
	SELECT @pr_percentile = 50 + (25 * (@pr_value - @lr_percentile_50)/(@lr_percentile_75 - @lr_percentile_50))
ELSE IF @pr_value < @lr_percentile_90
	SELECT @pr_percentile = 75 + (15 * (@pr_value - @lr_percentile_75)/(@lr_percentile_90 - @lr_percentile_75))
ELSE IF @pr_value <= @lr_percentile_95
	SELECT @pr_percentile = 90 + (5 * (@pr_value - @lr_percentile_90)/(@lr_percentile_95 - @lr_percentile_90))
ELSE IF @pr_value > @lr_percentile_95 + @lr_percentile_95 - @lr_percentile_90
	SELECT @pr_percentile = 99
ELSE
	SELECT @pr_percentile = 97

GO
GRANT EXECUTE
	ON [dbo].[sp_growth_percentile]
	TO [cprsystem]
GO

