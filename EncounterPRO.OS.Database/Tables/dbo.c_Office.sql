
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Office]
Print 'Drop Table [dbo].[c_Office]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Office]') AND [type]='U'))
DROP TABLE [dbo].[c_Office]
GO
-- Create Table [dbo].[c_Office]
Print 'Create Table [dbo].[c_Office]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Office] (
		[office_id]                [varchar](4) NOT NULL,
		[office_number]            [smallint] NOT NULL,
		[description]              [varchar](80) NULL,
		[address1]                 [varchar](40) NULL,
		[address2]                 [varchar](40) NULL,
		[city]                     [varchar](40) NULL,
		[state]                    [varchar](2) NULL,
		[zip]                      [varchar](5) NULL,
		[zip_plus4]                [varchar](4) NULL,
		[phone]                    [varchar](14) NULL,
		[fax]                      [varchar](14) NULL,
		[status]                   [varchar](12) NULL,
		[server]                   [varchar](24) NULL,
		[dbname]                   [varchar](32) NULL,
		[dbms]                     [varchar](24) NULL,
		[billing_code]             [int] NULL,
		[billing_id]               [varchar](24) NULL,
		[id]                       [uniqueidentifier] NOT NULL,
		[billing_component_id]     [varchar](24) NULL,
		[office_nickname]          [varchar](24) NOT NULL,
	[country] [varchar](40) NULL,
		CONSTRAINT [UQ_c_Office_xxx]
		UNIQUE
		NONCLUSTERED
		([office_number])
		WITH FILLFACTOR=100
		ON [PRIMARY]

) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Office]
	ADD
	CONSTRAINT [PK_c_Office_xxx]
	PRIMARY KEY
	CLUSTERED
	([office_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Office]
	ADD
	CONSTRAINT [office_num_range]
	CHECK
	([office_number]<(32))
GO
ALTER TABLE [dbo].[c_Office]
CHECK CONSTRAINT [office_num_range]
GO
ALTER TABLE [dbo].[c_Office]
	ADD
	CONSTRAINT [DF__c_Office__id__118A8A8C]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Office]
	ADD
	CONSTRAINT [DF_c_Office_nickname]
	DEFAULT ('Office') FOR [office_nickname]
GO
ALTER TABLE [dbo].[c_Office]
	ADD
	CONSTRAINT [DF_c_Office_status_OK]
	DEFAULT ('OK') FOR [status]
GO
GRANT DELETE ON [dbo].[c_Office] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Office] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Office] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Office] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Office] TO [public]
GO
GRANT UPDATE ON [dbo].[c_Office] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Office] SET (LOCK_ESCALATION = TABLE)
GO

