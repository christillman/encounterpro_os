CREATE PROCEDURE sp_get_preferred_provider
	@ps_cpr_id varchar(12)= NULL,
	@ps_specialty_id varchar(24),
	@ps_authority_id varchar(24) = NULL
AS

IF @ps_authority_id IS NULL
BEGIN
	SELECT @ps_authority_id = authority_id
	FROM p_Patient_Authority
	WHERE cpr_id = @ps_cpr_id
END
SELECT c_Consultant.description,   
        c_Consultant.consultant_id,   
        selected_flag=0,   
        c_Preferred_Provider.authority_id,
	c_Consultant.specialty_id
FROM c_Consultant LEFT OUTER JOIN c_Preferred_Provider ON c_Consultant.consultant_id = c_Preferred_Provider.consultant_id  
 	AND c_Preferred_Provider.authority_id = @ps_authority_id
WHERE c_Consultant.specialty_id like @ps_specialty_id
order by description asc 


