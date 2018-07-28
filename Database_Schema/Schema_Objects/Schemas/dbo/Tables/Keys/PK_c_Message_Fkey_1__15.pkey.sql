ALTER TABLE [dbo].[c_Message_Fkey]
    ADD CONSTRAINT [PK_c_Message_Fkey_1__15] PRIMARY KEY CLUSTERED ([message_type] ASC, [message_part_sequence] ASC, [message_fkey_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

