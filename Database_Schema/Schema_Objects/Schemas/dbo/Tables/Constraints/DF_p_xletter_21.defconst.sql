ALTER TABLE [dbo].[p_Letter]
    ADD CONSTRAINT [DF_p_xletter_21] DEFAULT (getdate()) FOR [created];

