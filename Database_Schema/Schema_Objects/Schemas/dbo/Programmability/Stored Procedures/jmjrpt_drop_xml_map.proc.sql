


CREATE PROCEDURE jmjrpt_drop_xml_map
      @ps_cpr_id varchar(12) , 
      @pl_treatment_id int
AS
DECLARE @ls_observation_id varchar(24)

SELECT @ls_observation_id = observation_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
if (@ls_observation_id is not null ) and (@ls_observation_id != '')
      begin 
      Delete from c_xml_code 
      where epro_id = @ls_observation_id
      AND epro_domain = 'observation_id'
      select 'Deleted'
      end
else
      begin
      select 'Not deleted'
      end