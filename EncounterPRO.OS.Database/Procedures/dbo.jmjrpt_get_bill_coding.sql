
-- Drop Procedure [dbo].[jmjrpt_get_bill_coding]
Print 'Drop Procedure [dbo].[jmjrpt_get_bill_coding]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_bill_coding]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[jmjrpt_get_bill_coding]
GO

-- Create Procedure [dbo].[jmjrpt_get_bill_coding]
Print 'Create Procedure [dbo].[jmjrpt_get_bill_coding]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjrpt_get_bill_coding] @ps_cpr_id varchar(12), @pi_encounter_id integer, @ps_billing_id varchar(24), @pi_count integer, @ps_name varchar(40), @pdt_encounterdate datetime, @pdt_dischargedate datetime
AS
Declare @ls_cpr_id varchar(12)
Declare @li_encounter_id integer
Declare @billing_id varchar(24)
Declare @pat_name varchar(40)
Declare @mycount2 integer
Declare @mycount3 integer
Declare @encounterdate datetime
Declare @dischargedate datetime
Select @ls_cpr_id = @ps_cpr_id
Select @li_encounter_id = @pi_encounter_id
Select @billing_id = @ps_billing_id
Select @mycount2 = @pi_count
Select @pat_name = @ps_name
Select @encounterdate = @pdt_encounterdate
Select @dischargedate = @pdt_dischargedate
Declare @ls_icd_9_code1 varchar(12)
Declare @ls_icd_9_code2 varchar(12)
Declare @ls_icd_9 varchar(12)
Declare @last_icd varchar(12)
Declare @ls_assessment_id varchar(24)
Declare @ls_cpt_code varchar(24)
Declare @ls_cpt_code_last varchar(24)
Declare @ls_modifier varchar(2)
Declare @ls_charge money
Declare @ls_assessment_sequence  smallint
Declare @ls_problem_id int
Declare my_curses CURSOR local FAST_FORWARD for
SELECT  distinct
		assessment_sequence,
       	problem_id,
        assessment_id,
        icd_9_code,
        cpt_code,
        modifier,
        charge
		FROM v_Encounter_Assessment_Charge v
		WHERE cpr_id = @ls_cpr_id
			AND encounter_id = @li_encounter_id
			AND assessment_billing_id is null
			AND eac_bill_flag = 'Y'
			AND pea_bill_flag = 'Y'
			AND ec_bill_flag = 'Y' 
			AND NOT EXISTS (SELECT *
				FROM p_Assessment a2
				WHERE a2.cpr_id = @ls_cpr_id
				AND a2.problem_id = v.problem_id
				AND a2.diagnosis_sequence > v.diagnosis_sequence)
       ORDER BY assessment_sequence,
       problem_id
Open my_curses
WHILE @mycount2 > 0 
 BEGIN
  FETCH NEXT FROM my_curses
          into @ls_assessment_sequence,@ls_problem_id,
          @ls_assessment_id,@ls_icd_9_code2,@ls_cpt_code,@ls_modifier,@ls_charge
  Select @mycount2 = @mycount2 - 1
  Select @ls_icd_9 = @ls_icd_9_code2
  SELECT @mycount3 =  (Select count(i.icd_9_code) 
         FROM c_Assessment_Coding i WITH (NOLOCK),
              p_Patient_Authority pi WITH (NOLOCK)
              where pi.cpr_id = @ls_cpr_id
              AND authority_sequence = 1 
              AND i.assessment_id = @ls_assessment_id
             AND i.authority_id = pi.authority_id)
  if @mycount3 > 0 
  Begin
   SELECT @ls_icd_9 = ( select i.icd_9_code
    FROM  c_Assessment_Coding i WITH (NOLOCK)
	JOIN p_Patient_Authority pi WITH (NOLOCK) ON i.authority_id = pi.authority_id
    where pi.cpr_id = @ls_cpr_id
    AND authority_sequence = 1 
    AND i.assessment_id = @ls_assessment_id )
  END

    SELECT @mycount3 =  (Select count(*)
    From ##c_bill_Tree_Table
    where encounter_id = @li_encounter_id
    and billing_id = @billing_id
    and icd_9_code = @ls_icd_9
    and cpt_code = @ls_cpt_code)
     
    if @mycount3 = 0
     Begin
      SELECT @mycount3 =  (Select count(*)
       From ##c_bill_Tree_Table
       where encounter_id = @li_encounter_id
       and billing_id = @billing_id
       and cpt_code = @ls_cpt_code)
      if @mycount3 = 0 
      Begin
      BEGIN TRANSACTION
      Insert into ##c_bill_Tree_Table
	VALUES(@encounterdate,
	@li_encounter_id,
	@billing_id,
	@pat_name,
	@ls_icd_9,
	@ls_cpt_code,
	@ls_modifier,
	@ls_charge,
	@dischargedate) 
      COMMIT
      END
    ELSE
     if @ls_icd_9 <> @last_icd
     Begin
     SELECT @mycount3 =  (Select count(*)
       From ##c_bill_Tree_Table
       where encounter_id = @li_encounter_id
       and billing_id = @billing_id
       and icd_9_code = @ls_icd_9)
      if @mycount3 = 0 
      Begin
      BEGIN TRANSACTION
      Select @ls_charge = null
      Insert into ##c_bill_Tree_Table
	VALUES(@encounterdate,
	@li_encounter_id,
	@billing_id,
	@pat_name,
	@ls_icd_9,
	'',
	'',
	@ls_charge,
	@dischargedate)
	Commit
      End
      End
      End
    Select @last_icd = @ls_icd_9
 END

Close my_curses

DEALLOCATE my_curses



GO
GRANT EXECUTE ON [jmjrpt_get_bill_coding] TO [cprsystem] AS [dbo]
GO
