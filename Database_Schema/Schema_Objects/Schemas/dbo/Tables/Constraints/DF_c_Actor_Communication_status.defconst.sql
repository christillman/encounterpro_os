ALTER TABLE [dbo].[c_Actor_Communication]
    ADD CONSTRAINT [DF_c_Actor_Communication_status] DEFAULT ('OK') FOR [status];

