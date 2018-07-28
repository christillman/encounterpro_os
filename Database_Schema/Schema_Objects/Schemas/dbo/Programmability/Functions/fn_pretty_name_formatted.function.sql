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
		@ll_keyword_index int

IF @ps_name_format = 'Full'
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERNECES', 'Patient Name Format Full', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{ First}{ M.}{ (Nickname)}{ Last}{ Suffix}'
	END

IF @ps_name_format = 'List'
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERNECES', 'Patient Name Format List', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{Last},{ First}{ M.}{ (Nickname)}{, Suffix}'
	END

IF @ps_name_format IS NULL OR @ps_name_format = '' OR CHARINDEX('{', @ps_name_format) = 0
	BEGIN
	SET @ps_name_format = dbo.fn_get_preference('PREFERNECES', 'Patient Name Format Full', NULL, NULL)
	IF @ps_name_format IS NULL
		SET @ps_name_format = '{ First}{ M.}{ (Nickname)}{ Last}{ Suffix}'
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
		IF @ll_keyword_index > 0 AND LEN(@ps_name_prefix) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Prefix', @ps_name_prefix)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('First', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_first_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'First', @ps_first_name)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Middle', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_middle_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Middle', @ps_middle_name)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Last', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_last_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Last', @ps_last_name)
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
		IF @ll_keyword_index > 0 AND LEN(@ps_name_suffix) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Suffix', @ps_name_suffix)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('Degree', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_degree) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'Degree', @ps_degree)
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('F', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_first_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'F', LEFT(@ps_first_name, 1))
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('M', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_middle_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'M', LEFT(@ps_middle_name, 1))
		END		

	IF @ll_keyword_index = 0
		BEGIN
		SET @ll_keyword_index = CHARINDEX('L', @ls_token_contents)
		IF @ll_keyword_index > 0 AND LEN(@ps_last_name) > 0
			SET @ls_patient_full_name = @ls_patient_full_name + REPLACE(@ls_token_contents, 'L', LEFT(@ps_last_name, 1))
		END		

	IF @ll_index > LEN(@ps_name_format)
		BREAK
	END



RETURN @ls_patient_full_name 

END

