

-- Drop Procedure [dbo].[sp_get_administer_method_list]
Print 'Drop Procedure [dbo].[sp_get_administer_method_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_administer_method_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_administer_method_list]
GO

-- Create Procedure [dbo].[sp_get_administer_method_list]
Print 'Create Procedure [dbo].[sp_get_administer_method_list]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_administer_method_list    Script Date: 7/25/2000 8:43:50 AM ******/
CREATE PROCEDURE sp_get_administer_method_list (
	@ps_package_id varchar(12))
AS
SELECT [description]
FROM c_Administration_Method m
JOIN c_Package_Administration_Method pm ON pm.administer_method = m.administer_method
WHERE package_id = @ps_package_id
GO
GRANT EXECUTE
	ON [dbo].[sp_get_administer_method_list]
	TO [cprsystem]
GO

