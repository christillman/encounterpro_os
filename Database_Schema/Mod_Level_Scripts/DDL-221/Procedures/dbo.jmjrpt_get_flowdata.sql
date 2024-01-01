
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_get_flowdata]
Print 'Drop Procedure [dbo].[jmjrpt_get_flowdata]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_flowdata]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_flowdata]
GO

-- Create Procedure [dbo].[jmjrpt_get_flowdata]
Print 'Create Procedure [dbo].[jmjrpt_get_flowdata]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_get_flowdata
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Select @cprid = @ps_cpr_id

CREATE TABLE #jmc_flow1 (RecordDate DATETIME,descrip varchar(24),UOM varchar(40) NULL,result_value varchar(80) NULL) ON [PRIMARY]
CREATE TABLE #jmc_flow2 (RecordDate varchar(10),HDL varchar(15) NULL ,LDL varchar(15) NULL ,Triglycer varchar(15) NULL,TotCholes varchar(15) NULL,PT varchar(15) NULL ,PTT varchar(15) NULL ,Hemoglob varchar(15) NULL ,Glucose varchar(15) NULL) ON [PRIMARY]
Declare @mycount Integer, @mycount2 Integer
declare jmc_curse1 cursor LOCAL FAST_FORWARD TYPE_WARNING for
SELECT p_Observation_Result.result_date_time AS RecordDate,
p_Observation_RESULT.observation_id,
p_Observation_Result.result AS UOM,
p_Observation_Result.result_value
FROM c_Observation with (NOLOCK)
INNER JOIN c_Observation_Tree with (NOLOCK) ON c_Observation.observation_id = c_Observation_Tree.parent_observation_id
INNER JOIN c_Observation c_Observation_1 with (NOLOCK) ON c_Observation_Tree.child_observation_id = c_Observation_1.observation_id
INNER JOIN p_Observation_Result with (NOLOCK) ON c_Observation_1.observation_id = p_Observation_Result.observation_id
WHERE (c_Observation.observation_id = 'DEMO13201')
 AND (p_Observation_Result.cpr_id = @cprid)
 AND (p_Observation_Result.result_type = 'PERFORM')
 ORDER BY p_Observation_Result.result_date_time desc

declare jmc_curse2 cursor LOCAL FAST_FORWARD TYPE_WARNING for
SELECT 	convert(varchar(10),RecordDate,101),
c_observation.description,
#jmc_flow1.result_value,
#jmc_flow1.UOM
From #jmc_flow1
JOIN c_observation with (NOLOCK)
ON #jmc_flow1.descrip = c_observation.observation_id 
ORDER BY #jmc_flow1.RecordDate desc, c_observation.description, #jmc_flow1.result_value

declare @recorddate varchar(10),@observation_id varchar(24),@UOM varchar(40), @result_value varchar(80)
declare @observation_id1 varchar(24) 
declare @myfirstdate varchar(10), @mylastdate varchar(10), @mydescription varchar(80)
declare @myresult varchar(15), @myuom varchar(8)
declare @the_result varchar(15)
declare @mytype integer
declare @recorddt datetime
declare @recorddt1 datetime
SELECT @mycount =  (Select count(p_Observation_Result.result_date_time)
FROM c_Observation with (NOLOCK)
INNER JOIN c_Observation_Tree ON c_Observation.observation_id = c_Observation_Tree.parent_observation_id
INNER JOIN c_Observation c_Observation_1 ON c_Observation_Tree.child_observation_id = c_Observation_1.observation_id
INNER JOIN p_Observation_Result ON c_Observation_1.observation_id = p_Observation_Result.observation_id
WHERE (c_Observation.observation_id = 'DEMO13201')
 AND (p_Observation_Result.cpr_id = @cprid)
 AND (p_Observation_Result.result_type = 'PERFORM'))

If @mycount > 0
 Begin
 open jmc_curse1

 FETCH NEXT FROM jmc_curse1
   into @recorddt1,@observation_id1,@UOM,@result_value

 Insert into #jmc_flow1
	VALUES(@recorddt1,@observation_id1,@UOM,@result_value)

 Select @mycount2 = @mycount2 + 1 
 Select @mycount = @mycount - 1 
 WHILE @mycount > 0
  BEGIN
   Select @recorddt1 = @recorddt
   Select @observation_id1 = @observation_id
   FETCH NEXT FROM jmc_curse1
   into @recorddt,@observation_id,@UOM,@result_value
   If NOT (@recorddt1 = @recorddt AND @observation_id1 = @observation_id)
	BEGIN
	Insert into #jmc_flow1
	VALUES(@recorddt,@observation_id,@UOM,@result_value)
        Select @mycount2 = @mycount2 + 1
        Select @recorddt1 = @recorddt
   	Select @observation_id1 = @observation_id
	END
   Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse1
 Select @mycount = @mycount2

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
   	WHEN (@mydescription = 'Cholesterol, HDL (83718)') THEN 1
	WHEN (@mydescription = 'Lipoprotein, direct, HDL cholesterol') THEN 1
   	WHEN (@mydescription = 'Cholesterol, LDL (83721)') THEN 2
	WHEN (@mydescription = 'Lipoprotein, direct, LDL cholesterol') THEN 2
    	WHEN (@mydescription = 'Triglycerides (84478)') THEN 3
	WHEN (@mydescription = 'Triglycerides') THEN 3
    	WHEN (@mydescription = 'Cholesterol, total (82465)') THEN 4
	WHEN (@mydescription = 'Cholesterol, blood, total') THEN 4
    	WHEN (@mydescription = 'PT (85610)') THEN 5
	WHEN (@mydescription = 'PTT (85730)') THEN 6
	WHEN (@mydescription = 'Hemoglobin health check (85018)') THEN 7	
	WHEN (@mydescription = 'Hemoglobin (85018)') THEN 7	
	WHEN (@mydescription = 'Glucose, finger stick (82948)') THEN 8
	WHEN (@mydescription = 'Glucose, serum (82947)') THEN 8
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
 END
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

DEALLOCATE jmc_curse1
DEALLOCATE jmc_curse2
DROP TABLE #jmc_flow1
DROP TABLE #jmc_flow2

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_flowdata]
	TO [cprsystem]
GO

