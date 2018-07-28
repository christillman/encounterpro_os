CREATE PROCEDURE sp_get_ss_prescriber_spi
(
	@ps_dea_number varchar(18)
)
AS


SELECT ap.progress_value as spi
FROM jmjtech.eproupdates.dbo.c_Actor a
	INNER JOIN jmjtech.eproupdates.dbo.c_Actor_Progress ap
	ON ap.progress_type='ID'
	AND ap.progress_key='211^surescript_spi'
WHERE a.dea_number = @ps_dea_number


