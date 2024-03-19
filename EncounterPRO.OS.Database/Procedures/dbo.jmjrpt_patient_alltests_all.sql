DROP PROCEDURE IF EXISTS [jmjrpt_patient_alltests_all]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER OFF




GO

--drop table dbo.##temp_tests1
CREATE PROCEDURE [jmjrpt_patient_alltests_all]
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Declare @observation_id varchar(24)
Select @cpr_id = @ps_cpr_id
Declare @mycount integer
Declare @Ordered varchar(21)
Declare @Order_Date varchar(10)
Declare @report_Date varchar(10)
Declare @Treatment varchar(21)
Declare @Results varchar(120)
Declare @RV varchar(40)
Declare @UM varchar(21)
if exists (select * from dbo.sysobjects where
id = object_id(N'[##temp_tests1]') and 
OBJECTPROPERTY(id, N'IsTable')= 1) drop table ##temp_tests1

Create Table ##temp_tests1 (Ordered varchar(41) not null,Treat varchar(41),Order_Date varchar(10) not null,Report_Date varchar(10), Results varchar(121),UM varchar(10),t_treatment_id integer) ON [PRIMARY]

Declare get_tests Cursor LOCAL FAST_FORWARD FOR
Select observation_id 
from p_treatment_item (NOLOCK)
where cpr_id = @cpr_id 
and (observation_id is not null or observation_id = '') 
and Isnull(treatment_status,'Open') != 'CANCELLED' 
and treatment_type in ('LAB','TEST','BIOPSY','XRAY','EKG','TIMED_TEST','ECHO','NUCLEAR','MRI','CT') 
Order By p_treatment_item.created 

SELECT @mycount =  (Select count(*)
from p_treatment_item (NOLOCK)
where cpr_id = @cpr_id 
and (observation_id is not null or observation_id <> '') 
and Isnull(treatment_status,'Open') != 'CANCELLED' 
and treatment_type in ('LAB','TEST','BIOPSY','XRAY','EKG','TIMED_TEST','ECHO','NUCLEAR','MRI','CT')) 

If @mycount > 0
 BEGIN
 Open get_tests
  WHILE @mycount > 0
   BEGIN
    
    FETCH NEXT FROM get_tests
       into @observation_id
    Select @mycount = @mycount - 1 
    EXEC jmjrpt_patient_alltests_observation @cpr_id, @observation_id
   END
  END
Close get_tests 
Deallocate get_tests

Declare get_attachments Cursor LOCAL FAST_FORWARD FOR

Select substring(pt.treatment_description,1,21) AS Ordered
      ,convert(varchar(10),pt.begin_date,101) AS Order_Date
      ,convert(varchar(10),ptp.progress_date_time,101) AS Report_Date 
      ,ptp.progress_value AS Treatment
	,pt.treatment_id
from p_treatment_item pt (NOLOCK)
JOIN p_treatment_progress ptp (NOLOCK) ON ptp.cpr_id = pt.cpr_id
where pt.cpr_id = @cpr_id 
and (observation_id is null or observation_id = '') 
and Isnull(pt.treatment_status,'Open') != 'CANCELLED' 
and treatment_type in ('LAB','TEST','BIOPSY','XRAY','EKG','TIMED_TEST','ECHO','NUCLEAR','MRI','CT') 
and ptp.progress_type = 'ATTACHMENT'
Order By pt.created 

Declare @treatment_id integer
SELECT @mycount =  (Select count(*)
from p_treatment_item pt2 (NOLOCK)
JOIN p_treatment_progress ptp2 (NOLOCK) ON ptp2.cpr_id = pt2.cpr_id
where pt2.cpr_id = @cpr_id 
and (observation_id is null or observation_id = '') 
and ISNULL(pt2.treatment_status,'Open') != 'CANCELLED' 
and treatment_type in ('LAB','TEST','BIOPSY','XRAY','EKG','TIMED_TEST','ECHO','NUCLEAR','MRI','CT') 
and ptp2.progress_type = 'ATTACHMENT' )

Open get_attachments
 WHILE @mycount > 0
   BEGIN
   FETCH NEXT FROM get_attachments
   into @Ordered,@Order_Date,@Report_Date,@Treatment,@treatment_id
   Select @mycount = @mycount - 1
   INSERT INTO ##temp_tests1 
       VALUES(@Ordered,@Treatment,@Order_Date,@Report_Date,null,null,@treatment_id) 	
   END
Close get_attachments



Select distinct Ordered,treat,Order_Date,Report_Date,Results,UM,t_treatment_id AS TreatID
FROM ##temp_tests1
Group by Ordered,treat,Order_Date,Report_Date,Results,UM,t_treatment_id
order by Order_Date asc,Ordered asc,t_treatment_id asc
drop table ##temp_tests1

GRANT EXECUTE ON [jmjrpt_patient_alltests_all] TO [cprsystem] AS [dbo]


GO


