
CREATE OR ALTER FUNCTION [dbo].[get_client_datetime]()
RETURNS DATETIME
AS
BEGIN
RETURN (SELECT TOP 1 CAST(SYSDATETIMEOFFSET() AT TIME ZONE IsNull(timezone,'E. Africa Standard Time') AS datetime)
	FROM c_Database_Status)
END
