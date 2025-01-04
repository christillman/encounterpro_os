
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_encounter_charge_move]
Print 'Drop Procedure [dbo].[jmj_encounter_charge_move]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_encounter_charge_move]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_encounter_charge_move]
GO

-- Create Procedure [dbo].[jmj_encounter_charge_move]
Print 'Create Procedure [dbo].[jmj_encounter_charge_move]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_encounter_charge_move (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_encounter_charge_id int,
	@pl_problem_id int,
	@ps_direction varchar(8)
	)
AS

DECLARE @ll_problem_id int,
		@ll_billing_sequence int,
		@ll_error int,
		@ll_count int,
		@ll_current_sequence int

DECLARE @ac TABLE (
	problem_id int NOT NULL,
	billing_sequence int NOT NULL,	
	new_sequence int IDENTITY (1, 1) NOT NULL)

IF @ps_direction NOT IN ('UP', 'DOWN', 'TOP', 'BOTTOM')
	RETURN


INSERT INTO @ac (
	problem_id,
	billing_sequence)
SELECT ac.problem_id, ac.billing_sequence
FROM dbo.p_Encounter_Assessment_Charge ac
	INNER JOIN dbo.p_Encounter_Assessment a
	ON ac.cpr_id = a.cpr_id
	AND ac.encounter_id = a.encounter_id
	AND ac.problem_id = a.problem_id
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.encounter_charge_id = @pl_encounter_charge_id
ORDER BY COALESCE(ac.billing_sequence, a.assessment_sequence)

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

SELECT @ll_current_sequence = new_sequence
FROM @ac
WHERE problem_id = @pl_problem_id

IF @ps_direction = 'UP'
	BEGIN
	IF @ll_current_sequence > 1
		BEGIN
		UPDATE @ac
		SET billing_sequence = new_sequence
		WHERE new_sequence < @ll_current_sequence - 1
		OR new_sequence > @ll_current_sequence

		UPDATE @ac
		SET billing_sequence = @ll_current_sequence
		WHERE new_sequence = @ll_current_sequence - 1

		UPDATE @ac
		SET billing_sequence = @ll_current_sequence - 1
		WHERE new_sequence = @ll_current_sequence
		END
	END

IF @ps_direction = 'DOWN'
	BEGIN
	IF @ll_current_sequence < @ll_count
		BEGIN
		UPDATE @ac
		SET billing_sequence = new_sequence
		WHERE new_sequence < @ll_current_sequence
		OR new_sequence > @ll_current_sequence + 1

		UPDATE @ac
		SET billing_sequence = @ll_current_sequence
		WHERE new_sequence = @ll_current_sequence + 1

		UPDATE @ac
		SET billing_sequence = @ll_current_sequence + 1
		WHERE new_sequence = @ll_current_sequence
		END
	END

IF @ps_direction = 'TOP'
	BEGIN
	IF @ll_current_sequence > 1
		BEGIN
		UPDATE @ac
		SET billing_sequence = new_sequence
		WHERE new_sequence > @ll_current_sequence

		UPDATE @ac
		SET billing_sequence = new_sequence + 1
		WHERE new_sequence < @ll_current_sequence

		UPDATE @ac
		SET billing_sequence = 1
		WHERE new_sequence = @ll_current_sequence
		END
	END

IF @ps_direction = 'BOTTOM'
	BEGIN
	IF @ll_current_sequence < @ll_count
		BEGIN
		UPDATE @ac
		SET billing_sequence = new_sequence
		WHERE new_sequence < @ll_current_sequence

		UPDATE @ac
		SET billing_sequence = new_sequence - 1
		WHERE new_sequence > @ll_current_sequence

		UPDATE @ac
		SET billing_sequence = @ll_count
		WHERE new_sequence = @ll_current_sequence
		END
	END


UPDATE ac
SET billing_sequence = x.billing_sequence
FROM dbo.p_Encounter_Assessment_Charge ac
	INNER JOIN @ac x
	ON ac.cpr_id = @ps_cpr_id
	AND ac.encounter_id = @pl_encounter_id
	AND ac.problem_id = x.problem_id
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.encounter_charge_id = @pl_encounter_charge_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_encounter_charge_move]
	TO [cprsystem]
GO

