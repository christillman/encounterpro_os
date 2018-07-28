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

-- Drop Procedure [dbo].[jmjrpt_get_ewg]
Print 'Drop Procedure [dbo].[jmjrpt_get_ewg]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_ewg]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_ewg]
GO

-- Create Procedure [dbo].[jmjrpt_get_ewg]
Print 'Create Procedure [dbo].[jmjrpt_get_ewg]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_get_ewg
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Declare @result_value varchar(40)
Declare @EWG varchar(40)
Declare @LMP DATETIME
declare @calcday integer
declare @calcweek integer
declare @calcwkday integer
Select @cprid = @ps_cpr_id

SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
FROM p_Observation, p_Observation_Result 
WHERE (SELECT COUNT(*) FROM p_Assessment 
WHERE p_Assessment.cpr_id = @cprid
AND p_Assessment.assessment_id IN  
(Select assessment_id from c_assessment_definition 
--where ICD_9_CODE IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','648.93','659.63'))
where assessment_type = 'OB' and assessment_category_id = 'OB')
AND Isnull(p_Assessment.assessment_status,'Open') = 'Open'
AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0 
AND p_Observation.cpr_id = @cprid 
AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
AND p_Observation.observation_id = 'DEMO12457'
AND p_Observation.observation_id = p_Observation_Result.observation_id 
AND p_Observation_Result.result_value IS NOT NULL
AND p_Observation_Result.current_flag = 'Y' 
ORDER BY p_Observation_Result.created DESC)

If ((@result_value IS NOT NULL) OR (@result_value <> ''))
 Begin
  Select @EWG = 'Ultrasound exam not current' 
  if (ISDATE(@result_value)= 1)
   Begin 
    if DATEDIFF(Week,@result_value,GETDATE()) < 4 
     Begin
      Select @LMP = DateAdd(DAY,-280,@result_value) 
      Select @calcday = DateDiff(DAY,@LMP,GETDATE())
      Select @calcweek = @calcday / 7	
      Select @calcwkday = @calcweek * 7		
      Select @EWG = Str(@calcweek,2) + 'w' + Str(@calcday - @calcwkday) + 'd'
      Select @EWG = @EWG
      END
   End
 End
ELSE
 Begin
 SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
 FROM p_Observation, p_Observation_Result 
 WHERE (SELECT COUNT(*) FROM p_Assessment 
 WHERE p_Assessment.cpr_id = @cprid
 AND p_Assessment.assessment_id IN  
 (Select assessment_id from c_assessment_definition 
 --where ICD_9_CODE IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','659.63','648.93'))
 where assessment_type = 'OB' and assessment_category_id = 'OB')
 AND Isnull(p_Assessment.assessment_status,'Open') = 'Open' 
 AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0  
 AND p_Observation.cpr_id = @cprid 
 AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
 AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
 AND p_Observation.observation_id = 'DEMO12485'
 AND p_Observation.observation_id = p_Observation_Result.observation_id 
 AND p_Observation_Result.result_value IS NOT NULL 
 AND p_Observation_Result.current_flag = 'Y'  
 ORDER BY p_Observation_Result.created DESC)
 If ((@result_value IS NOT NULL) OR (@result_value <> '')) 
  Begin
   Select @EWG = 'No def LMP' 
   if isdate(@result_value) = 1
    Begin
     if DATEDIFF(Week,@result_value,GETDATE()) < 44
      Begin
       Select @LMP = DateAdd(day,280,@result_value)
       Select @calcday = DateDiff(DAY,@LMP,GETDATE())
       Select @calcweek = @calcday / 7	
       Select @calcwkday = @calcweek * 7		
       Select @EWG = Str(@calcweek,2) + 'w' + Str(@calcday - @calcwkday) + 'd'
       Select @EWG = @result_value
      END
    End
  End
 End
Select @EWG


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_ewg]
	TO [cprsystem]
GO

