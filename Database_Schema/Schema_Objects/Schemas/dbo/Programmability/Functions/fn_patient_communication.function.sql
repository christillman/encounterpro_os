CREATE FUNCTION fn_patient_communication (
	@ps_cpr_id varchar(12) )

RETURNS @comm TABLE (
	communication_type varchar (24) NOT NULL ,
	communication_name varchar (24) NOT NULL ,
	communication_value varchar (80) NOT NULL ,
	sort_sequence int NULL)
AS
BEGIN

DECLARE @type TABLE (
	communication_type varchar(24) NOT NULL)

DECLARE @comm_name TABLE (
	communication_type varchar(24) NOT NULL,
	progress_type varchar(24) NOT NULL,
	progress_key varchar(40) NOT NULL,
	sort_sequence int NULL)

-- Get values from p_Patient
INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value )
SELECT 'Phone',
	'Phone',
	phone_number
FROM p_Patient
WHERE cpr_id = @ps_cpr_id
AND LEN(phone_number) > 0

INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value )
SELECT 'Email',
	'Email',
	email_address
FROM p_Patient
WHERE cpr_id = @ps_cpr_id
AND LEN(email_address) > 0

-- Get values from p_Patient_Progress
INSERT INTO @type (
	communication_type)
SELECT CAST(domain_item AS varchar(24))
FROM c_Domain
WHERE domain_id = 'Communication Type'

INSERT INTO @comm_name (
	communication_type,
	progress_type ,
	progress_key,
	sort_sequence)
SELECT t.communication_type,
	'Communication ' + t.communication_type,
	CAST(d.domain_item AS varchar(24)),
	d.sort_sequence
FROM @type t
	INNER JOIN c_Domain d
	ON d.domain_id = 'Communication ' + t.communication_type

INSERT INTO @comm (
	communication_type ,
	communication_name ,
	communication_value ,
	sort_sequence)
SELECT x.communication_type ,
	x.progress_key,
	COALESCE(p.progress_value, CAST(p.progress AS varchar(80))),
	x.sort_sequence
FROM p_Patient_Progress p
	INNER JOIN @comm_name x
	ON p.progress_type = x.progress_type
	AND p.progress_key = x.progress_key
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
AND (p.progress_value IS NOT NULL OR p.progress IS NOT NULL)

RETURN
END
