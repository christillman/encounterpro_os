
drop function if exists dbo.fn_ingredients_equal 
go
create function dbo.fn_ingredients_equal (@ingredient_list_1 varchar(500), @ingredient_list_2 varchar(500))
returns int
as begin
return case 
	when exists 
		(
		select substr from dbo.fn_split(@ingredient_list_1, ' / ')
		except 
		select substr from dbo.fn_split(@ingredient_list_2, ' / ')
		) then 0 
	when exists 
		(
		select substr from dbo.fn_split(@ingredient_list_2, ' / ')
		except 
		select substr from dbo.fn_split(@ingredient_list_1, ' / ')
		) then 0 
	else 1 end
end

