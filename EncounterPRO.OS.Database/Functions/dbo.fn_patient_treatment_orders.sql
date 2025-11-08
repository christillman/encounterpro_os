
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_treatment_orders]
Print 'Drop Function [dbo].[fn_patient_treatment_orders]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_treatment_orders]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_treatment_orders]
GO

-- Create Function [dbo].[fn_patient_treatment_orders]
Print 'Create Function [dbo].[fn_patient_treatment_orders]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION dbo.fn_patient_treatment_orders (
	@ps_cpr_id varchar(12),
	@pl_treatment_id integer = NULL)

RETURNS @orders TABLE (
		cpr_id varchar(12) NOT NULL,
		treatment_id int NOT NULL,
		order_sequence int IDENTITY (1, 1) NOT NULL,
		encounter_id int NOT NULL,
		order_type varchar(24) NOT NULL,
		description varchar(255) NOT NULL,
		ordered_by varchar(255) NOT NULL,
		ordered_date datetime NOT NULL,
		signature_user varchar(255) NULL,
		signature_data image NULL,
		signature_filetype varchar(24) NULL)
		
AS

-- The purpose of this function is to return each of the "order" events for the specified treatment
-- An "order" in general consists of a specific instance of a provider asking for or confirming
-- the continuation of the treatment
--
-- For point-in-time treatments (e.g. Labs) this will always consist of a single record
-- representing the original order.
-- For continuous treatments (e.g. Prescription Medication) this will consist of the
-- original order plus any instances of reconfirming or reordering the
-- treatment (e.g. prescription refill).

-- EncounterPRO considers the treatment creation to be an order and determines the effective ordered-by
-- provider using the following logic:
-- 
-- 1) If someone signed for the treatment in the encounter in which it was created, then that is the ordered_by provider
-- 2) If no one signed for the treatment in the encounter in which it was created, then the provider
--    who ordered the treatment is the ordered_by provider
-- 
-- EncounterPRO considers every "Refill"progress note to be a re-order where the ordered_by provider is the
-- provider logging the refill.
-- 
-- 
-- Once the orders and ordered-by providers have been determined, then the following logic is used to 
-- determine which signature to display for each order:
-- 
-- If the treatment is a prescription drug treatment, then
--   The ordered-by provider's signature is used if any of the following are true
--   1) the ordered-by provider does not have a supervisor and is certified
--   2) the ordered-by provider has a supervisor and the use_supervisor_signature_stamp is false
-- 
--   If the ordered-by provider has a supervisor then the supervisor's signature is used if either of the following are true:
--   1) the ordered-by provider is not certified
--   2) the ordered-by provider is certified and the use_supervisor_signature_stamp is true
-- 
-- 
-- If the treatment is NOT a prescription drug treatment, then
--   The ordered-by provider's signature is used if any of the following are true
--   1) the ordered-by provider does not have a supervisor
--   2) the ordered-by provider has a supervisor and the use_supervisor_signature_stamp is false
-- 
--   If the ordered-by provider has a supervisor then the supervisor's signature is used if either of the following are true:
--   2) the ordered-by provider the use_supervisor_signature_stamp is true
-- 
-- 
-- 
--   If an actual signature is available from the prescription, then the actual signature is used.  Otherwise, 
--   the appropriate signature stamp is used.  Note that whether or not a signature stamp is available or used 
--   is subject to two preferences, namely rx_use_signature_stamp and rx_always_use_signature_stamp.
-- 
-- 
-- 



BEGIN

-- Hold the records in a temp table so we can sort them into @orders

DECLARE @temporders TABLE (
		cpr_id varchar(12) NOT NULL,
		treatment_id int NOT NULL,
		encounter_id int NOT NULL,
		order_type varchar(24) NOT NULL,
		description varchar(255) NOT NULL,
		ordered_by varchar(24) NOT NULL,
		ordered_date datetime NOT NULL,
		signature_user varchar(24) NULL,
		signature_data image NULL,
		signature_filetype varchar(24) NULL)


-- If the treatment was signed in the same encounter in which it was ordered, then use the signing
-- provider as the ordering provider.
INSERT INTO @temporders (
	cpr_id ,
	treatment_id ,
	encounter_id ,
	order_type,
	description ,
	ordered_by ,
	ordered_date)
SELECT p.cpr_id ,
	p.treatment_id ,
	p.encounter_id ,
	'Order' ,
	'Signed by ' + ISNULL(u.user_full_name, ''),
	p.user_id ,
	p.progress_date_time
FROM p_Treatment_Progress p
	INNER JOIN p_Attachment a
	ON p.cpr_id = a.cpr_id
	AND p.attachment_id = a.attachment_id
	INNER JOIN p_Treatment_Item t
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
	AND p.encounter_id = t.open_encounter_id
	INNER JOIN p_Patient_Encounter e
	ON t.cpr_id = e.cpr_id
	AND t.open_encounter_id = e.encounter_id
	INNER JOIN c_User u
	ON p.user_id = u.user_id
WHERE p.cpr_id = @ps_cpr_id
AND p.treatment_id = @pl_treatment_id
AND p.progress_type = 'Attachment'
AND a.attachment_type = 'Signature'
AND p.current_flag = 'Y'

-- Next, add the progress records that constitute re-orders
INSERT INTO @temporders (
	cpr_id ,
	treatment_id ,
	encounter_id ,
	order_type,
	description ,
	ordered_by ,
	ordered_date)
SELECT p.cpr_id ,
	p.treatment_id ,
	p.encounter_id ,
	p.progress_type ,
	COALESCE(p.progress_value, CAST(p.progress AS varchar(255)), p.progress_type) ,
	p.user_id ,
	p.progress_date_time
FROM p_Treatment_Progress p
WHERE p.cpr_id = @ps_cpr_id
AND p.treatment_id = @pl_treatment_id
AND p.current_flag = 'Y'
AND p.progress_type IN ('Refill')
AND NOT EXISTS (
	SELECT 1
	FROM @temporders x
	WHERE x.encounter_id = p.encounter_id)

-- If the treatment wasn't signed or refilled in the encounter in which it was created, then 
-- consider the creation to be an order event
INSERT INTO @temporders (
	cpr_id ,
	treatment_id ,
	encounter_id ,
	order_type,
	description ,
	ordered_by ,
	ordered_date)
SELECT t.cpr_id ,
	t.treatment_id ,
	t.open_encounter_id ,
	CASE WHEN dbo.fn_date_truncate(t.begin_date, 'DAY') < dbo.fn_date_truncate(e.encounter_date, 'DAY') 
		THEN 'PMH'
		ELSE 'Order' END ,
	'Ordered by ' + ISNULL(u.user_full_name, ''),
	t.ordered_by ,
	t.begin_date
FROM p_Treatment_Item t
	INNER JOIN p_Patient_Encounter e
	ON t.cpr_id = e.cpr_id
	AND t.open_encounter_id = e.encounter_id
	INNER JOIN c_User u
	ON t.ordered_by = u.user_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id
AND u.user_status NOT IN ('SYSTEM', 'SPECIAL')
AND NOT EXISTS (
	SELECT 1
	FROM @temporders x
	WHERE x.encounter_id = e.encounter_id)




-- Now add the signature attachments that are from the same encounter as the order
/*
UPDATE x
SET signature_attachment_id = p.attachment_id
FROM @temporders x
	INNER JOIN p_Treatment_Progress p
	ON x.cpr_id = p.cpr_id
	AND x.treatment_id = p.treatment_id
	AND x.encounter_id = p.encounter_id
	INNER JOIN p_Attachment a
	ON p.cpr_id = a.cpr_id
	AND p.attachment_id = a.attachment_id
WHERE a.attachment_type = 'SIGNATURE'
*/

INSERT INTO @orders (
		cpr_id ,
		treatment_id ,
		encounter_id ,
		order_type ,
		description ,
		ordered_by ,
		ordered_date ,
		signature_user ,
		signature_data ,
		signature_filetype )
SELECT cpr_id ,
		treatment_id ,
		encounter_id ,
		order_type ,
		description ,
		ordered_by ,
		ordered_date ,
		signature_user ,
		signature_data ,
		signature_filetype
FROM @temporders
ORDER BY ordered_date asc, description asc


RETURN
END



GO
GRANT SELECT ON [dbo].[fn_patient_treatment_orders] TO [cprsystem]
GO

