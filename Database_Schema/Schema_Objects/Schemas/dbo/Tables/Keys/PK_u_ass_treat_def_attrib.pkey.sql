ALTER TABLE [dbo].[u_assessment_treat_def_attrib]
    ADD CONSTRAINT [PK_u_ass_treat_def_attrib] PRIMARY KEY CLUSTERED ([definition_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

