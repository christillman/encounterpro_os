ALTER TABLE [dbo].[o_Computers]
    ADD CONSTRAINT [DF__o_Computers_connected_flag] DEFAULT ('N') FOR [connected_flag];

