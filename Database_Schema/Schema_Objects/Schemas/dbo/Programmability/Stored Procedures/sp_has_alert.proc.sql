/****** Object:  Stored Procedure dbo.sp_has_alert    Script Date: 7/25/2000 8:43:58 AM ******/
CREATE PROCEDURE dbo.sp_has_alert (
	@ps_cpr_id varchar(12),
	@ps_alert_category_id varchar(12),
	@pi_alert_count smallint OUTPUT )
AS
SELECT @pi_alert_count = count(alert_id)
FROM p_Chart_Alert
WHERE cpr_id = @ps_cpr_id
AND alert_category_id = @ps_alert_category_id
AND alert_status IS NULL

