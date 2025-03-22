
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
	message varchar(max) NULL,
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
	JOIN p_Patient_WP_Item_Attribute a WITH (NOLOCK) ON wi.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'MESSAGE'
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

