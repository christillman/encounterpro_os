ALTER TABLE [dbo].[c_Folder]
    ADD CONSTRAINT [DF_c_folder_wp_rqd_flag] DEFAULT ('N') FOR [workplan_required_flag];

