
CREATE OR ALTER FUNCTION [dbo].[fn_from_age_days](@age_from int, @age_from_unit varchar(24))
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(day, dbo.get_client_datetime(), dbo.fn_date_add_interval(dbo.get_client_datetime(), @age_from, @age_from_unit))
END
GO

GRANT EXECUTE ON [dbo].[fn_from_age_days] TO [cprsystem]
GO