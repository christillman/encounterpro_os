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

-- Drop Procedure [dbo].[jmj_copy_BS_to_phone_list]
Print 'Drop Procedure [dbo].[jmj_copy_BS_to_phone_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_BS_to_phone_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_BS_to_phone_list]
GO

-- Create Procedure [dbo].[jmj_copy_BS_to_phone_list]
Print 'Create Procedure [dbo].[jmj_copy_BS_to_phone_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_BS_to_phone_list
AS
--This script converts BARTON Schmitt into TelephoneTriage.    
--After running this script you may need to set the rooms in the 
--two Telephone Encounter workplans.

UPDATE c_menu_item
SET menu_item = 'TelephoneTriage'
WHERE menu_item = 'BARTON'

UPDATE c_menu_item_attribute
SET value = 'TelephoneTriage'
WHERE value = 'BARTON'

UPDATE c_workplan_item
SET ordered_treatment_type = 'TelephoneTriage'
WHERE ordered_treatment_type = 'BARTON'

UPDATE c_workplan_item_attribute
SET value = 'TelephoneTriage'
WHERE value = 'BARTON'

UPDATE c_treatment_type
SET status = 'NA'
WHERE treatment_type = 'BARTON'

UPDATE c_treatment_type
SET status = 'OK'
WHERE treatment_type = 'TelephoneTriage'

UPDATE c_treatment_type_list
SET treatment_type = 'TelephoneTriage'
WHERE treatment_type = 'BARTON'

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'DEMO13165'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = 'DEMO13165')

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'DEMO14203'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = 'DEMO14203')

INSERT INTO c_observation_observation_cat
(
	treatment_type
	,observation_category_id
	,observation_id
)

SELECT	distinct
	'TelephoneTriage'
	,'TELE'
	,'0^22738'

FROM c_observation_observation_cat
WHERE NOT EXISTS (select observation_id from c_observation_observation_cat
WHERE observation_category_id = 'TELE'
AND observation_id = '0^22738')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$FP'
	,'TEST_TelephoneTriage'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = 'DEMO14203')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$FP'
	,'TEST_TelephoneTriage'
	,'Call Information'
	,'0^22738'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$FP'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = '0^22738')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$PEDS'
	,'TEST_TelephoneTriage'
	,'Provider-Initiated Phone Record'
	,'DEMO14203'
	,2

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = 'DEMO14203')

INSERT INTO u_top_20
(
	user_id
	,top_20_code
	,item_text
	,item_id
	,sort_sequence
)

SELECT	distinct
	'$PEDS'
	,'TEST_TelephoneTriage'
	,'Call Information'
	,'0^22738'
	,1

FROM u_top_20
WHERE NOT EXISTS (select item_id from u_top_20
WHERE user_id = '$PEDS'
AND top_20_code = 'TEST_TelephoneTriage'
AND item_id = '0^22738')

UPDATE c_menu_item
SET button = 'button_phone_large.bmp'
WHERE button = 'button_barton_schmitt.bmp'

UPDATE o_rooms
SET default_encounter_type = 'PHONE1'
WHERE default_encounter_type = 'BartonSchmittProvide'

UPDATE o_rooms
SET default_encounter_type = 'PHONE'
WHERE default_encounter_type = 'BartonSchmitt'

UPDATE p_treatment_item
SET treatment_type = 'TelephoneTriage'
WHERE treatment_type = 'BARTON'

GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_BS_to_phone_list]
	TO [cprsystem]
GO

