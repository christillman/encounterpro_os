﻿ALTER TABLE [dbo].[em_Component_Rule]
    ADD CONSTRAINT [PK_em_Component_Rule] PRIMARY KEY CLUSTERED ([em_documentation_guide] ASC, [em_component] ASC, [em_component_level] ASC, [rule_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
