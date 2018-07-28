ALTER TABLE [dbo].[x_Integration_Operation_Tree]
    ADD CONSTRAINT [PK_x_Integration_Operation_Tree_40] PRIMARY KEY CLUSTERED ([parent_integration_operation] ASC, [child_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

