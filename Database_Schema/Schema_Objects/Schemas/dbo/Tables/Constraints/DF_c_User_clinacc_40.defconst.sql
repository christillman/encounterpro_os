ALTER TABLE [dbo].[c_User]
    ADD CONSTRAINT [DF_c_User_clinacc_40] DEFAULT ('N') FOR [clinical_access_flag];

