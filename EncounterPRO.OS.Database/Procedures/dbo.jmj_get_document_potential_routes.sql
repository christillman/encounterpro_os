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

-- Drop Procedure [dbo].[jmj_get_document_potential_routes]
Print 'Drop Procedure [dbo].[jmj_get_document_potential_routes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_document_potential_routes]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_document_potential_routes]
GO

-- Create Procedure [dbo].[jmj_get_document_potential_routes]
Print 'Create Procedure [dbo].[jmj_get_document_potential_routes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_get_document_potential_routes (
	@ps_report_id varchar(40),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24))
AS

DECLARE @lui_report_id uniqueidentifier,
	@ll_error int,
	@ll_rowcount int,
	@ll_ordered_by_actor_id int,
	@ll_ordered_for_actor_id int

DECLARE @reports TABLE (
	report_id uniqueidentifier NOT NULL)

DECLARE @routes TABLE (
	document_route varchar(24) NOT NULL,
	document_format varchar(24) NOT NULL,
	communication_type varchar(24) NULL,
	sender_id_key varchar(40) NULL,
	receiver_id_key varchar(40) NULL,
	is_valid bit NOT NULL DEFAULT (1)
	)

IF @ps_ordered_for IS NULL
	BEGIN
	RAISERROR ('ordered_for cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_ordered_by_actor_id = @ll_ordered_by_actor_id
FROM c_User
WHERE user_id = @ps_ordered_by

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('ordered_by not found (%s)',16,-1, @ps_ordered_by)
	RETURN -1
	END

SELECT @ll_ordered_for_actor_id = @ll_ordered_for_actor_id
FROM c_User
WHERE user_id = @ps_ordered_for

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('ordered_for not found (%s)',16,-1, @ps_ordered_for)
	RETURN -1
	END

IF LEN(@ps_report_id) >= 36
	BEGIN
	SET @lui_report_id = CAST(@ps_report_id AS uniqueidentifier)
	
	-- Add the called report
	INSERT INTO @reports (
		report_id )
	VALUES (
		@lui_report_id )

	-- Add all the reports linked from the called report
	INSERT INTO @reports (
		report_id )
	SELECT CAST(value AS uniqueidentifier)
	FROM c_Report_Attribute
	WHERE report_id = @lui_report_id
	AND attribute LIKE '%report_id'
	AND LEN(value) >= 36
	END

-- Get the routes availble to this users' actor_class
INSERT INTO @routes (
	document_route,
	document_format,
	communication_type,
	sender_id_key,
	receiver_id_key)
SELECT dr.document_route,
	dr.document_format,
	dr.communication_type,
	dr.sender_id_key,
	dr.receiver_id_key
FROM c_Actor_Class_Route r
	INNER JOIN c_User u
	ON r.actor_class = u.actor_class
	INNER JOIN c_Document_Route dr
	ON r.document_route = dr.document_route
WHERE u.user_id = @ps_ordered_for
AND r.status = 'OK'

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

-- If no routes specified, then list all routes
IF @ll_rowcount = 0
	INSERT INTO @routes (
		document_route,
		document_format,
		communication_type,
		sender_id_key,
		receiver_id_key)
	SELECT document_route,
		document_format,
		communication_type,
		sender_id_key,
		receiver_id_key
	FROM c_Document_Route r
	WHERE status = 'OK'



SELECT DISTINCT cr.document_route,
		cr.document_format,
		cr.communication_type,
		cr.sender_id_key,
		cr.receiver_id_key
FROM @routes cr
	INNER JOIN c_Report_Definition rd
	ON rd.document_format = cr.document_format
	INNER JOIN @reports r
	ON r.report_id = rd.report_id
WHERE cr.is_valid = 1


GO
GRANT EXECUTE
	ON [dbo].[jmj_get_document_potential_routes]
	TO [cprsystem]
GO

