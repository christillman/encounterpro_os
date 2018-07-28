ALTER TABLE [dbo].[c_Classification_Set]
    ADD CONSTRAINT [DF_c_Classification_Set_status] DEFAULT ('OK') FOR [status];

