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

-- Drop Procedure [dbo].[jmj_config_object_top_20]
Print 'Drop Procedure [dbo].[jmj_config_object_top_20]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_config_object_top_20]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_config_object_top_20]
GO

-- Create Procedure [dbo].[jmj_config_object_top_20]
Print 'Create Procedure [dbo].[jmj_config_object_top_20]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_config_object_top_20 (
	@ps_config_object_type varchar (24) ,
	@ps_user_id varchar (24) ,
	@ps_top_20_code varchar(64) ,
	@ps_status varchar(12) = NULL)
AS

DECLARE @objects TABLE (
	[config_object_id] [uniqueidentifier] NOT NULL ,
	[config_object_type] [varchar] (24) NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[description] [varchar] (80) NOT NULL ,
	[long_description] [nvarchar](max) NULL ,
	[config_object_category] [varchar] (80) NULL ,
	[installed_version] [int] NULL ,
	[installed_version_date] [datetime] NULL ,
	[installed_version_status] [varchar] (12) NULL ,
	[latest_version] [int] NULL ,
	[latest_version_date] [datetime] NULL ,
	[latest_version_status] [varchar] (12) NULL ,
	[owner_id] [int] NOT NULL ,
	[owner_description] [varchar] (80) NULL ,
	[created] [datetime] NOT NULL ,
	[created_by] [varchar] (24) NULL ,
	[checked_out_by] [varchar] (24) NULL ,
	[checked_out_date_time] [datetime] NULL ,
	[checked_out_from_version] [int] NULL ,
	[status] [varchar] (12) NOT NULL ,
	[copyright_status] [varchar] (24) NOT NULL DEFAULT ('Owner'),
	[copyable] [bit] NOT NULL DEFAULT (1),
	[license_data] [varchar] (2000) NULL ,
	[license_status] [varchar] (24) NULL ,
	[license_expiration_date] [datetime] NULL ,
	[top_20_sequence] [int] NULL,
	[sort_sequence] [int] NULL,
	[production_version] [int] NULL ,
	[production_version_date] [datetime] NULL ,
	[beta_version] [int] NULL ,
	[beta_version_date] [datetime] NULL ,
	[testing_version] [int] NULL ,
	[testing_version_date] [datetime] NULL,
	[library_object] [int] NOT NULL DEFAULT(0) )

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

INSERT INTO @objects (
	[config_object_id],
	[config_object_type],
	[context_object],
	[description],
	[config_object_category],
	[owner_id],
	[created],
	[status],
	[top_20_sequence],
	[sort_sequence])
SELECT r.report_id,
	@ps_config_object_type,
	r.report_type,
	r.description,
	r.report_category,
	r.owner_id,
	r.last_updated,
	COALESCE(r.status, 'NA'),
	u.top_20_sequence,
	u.sort_sequence
FROM u_top_20 u
	INNER JOIN c_report_Definition r
	ON CAST(u.item_id AS uniqueidentifier) = r.report_id
WHERE u.user_id = @ps_user_id
AND u.top_20_code = @ps_top_20_code
AND r.status like @ps_status
AND LEN(u.item_id) >= 36

UPDATE @objects
SET long_description = c.long_description,
	installed_version  = c.installed_version,
	installed_version_date  = c.installed_version_date,
	installed_version_status  = c.installed_version_status,
	latest_version  = c.latest_version,
	latest_version_date  = c.latest_version_date,
	latest_version_status  = c.latest_version_status,
	owner_description  = c.owner_description,
	created_by  = c.created_by,
	checked_out_by  = c.checked_out_by,
	checked_out_date_time  = c.checked_out_date_time,
	checked_out_from_version  = c.checked_out_from_version,
	copyright_status  = c.copyright_status,
	copyable  = c.copyable,
	license_data  = c.license_data,
	license_status  = c.license_status,
	license_expiration_date  = c.license_expiration_date
FROM @objects x
	INNER JOIN c_Config_Object c
	ON x.config_object_id = c.config_object_id

UPDATE x
SET owner_description = dbo.fn_owner_description(owner_id)
FROM @objects x
WHERE owner_description IS NULL

-- Update fields from the library
UPDATE x
SET production_version = l.production_version,
	production_version_date  = l.production_version_date,
	beta_version  = l.beta_version,
	beta_version_date  = l.beta_version_date,
	testing_version  = l.testing_version,
	testing_version_date  = l.testing_version_date,
	library_object = 1
FROM @objects x
	INNER JOIN c_Config_Object_Library l
	ON x.config_object_id = l.config_object_id

-- Update fields from the local versions
UPDATE o
SET production_version = v.version,
	production_version_date  = v.release_status_date_time
FROM @objects o
	INNER JOIN (SELECT v.config_object_id,
					max(v.version) as production_version
				FROM @objects o
					INNER JOIN c_Config_Object_Version v
					ON o.config_object_id = v.config_object_id
				WHERE v.release_status IN ('Production', 'Shareware')
				AND v.status IN ('OK', 'CheckedIn')
				GROUP BY v.config_object_id
				) x
	ON o.config_object_id = x.config_object_id
	INNER JOIN c_Config_Object_Version v
	ON x.config_object_id = v.config_object_id
	AND x.production_version = v.version 
WHERE ISNULL(o.production_version, 0) < x.production_version

UPDATE o
SET beta_version = v.version,
	beta_version_date  = v.release_status_date_time
FROM @objects o
	INNER JOIN (SELECT v.config_object_id,
					max(v.version) as beta_version
				FROM @objects o
					INNER JOIN c_Config_Object_Version v
					ON o.config_object_id = v.config_object_id
				WHERE v.release_status = 'beta'
				AND v.status IN ('OK', 'CheckedIn')
				GROUP BY v.config_object_id
				) x
	ON o.config_object_id = x.config_object_id
	INNER JOIN c_Config_Object_Version v
	ON x.config_object_id = v.config_object_id
	AND x.beta_version = v.version 
WHERE ISNULL(o.beta_version, 0) < x.beta_version

UPDATE o
SET testing_version = v.version,
	testing_version_date  = v.release_status_date_time
FROM @objects o
	INNER JOIN (SELECT v.config_object_id,
					max(v.version) as testing_version
				FROM @objects o
					INNER JOIN c_Config_Object_Version v
					ON o.config_object_id = v.config_object_id
				WHERE v.release_status = 'testing'
				AND v.status IN ('OK', 'CheckedIn')
				GROUP BY v.config_object_id
				) x
	ON o.config_object_id = x.config_object_id
	INNER JOIN c_Config_Object_Version v
	ON x.config_object_id = v.config_object_id
	AND x.testing_version = v.version 
WHERE ISNULL(o.testing_version, 0) < x.testing_version


SELECT config_object_id,
	config_object_type,
	context_object,
	description,
	long_description,
	config_object_category,
	installed_version,
	installed_version_date,
	installed_version_status,
	latest_version,
	latest_version_date,
	latest_version_status,
	owner_id,
	owner_description,
	created,
	created_by,
	checked_out_by,
	checked_out_date_time,
	checked_out_from_version,
	status,
	copyright_status,
	copyable,
	license_data,
	license_status,
	license_expiration_date,
	[user_id] = @ps_user_id,
	top_20_code = @ps_top_20_code,
	top_20_sequence,
	sort_sequence,
	selected_flag = CAST(0 AS int),
	production_version ,
	production_version_date ,
	beta_version ,
	beta_version_date ,
	testing_version ,
	testing_version_date ,
	library_object ,
	local_object = 1 -- Assume all short-list objects are local
FROM @objects

GO
GRANT EXECUTE
	ON [dbo].[jmj_config_object_top_20]
	TO [cprsystem]
GO

