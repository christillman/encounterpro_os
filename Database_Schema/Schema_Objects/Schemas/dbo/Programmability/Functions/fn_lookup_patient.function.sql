CREATE FUNCTION fn_lookup_patient (
	@ps_id_domain varchar(40),
	@ps_id varchar(40) )

RETURNS varchar(12)

AS
BEGIN

DECLARE @ll_owner_id int,
		@ls_cpr_id varchar(12)

SET @ll_owner_id = NULL

SET @ls_cpr_id = dbo.fn_lookup_patient2(@ll_owner_id, @ps_id_domain, @ps_id)

RETURN @ls_cpr_id

END

