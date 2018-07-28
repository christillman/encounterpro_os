CREATE TABLE [dbo].[p_Patient_Alias] (
    [cpr_id]         VARCHAR (12)     NOT NULL,
    [alias_type]     VARCHAR (12)     NOT NULL,
    [alias_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [first_name]     VARCHAR (20)     NULL,
    [last_name]      VARCHAR (40)     NOT NULL,
    [middle_name]    VARCHAR (20)     NULL,
    [name_prefix]    VARCHAR (12)     NULL,
    [name_suffix]    VARCHAR (12)     NULL,
    [degree]         VARCHAR (12)     NULL,
    [comment]        VARCHAR (80)     NULL,
    [created]        DATETIME         NOT NULL,
    [created_by]     VARCHAR (24)     NOT NULL,
    [current_flag]   CHAR (1)         NOT NULL,
    [id]             UNIQUEIDENTIFIER NOT NULL
);



