
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
	SET @ll_seed = DATEDIFF(second, '1/1/2010', dbo.get_client_datetime()) + ISNULL(@pl_maintenance_rule_id, 0)

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

