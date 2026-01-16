
drop function if exists dbo.fn_ingredient_count
go
create function dbo.fn_ingredient_count (@ingredient_list varchar(500))
returns int
as begin
return (select count(*) as cnt 
from dbo.fn_split(@ingredient_list, ' / ')
)
end
