﻿ALTER TABLE [dbo].[c_Component_Definition]
    ADD CONSTRAINT [DF__c_Component_def_lic_status] DEFAULT ('Unlicensed') FOR [license_status];
