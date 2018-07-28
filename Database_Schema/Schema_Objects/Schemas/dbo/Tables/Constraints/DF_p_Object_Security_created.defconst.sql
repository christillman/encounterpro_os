ALTER TABLE [dbo].[p_Object_Security]
    ADD CONSTRAINT [DF_p_Object_Security_created] DEFAULT (getdate()) FOR [created];

