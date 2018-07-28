CREATE FUNCTION dbo.fn_patient_result_percentile (
	@pl_location_result_sequence int,
	@ps_percentile_algorithm varchar(40) )

RETURNS @percentile TABLE (
	location_result_sequence int NOT NULL,
	percentile_algorithm varchar(40) NOT NULL,
	percentile decimal(18, 6) NULL
	)
AS
BEGIN
DECLARE @ld_percentile decimal(18, 6)

IF @pl_location_result_sequence > 0 AND LEN(@ps_percentile_algorithm) > 0
	INSERT INTO @percentile (
		location_result_sequence,
		percentile_algorithm)
	VALUES (
		@pl_location_result_sequence,
		@ps_percentile_algorithm)
ELSE
	RETURN


-- Calculate the percentile for the selected algorithm
SET @ld_percentile = @pl_location_result_sequence

-- Update the return result set
UPDATE @percentile
SET percentile = @ld_percentile % 100

RETURN

END

