ALTER TABLE [dbo].[c_Document_Purpose]
    ADD CONSTRAINT [DF_c_Document_Purpose_last_updated] DEFAULT (getdate()) FOR [last_updated];

