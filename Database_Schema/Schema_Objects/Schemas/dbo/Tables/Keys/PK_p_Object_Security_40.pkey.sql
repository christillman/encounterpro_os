﻿ALTER TABLE [dbo].[p_Object_Security]
    ADD CONSTRAINT [PK_p_Object_Security_40] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [object_key] ASC, [context_object] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
