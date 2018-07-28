CREATE TABLE [dbo].[p_Object_Security] (
    [cpr_id]         VARCHAR (12)     NOT NULL,
    [object_key]     INT              NOT NULL,
    [context_object] VARCHAR (24)     NOT NULL,
    [user_id]        VARCHAR (24)     NOT NULL,
    [access_flag]    CHAR (1)         NOT NULL,
    [created]        DATETIME         NULL,
    [created_by]     VARCHAR (24)     NULL,
    [id]             UNIQUEIDENTIFIER NOT NULL
);



