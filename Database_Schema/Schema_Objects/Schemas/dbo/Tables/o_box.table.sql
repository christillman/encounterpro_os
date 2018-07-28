CREATE TABLE [dbo].[o_box] (
    [box_id]         INT          IDENTITY (1, 1) NOT NULL,
    [box_type]       VARCHAR (24) NULL,
    [description]    VARCHAR (80) NULL,
    [box_open_date]  DATETIME     NULL,
    [box_close_date] DATETIME     NULL,
    [last_item]      INT          NULL
);



