/*ALTER TABLE [dbo].[p_Patient_WP_Item]
    ADD CONSTRAINT [ck_p_Patient_WP_Item_in_office_flag] CHECK ([encounter_id] IS NOT NULL OR [in_office_flag]='N');*/

