ALTER TABLE [dbo].[c_Disease]
    ADD CONSTRAINT [DF_c_Disease_status_2__12] DEFAULT ('OK') FOR [status];

