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

-- Drop Procedure [dbo].[jmj_log_search]
Print 'Drop Procedure [dbo].[jmj_log_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_log_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_log_search]
GO

-- Create Procedure [dbo].[jmj_log_search]
Print 'Create Procedure [dbo].[jmj_log_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_log_search (
	@pl_computer_id int = NULL,
	@pl_min_severity int = 2,
	@ps_cpr_id varchar(12) = NULL,
	@ps_user_id varchar(24) = NULL,
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
)
AS

--
-- @pl_min_severity:	1 = debug
--						2 = informational
--						3 = warning
--						4 = error
--						5 = fatal error
--


	
DECLARE @severity TABLE (
	[severity] [varchar](12) NOT NULL
	)
	

DECLARE @log TABLE (
	[log_id] [int] NOT NULL,
	[severity] [varchar](12) NULL,
	[log_date_time] [datetime] NULL ,
	[caller] [varchar](40) NULL,
	[script] [varchar](40) NULL,
	[message] [varchar](255) NULL,
	[computer_id] [int] NULL,
	[computername] [varchar](40) NULL,
	[windows_logon_id] [varchar](40) NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[treatment_id] [int] NULL,
	[patient_workplan_item_id] [varchar](12) NULL,
	[service] [varchar](24) NULL,
	[user_id] [varchar](24) NULL,
	[scribe_user_id] [varchar](24) NULL,
	[program] [varchar](32) NULL,
	[cleared] [datetime] NULL,
	[cleared_by] [varchar](12) NULL,
	[os_version] [varchar](64) NULL,
	[epro_version] [varchar](64) NULL,
	[sql_version] [varchar](256) NULL,
	[id] [uniqueidentifier] NOT NULL ,
	[caused_by_id] [uniqueidentifier] NULL,
	[spid] [int] NULL ,
	[log_data] [text] NULL,
	scribe_user_full_name varchar(64) NULL
	)

IF @pl_min_severity IS NULL
	SET @pl_min_severity = 2

INSERT INTO @severity (
	severity)
VALUES (
	'FATAL ERROR' )

IF @pl_min_severity <= 4
	INSERT INTO @severity (
		severity)
	VALUES (
		'ERROR' )

IF @pl_min_severity <= 3
	INSERT INTO @severity (
		severity)
	VALUES (
		'WARNING' )

IF @pl_min_severity <= 2
	INSERT INTO @severity (
		severity)
	VALUES (
		'INFORMATION' )

IF @pl_min_severity <= 1
	INSERT INTO @severity (
		severity)
	VALUES (
		'DEBUG' )


INSERT INTO @log
   (log_id
	,severity
	,log_date_time
	,caller
	,script
	,message
	,computer_id
	,computername
	,windows_logon_id
	,cpr_id
	,encounter_id
	,treatment_id
	,patient_workplan_item_id
	,service
	,user_id
	,scribe_user_id
	,program
	,cleared
	,cleared_by
	,os_version
	,epro_version
	,sql_version
	,id
	,caused_by_id
	,spid
	,log_data
	,scribe_user_full_name)
SELECT l.log_id
	,l.severity
	,l.log_date_time
	,l.caller
	,l.script
	,l.message
	,l.computer_id
	,l.computername
	,l.windows_logon_id
	,l.cpr_id
	,l.encounter_id
	,l.treatment_id
	,l.patient_workplan_item_id
	,l.service
	,l.user_id
	,l.scribe_user_id
	,l.program
	,l.cleared
	,l.cleared_by
	,l.os_version
	,l.epro_version
	,l.sql_version
	,l.id
	,l.caused_by_id
	,l.spid
	,l.log_data
	,u.user_full_name
FROM o_Log l WITH (NOLOCK)
	INNER JOIN @severity s
	ON l.severity = s.severity
	LEFT OUTER JOIN c_User u
	ON u.user_id = l.scribe_user_id
WHERE (@pl_computer_id IS NULL OR l.computer_id = @pl_computer_id)
AND (@ps_cpr_id IS NULL OR cpr_id = @ps_cpr_id)
AND (@ps_user_id IS NULL OR l.scribe_user_id = @ps_user_id)
AND (@pdt_begin_date IS NULL OR log_date_time >= @pdt_begin_date)
AND (@pdt_end_date IS NULL OR log_date_time < @pdt_end_date)


SELECT l.log_id
	,l.severity
	,l.log_date_time
	,l.caller
	,l.script
	,l.message
	,l.computer_id
	,l.computername
	,l.windows_logon_id
	,l.cpr_id
	,l.encounter_id
	,l.treatment_id
	,l.patient_workplan_item_id
	,l.service
	,l.user_id
	,l.scribe_user_id
	,l.program
	,l.cleared
	,l.cleared_by
	,l.os_version
	,l.epro_version
	,l.sql_version
	,l.id
	,l.caused_by_id
	,l.spid
	,l.log_data
	,l.scribe_user_full_name
	,selected_flag = 0
FROM @log l


GO
GRANT EXECUTE
	ON [dbo].[jmj_log_search]
	TO [cprsystem]
GO

