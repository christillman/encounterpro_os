ALTER TABLE [dbo].[p_Object_Security]
    ADD CONSTRAINT [DF_p_Object_Security_id] DEFAULT (newid()) FOR [id];

