
DELETE FROM [c_Menu_Item]
WHERE menu_item IN ('Config_Country','Config_ID Document','Config_Locality')

INSERT INTO [c_Menu_Item]
           ([menu_id]
           ,[menu_item_type]
           ,[menu_item]
           ,[button_title]
           ,[button]
           ,[sort_sequence]
           ,[auto_close_flag]
           ,[context_object]
		   )
     VALUES
           (5
           ,'SERVICE'
           ,'Config_Country'
           ,'Countries'
           ,'button_wrench.bmp'
           ,1
           ,'N'
           ,'General'
		   )


INSERT INTO [c_Menu_Item]
           ([menu_id]
           ,[menu_item_type]
           ,[menu_item]
           ,[button_title]
           ,[button]
           ,[sort_sequence]
           ,[auto_close_flag]
           ,[context_object]
		   )
     VALUES
           (5
           ,'SERVICE'
           ,'Config_ID Document'
           ,'ID Documents'
           ,'button_wrench.bmp'
           ,1
           ,'N'
           ,'General'
		   )


INSERT INTO [c_Menu_Item]
           ([menu_id]
           ,[menu_item_type]
           ,[menu_item]
           ,[button_title]
           ,[button]
           ,[sort_sequence]
           ,[auto_close_flag]
           ,[context_object]
		   )
     VALUES
           (5
           ,'SERVICE'
           ,'Config_Locality'
           ,'Localities'
           ,'button_wrench.bmp'
           ,1
           ,'N'
           ,'General'
		   )

