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

-- Drop Procedure [dbo].[jmjrpt_calc_pefr]
Print 'Drop Procedure [dbo].[jmjrpt_calc_pefr]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_calc_pefr]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_calc_pefr]
GO

-- Create Procedure [dbo].[jmjrpt_calc_pefr]
Print 'Create Procedure [dbo].[jmjrpt_calc_pefr]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



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


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_calc_pefr]
	TO [cprsystem]
GO

