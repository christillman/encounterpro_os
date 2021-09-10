
-- Drop unused procedures which have non-working syntax per migration report
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_exams]') AND [type]='P'))
DROP PROCEDURE sp_get_exams

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_objective_flags]') AND [type]='P'))
DROP PROCEDURE sp_get_objective_flags

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_observation_results]') AND [type]='P'))
DROP PROCEDURE sp_get_observation_results

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_office_status_ALL]') AND [type]='P'))
DROP PROCEDURE sp_get_office_status_ALL

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_result_list]') AND [type]='P'))
DROP PROCEDURE sp_get_result_list