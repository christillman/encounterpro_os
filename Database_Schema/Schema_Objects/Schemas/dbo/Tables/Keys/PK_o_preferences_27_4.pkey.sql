ALTER TABLE [dbo].[o_Preferences]
    ADD CONSTRAINT [PK_o_preferences_27_4] PRIMARY KEY CLUSTERED ([preference_type] ASC, [preference_level] ASC, [preference_key] ASC, [preference_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

