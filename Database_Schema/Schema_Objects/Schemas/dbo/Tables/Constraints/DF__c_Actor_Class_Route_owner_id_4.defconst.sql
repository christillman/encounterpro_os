﻿ALTER TABLE [dbo].[c_Actor_Class_Route]
    ADD CONSTRAINT [DF__c_Actor_Class_Route_owner_id_4] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];
