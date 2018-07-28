CREATE TABLE [dbo].[u_assessment_treat_definition] (
    [definition_id]         INT           IDENTITY (1, 1) NOT NULL,
    [assessment_id]         VARCHAR (24)  NULL,
    [treatment_type]        VARCHAR (24)  NULL,
    [treatment_description] VARCHAR (255) NULL,
    [workplan_id]           INT           NULL,
    [followup_workplan_id]  INT           NULL,
    [user_id]               VARCHAR (24)  NULL,
    [sort_sequence]         SMALLINT      NULL,
    [instructions]          VARCHAR (50)  NULL,
    [parent_definition_id]  INT           NULL,
    [child_flag]            CHAR (1)      NULL,
    [created]               DATETIME      NOT NULL,
    [care_plan_id]          INT           NOT NULL,
    [treatment_key]         VARCHAR (64)  NULL,
    [treatment_mode]        VARCHAR (24)  NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'assessment_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'assessment_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'assessment_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2475, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2805, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'treatment_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'instructions';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'instructions';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'instructions';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'parent_definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'parent_definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'parent_definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'child_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'child_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_definition', @level2type = N'COLUMN', @level2name = N'child_flag';

