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

-- Drop Procedure [dbo].[sp_get_encounterpro_message]
Print 'Drop Procedure [dbo].[sp_get_encounterpro_message]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_encounterpro_message]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_encounterpro_message]
GO

-- Create Procedure [dbo].[sp_get_encounterpro_message]
Print 'Create Procedure [dbo].[sp_get_encounterpro_message]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_encounterpro_message (
	@ps_user_id varchar(24) = NULL ,
	@pl_patient_workplan_item_id int = NULL,
	@ps_ordered_service varchar(24) = '%' )
AS

DECLARE @ll_attribute_sequence int

DECLARE @messages TABLE (
	patient_workplan_item_id int NOT NULL,
	attribute_sequence int NOT NULL)
	

DECLARE @workplan_item TABLE (
	patient_workplan_item_id int NOT NULL,
	ordered_service varchar(24) NULL,
	service_description varchar(80) NULL,
	service_button varchar(64) NULL,
	service_icon varchar(64) NULL,
	owned_by varchar(24) NOT NULL,
	description varchar(80) NULL,
	dispatch_date datetime NULL,
	begin_date datetime NULL,
	end_date datetime NULL,
	status varchar(12) NULL,
	folder varchar(40) NULL,
	from_user_id varchar(24) NULL,
	from_user varchar(12) NULL,
	from_user_color int NULL,
	to_user_id varchar(24) NULL,
	to_user varchar(12) NULL,
	to_user_color int NULL,
	message text NULL,
	cpr_id varchar(12) NULL,
	patient_name varchar(80) NULL,
	selected_flag int NOT NULL DEFAULT (0),
	priority smallint NULL )

IF @pl_patient_workplan_item_id IS NOT NULL
	BEGIN
	INSERT INTO @workplan_item (
		patient_workplan_item_id,
		ordered_service,
		owned_by,
		description,
		dispatch_date,
		begin_date,
		end_date,
		status,
		folder,
		from_user_id,
		to_user_id,
		cpr_id,
		priority)
	SELECT patient_workplan_item_id,
		ordered_service,
		owned_by,
		description,
		dispatch_date,
		begin_date,
		end_date,
		status,
		folder,
		ordered_by,
		ordered_for,
		cpr_id,
		priority
	FROM p_Patient_WP_Item WITH (NOLOCK)
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	END
ELSE
	BEGIN
	INSERT INTO @workplan_item (
		patient_workplan_item_id,
		ordered_service,
		owned_by,
		description,
		dispatch_date,
		begin_date,
		end_date,
		status,
		folder,
		from_user_id,
		to_user_id,
		cpr_id,
		priority)
	SELECT patient_workplan_item_id,
		ordered_service,
		owned_by,
		description,
		dispatch_date,
		begin_date,
		end_date,
		status,
		folder,
		ordered_by,
		ordered_for,
		cpr_id,
		priority
	FROM p_Patient_WP_Item WITH (NOLOCK)
	WHERE owned_by = @ps_user_id
	AND active_service_flag = 'Y'
	AND item_type = 'SERVICE'
	AND ordered_service like @ps_ordered_service
	END

UPDATE @workplan_item
SET patient_name = dbo.fn_patient_full_name(cpr_id)

UPDATE wi
SET 	service_description = s.description,
	service_button = s.button,
	service_icon = s.icon
FROM @workplan_item wi
	INNER JOIN o_Service s WITH (NOLOCK)
	ON wi.ordered_service = s.service

UPDATE wi
SET 	from_user = u.user_short_name,
	from_user_color = u.color
FROM @workplan_item wi
	INNER JOIN c_User u WITH (NOLOCK)
	ON wi.from_user_id = u.user_id

UPDATE wi
SET 	to_user = u.user_short_name,
	to_user_color = u.color
FROM @workplan_item wi
	INNER JOIN c_User u WITH (NOLOCK)
	ON wi.to_user_id = u.user_id
	AND LEFT(wi.to_user_id, 1) <> '!'

UPDATE wi
SET 	to_user = CAST(r.role_name AS varchar(12)),
	to_user_color = r.color
FROM @workplan_item wi
	INNER JOIN c_Role r WITH (NOLOCK)
	ON wi.to_user_id = r.role_id
	AND LEFT(wi.to_user_id, 1) = '!'


-- Get the message from the p_Patient_WP_Item_Attribute table
-- First gather the latest attribute sequences for the 'MESSAGE' attribute
INSERT INTO @messages (
	patient_workplan_item_id,
	attribute_sequence )
SELECT a.patient_workplan_item_id,
	max(a.attribute_sequence) as attribute_sequence
FROM 	@workplan_item wi
	, p_Patient_WP_Item_Attribute a WITH (NOLOCK)
WHERE wi.patient_workplan_item_id = a.patient_workplan_item_id
AND a.attribute = 'MESSAGE'
GROUP BY a.patient_workplan_item_id

-- Then update the temp table with the actual messages
UPDATE wi
SET message = COALESCE(a.value, a.message)
FROM @workplan_item wi
	INNER JOIN @messages m
	ON wi.patient_workplan_item_id = m.patient_workplan_item_id
	INNER JOIN p_Patient_WP_Item_Attribute a WITH (NOLOCK)
	ON m.patient_workplan_item_id = a.patient_workplan_item_id
	AND m.attribute_sequence = a.attribute_sequence

SELECT patient_workplan_item_id,
	ordered_service,
	service_description,
	service_button,
	service_icon,
	owned_by,
	description,
	dispatch_date,
	begin_date,
	end_date,
	status,
	folder,
	from_user_id,
	from_user,
	from_user_color,
	to_user_id,
	to_user,
	to_user_color,
	message,
	cpr_id,
	patient_name,
	selected_flag,
	priority
FROM @workplan_item


GO
GRANT EXECUTE
	ON [dbo].[sp_get_encounterpro_message]
	TO [cprsystem]
GO

