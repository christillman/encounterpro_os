
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_patient_pastdue_vacc]
Print 'Drop Procedure [dbo].[jmjrpt_patient_pastdue_vacc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_pastdue_vacc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_pastdue_vacc]
GO

-- Create Procedure [dbo].[jmjrpt_patient_pastdue_vacc]
Print 'Create Procedure [dbo].[jmjrpt_patient_pastdue_vacc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_patient_pastdue_vacc
AS
CREATE TABLE #overdue_vacc(
            id int IDENTITY (1, 1) NOT NULL ,cpr_id varchar(12),dob datetime, vaccid varchar(24),vaccseq smallint,diseaseid integer) ON [PRIMARY]
CREATE TABLE #overdue_vacc2(
            id int IDENTITY (1, 1) NOT NULL , namer varchar(40),dob datetime,vacc_descp varchar(40),odue_days integer) ON [PRIMARY] 
DECLARE @li_vaccine_count smallint,
	@li_schedule_count smallint,
        @li_max_count smallint,
	@ldt_date_of_birth datetime,
	@ldt_age datetime,
        @ldt_due_date_time datetime, 
        @vaccid varchar(24),@lstvaccid varchar(24),
        @diseaseid integer,
        @cprid varchar(12),@lstcprid varchar(12),@namer varchar(40), @vaccdesc varchar(40),
        @switch char

Declare my_curses CURSOR LOCAL FAST_FORWARD FOR
SELECT p.cpr_id
      ,p.date_of_birth
      ,cvd.vaccine_id
      ,cid.disease_id
      ,COUNT(i.treatment_id)
      ,'Y'
     FROM p_patient p WITH (NOLOCK)
     LEFT OUTER JOIN p_Treatment_Item i WITH (NOLOCK)
        ON p.cpr_id = i.cpr_id
        AND i.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
        AND ISNULL( i.treatment_status, 'OPEN' ) <> 'CANCELLED'
	JOIN c_vaccine v ON i.drug_id = v.drug_id
	JOIN c_vaccine_disease cvd ON v.vaccine_id = cvd.vaccine_id
     INNER JOIN c_Immunization_Schedule cid WITH (NOLOCK)
        ON cvd.disease_id = cid.disease_id    
-- A vaccine already done
      WHERE
        p.patient_status = 'ACTIVE' 
        AND datediff(year, p.date_of_birth, getdate()) <= 24
        -- if patient had disease then vaccine not needed
        AND p.cpr_id not in
        (select cpr_id from p_assessment a WITH (NOLOCK)
         inner join c_Disease_Assessment d WITH (NOLOCK)
          ON a.assessment_id = d.assessment_id
         inner join c_Disease cd WITH (NOLOCK)
          ON  d.disease_id = cd.disease_id
        AND  cd.no_vaccine_after_disease = 'Y')
        AND  i.treatment_id = (SELECT MAX(i2.treatment_id)
        FROM p_Treatment_Item i2 WITH (NOLOCK)
		JOIN c_vaccine v2 ON i2.drug_id = v2.drug_id
		JOIN c_vaccine_disease cvd2 ON v2.vaccine_id = cvd2.vaccine_id
        INNER JOIN c_Immunization_Schedule cid2 WITH (NOLOCK)
        ON cvd2.disease_id = cid2.disease_id
        WHERE p.cpr_id = i2.cpr_id
        AND i2.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
        AND ISNULL( i2.treatment_status, 'OPEN' ) <> 'CANCELLED')
GROUP BY p.cpr_id, p.date_of_birth,cvd.vaccine_id,cid.disease_id

UNION 
--some vaccine not done
SELECT p.cpr_id
      ,p.date_of_birth
      ,cvd.vaccine_id
      ,cid.disease_id
      ,'1'
      ,'Y' 
FROM c_vaccine_disease cvd WITH (NOLOCK),
     c_Immunization_Schedule cid WITH (NOLOCK),
     p_patient p WITH (NOLOCK)
     WHERE
        cvd.disease_id = cid.disease_id 
        AND p.patient_status = 'ACTIVE' 
        AND datediff(year, p.date_of_birth, getdate()) <= 24
         -- if patient had disease then vaccine not needed
        AND p.cpr_id not in
        (select cpr_id from p_assessment a WITH (NOLOCK)
         inner join c_Disease_Assessment d WITH (NOLOCK)
          ON a.assessment_id = d.assessment_id
         inner join c_Disease cd WITH (NOLOCK)
          ON  d.disease_id = cd.disease_id
        AND  cd.no_vaccine_after_disease = 'Y')
        AND NOT EXISTS
        (SELECT i3.cpr_id
           FROM p_Treatment_Item i3 WITH (NOLOCK)
		JOIN c_vaccine v3 ON i3.drug_id = v3.drug_id
		JOIN c_vaccine_disease cvd3 ON v3.vaccine_id = cvd3.vaccine_id
        INNER JOIN c_Immunization_Schedule cid3 WITH (NOLOCK)
        ON cvd3.disease_id = cid3.disease_id
        WHERE p.cpr_id = i3.cpr_id
        AND i3.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
        AND ISNULL( i3.treatment_status, 'OPEN' ) <> 'CANCELLED') 
       GROUP BY p.cpr_id, p.date_of_birth,cvd.vaccine_id,cid.disease_id

ORDER BY date_of_birth desc, p.cpr_id asc,cvd.vaccine_id 

 
OPEN my_curses

FETCH NEXT FROM my_curses INTO @cprid,@ldt_date_of_birth,@vaccid,@diseaseid,@li_vaccine_count,@switch

WHILE (@@FETCH_STATUS = 0)
BEGIN
IF @switch = 'Y'
 BEGIN
  SELECT @li_vaccine_count = @li_vaccine_count + 1
  SELECT @lstvaccid = ''
  SELECT @lstcprid =  ''
  
  SELECT @ldt_age = age
	 FROM c_Immunization_Schedule WITH (NOLOCK)
         INNER JOIN c_vaccine_disease cvd4 WITH (NOLOCK)
         ON cvd4.disease_id = c_Immunization_Schedule.disease_id
	 WHERE c_Immunization_Schedule.disease_id = @diseaseid 
           AND schedule_sequence = @li_vaccine_count
  IF @ldt_age IS NOT NULL 
  BEGIN
      SELECT @ldt_due_date_time = dateadd(day, datediff(day, '1/1/1980', @ldt_age), @ldt_date_of_birth)
      IF @ldt_due_date_time < getdate()
          BEGIN
            SELECT @diseaseid = datediff(day,@ldt_due_date_time,getdate())
            INSERT INTO #OVERDUE_VACC VALUES(@cprid,@ldt_date_of_birth,@vaccid,@li_vaccine_count,@diseaseid)
          END
   END
 END
 ELSE
 BEGIN
   IF (@vaccid != @lstvaccid AND @cprid != @lstcprid)
   BEGIN
    SELECT @lstvaccid = @vaccid
    SELECT @lstcprid =  @cprid
    SELECT @ldt_age = age
	 FROM c_Immunization_Schedule WITH (NOLOCK)
         INNER JOIN c_vaccine_disease cvd5 WITH (NOLOCK)
         ON cvd5.disease_id = c_Immunization_Schedule.disease_id
	 WHERE c_Immunization_Schedule.disease_id = @diseaseid AND schedule_sequence = 1
    BEGIN
      SELECT @ldt_due_date_time = dateadd(day, datediff(day, '1/1/1980', @ldt_age), @ldt_date_of_birth)
      IF @ldt_due_date_time < getdate()
          BEGIN
            INSERT INTO #OVERDUE_VACC VALUES(@cprid,@ldt_date_of_birth,@vaccid,1,@diseaseid)
          END
    END
   END
 END
 FETCH NEXT FROM my_curses INTO @cprid,@ldt_date_of_birth,@vaccid,@diseaseid,@li_vaccine_count,@switch
 END
CLOSE my_curses
DEALLOCATE my_curses

Declare my_curses2 CURSOR LOCAL FAST_FORWARD FOR
SELECT p.cpr_id
      ,p.dob
      ,p.vaccid
      ,p.vaccseq
      ,p.diseaseid
      FROM #OVERDUE_VACC p WITH (NOLOCK)
ORDER BY dob desc,cpr_id,vaccid,vaccseq

OPEN my_curses2
SELECT @lstcprid = ''
SELECT @lstvaccid = ''
SELECT @li_schedule_count = 0

FETCH NEXT FROM my_curses2 INTO @cprid,@ldt_date_of_birth,@vaccid,@li_vaccine_count,@diseaseid

WHILE (@@FETCH_STATUS = 0)
BEGIN 
--   IF (@vaccid != @lstvaccid AND @cprid != @lstcprid AND @li_vaccine_count != @li_schedule_count)
     IF (@cprid != @lstcprid) 
      BEGIN	
      SELECT @namer = (SELECT last_name + ',' + first_name
         FROM p_patient WITH (NOLOCK)
         where cpr_id = @cprid)
         SELECT @lstcprid =  @cprid
      END   
     SELECT @vaccdesc = (SELECT description
         FROM c_vaccine WITH (NOLOCK)
         where vaccine_id = @vaccid
         AND status = 'OK')
      IF @vaccdesc IS NOT NULL 
         BEGIN
         Insert INTO #overdue_vacc2 VALUES(@namer,@ldt_date_of_birth,@vaccdesc,@diseaseid)
         END
     SELECT @lstvaccid = @vaccid
     SELECT @li_schedule_count = @li_vaccine_count

   FETCH NEXT FROM my_curses2 INTO @cprid,@ldt_date_of_birth,@vaccid,@li_vaccine_count,@diseaseid
END

CLOSE my_curses2
DEALLOCATE my_curses2
SELECT 
 Namer AS Name,
 Convert(varchar(10),dob,101) As DOB,
 vacc_descp AS Vaccine,
 Min(odue_days) AS Days_over
 from #OVERDUE_VACC2
where odue_days > 0
and vacc_descp not like ('NO %')
and (datediff(day,dob,getdate()) - odue_days) > 0
 group by Namer,dob, vacc_descp
order by Days_over desc,Namer,vacc_descp

DROP TABLE #OVERDUE_VACC
DROP TABLE #OVERDUE_VACC2
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_pastdue_vacc]
	TO [cprsystem]
GO

