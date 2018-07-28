ALTER TABLE [dbo].[c_Property]
    ADD CONSTRAINT [DF_c_Property_status] DEFAULT ('OK') FOR [status];

