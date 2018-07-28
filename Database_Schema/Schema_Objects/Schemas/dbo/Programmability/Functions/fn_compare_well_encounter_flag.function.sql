CREATE FUNCTION fn_compare_well_encounter_flag (
	@ps_well_encounter_flag_1 char(1),
	@ps_well_encounter_flag_2 char(1))

RETURNS int

AS
BEGIN

IF ISNULL(@ps_well_encounter_flag_1, 'A') = 'A' OR ISNULL(@ps_well_encounter_flag_2, 'A') = 'A' OR ISNULL(@ps_well_encounter_flag_1, 'A') = ISNULL(@ps_well_encounter_flag_2, 'A')
	RETURN 1

RETURN 0

END

