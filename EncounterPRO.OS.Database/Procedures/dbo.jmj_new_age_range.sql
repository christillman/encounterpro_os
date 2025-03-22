
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_age_range]
Print 'Drop Procedure [dbo].[jmj_new_age_range]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_age_range]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_age_range]
GO

-- Create Procedure [dbo].[jmj_new_age_range]
Print 'Create Procedure [dbo].[jmj_new_age_range]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_age_range (
	@ps_age_range_category varchar(24),
	@ps_description varchar(40),
	@pl_age_from int,
	@ps_age_from_unit varchar(24),
	@pl_age_to int,
	@ps_age_to_unit varchar(24),
	@pl_age_range_id int OUTPUT
	)
AS

-- This stored procedure creates a local copy of the specified age_range and returns the new age_range_id
DECLARE @ll_customer_id int
SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @pl_age_range_id = min(age_range_id)
FROM c_age_range
WHERE age_range_category = @ps_age_range_category
AND ISNULL(age_from, -99) = ISNULL(@pl_age_from, -99)
AND ISNULL(age_from_unit, '!NULL') = ISNULL(@ps_age_from_unit, '!NULL')
AND ISNULL(age_to, -99) = ISNULL(@pl_age_to, -99)
AND ISNULL(age_to_unit, '!NULL') = ISNULL(@ps_age_to_unit, '!NULL')

IF @@ERROR <> 0
	RETURN -1

IF @pl_age_range_id > 0
	RETURN @pl_age_range_id

INSERT INTO dbo.c_Age_Range (
	age_range_category
	,description
	,age_from
	,age_from_unit
	,age_to
	,age_to_unit
	,owner_id
	,status)
VALUES (
	@ps_age_range_category,	
	@ps_description,
	@pl_age_from,
	@ps_age_from_unit,
	@pl_age_to,
	@ps_age_to_unit,
	@ll_customer_id,
	'OK')

IF @@ERROR <> 0
	RETURN

SET @pl_age_range_id = SCOPE_IDENTITY()

RETURN @pl_age_range_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_age_range]
	TO [cprsystem]
GO

