CREATE TABLE [dbo].[c_Report_Recipient] (
    [report_id]    UNIQUEIDENTIFIER NOT NULL,
    [actor_class]  VARCHAR (24)     NOT NULL,
    [status]       VARCHAR (12)     NOT NULL,
    [owner_id]     INT              NOT NULL,
    [last_updated] DATETIME         NOT NULL,
    [id]           UNIQUEIDENTIFIER NOT NULL
);



