ALTER TABLE [dbo].[c_Document_Purpose]
    ADD CONSTRAINT [DF_c_Document_Purpose_status] DEFAULT (newid()) FOR [id];

