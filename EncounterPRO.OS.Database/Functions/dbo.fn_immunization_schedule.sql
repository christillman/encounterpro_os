
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_immunization_schedule]
Print 'Drop Function [dbo].[fn_immunization_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_immunization_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_immunization_schedule]
GO

-- Create Function [dbo].[fn_immunization_schedule]
Print 'Create Function [dbo].[fn_immunization_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_immunization_schedule (
	@pl_disease_id int,
	@pl_next_dose_number int,
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime,
	@pdt_first_dose_date datetime,
	@pdt_last_dose_date datetime)

RETURNS @schedule TABLE (
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_schedule_sequence int NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @pl_next_dose_number IS NULL
	RETURN

SET @pdt_current_date = convert(datetime, convert(varchar,@pdt_current_date, 112))
SET @pdt_first_dose_date = convert(datetime, convert(varchar,@pdt_first_dose_date, 112))
SET @pdt_last_dose_date = convert(datetime, convert(varchar,@pdt_last_dose_date, 112))

DECLARE @ldt_dose_date datetime,
		@ldt_hypothetical_current_date datetime,
		@ldt_hypothetical_first_dose_date datetime,
		@ldt_hypothetical_last_dose_date datetime,
		@ll_dose_schedule_sequence int,
		@ls_dose_text varchar(255)

SET @ll_dose_schedule_sequence = NULL
SET @ldt_hypothetical_current_date = @pdt_current_date
SET @ldt_hypothetical_first_dose_date = @pdt_first_dose_date
SET @ldt_hypothetical_last_dose_date = @pdt_last_dose_date

WHILE 1 = 1
	BEGIN

	SELECT @ldt_dose_date = next_dose_date,
			@ll_dose_schedule_sequence = next_dose_schedule_sequence,
			@ls_dose_text = next_dose_text
	FROM dbo.fn_immunization_next_dose_date(@pl_disease_id ,
											@pl_next_dose_number ,
											@pdt_date_of_birth ,
											@ldt_hypothetical_current_date ,
											@ldt_hypothetical_first_dose_date ,
											@ldt_hypothetical_last_dose_date)
	
	IF @@ROWCOUNT = 0
		BREAK
	
	IF @ldt_dose_date < @ldt_hypothetical_current_date
		SET @ldt_dose_date = @ldt_hypothetical_current_date
	
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_schedule_sequence,
		dose_text )
	VALUES (
		@pl_next_dose_number,
		@ldt_dose_date,
		@ll_dose_schedule_sequence,
		@ls_dose_text)

	IF @pl_next_dose_number = 1
		SET @ldt_hypothetical_first_dose_date = @ldt_dose_date
		
	SET @pl_next_dose_number = @pl_next_dose_number + 1
	SET @ldt_hypothetical_last_dose_date = @ldt_dose_date
	SET @ldt_hypothetical_current_date = @ldt_dose_date
	
	END

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_immunization_schedule] TO [cprsystem]
GO

