




CREATE PROCEDURE jmjrpt_tx_vfc_rpt
	@ps_begin_date varchar(10)
   ,@ps_end_date varchar(10)    
AS
CREATE TABLE #jmc_tx_vfc (myvacc varchar(24),la1 integer NULL ,a1 integer NULL ,a2 integer NULL,a3_4 integer NULL,a5 integer NULL ,a6_9 integer NULL ,a10_14 integer NULL ,a15_19 integer NULL , a20_24 integer NULL , a25_44 integer NULL, a25_64 integer NULL , a65 integer NULL,asum integer NULL ) ON [PRIMARY]

Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Declare jmc_curse1 Insensitive cursor for
SELECT p_treatment_item.treatment_description,
p_treatment_item.drug_id,
p_patient.date_of_birth
FROM p_treatment_item with (NOLOCK),
p_patient with (NOLOCK)
WHERE (p_treatment_item.treatment_type = 'IMMUNIZATION')
 AND (p_treatment_item.treatment_status = 'CLOSED')
 AND ((p_treatment_item.treatment_description LIKE '%(VFC)%')
       OR p_treatment_item.treatment_description in ('Comvax VFC','Pediarix (VFC) TX'))
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 AND (p_treatment_item.cpr_id = p_patient.cpr_id)
 AND (p_patient.date_of_birth is not NULL)
 ORDER BY p_treatment_item.treatment_description,p_patient.date_of_birth desc 

Declare @DOB datetime, @today datetime
Declare @Age integer
Declare @Age_months integer
Declare @the_result varchar(24)
Declare @mytype integer
Declare @mycount integer
Declare @vacc_descrip varchar(24),@drug_id varchar(24)
Declare @immune varchar(24)
SELECT @today = Getdate()

SELECT @mycount =  (SELECT Count(p_treatment_item.treatment_description)
FROM p_treatment_item with (NOLOCK),
p_patient with (NOLOCK)
WHERE (p_treatment_item.treatment_type = 'IMMUNIZATION')
 AND (p_treatment_item.treatment_status = 'CLOSED')
 AND ((p_treatment_item.treatment_description LIKE '%(VFC)%')
      OR p_treatment_item.treatment_description in ('Comvax VFC','Pediarix (VFC) TX'))
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 AND (p_treatment_item.cpr_id = p_patient.cpr_id)
 AND (p_patient.date_of_birth is not NULL)
 )
 
If @mycount > 0
 Begin
 --initialize the table
 INSERT INTO #jmc_tx_vfc
	values('DTAP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('DT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('Td',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('HIB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('IPV',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('MMR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('MEASLES',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('VARICELLA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('PCV 7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('HEPATITIS A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('HEPATITIS B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('INFLUENZA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('PNEUMO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_tx_vfc
	values('PEDIARIX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)												
 INSERT INTO #jmc_tx_vfc
	values('COMVAX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)	

 Open jmc_curse1
 WHILE @mycount > 0
  BEGIN
    FETCH NEXT FROM jmc_curse1
     into @vacc_descrip,@drug_id,@DOB
    If @DOB IS NOT NULL
	 BEGIN
	   Select @Age_months = (DATEDIFF(month,@DOB,@today))
	   If DATEDIFF(day,@DOB,@today) > 0
	   BEGIN
	      Select @Age_months = @Age_months - 1
	   END
	   Select @Age =  @Age_months / 12
	 If @Age > -1
	  Begin
           SELECT @mytype = 
	   CASE 
   	      WHEN (@Age < 1) THEN 1
	      WHEN (@Age = 1) THEN 2
   	      WHEN (@Age = 2) THEN 3
	      WHEN (@Age IN (3,4)) THEN 4
              WHEN (@Age = 5) THEN 5
	      WHEN (@Age IN (6,7,8,9)) THEN 6
              WHEN (@Age IN (10,11,12,13,14)) THEN 7
	      WHEN (@Age IN (15,16,17,18,19)) THEN 8
              WHEN (@Age IN (20,21,22,23,24)) THEN 9
	      WHEN ((@Age >= 25) AND (@Age <=44)) THEN 10
	      WHEN ((@Age >= 45) AND (@Age <=64)) THEN 11
	      WHEN (@Age >= 65) THEN 12
   	   ELSE 13
	   END
	   SELECT @immune = 
	    CASE 
   		  WHEN (@drug_id = 'DTAP') THEN @drug_id
		  WHEN (@drug_id = 'HEPA') THEN 'HEPATITIS A'
	   	  WHEN (@drug_id = 'HEPB') THEN 'HEPATITIS B'
	   	  WHEN (@drug_id = 'Hib')  THEN 'HIB'
	   	  WHEN (@drug_id = 'OPV')  THEN 'IPV' 
		  WHEN (@drug_id = 'MMR')  THEN 'MMR'
	   	  WHEN (@drug_id = 'Pnemococcus,Prevnar') THEN 'PCV 7'
		  WHEN (@drug_id IN ('TETANUS','ZADULTTD')) THEN 'Td'
		  WHEN (@drug_id = 'Varivax1') THEN 'VARICELLA'
	   	  WHEN (@drug_id = 'PEDDT') THEN 'DT'
	   	  WHEN (@drug_id = 'MEASLES') THEN 'MEASLES'
	   	  WHEN (@drug_id = 'INFLUENZA') THEN 'INFLUENZA'
	      WHEN (@drug_id = 'Pneumococcus') THEN 'PNEUMO'
	      WHEN (@drug_id = 'Pediarix') THEN 'PEDIARIX'
          WHEN (@drug_id = 'ComvaxVFC') THEN 'COMVAX'
	    ELSE 'Other'
	    END
	    
	    BEGIN
		SELECT @the_result = asum FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET asum = @the_result WHERE myvacc = @immune
		END
     
      	  If @mytype = 1
		BEGIN
		SELECT @the_result = la1 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
            		END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET la1 = @the_result WHERE myvacc = @immune
		END
          ELSE
	  If @mytype = 2
		BEGIN
		SELECT @the_result = a1	FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a1 = @the_result WHERE myvacc = @immune
                END
	  ELSE
	  If @mytype = 3
		BEGIN
		SELECT @the_result = a2 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a2 = @the_result WHERE myvacc = @immune
                END
	  ELSE
	  If @mytype = 4
		BEGIN
		SELECT @the_result = a3_4 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a3_4 = @the_result WHERE myvacc = @immune
                END 
	  ELSE
          If @mytype = 5
		BEGIN
		SELECT @the_result = a5	FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a5 = @the_result WHERE myvacc = @immune
                END
	  ELSE
      	  If @mytype = 6
		BEGIN
		SELECT @the_result = a6_9 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a6_9 = @the_result WHERE myvacc = @immune
                END
	  ELSE
          If @mytype = 7
		BEGIN
		SELECT @the_result = a10_14 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
           		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a10_14 = @the_result WHERE myvacc = @immune
                END
	  ELSE
          If @mytype = 8
		BEGIN
		SELECT @the_result = a15_19 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a15_19 = @the_result WHERE myvacc = @immune
                END
	  ELSE
	  If @mytype = 9
		BEGIN
		SELECT @the_result = a20_24 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a20_24 = @the_result WHERE myvacc = @immune
                END
	  ELSE
	  If @mytype = 10
		BEGIN
		SELECT @the_result = a25_44 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a25_44 = @the_result WHERE myvacc = @immune
		END
          ELSE
	  If @mytype = 11
		BEGIN
		SELECT @the_result = a25_64 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a25_64 = @the_result WHERE myvacc = @immune
		END
          ELSE
	  If @mytype = 12
		BEGIN
		SELECT @the_result = a65 FROM #jmc_tx_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_tx_vfc SET a65 = @the_result WHERE myvacc = @immune
		END
	END	
  END
 
 -- SELECT @mytype,@age
 Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse1
END

SELECT myvacc AS VACCINE
       ,la1 AS less_1
       ,a1 AS one
       ,a2 AS two
       ,a3_4 AS Fr3_4
       ,a5 AS five
       ,a6_9 AS Fr6_9
       ,a10_14 AS Fr10_14
       ,a15_19 AS Fr15_19
       ,a20_24 AS Fr20_24
       ,a25_44 AS Fr25_44
       ,a25_64 AS Fr45_64
       ,a65 AS Fr65
       ,asum AS Total  
FROM #jmc_tx_vfc

DEALLOCATE jmc_curse1

DROP TABLE #jmc_tx_vfc