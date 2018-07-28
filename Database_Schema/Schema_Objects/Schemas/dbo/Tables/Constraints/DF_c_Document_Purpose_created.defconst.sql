ALTER TABLE [dbo].[c_Document_Purpose]
    ADD CONSTRAINT [DF_c_Document_Purpose_created] DEFAULT (getdate()) FOR [created];

