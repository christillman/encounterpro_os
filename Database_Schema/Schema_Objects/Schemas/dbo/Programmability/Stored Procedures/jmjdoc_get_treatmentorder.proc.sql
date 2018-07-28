CREATE PROCEDURE jmjdoc_get_treatmentorder (
	@ps_cpr_id varchar(24),
	@pl_treatmentid int
)

AS

/*****************************************************************************************************
	
			Specific Treatment orders

	Retrieve all the Specific Treatment order Information
*****************************************************************************************************/

SELECT order_sequence, Order_Type, Encounter_id, Ordered_Date, Ordered_By, Description
FROM dbo.fn_patient_treatment_orders(@ps_cpr_id, @pl_treatmentid)
ORDER BY order_sequence asc

