ALTER TABLE [dbo].[p_Assessment]
    ADD CONSTRAINT [DF__p_Assessment_sort_sequence] DEFAULT ((0)) FOR [sort_sequence];

