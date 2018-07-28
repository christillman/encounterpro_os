CREATE PROCEDURE sp_authority_consultant
	@ps_cpr_id varchar(12),
	@ps_specialty_id varchar(24)
AS

declare @ls_authority_id varchar(24)

SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id

SELECT c_Consultant.description,   
        c_Consultant.consultant_id,   
        selected_flag=0,   
        c_Preferred_Provider.authority_id  
FROM c_Consultant LEFT OUTER JOIN c_Preferred_Provider ON c_Consultant.consultant_id = c_Preferred_Provider.consultant_id  
 	AND c_Preferred_Provider.authority_id = @ls_authority_id
WHERE c_Consultant.specialty_id = @ps_specialty_id    



