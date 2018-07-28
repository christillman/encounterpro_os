ALTER TABLE [dbo].[c_Object_Default_Progress_Type]
    ADD CONSTRAINT [DF_c_obj_def_progr_allow_multiple_dates] DEFAULT ('Y') FOR [allow_multiple_dates];

