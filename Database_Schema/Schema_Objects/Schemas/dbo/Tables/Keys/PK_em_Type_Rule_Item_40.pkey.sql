﻿ALTER TABLE [dbo].[em_Type_Rule_Item]
    ADD CONSTRAINT [PK_em_Type_Rule_Item_40] PRIMARY KEY CLUSTERED ([em_documentation_guide] ASC, [em_component] ASC, [em_type] ASC, [em_type_level] ASC, [rule_id] ASC, [item_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
