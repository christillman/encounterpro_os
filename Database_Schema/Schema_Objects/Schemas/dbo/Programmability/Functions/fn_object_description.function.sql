CREATE FUNCTION fn_object_description (
	@ps_object varchar(40),
	@ps_key varchar(40) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_description varchar(255)

SET @ls_description = @ps_key

IF @ps_object = 'Drug'
	BEGIN
	SELECT @ls_description = common_name
	FROM c_Drug_Definition
	WHERE drug_id = @ps_key
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_key
	END

IF @ps_object = 'Consultant'
	BEGIN
	SELECT @ls_description = description
	FROM c_Consultant
	WHERE consultant_id = @ps_key
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_key
	END

RETURN @ls_description 

END
