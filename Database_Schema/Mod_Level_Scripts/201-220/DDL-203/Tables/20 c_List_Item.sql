

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_List_Item]') AND [type]='U'))
	DROP TABLE [dbo].[c_List_Item]
GO

CREATE TABLE c_List_Item (
	list_id varchar(24) NOT NULL, 
	list_item_id varchar(24) NULL, 
	list_item varchar(40) NOT NULL, 
	sort_sequence integer,
	status varchar(10)  
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_List_Item] TO [cprsystem]

