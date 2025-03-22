
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[p_Patient]
Print 'Drop Table [dbo].[p_Patient]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient]
GO
-- Create Table [dbo].[p_Patient]
Print 'Create Table [dbo].[p_Patient]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient] (
		[cpr_id]                     [varchar](12) NOT NULL,
		[race]                       [varchar](24) NULL,
		[date_of_birth]              [datetime] NULL,
		[sex]                        [varchar](1) NULL,
		[primary_language]           [varchar](12) NULL,
		[marital_status]             [varchar](1) NULL,
		[billing_id]                 [varchar](24) NULL,
		[ssn]                        [varchar](24) NULL,
		[first_name]                 [varchar](20) NULL,
		[last_name]                  [varchar](40) NULL,
		[degree]                     [varchar](12) NULL,
		[name_prefix]                [varchar](12) NULL,
		[middle_name]                [varchar](20) NULL,
		[name_suffix]                [varchar](12) NULL,
		[maiden_name]                [varchar](40) NULL,
		[attachment_id]              [int] NULL,
		[primary_provider_id]        [varchar](24) NULL,
		[secondary_provider_id]      [varchar](24) NULL,
		[last_update]                [datetime] NULL,
		[phone_number]               [varchar](32) NULL,
		[patient_id]                 [int] NULL,
		[date_of_conception]         [datetime] NULL,
		[patient_status]             [varchar](24) NOT NULL,
		[created]                    [datetime] NULL,
		[created_by]                 [varchar](24) NULL,
		[modified_by]                [varchar](24) NULL,
		[office_id]                  [varchar](4) NULL,
		[locked_by]                  [varchar](24) NULL,
		[attachment_location_id]     [int] NULL,
		[attachment_path]            [varchar](128) NULL,
		[referring_provider_id]      [varchar](24) NULL,
		[address_line_1]             [varchar](80) NULL,
		[address_line_2]             [varchar](40) NULL,
		[state]                      [varchar](2) NULL,
		[zip]                        [varchar](10) NULL,
		[country]                    [varchar](2) NULL,
		[secondary_phone_number]     [varchar](16) NULL,
		[email_address]              [varchar](40) NULL,
		[religion]                   [varchar](12) NULL,
		[nationality]                [varchar](12) NULL,
		[financial_class]            [varchar](40) NULL,
		[city]                       [varchar](40) NULL,
		[employer]                   [varchar](40) NULL,
		[employeeID]                 [varchar](24) NULL,
		[department]                 [varchar](10) NULL,
		[shift]                      [varchar](10) NULL,
		[job_description]            [varchar](24) NULL,
		[start_date]                 [datetime] NULL,
		[termination_date]           [datetime] NULL,
		[employment_status]          [varchar](24) NULL,
		[id]                         [uniqueidentifier] NOT NULL,
		[default_grant]              [bit] NOT NULL,
		[nickname]                   [varchar](20) NULL,
		[phone_number_7digit]        [varchar](8) NULL,
		[test_patient]               [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [PK_p_Patient_1_40]
	PRIMARY KEY
	CLUSTERED
	([cpr_id])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF__p_Patient__test___795274BB]
	DEFAULT ((0)) FOR [test_patient]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF__p_patient_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF_p_patient_40]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF_p_Patient_id_40]
	DEFAULT (newid()) FOR [id]
GO
CREATE NONCLUSTERED INDEX [idx_billing_id]
	ON [dbo].[p_Patient] ([billing_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dob]
	ON [dbo].[p_Patient] ([date_of_birth], [cpr_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_last_name]
	ON [dbo].[p_Patient] ([last_name])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_phone_number]
	ON [dbo].[p_Patient] ([phone_number], [cpr_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ssn]
	ON [dbo].[p_Patient] ([ssn])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Patient] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Patient] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Patient] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Patient] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Patient] TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient] SET (LOCK_ESCALATION = TABLE)
GO

