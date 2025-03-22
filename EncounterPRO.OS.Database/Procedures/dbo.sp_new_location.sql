
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_new_location]
Print 'Drop Procedure [dbo].[sp_new_location]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_location]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_location]
GO

-- Create Procedure [dbo].[sp_new_location]
Print 'Create Procedure [dbo].[sp_new_location]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_new_location (
	@ps_location varchar(24) OUTPUT,
	@ps_location_domain varchar(12) = 'NA',
	@ps_description varchar(40),
	@pi_sort_sequence smallint = NULL,
	@ps_diffuse_flag char(1) = NULL,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL )
AS
DECLARE @ll_key_value integer,
		@ls_owner_id varchar(8),
		@ls_status varchar(8),
		@ll_customer_id int


-- See if the location already exists
SELECT @ps_location = location,
		@ls_status = status
FROM c_Location
WHERE location_domain = @ps_location_domain
AND description = @ps_description

IF @ps_location IS NOT NULL
	BEGIN
	-- If we're adding a visible location and the existing is not visible, then
	-- make it visible
	IF @ps_status = 'OK' AND @ls_status <> 'OK'
		UPDATE c_Location
		SET status = 'OK'
		WHERE location = @ps_location
	END
ELSE
	BEGIN
	SELECT @ll_customer_id = customer_id
	FROM c_database_status

	IF @pl_owner_id IS NULL
		SET @pl_owner_id = @ll_customer_id

	IF @pl_owner_id = @ll_customer_id AND @ps_status IS NULL
		SET @ps_status = 'OK'
	ELSE
		SET @ps_status = 'NA'

	SET @ls_owner_id = CAST(@pl_owner_id AS varchar(8))
	
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'LOCATION',
		@pl_key_value = @ll_key_value OUTPUT

	SELECT @ps_location = @ls_owner_id + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_Location where location = @ps_location)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'LOCATION',
			@pl_key_value = @ll_key_value OUTPUT

		SELECT @ps_location = @ls_owner_id + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END
	
	IF @ps_location_domain IS NULL
		SET @ps_location_domain = 'NA'
		
	IF @ps_diffuse_flag IS NULL
		SET @ps_diffuse_flag = 'N'

	IF @pi_sort_sequence IS NULL
		SELECT @pi_sort_sequence = max(sort_sequence)
		FROM c_Location
		WHERE location_domain = @ps_location_domain
	
	IF @pi_sort_sequence IS NULL
		SET @pi_sort_sequence = 1
	ELSE
		SET @pi_sort_sequence = @pi_sort_sequence + 1

	INSERT INTO c_Location (
		location,
		location_domain,
		description,
		sort_sequence,
		diffuse_flag,
		status,
		id,
		owner_id )
	VALUES (
		@ps_location,
		@ps_location_domain,
		@ps_description,
		@pi_sort_sequence,
		@ps_diffuse_flag,
		@ps_status,
		newid(),
		@pl_owner_id )
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_new_location]
	TO [cprsystem]
GO

