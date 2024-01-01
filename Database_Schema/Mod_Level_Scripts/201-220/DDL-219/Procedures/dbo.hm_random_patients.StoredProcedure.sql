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

-- Drop Procedure [dbo].[hm_random_patients]
Print 'Drop Procedure [dbo].[hm_random_patients]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[hm_random_patients]') AND [type]='P'))
DROP PROCEDURE [dbo].[hm_random_patients]
GO

-- Create Procedure [dbo].[hm_random_patients]
Print 'Create Procedure [dbo].[hm_random_patients]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hm_random_patients] 
	@pl_maintenance_rule_id int,
	@pl_patient_count int
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @patients TABLE (
	[cpr_id] [varchar] (12) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NULL
	)

DECLARE @population TABLE (
	IdentityIndex int IDENTITY (1, 1) NOT NULL,
	ActorIndex int NULL,
	cpr_id [varchar] (12) NOT NULL,
	begin_date [datetime] NOT NULL,
	end_date [datetime] NULL
	)

DECLARE @ll_patient_count int,
	@ll_index int,
	@ll_population_count int,
	@ll_seed int,
	@ls_sex char(1),
	@ldt_date_of_birth datetime,
	@ldt_max_date_of_birth datetime,
	@ll_seconds_range int,
	@ls_middle_initial nvarchar(1)

-- Get the population.  If a patient class is passed in then limit the population to only
-- the current members of that class
IF @pl_maintenance_rule_id IS NULL OR @pl_maintenance_rule_id = 0
	INSERT INTO @population (
		cpr_id,
		begin_date)
	SELECT cpr_id,
		created
	FROM p_Patient
	WHERE patient_status = 'Active'
ELSE
	INSERT INTO @population (
		cpr_id,
		begin_date)
	SELECT c.cpr_id,
		begin_date = MIN(status_date)
	FROM dbo.p_Maintenance_Class c
	WHERE c.maintenance_rule_id = @pl_maintenance_rule_id
	AND c.current_flag = 'Y'
	AND c.in_class_flag = 'Y'
	GROUP BY c.cpr_id


SELECT @ll_population_count = @@ROWCOUNT

UPDATE @population
SET ActorIndex = IdentityIndex

-- If the desired number is greater than or equal to the population, just return the population
IF @pl_patient_count >= @ll_population_count
	BEGIN
	INSERT INTO @patients (
		cpr_id,
		begin_date,
		end_date)
	SELECT
		cpr_id,
		begin_date,
		end_date
	FROM @population
	END
ELSE
	BEGIN
	SET @ll_seed = DATEDIFF(second, '1/1/2010', getdate()) + ISNULL(@pl_maintenance_rule_id, 0)

	SET @ll_patient_count = 0

	WHILE 1 = 1
		BEGIN
		IF @ll_population_count < 1
			BREAK
		
		SET @ll_index = RAND() * @ll_population_count

		INSERT INTO @patients (
			cpr_id,
			[begin_date],
			[end_date])
		SELECT
			cpr_id,
			[begin_date],
			[end_date]
		FROM @population
		WHERE ActorIndex = @ll_index
		
		IF @@rowcount = 1
			BEGIN
			SET @ll_patient_count = @ll_patient_count + 1
			IF @ll_patient_count >= @pl_patient_count
				BREAK
			
			-- Delete the patient just selected
			DELETE @population
			WHERE ActorIndex = @ll_index
			
			-- Move the last patient into the empty slot so the indexes are still contiguous
			UPDATE @population
			SET ActorIndex = @ll_index
			WHERE ActorIndex = @ll_population_count
			
			SET @ll_population_count = @ll_population_count - 1
			END
		
		
		END
	END

SELECT	cpr_id,
		[begin_date],
		[end_date]
FROM @patients

END
GO

