ALTER TABLE [dbo].[c_Office]
    ADD CONSTRAINT [office_num_range] CHECK ([office_number]<(32));

