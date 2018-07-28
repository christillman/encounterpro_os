

CREATE PROCEDURE jmjrpt_vfc_rpt2
	@ps_begin_date varchar(10)
   ,@ps_end_date varchar(10)    
AS
CREATE TABLE #jmc_vfc (myvacc varchar(24),la3mo integer NULL,la1 integer NULL ,a1_6 integer NULL ,a7_18 integer NULL,asum integer NULL,ins_category varchar(24) ) ON [PRIMARY]

Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Declare @today DateTime
Select @today = GetDate()
--Select @Today
Declare jmc_curse1 Insensitive cursor for
SELECT p_treatment_item.treatment_description,
p_treatment_item.drug_id,
pp.date_of_birth,
ca.authority_category
FROM p_treatment_item with (NOLOCK)
Inner Join
p_patient pp with (NOLOCK) ON
pp.cpr_id = p_treatment_item.cpr_id
AND (pp.date_of_birth is not NULL)
AND (DateDIFF(YEAR,pp.date_of_birth,@today) < 19)
Left Outer Join
p_patient_authority pa with (NOLOCK) ON
pa.cpr_id = p_treatment_item.cpr_id
Left Outer Join
c_authority ca with (NOLOCK) ON
ca.authority_id = pa.authority_id
WHERE (p_treatment_item.treatment_type IN ('PASTIMMUN', 'IMMUNIZATION'))
 AND (p_treatment_item.treatment_status = 'CLOSED')
 AND (p_treatment_item.treatment_description LIKE '%(VFC)%')
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 ORDER BY p_treatment_item.treatment_description,pp.date_of_birth desc 

Declare @DOB datetime
Declare @Age integer
Declare @Age_months integer
Declare @the_result varchar(24)
Declare @mytype integer
Declare @mycount integer
Declare @vacc_descrip varchar(24),@drug_id varchar(24)
Declare @immune varchar(24)
Declare @class varchar(24)
SELECT @mycount =  (SELECT Count(p_treatment_item.treatment_description)
FROM p_treatment_item with (NOLOCK),
p_patient with (NOLOCK)
WHERE (p_treatment_item.treatment_type IN ('PASTIMMUN', 'IMMUNIZATION'))
 AND (Isnull(p_treatment_item.treatment_status,'Open') = 'CLOSED')
 AND (p_treatment_item.treatment_description LIKE '%(VFC)%')
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 AND (p_treatment_item.cpr_id = p_patient.cpr_id)
 AND (p_patient.date_of_birth is not NULL)
 AND (DateDIFF(YEAR,p_patient.date_of_birth,@today) < 19)
 )
--Select @mycount 
If @mycount > 0
 Begin
 --initialize the table
 INSERT INTO #jmc_vfc
	values('DTAP',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('DT',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('Td',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('HIB',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('IPV',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('MMR',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('MEASLES',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('VARICELLA',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('PCV 7',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('HEPATITIS A',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('HEPATITIS B',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('INFLUENZA',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('PNEUMO',NULL,NULL,NULL,NULL,NULL,NULL)
 INSERT INTO #jmc_vfc
	values('COMVAX',NULL,NULL,NULL,NULL,NULL,NULL)	
 INSERT INTO #jmc_vfc
	values('PEDIARIX',NULL,NULL,NULL,NULL,NULL,NULL)
												
 Open jmc_curse1
 WHILE @mycount > 0
  BEGIN
    FETCH NEXT FROM jmc_curse1
     into @vacc_descrip,@drug_id,@DOB,@class
    If @DOB IS NOT NULL
	 BEGIN
	   Select @Age_months = (DATEDIFF(month,@DOB,@today))
	   If DATEDIFF(day,@DOB,@today) > 0
	   BEGIN
	      Select @Age_months = @Age_months - 1
	   END
	   Select @Age =  @Age_months / 12
	 If @Age_months < 3
	   Begin
	      Select @mytype = 1
	   END   
	 Else     
	 If @Age > -1
	  Begin
           SELECT @mytype = 
	   CASE 
   	      WHEN (@Age < 1) THEN 2
	      WHEN (@Age IN (1,2,3,4,5,6)) THEN 3
              WHEN ((@Age >= 7) AND (@Age <19)) THEN 4
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
		  WHEN (@drug_id = 'comvax') THEN 'COMVAX'
		  WHEN (@drug_id = 'Pediarix') THEN 'PEDIARIX'
	    ELSE 'Other'
	    END
	    
	    BEGIN
		SELECT @the_result = asum FROM #jmc_vfc 
                 WHERE myvacc = @immune
                 
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_vfc 
                SET asum = @the_result
                WHERE myvacc = @immune

		END
     
      	  If @mytype = 2
		BEGIN
		SELECT @the_result = la1 FROM #jmc_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
            		END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_vfc SET la1 = @the_result WHERE myvacc = @immune
		END
          ELSE
	  If @mytype = 3
		BEGIN
		SELECT @the_result = a1_6 FROM #jmc_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_vfc SET a1_6 = @the_result WHERE myvacc = @immune
                END
	  ELSE
	  If @mytype = 4
		BEGIN
		SELECT @the_result = a7_18 FROM #jmc_vfc WHERE myvacc = @immune
		IF @the_result is null
			BEGIN
			SELECT @the_result = 1
			END
		ELSE
            		BEGIN 
			SELECT @the_result = @the_result + 1
			END
		UPDATE #jmc_vfc SET a7_18 = @the_result WHERE myvacc = @immune
                END
	END	
  END
 
 -- SELECT @mytype,@age
 Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse1
END

SELECT myvacc AS VACCINE
       ,isnull(la3mo,'') AS less_3MO
       ,isnull(la1,'') AS less_1YR
       ,isnull(a1_6,'') AS Age_1_6
       ,isnull(a7_18,'') AS Age_7_18
       ,isnull(asum,'') AS Total  
FROM #jmc_vfc

DEALLOCATE jmc_curse1

DROP TABLE #jmc_vfc