ALTER TABLE [dbo].[c_Folder]
    ADD CONSTRAINT [DF_c_folder_id] DEFAULT (newid()) FOR [id];

