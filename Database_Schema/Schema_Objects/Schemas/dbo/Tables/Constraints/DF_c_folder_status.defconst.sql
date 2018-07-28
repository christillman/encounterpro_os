ALTER TABLE [dbo].[c_Folder]
    ADD CONSTRAINT [DF_c_folder_status] DEFAULT ('OK') FOR [status];

