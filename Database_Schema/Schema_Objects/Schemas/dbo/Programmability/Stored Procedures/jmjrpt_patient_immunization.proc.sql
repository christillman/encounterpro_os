



CREATE PROCEDURE jmjrpt_patient_immunization
	@ps_cpr_id varchar(12)
AS

Declare @cpr_id varchar(12)

Select @cpr_id = @ps_cpr_id

SELECT distinct b.begin_date,
	treatment_description, 
	c_Drug_Maker.maker_name, 
	lot_number,
	convert(varchar(10),b.expiration_date,101) As Expiration,
	cl.description As Location,
	duration_prn As Lit_Date,
--	COALESCE(cu.user_short_name,cu2.user_short_name) AS Entered_by 
	cu2.user_short_name AS Entered_by, 
	place_administered=COALESCE(c_Office.description, dbo.fn_patient_object_property(b.cpr_id, 'Treatment', b.treatment_id, 'Place Administered') )
      INTO #temp_table	
      FROM p_treatment_item b WITH (NOLOCK)
	LEFT OUTER JOIN p_treatment_progress pp WITH (NOLOCK)
		ON  pp.cpr_id = b.cpr_id 
		AND pp.treatment_id = b.treatment_id
		AND progress_type = 'CLOSED'
	INNER JOIN 
		p_patient_encounter a WITH (NOLOCK)
		ON a.encounter_id =  b.open_encounter_id 
		AND a.cpr_id = b.cpr_id 
	Left Outer JOIN c_location cl with (NOLOCK)
		ON b.location = cl.location
	LEFT OUTER JOIN c_Office with (NOLOCK) ON b.office_id = c_Office.office_id
	LEFT OUTER JOIN c_Drug_Maker with (NOLOCK) ON b.maker_id = c_Drug_Maker.maker_id
--	INNER JOIN p_patient_wp_item wp with (NOLOCK)
--		ON b.cpr_id = wp.cpr_id
--		AND b.open_encounter_id = wp.encounter_id
--		AND b.treatment_type = wp.ordered_service
--		AND b.treatment_description = wp.description
--		AND wp.status IN ('CLOSED','COMPLETED')
--	Left Outer JOIN c_user cu with (NOLOCK)
--		ON wp.completed_by = cu.user_id
	Left Outer JOIN c_user cu2 with (NOLOCK)
		ON pp.user_id = cu2.user_id
WHERE a.cpr_id = @cpr_id
and treatment_type = 'IMMUNIZATION' 
and treatment_description is not null 
and isnull(treatment_status,'Open') = 'CLOSED'
order by treatment_description asc,b.begin_date asc

select 
convert(varchar(10),begin_date,101) As ReportDate,
treatment_description, 
maker_name, 
lot_number,
Expiration,
location,
Lit_Date,
Entered_by As Entered,
Place_Administered  
from #temp_table