DROP PROCEDURE [jmjrpt_c_Observation_Tree_Recursive]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [jmjrpt_c_Observation_Tree_Recursive]
	@level int, @obsarg VARCHAR(24)
AS
DECLARE @obs VARCHAR(24), @ll_next_level int, @ls_description VARCHAR(80), @li_indent int
DECLARE @ls_em_component VARCHAR(24), @ls_em_type VARCHAR(24), @ls_em_category VARCHAR(24),
        @ls_em_element VARCHAR(40)
SET @ls_em_component = ''
SET @ls_em_type = ''
SET @ls_em_category = ''
SET @ls_em_element = ''
SELECT  @ls_description = description FROM c_Observation WITH (NOLOCK) WHERE observation_id = @obsarg
SELECT  @ls_em_type = em_type,
        @ls_em_category = em_category,
        @ls_em_element = em_element
FROM em_Observation_Element WITH (NOLOCK)
WHERE observation_id = @obsarg
SET NOCOUNT ON

SET @ll_next_level = @level + 1

SELECT c_Observation_Tree.child_observation_id INTO #obslist
   FROM     c_Observation_Tree WITH (NOLOCK)
   WHERE    c_Observation_Tree.parent_observation_id = @obsarg
INSERT INTO ##c_Observation_Tree_Table
            (
             level,
             description,
             observation_id ,
             em_component ,
             em_type ,
             em_category ,
             em_element
            )
VALUES (@level, @ls_description, @obsarg, @ls_em_component, @ls_em_type, @ls_em_category, @ls_em_element)
--Chucks famous recursive feature!!
WHILE EXISTS (SELECT * FROM #obslist)
   BEGIN
      SET ROWCOUNT 1
      SELECT @obs = child_observation_id FROM #obslist
      SET ROWCOUNT 0
      DELETE FROM #obslist WHERE child_observation_id = @obs
      EXECUTE jmjrpt_c_Observation_Tree_Recursive @ll_next_level, @obs
   END
   
   

GO
GRANT EXECUTE ON [jmjrpt_c_Observation_Tree_Recursive] TO [cprsystem] AS [dbo]
GO
