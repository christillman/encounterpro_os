ALTER TABLE [dbo].[p_Chart_Alert]
    ADD CONSTRAINT [DF__p_Chart_Aler__id__20CCCE1C] DEFAULT (newid()) FOR [id];

