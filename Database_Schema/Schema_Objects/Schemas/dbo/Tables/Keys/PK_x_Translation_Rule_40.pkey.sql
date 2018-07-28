ALTER TABLE [dbo].[x_Translation_Rule]
    ADD CONSTRAINT [PK_x_Translation_Rule_40] PRIMARY KEY NONCLUSTERED ([external_application_id] ASC, [integration_operation] ASC, [epro_source_flag] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

