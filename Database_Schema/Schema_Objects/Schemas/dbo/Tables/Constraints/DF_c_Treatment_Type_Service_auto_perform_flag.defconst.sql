ALTER TABLE [dbo].[c_Treatment_Type_Service]
    ADD CONSTRAINT [DF_c_Treatment_Type_Service_auto_perform_flag] DEFAULT ('N') FOR [auto_perform_flag];

