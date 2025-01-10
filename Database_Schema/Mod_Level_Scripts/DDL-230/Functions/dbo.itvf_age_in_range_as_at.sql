-------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[itvf_age_in_range_as_at]
Print 'Drop Function [dbo].[itvf_age_in_range_as_at]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[itvf_age_in_range_as_at]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[itvf_age_in_range_as_at]
GO

-- Create Function [dbo].[itvf_age_in_range_as_at]
Print 'Create Function [dbo].[itvf_age_in_range_as_at]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.itvf_age_in_range_as_at (
	@pl_age_from int,
	@ps_age_from_unit_id varchar(24),
	@pl_age_to int,
	@ps_age_to_unit_id varchar(24),
	@pdt_birth_date datetime,
	@pdt_as_at_date datetime)

RETURNS TABLE
RETURN
/* Refactor fn_age_range_compare as inline tvf, avoiding query of age_range table 
	Also needed because the @@ROWCOUNT function doesn't = 1 for a valid id, 
	unless the row is already in the cache; causing a NULL return
	*/
SELECT
	from_compare.cmp_value as from_compare,
	CASE WHEN  @pl_age_to IS NULL OR @ps_age_to_unit_id IS NULL
	-- If the upper bound is null then there is no limit
		THEN -1
	ELSE to_compare.cmp_value
	END as to_compare,
	CASE WHEN from_compare.cmp_value < 0 THEN -1 -- age as at is below the minimum of the range
			WHEN CASE WHEN  @pl_age_to IS NULL OR @ps_age_to_unit_id IS NULL
				-- If the upper bound is null then there is no limit
					THEN -1
				ELSE to_compare.cmp_value
				END >= 0 THEN 1 -- age as at is above the maximum of the range
		ELSE 0 END -- age as at is within the range
	AS is_in_range
FROM dbo.itvf_interval_compare(@pl_age_from, @ps_age_from_unit_id, @pdt_birth_date, @pdt_as_at_date) as from_compare
	CROSS APPLY dbo.itvf_interval_compare(@pl_age_to, @ps_age_to_unit_id, @pdt_birth_date, @pdt_as_at_date) as to_compare

GO
GRANT SELECT
	ON [dbo].[itvf_age_in_range_as_at]
	TO [cprsystem]
GO
/*
-- 	@pl_age_from,@ps_age_from_unit_id,@pl_age_to,@ps_age_to_unit_id,@pdt_birth_date,@pdt_as_at_date
select *, dbo.fn_age_range_compare(117,'2001-01-01','2002-01-01') 
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2001-01-01','2002-01-01')
union all
select *, dbo.fn_age_range_compare(117,'2001-01-01','2002-12-31') 
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2001-01-01','2002-12-31')
union all
select *, dbo.fn_age_range_compare(117,'2001-01-01','2003-01-01')  
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2001-01-01','2003-01-01')
union all
select *, dbo.fn_age_range_compare(117,'2001-01-01','2004-12-31')  
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2001-01-01','2004-12-31')
union all
select *, dbo.fn_age_range_compare(117,'2001-01-01','2005-01-01')  
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2001-01-01','2005-01-01')
union all
select *, dbo.fn_age_range_compare(117,'2005-01-01','2005-01-01')  
from dbo.itvf_age_in_range_as_at (2,'year',4,'year','2005-01-01','2005-01-01')

select *, dbo.fn_age_range_compare(158,'2001-01-01','2001-01-14')
from dbo.itvf_age_in_range_as_at (0,'day',15,'day','2001-01-01','2001-01-14')
union all
select *, dbo.fn_age_range_compare(158,'2001-01-01','2001-01-15') 
from dbo.itvf_age_in_range_as_at (0,'day',15,'day','2001-01-01','2001-01-15')
union all
select *, dbo.fn_age_range_compare(158,'2001-01-01','2001-01-16') 
from dbo.itvf_age_in_range_as_at (0,'day',15,'day','2001-01-01','2001-01-16')


select *, dbo.fn_age_range_compare(300,'2001-01-01','2005-11-30')  
from dbo.itvf_age_in_range_as_at (0,'month',59,'month','2001-01-01','2005-11-30')
union all
select *, dbo.fn_age_range_compare(300,'2001-01-01','2005-12-01')  
from dbo.itvf_age_in_range_as_at (0,'month',59,'month','2001-01-01','2005-12-01')
union all
select *, dbo.fn_age_range_compare(300,'2005-01-01','2005-12-02')  
from dbo.itvf_age_in_range_as_at (0,'month',59,'month','2005-01-01','2005-12-02')

select *, dbo.fn_age_range_compare(32,'2001-01-01','2005-11-30')  
from dbo.itvf_age_in_range_as_at (0,'year',null,null,'2001-01-01','2005-11-30')
union all
select *, dbo.fn_age_range_compare(32,'2001-01-01','2000-12-01')  
from dbo.itvf_age_in_range_as_at (0,'year',null,null,'2001-01-01','2000-12-01')
union all
select *, dbo.fn_age_range_compare(32,'2001-01-01','2405-12-02') 
from dbo.itvf_age_in_range_as_at (0,'year',null,null,'2005-01-01','2405-12-02')

select *, dbo.fn_age_range_compare(106,'2001-01-01','2005-11-30')  
from dbo.itvf_age_in_range_as_at (1,'day',null,null,'2001-01-01','2005-11-30')
union all
select *, dbo.fn_age_range_compare(106,'2001-01-01','2000-12-01')  
from dbo.itvf_age_in_range_as_at (1,'day',null,null,'2001-01-01','2000-12-01')
union all
select *, dbo.fn_age_range_compare(106,'2001-01-01','2405-12-02') 
from dbo.itvf_age_in_range_as_at (1,'day',null,null,'2005-01-01','2405-12-02')

select *, dbo.fn_age_range_compare(197,'2001-01-01','2001-01-01')  
from dbo.itvf_age_in_range_as_at (1,'day',6,'year','2001-01-01','2001-01-01')
union all
select *, dbo.fn_age_range_compare(197,'2001-01-01','2001-01-02')  
from dbo.itvf_age_in_range_as_at (1,'day',6,'year','2001-01-01','2001-01-02')
union all
select *, dbo.fn_age_range_compare(197,'2001-01-01','2006-12-31') 
from dbo.itvf_age_in_range_as_at (1,'day',6,'year','2001-01-01','2006-12-31')
union all
select *, dbo.fn_age_range_compare(197,'2001-01-01','2007-01-01') 
from dbo.itvf_age_in_range_as_at (1,'day',6,'year','2001-01-01','2007-01-01')
union all
select *, dbo.fn_age_range_compare(197,'2001-01-01','2007-01-02') 
from dbo.itvf_age_in_range_as_at (1,'day',6,'year','2001-01-01','2007-01-02')

*/
