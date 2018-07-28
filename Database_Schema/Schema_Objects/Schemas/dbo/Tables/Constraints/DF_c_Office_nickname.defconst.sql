ALTER TABLE [dbo].[c_Office]
    ADD CONSTRAINT [DF_c_Office_nickname] DEFAULT ('Office') FOR [office_nickname];

