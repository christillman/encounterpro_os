DROP PROCEDURE IF EXISTS [jmjrpt_get_flowdata1]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON


GO
CREATE PROCEDURE [jmjrpt_get_flowdata1]
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Select @cprid = @ps_cpr_id

CREATE TABLE ##jmc_flow1 (RecordDate DATETIME,descrip varchar(41),UOM varchar(40) NULL,result_value varchar(80) NULL) ON [PRIMARY]
CREATE TABLE #jmc_flow2 (RecordDate varchar(10),HDL varchar(15) NULL ,LDL varchar(15) NULL ,Triglycer varchar(15) NULL,TotCholes varchar(15) NULL,PT varchar(15) NULL ,PTT varchar(15) NULL ,Hemoglob varchar(15) NULL ,Glucose varchar(15) NULL) ON [PRIMARY]
Declare @mycount Integer, @mycount2 Integer

declare jmc_curse2 Insensitive cursor for
SELECT 	convert(varchar(10),RecordDate,101),
c_observation.description,
##jmc_flow1.result_value,
##jmc_flow1.UOM
From ##jmc_flow1
JOIN c_observation with (NOLOCK)
ON ##jmc_flow1.descrip = c_observation.observation_id 
ORDER BY ##jmc_flow1.RecordDate desc, c_observation.description, ##jmc_flow1.result_value

declare @recorddate varchar(10),@observation_id varchar(24),@UOM varchar(40), @result_value varchar(80)
declare @myfirstdate varchar(10), @mylastdate varchar(10), @mydescription varchar(80)
declare @myresult varchar(15), @myuom varchar(8)
declare @the_result varchar(15)
declare @mytype integer
declare @recorddt datetime
declare @recorddt1 datetime

-- 'DEMO21244' = Lipid flow sheet
Set @observation_id = 'DEMO21244'

EXEC jmjrpt_patient_all_observation @cprid, @observation_id

Select @mycount2 = (select count(*) from ##jmc_flow1)

 open jmc_curse2
 WHILE @mycount2 > 0
  BEGIN
   FETCH NEXT FROM jmc_curse2
	INTO @myfirstdate,@mydescription,@myresult,@myuom
	IF @myuom IS NOT NULL
		BEGIN
		SELECT @myresult = @myresult + ' ' + @myuom
		END
	
	SELECT @mytype = 
	CASE 
   	WHEN (@mydescription like 'Cholesterol, HDL%') THEN 1
        WHEN (@mydescription = 'HDL (mg/dl)') THEN 1
	WHEN (@mydescription like 'Lipoprotein, direct, HDL%') THEN 1
   	WHEN (@mydescription like 'Cholesterol, LDL%') THEN 2
        WHEN (@mydescription = 'LDL (mg/dl)') THEN 2
	WHEN (@mydescription like 'Lipoprotein, direct, LDL%') THEN 2
    	WHEN (@mydescription like 'Triglyc%') THEN 3
	WHEN (@mydescription like 'Cholesterol, total%') THEN 4
	WHEN (@mydescription = 'Cholesterol, blood, total') THEN 4
        WHEN (@mydescription like 'Choles, tot%') THEN 4
    	WHEN (@mydescription like 'PT %') THEN 5
	WHEN (@mydescription like 'PTT %') THEN 6
	WHEN (@mydescription like 'Hemoglobin%') THEN 7	
	WHEN (@mydescription like 'Glucose,%') THEN 8
	
    	ELSE
	9
	END

	if @mylastdate = @myfirstdate
	 BEGIN
	  If @mytype = 1
		BEGIN
		SELECT @the_result = HDL
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET HDL = @myresult
			WHERE RecordDate = @myfirstdate
			END
		END
	If @mytype = 2
		BEGIN
		SELECT @the_result = LDL
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET LDL = @myresult
			WHERE RecordDate = @myfirstdate
			END
		END
	If @mytype = 3
		BEGIN
		SELECT @the_result = Triglycer
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET Triglycer = @myresult
			WHERE RecordDate = @myfirstdate
			END
		END
	If @mytype = 4
		BEGIN
		SELECT @the_result = TotCholes
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET TotCholes = @myresult
			WHERE RecordDate = @myfirstdate
			END
	
		END
        If @mytype = 5
		BEGIN
		SELECT @the_result = TotCholes
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET PT = @myresult
			WHERE RecordDate = @myfirstdate
			END
	
		END 
         If @mytype = 6
		BEGIN
		SELECT @the_result = PTT
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET PT = @myresult
			WHERE RecordDate = @myfirstdate
			END
	
		END 
        If @mytype = 7
		BEGIN
		SELECT @the_result = Hemoglob
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET PT = @myresult
			WHERE RecordDate = @myfirstdate
			END
	
		END  
        If @mytype = 8
		BEGIN
		SELECT @the_result = Glucose
		FROM #jmc_flow2
		WHERE RecordDate = @myfirstdate
		IF (@the_result is null or @the_result <> @myresult)
			BEGIN
			UPDATE #jmc_flow2
			SET PT = @myresult
			WHERE RecordDate = @myfirstdate
			END
	
		END  
	if @mylastdate <> @myfirstdate
		BEGIN
		SELECT @mylastdate = @myfirstdate
		If @mytype = 1
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,@myresult,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
			END
		If @mytype = 2
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,@myresult,NULL,NULL,NULL,NULL,NULL,NULL)
			END
		If @mytype = 3
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,@myresult,NULL,NULL,NULL,NULL,NULL)
			END
		If @mytype = 4
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,@myresult,NULL,NULL,NULL,NULL)
			END
		If @mytype = 5
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,NULL,@myresult,NULL,NULL,NULL)
			END
		If @mytype = 6
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,NULL,NULL,@myresult,NULL,NULL)
			END
		If @mytype = 7
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,NULL,NULL,NULL,@myresult,NULL)
			END
		If @mytype = 8
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@myresult)
			END
		If @mytype = 9
			BEGIN
			INSERT INTO #jmc_flow2
			values(@myfirstdate,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
			END
		END
              End
  Select @mycount2 = @mycount2 - 1
  END

CLOSE jmc_curse2

SELECT RecordDate
       ,HDL
       ,LDL
       ,Triglycer
       ,TotCholes
       ,PT
       ,PTT
       ,Hemoglob
       ,Glucose    
FROM #jmc_flow2

DEALLOCATE jmc_curse2
DROP TABLE ##jmc_flow1
DROP TABLE #jmc_flow2


GRANT EXECUTE ON [jmjrpt_get_flowdata1] TO [cprsystem] AS [dbo]


GO


