CREATE TABLE [dbo].[o_Component_Selection] (
    [component_type] VARCHAR (24)     NOT NULL,
    [office_id]      VARCHAR (4)      NOT NULL,
    [component_id]   VARCHAR (24)     NOT NULL,
    [created_by]     VARCHAR (24)     NOT NULL,
    [created]        DATETIME         NOT NULL,
    [id]             UNIQUEIDENTIFIER NOT NULL
);



