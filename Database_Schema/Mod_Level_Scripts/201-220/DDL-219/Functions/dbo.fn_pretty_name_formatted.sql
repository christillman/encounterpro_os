﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_pretty_name_formatted]
Print 'Drop Function [dbo].[fn_pretty_name_formatted]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_pretty_name_formatted]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_pretty_name_formatted]
GO

-- Create Function [dbo].[fn_pretty_name_formatted]
Print 'Create Function [dbo].[fn_pretty_name_formatted]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_pretty_name_formatted (
	@ps_first_name varchar(20),
	@ps_middle_name varchar(20),
	@ps_last_name varchar(40),
	@ps_nickname varchar(20),
	@ps_name_suffix varchar(12),
	@ps_name_prefix varchar(12),
	@ps_degree varchar(12),
	@ps_name_format varchar(64) )

RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_patient_full_name varchar(80),
		@ll_index int,
		@ll_next_token_start int,
		@ll_next_token_end int,
		@ls_token_contents varchar(64),
		@ll_keyword_index int,
		@ls_last_name varchar(40) = @ps_last_name,
		@ls_first_name varchar(40) = @ps_first_name,
		@ls_middle_name varchar(40) = @ps_middle_name,
		@ls_name_prefix varchar(12) = @ps_name_prefix,
		@ls_name_suffix varchar(12) = @ps_name_suffix,
		@ls_degree varchar(24) = @ps_degree,
		@lb_wordcap char(1) = 'N'

IF @ps_name_format = 'Full'
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERENCES', 'Patient Name Format Full', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{ First}{ M.}{ (Nickname)}{ Last}{ Suffix}'
	END

IF @ps_name_format = 'List'
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERENCES', 'Patient Name Format List', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{Last},{ First}{ M.}{ (Nickname)}{, Suffix}'
	END

IF @ps_name_format IS NULL OR @ps_name_format = '' OR CHARINDEX('{', @ps_name_format) = 0
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERENCES', 'Patient Name Format Full', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{ First}{ M.}{ (Nickname)}{ Last}{ Suffix}{, Degree}'
	END


SET @lb_wordcap = dbo.fn_get_preference('PREFERENCES', 'NameCap', NULL, NULL)
IF @lb_wordcap IS NULL
	SET @lb_wordcap = 'N'

IF @lb_wordcap = 'Y' 
BEGIN
	SET @ls_last_name = dbo.fn_wordcap(@ls_last_name)
	SET @ls_first_name = dbo.fn_wordcap(@ls_first_name)
	SET @ls_middle_name = dbo.fn_wordcap(@ls_middle_name)
	SET @ls_last_name = dbo.fn_wordcap(@ls_last_name)
	SET @ls_name_prefix = dbo.fn_wordcap(@ls_name_prefix)
	SET @ls_name_suffix = dbo.fn_wordcap(@ls_name_suffix)
	SET @ls_degree = CASE WHEN UPPER(@ps_degree) = 'PHD' THEN 'PhD' 
				WHEN UPPER(@ps_degree) = 'PH.D.' THEN 'Ph.D.' 
				ELSE UPPER(@ps_degree) END
END


SET @ll_index = 1
SET @ls_patient_full_name = ''

WHILE 1 = 1
	BEGIN
	SET @ll_next_token_start = CHARINDEX('{', @ps_name_format, @ll_index)

	IF @ll_next_token_start IS NULL
		BREAK

	IF @ll_next_token_start = 0
		BEGIN
		-- No more tokens so append the rest of the format string and exit
		SET @ls_patient_full_name = @ls_patient_full_name + SUBSTRING(@ps_name_format, @ll_index, LEN(@ps_name_format) - @ll_index + 1)
		BREAK
		END

	SET @ll_next_token_end = CHARINDEX('}', @ps_name_format, @ll_next_token_start + 1)


	IF @ll_next_token_end IS NULL
		BREAK

	IF @ll_next_token_end = 0
		BEGIN
		-- No more tokens so append the rest of the format string and exit
		SET @ls_patient_full_name = @ls_patient_full_name + SUBSTRING(@ps_name_format, @ll_index, LEN(@ps_name_format) - @ll_index + 1)
		BREAK
		END
	
	-- Append any characters between the tokens
	IF @ll_next_token_start > @ll_index
		SET @ls_patient_full_name = @ls_patient_full_name + SUBSTRING(@ps_name_format, @ll_index, @ll_next_token_start - @ll_index)

	SET @ll_index = @ll_next_token_end + 1

	SET @ls_token_contents = SUBSTRING(@ps_name_format, @ll_next_token_start + 1, @ll_next_token_end - @ll_next_token_start - 1)

	SET @ll_keyword_index = 0

	-- Determine which keyword is in the token and substitute the appropriate value
	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Prefix', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_name_prefix) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Prefix', @ls_name_prefix)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('First', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_first_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'First', @ls_first_name)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Middle', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_middle_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Middle', @ls_middle_name)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Last', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_last_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Last', @ls_last_name)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Nickname', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_nickname) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Nickname', @ps_nickname)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Suffix', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_name_suffix) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Suffix', @ls_name_suffix)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Degree', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_degree) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Degree', 
				CASE WHEN UPPER(@ls_degree) = 'PHD' THEN 'PhD' 
				WHEN UPPER(@ls_degree) = 'PH.D.' THEN 'Ph.D.' 
				ELSE UPPER(@ls_degree) END)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('F', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_first_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'F', LEFT(@ls_first_name, 1))
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('M', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_middle_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'M', LEFT(@ls_middle_name, 1))
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('L', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ls_last_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'L', LEFT(@ls_last_name, 1))
		END		

	IF @ll_index > LEN(@ps_name_format)
		BREAK
	END



RETURN @ls_patient_full_name 

END

/*
select dbo.fn_pretty_name_formatted(
	'chRis' ,
	'DEAN' ,
	'TiLLmAn' ,
	'toff' ,
	'sr' ,
	'mr.' ,
	'MspDc',
	NULL)

select dbo.fn_pretty_name ( 
	'TiLLmAn' ,
	'chRis' ,
	'DEAN' ,
	'sr' ,
	'mr.' ,
	'phd' )

*/

GO
GRANT EXECUTE ON [dbo].[fn_pretty_name_formatted] TO [cprsystem]
GO

