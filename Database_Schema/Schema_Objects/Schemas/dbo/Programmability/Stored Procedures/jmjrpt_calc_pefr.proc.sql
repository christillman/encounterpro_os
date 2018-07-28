


CREATE PROCEDURE jmjrpt_calc_pefr
	@ps_cpr_id varchar(12)
AS
declare @cprid varchar(12)
declare @ideal_pefr numeric,@calc_yellow numeric,@calc_green numeric
declare @green varchar(36)
declare @yellow varchar(36)
declare @red varchar(36)
declare @ru varchar(24)
declare @rv numeric
declare @zone varchar(36)
declare @calc_pefr sql_variant,@calc_pefr2 sql_variant
CREATE TABLE #temp(descrip varchar(12), value varchar(36)) ON [PRIMARY]

Select @cprid = @ps_cpr_id
SELECT @rv = (SELECT TOP 1 result_value
FROM p_observation_result 
WHERE location_result_sequence = 
(SELECT TOP 1 location_result_sequence FROM p_observation_result 
WHERE result_value IS NOT NULL AND cpr_id = @cprid  
AND observation_id = 'HGT' order by result_date_time desc))
SELECT @ru = (SELECT TOP 1 result_unit
FROM p_observation_result 
WHERE location_result_sequence = 
(SELECT TOP 1 location_result_sequence FROM p_observation_result 
WHERE result_value IS NOT NULL 
AND result_value <> '' 
AND cpr_id = @cprid 
AND observation_id = 'HGT' order by result_date_time desc))
IF @ru = 'INCH' 
begin
   Set @rv = @rv * 2.5
end
if @rv is not null
begin
Set @calc_pefr = convert(sql_variant,((@rv - 80) * 5))
Select @ideal_pefr = convert(numeric,@calc_pefr)
Select @zone = convert(varchar,@ideal_pefr)
insert into #temp values
    ('PEFR',@zone) 

Set @calc_pefr2 = convert(sql_variant,(@ideal_pefr * .8))
Select @calc_green = convert(numeric,@calc_pefr2)
Set @zone = convert(varchar,@ideal_pefr) + ' - ' + convert(varchar,@calc_green)
insert into #temp values
    ('Green',@zone)

Set @calc_pefr2 = convert(sql_variant,(@ideal_pefr * .5))
Set @calc_yellow = convert(numeric,@calc_pefr2)
Set @zone = convert(varchar,@calc_green) + ' - ' + convert(varchar,@calc_yellow) 
insert into #temp values
    ('Yellow',@zone)

Set @zone = 'less than ' + convert(varchar,@calc_yellow) 

insert into #temp values
    ('Red',@zone)  
Select descrip,value
FROM #temp
end
else
Begin
Select 'No height'
end
DROP TABLE #temp