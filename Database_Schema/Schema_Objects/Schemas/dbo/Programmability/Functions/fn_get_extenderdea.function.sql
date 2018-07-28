CREATE FUNCTION fn_get_extenderdea (
	@ps_dea_number varchar(18)
)

RETURNS varchar(21)

AS
BEGIN

DECLARE @ls_extenderdea varchar(21),
	@ll_max int
DECLARE @extender_dea_list TABLE (
	deanumber varchar(18) NOT NULL,
	suffix int NOT NULL)

INSERT INTO @extender_dea_list
	( deanumber,
	  suffix
	 )
SELECT ap.progress_value, substring(ap.progress_value,PATINDEX('%-%',ap.progress_value) + 1,len(ap.progress_value)-PATINDEX('%-%',ap.progress_value))
FROM c_user_progress  ap
WHERE ap.current_flag = 'Y'
AND ap.progress_type='Property'
AND ap.progress_key='SureScripts_Supervisor_DEA'
AND COALESCE(ap.progress_value,ap.progress) like @ps_dea_number+'%'

SELECT @ll_max = max(suffix)
FROM @extender_dea_list

IF @ll_max <= 0 OR @ll_max IS NULL
	SET @ls_extenderdea = @ps_dea_number + '-1'
ELSE
	BEGIN
	SET @ll_max = @ll_max + 1
	SET @ls_extenderdea = @ps_dea_number + '-' + CAST(@ll_max AS varchar(8))

	END

RETURN @ls_extenderdea

END



