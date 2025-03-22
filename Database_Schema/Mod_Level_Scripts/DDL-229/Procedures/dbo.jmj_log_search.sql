
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
SET QUOTED_IDENTIFIER ON
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
	[message] [varchar](1000) NULL,
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
	[spid] [int] NULL ,
	progress_seconds numeric(18,4) NULL,
	[log_data] [nvarchar](max) NULL,
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
	,spid
	,progress_seconds
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
	,l.spid
	,l.progress_seconds
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
	,l.spid
	,l.progress_seconds
	,l.log_data
	,l.scribe_user_full_name
	,selected_flag = 0
FROM @log l


GO
GRANT EXECUTE
	ON [dbo].[jmj_log_search]
	TO [cprsystem]
GO

