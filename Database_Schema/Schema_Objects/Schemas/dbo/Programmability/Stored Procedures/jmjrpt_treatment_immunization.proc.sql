


CREATE PROCEDURE jmjrpt_treatment_immunization
	@ps_cpr_id varchar(12),@pi_encounter_id integer,@pi_treatment_id integer
AS
Declare @cpr_id varchar(12)
Declare @encounter_id integer
Declare @treatment_id integer
Select @cpr_id = @ps_cpr_id
Select @encounter_id = @pi_encounter_id
Select @treatment_id = @pi_treatment_id

SELECT maker_id,lot_number,
convert(varchar(10),expiration_date,101) As Expiration,
cl.description As location
FROM p_treatment_item a with (NOLOCK)
Left Outer JOIN c_location cl with (NOLOCK) 
ON a.location = cl.location
WHERE a.cpr_id = @cpr_id 
and a.open_encounter_id = @encounter_id and a.treatment_id = @treatment_id