CREATE TABLE [dbo].[c_Observation_Tree_Root] (
    [root_sequence]   INT          IDENTITY (1, 1) NOT NULL,
    [treatment_type]  VARCHAR (24) NULL,
    [root_category]   VARCHAR (24) NULL,
    [root_key]        VARCHAR (40) NULL,
    [observation_id]  VARCHAR (24) NOT NULL,
    [auto_order_flag] CHAR (1)     NULL,
    [sort_sequence]   SMALLINT     NULL
);

