
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_comm_disease]
Print 'Drop Procedure [dbo].[jmjrpt_comm_disease]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_comm_disease]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_comm_disease]
GO

-- Create Procedure [dbo].[jmjrpt_comm_disease]
Print 'Create Procedure [dbo].[jmjrpt_comm_disease]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_comm_disease
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @mycount integer
Declare @name varchar(52),@descrip varchar(40)
Declare @last_name varchar(30),@first_name varchar(20)
Declare @DOB datetime
Declare @billing_id varchar(24)
Declare @icd_9_code varchar(12)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date

RAISERROR ('jmjrpt_comm_disease has not been converted to ICD10', 16, -1)
Declare my_cursor Cursor Local FAST_FORWARD For
Select  ca.icd_9_code,
	ca.description,
       pat.last_name,
       pat.first_name,
       pat.billing_id,
       pat.date_of_birth
FROM p_assessment pa (NOLOCK)
     JOIN c_assessment_definition ca (NOLOCK) ON pa.assessment_id = ca.assessment_id
     JOIN p_patient pat (NOLOCK) ON pa.cpr_id = pat.cpr_id
Where pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
	AND (ca.icd_9_code In ('071','482.2','038.41','041.5','033.0','042','501','008.43','099.0','099.41','099.5','483.1','007.4','061','065.4','064','323.4','323.5','323.6','008.0','038.42','041.4','482.82','647.1','030.8','030.9','079.81','283.11','795.71','482.84','027.0','088.81','072.2','V82.5','026.1','087.9','056','771.0','002.0','004','004.9','011','502','082.0','038.0','320.2','420.99','511.1','511.0','097.9','771.3','037','978.4','124','008.44')       
         OR ca.icd_9_code LIKE '001%'
         OR ca.icd_9_code LIKE '005%'
         OR ca.icd_9_code LIKE '006%'
         OR ca.icd_9_code LIKE '020%'
	 OR ca.icd_9_code LIKE '021%'
     OR ca.icd_9_code LIKE '022%'
 	 OR ca.icd_9_code LIKE '023%'
     OR ca.icd_9_code LIKE '032%'
	 OR ca.icd_9_code LIKE '036%'	
     OR ca.icd_9_code LIKE '045%'
	 OR ca.icd_9_code LIKE '050%'
	 OR ca.icd_9_code LIKE '052%'
     OR ca.icd_9_code LIKE '055%'
	 OR ca.icd_9_code LIKE '060%'
     OR ca.icd_9_code LIKE '065%'
     OR ca.icd_9_code LIKE '070%'
     OR ca.icd_9_code LIKE '080%'
     OR ca.icd_9_code LIKE '081%'
     OR ca.icd_9_code LIKE '082%'
	 OR ca.icd_9_code LIKE '084%'
     OR ca.icd_9_code LIKE '320%')
     AND pa.cpr_id not in (select cpr_id from p_assessment where assessment_status = 'CANCELLED')
Order by ca.description,pat.last_name,pat.first_name


Create Table #comm_disease (
            [id] [int] IDENTITY (1, 1) NOT NULL ,
            [icd_9_code] [varchar] (12) NULL , 
            [descrip] [varchar] (40) NULL, 
            [pat_name] [varchar]  (40) NULL ,
            [billing_id] [varchar] (24)  NULL ,
            [dob] [datetime] NULL 
) ON [PRIMARY]


SELECT @mycount =  (Select count(*)
FROM p_assessment pa (NOLOCK)
     JOIN c_assessment_definition ca (NOLOCK) ON pa.assessment_id = ca.assessment_id
WHERE pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
	AND (ca.icd_9_code In ('071','482.2','038.41','041.5','033.0','042','501','008.43','099.0','099.41','099.5','483.1','007.4','061','065.4','064','323.4','323.5','323.6','008.0','038.42','041.4','482.82','647.1','030.8','030.9','079.81','283.11','795.71','482.84','027.0','088.81','072.2','V82.5','026.1','087.9','056','771.0','002.0','004','004.9','011','502','082.0','038.0','320.2','420.99','511.1','511.0','097.9','771.3','037','978.4','124','008.44')       
    OR ca.icd_9_code LIKE '001%'
    OR ca.icd_9_code LIKE '005%'
    OR ca.icd_9_code LIKE '006%'
    OR ca.icd_9_code LIKE '020%'
	OR ca.icd_9_code LIKE '021%'
    OR ca.icd_9_code LIKE '022%'
 	OR ca.icd_9_code LIKE '023%'
    OR ca.icd_9_code LIKE '032%'
	OR ca.icd_9_code LIKE '036%'	
    OR ca.icd_9_code LIKE '045%'
	OR ca.icd_9_code LIKE '050%'
	OR ca.icd_9_code LIKE '052%'
    OR ca.icd_9_code LIKE '055%'
	OR ca.icd_9_code LIKE '060%'
    OR ca.icd_9_code LIKE '065%'
    OR ca.icd_9_code LIKE '070%'
    OR ca.icd_9_code LIKE '080%'
    OR ca.icd_9_code LIKE '081%'
    OR ca.icd_9_code LIKE '082%'
	OR ca.icd_9_code LIKE '084%'
    OR ca.icd_9_code LIKE '320%')
    AND pa.cpr_id not in (select cpr_id from p_assessment where assessment_status = 'CANCELLED'))
If @mycount > 0 
 Begin
  OPEN my_cursor
  While @mycount > 0
   Begin
    Fetch Next From my_cursor INTO
    @icd_9_code,@descrip,@last_name,@first_name,@billing_id,@DOB
    select @name = @last_name + ', ' + @first_name
    Insert into #comm_disease values (@icd_9_code,@descrip,@name,@billing_id,@DOB)
    Select @mycount = @mycount - 1
   End
  Close my_cursor 
 End

Select  icd_9_code As ICD_9,
	descrip As Description,
        pat_name As Name,
	billing_id As Billing_id,
	Convert(varchar(10),dob,101) As DOB
From  #comm_disease
DROP Table #comm_disease
DEALLOCATE my_cursor

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_comm_disease]
	TO [cprsystem]
GO

