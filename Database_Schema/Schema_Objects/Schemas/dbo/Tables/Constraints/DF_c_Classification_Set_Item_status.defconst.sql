ALTER TABLE [dbo].[c_Classification_Set_Item]
    ADD CONSTRAINT [DF_c_Classification_Set_Item_status] DEFAULT ('OK') FOR [status];

