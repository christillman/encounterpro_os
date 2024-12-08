
-- Drop Procedure [dbo].[jmjrpt_get_observation_em_coding]
Print 'Drop Procedure [dbo].[jmjrpt_get_observation_em_coding]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_observation_em_coding]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[jmjrpt_get_observation_em_coding]
GO

-- Create Procedure [dbo].[jmjrpt_get_observation_em_coding]
Print 'Create Procedure [dbo].[jmjrpt_get_observation_em_coding]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjrpt_get_observation_em_coding]
	@ps_observation_id varchar(24)
AS
Declare @ls_obs varchar(24)
Select @ls_obs = @ps_observation_id
CREATE TABLE ##c_Observation_Tree_Table (
            [id] [int] IDENTITY (1, 1) NOT NULL ,
            [level] [int] NOT NULL ,
            [description] [varchar] (80) NOT NULL ,
            [observation_id] [varchar] (24) NOT NULL ,
            [em_component] [varchar] (24) NULL ,
            [em_type] [varchar] (24) NULL ,
            [em_category] [varchar] (24) NULL ,
            [em_element] [varchar] (40) NULL
) ON [PRIMARY]
EXEC jmjrpt_c_Observation_Tree_Recursive 0, @ls_obs
Select level As Level,
       description As Observation,
       em_type As EM_Type,
       em_category As EM_Category,
       em_element As EM_Element 
FROM ##c_Observation_Tree_Table
DROP Table ##c_Observation_Tree_Table


GO
GRANT EXECUTE ON [jmjrpt_get_observation_em_coding] TO [cprsystem] AS [dbo]
GO
