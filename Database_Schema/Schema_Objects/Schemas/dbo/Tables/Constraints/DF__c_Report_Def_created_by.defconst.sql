ALTER TABLE [dbo].[c_Report_Definition]
    ADD CONSTRAINT [DF__c_Report_Def_created_by] DEFAULT ([dbo].[fn_current_epro_user]()) FOR [created_by];

