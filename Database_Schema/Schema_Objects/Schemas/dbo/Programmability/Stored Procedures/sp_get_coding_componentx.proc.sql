CREATE PROCEDURE sp_get_coding_componentx (
	@ps_cpr_id varchar(12))
AS
DECLARE @li_authority_sequence smallint,
	@ps_component_id varchar(24)
	
SELECT @ps_component_id = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
IF @li_authority_sequence IS NOT NULL
	SELECT @ps_component_id = i.coding_component_id
	FROM c_Authority i, p_Patient_Authority pi
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence
	AND pi.authority_id = i.authority_id
IF @ps_component_id IS NULL
	SELECT @ps_component_id = 'JMJ_STD'
	
	

SELECT @ps_component_id as component_id



