ALTER TABLE [dbo].[u_Top_20]
    ADD CONSTRAINT [DF__u_Top_20__last_h__18F6A22A] DEFAULT (getdate()) FOR [last_hit];

