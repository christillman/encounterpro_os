ALTER TABLE [dbo].[u_Top_20]
    ADD CONSTRAINT [DF__u_Top_20__create__40] DEFAULT (getdate()) FOR [created];

