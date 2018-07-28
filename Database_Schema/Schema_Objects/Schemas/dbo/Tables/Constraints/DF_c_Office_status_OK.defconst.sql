ALTER TABLE [dbo].[c_Office]
    ADD CONSTRAINT [DF_c_Office_status_OK] DEFAULT ('OK') FOR [status];

