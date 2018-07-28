CREATE PROCEDURE jmj_modify_age_range_references (
	@pl_from_age_range_id int,
	@pl_to_age_range_id int)
AS

-- This stored procedure creates a local copy of the specified age_range and returns the new age_range_id
DECLARE @ll_count int,
		@ll_error int

BEGIN TRANSACTION

UPDATE c_Age_Range_Assessment
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Age_Range_Procedure
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Chart_Section
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Immunization_Dose_Schedule
SET first_dose_age_range_id = @pl_to_age_range_id
WHERE first_dose_age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Immunization_Dose_Schedule
SET last_dose_age_range_id = @pl_to_age_range_id
WHERE last_dose_age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Immunization_Dose_Schedule
SET patient_age_range_id = @pl_to_age_range_id
WHERE patient_age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Maintenance_Patient_Class
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Maintenance_Rule
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Observation_Result_Range
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Observation_Tree
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Workplan_Item
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE c_Workplan_Selection
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE u_Exam_Selection
SET age_range_id = @pl_to_age_range_id
WHERE age_range_id = @pl_from_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

COMMIT TRANSACTION

RETURN @pl_to_age_range_id

