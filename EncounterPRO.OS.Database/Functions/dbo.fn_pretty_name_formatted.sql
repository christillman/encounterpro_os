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

GO
GRANT EXECUTE
	ON [dbo].[fn_pretty_name_formatted]
	TO [cprsystem]
GO

