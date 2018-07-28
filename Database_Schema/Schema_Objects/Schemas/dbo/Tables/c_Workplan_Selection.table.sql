CREATE TABLE [dbo].[c_Workplan_Selection] (
    [workplan_selection_id] INT          IDENTITY (1, 1) NOT NULL,
    [encounter_type]        VARCHAR (24) NULL,
    [new_flag]              VARCHAR (1)  NULL,
    [age_range_id]          INT          NULL,
    [sex]                   CHAR (1)     NULL,
    [workplan_id]           INT          NULL,
    [search_order]          SMALLINT     NULL
);

