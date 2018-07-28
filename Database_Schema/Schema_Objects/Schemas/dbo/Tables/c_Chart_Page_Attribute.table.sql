CREATE TABLE [dbo].[c_Chart_Page_Attribute] (
    [page_class]         VARCHAR (80)  NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (40)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



