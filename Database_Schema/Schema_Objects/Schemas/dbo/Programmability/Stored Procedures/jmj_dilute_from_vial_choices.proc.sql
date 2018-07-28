CREATE PROCEDURE jmj_dilute_from_vial_choices (
	@ps_cpr_id varchar(24) = NULL,
	@ps_vial_type varchar(24)
)

AS

DECLARE @vialchoices TABLE (
	vial_type varchar(24) NOT NULL )

DECLARE @ls_dilute_from_vial_type varchar(24)

SET @ls_dilute_from_vial_type = @ps_vial_type

WHILE 1 = 1
	BEGIN
	SELECT @ls_dilute_from_vial_type = dilute_from_vial_type
	FROM c_Vial_Type
	WHERE vial_type = @ls_dilute_from_vial_type
	IF @@ROWCOUNT <> 1 
		BREAK
	IF @ls_dilute_from_vial_type IS NULL
		BREAK

	-- Only add this vial type to the list of choices if this patient has one open
	IF @ps_cpr_id IS NULL OR EXISTS(	SELECT 1
										FROM p_Treatment_Item
										WHERE cpr_id = @ps_cpr_id
										AND treatment_type = 'AllergyVialInstance'
										AND vial_type = @ls_dilute_from_vial_type
										AND treatment_status = 'OPEN')
	INSERT INTO @vialchoices (
		vial_type)
	VALUES (
		@ls_dilute_from_vial_type)

END

SELECT v.vial_type, 
		v.full_strength_ratio,
		description=dbo.fn_vial_type_description(v.vial_type),
		selected_flag=0
FROM @vialchoices x
	INNER JOIN c_Vial_Type v
	ON x.vial_type = v.vial_type
ORDER BY v.full_strength_ratio

