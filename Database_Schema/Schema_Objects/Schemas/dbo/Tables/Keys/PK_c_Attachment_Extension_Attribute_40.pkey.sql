ALTER TABLE [dbo].[c_Attachment_Extension_Attribute]
    ADD CONSTRAINT [PK_c_Attachment_Extension_Attribute_40] PRIMARY KEY CLUSTERED ([extension] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

