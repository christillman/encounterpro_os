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

-- Drop Procedure [dbo].[sp_setup_practicemanagement]
Print 'Drop Procedure [dbo].[sp_setup_practicemanagement]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_setup_practicemanagement]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_setup_practicemanagement]
GO

-- Create Procedure [dbo].[sp_setup_practicemanagement]
Print 'Create Procedure [dbo].[sp_setup_practicemanagement]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_setup_practicemanagement (
	@ps_billing_system varchar(24),
	@ps_office_id varchar(10)
	)
AS

DECLARE @ls_scheduler varchar(50),
	@ls_billing varchar(50),
	@ls_message_in varchar(50),
	@ls_message_out varchar(50),
	@ls_input_file varchar(255),
	@ls_output_file varchar(255),
	@ls_message_handler char(24),
	@li_count int,
	@li_subscription_id int,
	@ls_message_type_in varchar(50),
	@ls_message_type_out varchar(50)

-- get the component id's from x_integration
SELECT @ls_scheduler = schedule_id,
	@ls_billing = billing_id,
	@ls_message_in = message_in,
	@ls_message_out = message_out,
	@ls_input_file = input_file,
	@ls_output_file = output_file,
	@ls_message_handler = message_handler,
	@ls_message_type_in = message_type_in,
	@ls_message_type_out = message_type_out
FROM x_Integrations
WHERE billing_system = @ps_billing_system

----------------------------------------------------
-- Update billing component(it's updating for all office)
----------------------------------------------------
Update c_Office
set billing_component_id = @ls_billing

-----------------------------------------------------------
-- update scheduler server components & Attributes
-----------------------------------------------------------
SELECT @li_count = count(*)
FROM o_Server_Component
WHERE component_id = @ls_scheduler
AND Status = 'OK'

IF @li_count = 0
BEGIN
	UPDATE o_Server_Component
	set status = 'NA'
	WHERE system_user_id = '#SCHED'

	INSERT INTO o_Server_Component (
		component_id,
		system_user_id,
		start_order,
		status
		)
		VALUES (
		@ls_scheduler,
		'#SCHED',
		1,
		'OK'
		)
END
-----------------------------------------------------------
-- update billing server components & Attributes
-----------------------------------------------------------
SELECT @li_count = count(*)
FROM o_Server_Component
WHERE system_user_id = '#BILL'
and component_id = 'JMJ_SERVERSERVICE'
AND Status = 'OK'

IF @li_count = 0

	INSERT INTO o_Server_Component (
		component_id,
		system_user_id,
		start_order,
		status
		)
		VALUES (
		'JMJ_SERVERSERVICE',
		'#BILL',
		1,
		'OK'
		)

SELECT @li_count = count(*)
FROM c_User
WHERE user_id = '#BILL'

IF @li_count = 0
	INSERT INTO c_User (
	user_id,
	user_status,
	user_full_name,
	user_short_name,
	color,
	user_initial
	)
	VALUES (
	'#BILL',
	'SYSTEM',
	'Billing Service',
	'Billing',
	33023,
	'SYS'
	)
------------------------------------------
-- Add Attributes to c_Component_Attribute
-------------------------------------------
DELETE FROM c_Component_Attribute
WHERE component_id = @ls_billing
and attribute = 'message_type'

DELETE FROM c_Component_Attribute
WHERE component_id = @ls_billing
and attribute = 'billing_system'

DELETE FROM c_Component_Attribute
WHERE component_id = @ls_scheduler
and attribute = 'message_type'

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_scheduler,
'message_type',
@ls_message_type_in
)

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_billing,
'message_type',
@ls_message_type_out
)

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_billing,
'billing_system',
@ps_billing_system
)

SELECT @li_count = count(*)
FROM c_Component_Attribute
WHERE component_id = @ls_billing
and attribute = 'FACILITYID'

IF @li_count = 0
	INSERT INTO c_Component_Attribute
	(
	component_id,
	attribute
	)
	VALUES (
	@ls_billing,
	'FACILITYID'
	)

SELECT @li_count = count(*)
FROM c_Component_Attribute
WHERE component_id = @ls_scheduler
and attribute = 'FACILITYID'

IF @li_count = 0
	INSERT INTO c_Component_Attribute
	(
	component_id,
	attribute
	)
	VALUES (
	@ls_scheduler,
	'FACILITYID'
	)

-----------------------------------
-- Update Message Handler server
-----------------------------------
SELECT @li_count = count(*)
FROM o_Server_Component
WHERE system_user_id = '#MSG'
AND status = 'OK'

IF @li_count = 0

	INSERT INTO o_Server_Component (
	component_id,
	system_user_id,
	start_order,
	status
	)
	VALUES (
	'MSGHANDLERSERVER',
	'#MSG',
	1,
	'OK'
	)

-------------------------------------------------
-- update subscription
-------------------------------------------------

SELECT @li_count = count(*)
FROM o_Message_Subscription
WHERE message_type = @ls_message_type_in
and transport_component_id = @ls_message_in
and direction = 'I'

IF @li_count = 0
	
	SELECT @li_subscription_id = max(subscription_id)
	FROM o_Message_Subscription

	IF @li_subscription_id is null
		SELECT @li_subscription_id = 0

	SELECT @li_subscription_id = @li_subscription_id + 1

	INSERT INTO o_Message_Subscription (
		subscription_id,
		message_type,
		office_id,
		transport_component_id,
		address,
		direction,
		compression_type
		)
	VALUES(
		@li_subscription_id,
		@ls_message_type_in,
		@ps_office_id,
		@ls_message_in,
		@ls_input_file,
		'I',
		'NONE'
		)

SELECT @li_count = count(*)
FROM o_Message_Subscription
WHERE message_type = @ls_message_type_out
and transport_component_id = @ls_message_out
and direction = 'O'

IF @li_count = 0

	SELECT @li_subscription_id = max(subscription_id)
	FROM o_Message_Subscription

	IF @li_subscription_id is null
		SELECT @li_subscription_id = 0

	SELECT @li_subscription_id = @li_subscription_id + 1

	INSERT INTO o_Message_Subscription (
		subscription_id,
		message_type,
		office_id,
		transport_component_id,
		address,
		direction,
		compression_type
		)
	VALUES(
		@li_subscription_id,
		@ls_message_type_out,
		@ps_office_id,
		@ls_message_out,
		@ls_output_file,
		'O',
		'NONE'
		)

-------------------------------
-- Subscription IN Attributes
-------------------------------
DELETE FROM c_Component_Attribute
WHERE component_id = @ls_message_in
and attribute = 'bs_system'

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_message_in,
'bs_system',
@ps_billing_system
)
-------------------------------
-- Subscription OUT Attributes
-------------------------------
DELETE FROM c_Component_Attribute
WHERE component_id = @ls_message_out
and attribute = 'bs_system'

DELETE FROM c_Component_Attribute
WHERE component_id = @ls_message_out
and attribute = 'billing_system'

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_message_out,
'billing_system',
@ps_billing_system
)

INSERT INTO c_Component_Attribute
(
 component_id,
attribute,
value
)
VALUES (
@ls_message_out,
'bs_system',
@ps_billing_system
)
-------------------------------
-- Update the preference
-------------------------------
EXECUTE sp_set_preference 'PREFERENCES', 'Global', 'Global', 'default_billing_system', @ps_billing_system


GO
GRANT EXECUTE
	ON [dbo].[sp_setup_practicemanagement]
	TO [cprsystem]
GO

