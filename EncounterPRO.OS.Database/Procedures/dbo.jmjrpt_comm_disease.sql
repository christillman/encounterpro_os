--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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

Declare my_cursor Cursor Local FAST_FORWARD For
Select  ca.icd_9_code,
	ca.description,
       pat.last_name,
       pat.first_name,
       pat.billing_id,
       pat.date_of_birth
FROM p_assessment pa (NOLOCK),
     c_assessment_definition ca (NOLOCK),
     p_patient pat (NOLOCK)
Where pa.cpr_id = pat.cpr_id
AND pa.assessment_id = ca.assessment_id
	AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
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
FROM p_assessment pa (NOLOCK),
     c_assessment_definition ca (NOLOCK)
WHERE
	pa.assessment_id = ca.assessment_id
	AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
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

