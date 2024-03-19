DROP PROCEDURE IF EXISTS [jmjrpt_days_bills_bydoc]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

GO
CREATE PROCEDURE [jmjrpt_days_bills_bydoc] @ps_userid varchar(24), @ps_encounter_date varchar(10)
AS
Declare @user_id varchar(24)
Declare @ls_cpr_id varchar(12)
Declare @li_encounter_id integer
Declare @billing_id varchar(24),@last_name varchar(40),@first_name varchar(20)
Declare @pat_name varchar(40)
Declare @encounterdate datetime
Declare @dischargedate datetime
Declare @mycount integer
Declare @mycount2 integer
Select @encounterdate = @ps_encounter_date
Select @user_id = @ps_userid
Declare my_daily_curse Insensitive CURSOR for
SELECT	pe.cpr_id,
	    pe.encounter_id,
        p.billing_id,
        p.last_name,
        p.first_name,
        pe.discharge_date
	FROM p_Patient_Encounter pe (NOLOCK)
	JOIN p_patient p (NOLOCK) ON p.cpr_id = pe.cpr_id
	WHERE 
	bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND DATEDIFF(day, encounter_date, @encounterdate) = 0
    AND (pe.attending_doctor = @user_id)
    order by encounter_date

CREATE TABLE ##c_bill_Tree_Table (
            [id] [int] IDENTITY (1, 1) NOT NULL ,
            [encounter_date] datetime NULL, 
            [encounter_id] integer NULL, 
            [billing_id] [varchar] (24)  NULL ,
            [pat_name] [varchar]   (40) NULL ,
            [icd_9_code] [varchar] (12) NULL ,
            [cpt_code] [varchar] (24) NULL ,
            [modifier] [varchar] (2) NULL , 
            [charge] [money]  NULL ,
            [discharge_date] [datetime] NULL
) ON [PRIMARY]

SELECT @mycount =  (Select count(*)
       FROM p_Patient_Encounter (NOLOCK)
       WHERE 
       bill_flag = 'Y'
       AND encounter_status = 'CLOSED'
       AND (attending_doctor = @user_id)
       AND DATEDIFF(day, encounter_date, @encounterdate) = 0)
If @mycount > 0
 BEGIN
 Open my_daily_curse 
  WHILE @mycount > 0
   BEGIN
    
    FETCH NEXT FROM my_daily_curse
       into @ls_cpr_id,@li_encounter_id,@billing_id,@last_name,@first_name,@dischargedate
    Select @mycount = @mycount - 1 
    Select @pat_name = @last_name + ', ' + @first_name
    SELECT @mycount2 =  (Select count(*)
		FROM v_Encounter_Assessment_Charge v
		WHERE cpr_id = @ls_cpr_id
			AND encounter_id = @li_encounter_id
			AND assessment_billing_id is null
			AND eac_bill_flag = 'Y'
			AND pea_bill_flag = 'Y'
			AND ec_bill_flag = 'Y' 
			AND NOT EXISTS (SELECT 1
				FROM p_Assessment a2
				WHERE a2.cpr_id = v.cpr_id
				AND a2.problem_id = v.problem_id
				AND a2.diagnosis_sequence > v.diagnosis_sequence)
		)
    If @mycount2 > 0 
      BEGIN
      EXEC jmjrpt_get_bill_coding @ls_cpr_id, @li_encounter_id, @billing_id, @mycount2, @pat_name,@encounterdate,@dischargedate
      END
    END
   Close my_daily_curse 
  END
  
Select distinct
       billing_id As Billing_ID,
       pat_name As Name,
       icd_9_code AS ICD_9,
       cpt_code AS CPT,
       modifier AS Modifier,
       charge AS Charge,
       discharge_date AS Discharged
FROM ##c_bill_Tree_Table
group by encounter_date,billing_id,pat_name,icd_9_code,cpt_code,modifier,charge,discharge_date
order by pat_name

DROP Table ##c_bill_Tree_Table
DEALLOCATE my_daily_curse


GRANT EXECUTE ON [jmjrpt_days_bills_bydoc] TO [cprsystem] AS [dbo]




GO


