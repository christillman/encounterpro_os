--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
SET QUOTED_IDENTIFIER OFF
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

