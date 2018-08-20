IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__o_Service__id]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[o_Service]
	ADD CONSTRAINT [DF__o_Service__id]
	DEFAULT (newid()) FOR [id]
END
GO