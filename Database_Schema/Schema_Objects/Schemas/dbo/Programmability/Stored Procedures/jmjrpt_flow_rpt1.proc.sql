

CREATE PROCEDURE jmjrpt_flow_rpt1
	@ps_cpr_id varchar(12)
	,@ps_observation_id varchar(24)
AS
Declare @cpr_id varchar(12)
Declare @observation_id varchar(24)
Declare @mycount Integer
Declare @recorddate varchar(10),@UOM varchar(40), @result_value varchar(80)

Select @cpr_id = @ps_cpr_id
Select @observation_id = @ps_observation_id
CREATE TABLE ##jmc_flow1 (RecordDate DATETIME,descrip varchar(41),UOM varchar(40) NULL,result_value varchar(80) NULL) ON [PRIMARY]

Select distinct Ordered,treat,Order_Date,Report_Date,Results,UM
FROM dbo.##jmc_flow1
Group by Ordered,treat,Order_Date,Report_Date,Results,UM
order by Ordered asc,Order_Date desc
DEALLOCATE get_tests
drop table dbo.##jmc_flow1