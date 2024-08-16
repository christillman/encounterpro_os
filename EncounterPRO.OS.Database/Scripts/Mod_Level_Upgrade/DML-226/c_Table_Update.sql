
-- Initialize these rows in c_Table_Update

EXECUTE sp_table_update @ps_table_name = 'o_Rooms'
EXECUTE sp_table_update @ps_table_name = 'p_Patient_Encounter'
EXECUTE sp_table_update @ps_table_name = 'p_Patient_WP_Item'
EXECUTE sp_table_update @ps_table_name = 'o_Active_Services'