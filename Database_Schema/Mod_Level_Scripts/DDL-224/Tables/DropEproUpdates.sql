
-- make our db compatible with Azure SQL by getting rid of db references we don't have

drop procedure IF EXISTS jmjsys_add_actor_address
drop procedure IF EXISTS jmjsys_add_actor
drop procedure IF EXISTS jmjsys_add_actor_communication
drop procedure IF EXISTS jmjsys_add_actor_progress
drop procedure IF EXISTS jmjsys_bootstrap_table
drop procedure IF EXISTS jmjsys_get_sync_table_data
drop procedure IF EXISTS jmjsys_sync_actors
drop procedure IF EXISTS jmjsys_sync_components
drop procedure IF EXISTS jmjsys_sync_table_column_info

-- Also need to get rid of references to master and msdb
drop procedure IF EXISTS jmj_log_backups
drop procedure IF EXISTS sp_blocker_pss70
drop procedure IF EXISTS sp_rk_blocker_blockee
drop procedure IF EXISTS sp_ResetEproPermissions

drop schema IF EXISTS jmjtech
drop user IF EXISTS jmjtech
drop user IF EXISTS [ict\beth]
drop user IF EXISTS [JMJ\EHRI - All Employees]
drop user IF EXISTS [JMJ\EHRI - Testers]
drop user IF EXISTS [JMJ\mark]
drop user IF EXISTS [JMJ\Stephanie.Saxon]


-- drop user IF EXISTS greenolive
-- drop user IF EXISTS greenoliveehr
drop user IF EXISTS Greenland
