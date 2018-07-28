



CREATE PROCEDURE jmjrpt_patient_vaccine_detail
	@ps_cpr_id varchar(12)
AS



  SELECT p_Treatment_Item.treatment_description,   
         p_Treatment_Item.begin_date,   
         c_Drug_Maker.maker_name,   
         p_Treatment_Item.lot_number,   
         c_Location.description,
         place_administered=COALESCE(c_Office.description, dbo.fn_patient_object_property(cpr_id, 'Treatment', treatment_id, 'Place Administered') )
    FROM {oj p_Treatment_Item LEFT OUTER JOIN c_Office ON p_Treatment_Item.office_id = c_Office.office_id LEFT OUTER JOIN c_Drug_Maker ON p_Treatment_Item.maker_id = c_Drug_Maker.maker_id LEFT OUTER JOIN c_Location ON p_Treatment_Item.location = c_Location.location}  
   WHERE ( p_Treatment_Item.cpr_id = @ps_cpr_id ) AND  
         ( p_Treatment_Item.treatment_type = 'IMMUNIZATION' ) AND  
         ( ISNULL(p_Treatment_Item.treatment_status, '!OPEN') <> 'CANCELLED' )    
	ORDER BY p_Treatment_Item.treatment_description, p_Treatment_Item.begin_date