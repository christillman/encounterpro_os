
drop function if exists dbo.fn_assemble_formulation
go
create function dbo.fn_assemble_formulation (@ingredient_list varchar(500), @strength_list varchar(500))
returns varchar(1000)
as begin

declare @result varchar(1000) = ''

if dbo.fn_ingredient_count(@ingredient_list) != dbo.fn_ingredient_count(@strength_list)
	return 'differing number of slashes'

	;with ingredients as (
		select trim(substr) as substr, ordinal 
		from dbo.fn_split(@ingredient_list, ' / ')
	),
	strengths as (
		select trim(substr) as substr, ordinal 
		from dbo.fn_split(@strength_list, ' / ')
	)
	-- string_agg is not adding the delimiter?
	select @result = @result + string_agg(CONVERT (NVARCHAR (MAX), concat(i.substr, ' ', s.substr, ' / ')), ' / ')
	from ingredients i
	join strengths s on s.ordinal = i.ordinal
	group by s.ordinal
	order by s.ordinal
	return trim(left(@result, len(@result) - 2))
end
go

/* 
select dbo.fn_assemble_formulation('Sodium Bicarbonate / sodium citrate / Anise / Dill / Ginger / glucose', 
	'1.2 % / 0.5 % / 0.12 % / 0.058 % / 0.5 % / 20.0 %')
	Sodium Bicarbonate 1.2 % / sodium citrate 0.5 % / Anise 0.12 % / Dill 0.058 % / Ginger 0.5 % / glucose 20.0 %
select dbo.fn_assemble_formulation([generic Name],[Dosage Strength]) from Rwanda_FDA
where dbo.fn_assemble_formulation([generic Name],[Dosage Strength]) like 'diff%'
	*/
