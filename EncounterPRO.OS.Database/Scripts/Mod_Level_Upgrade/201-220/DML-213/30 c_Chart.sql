/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP 1000 [chart_id]
      ,[section_id]
      ,[page_id]
      ,[sort_sequence]
      ,[description]
      ,[page_class]
      ,[bitmap]
      ,[id]
  FROM [EncounterPro_OS].[dbo].[c_Chart_Section_Page]
  where chart_id = 7
  order by chart_id 

  update [c_Chart_Section_Page]
  set page_class = 'u_soap_page_results'
  where chart_id = 7 and page_id = 156
  */
  
  
DELETE FROM c_Chart_Page_Definition
WHERE page_class = 'u_soap_page_results'

INSERT INTO [dbo].[c_Chart_Page_Definition]
           ([page_class]
           ,[description]
           ,[default_tab_description]
           ,[bitmap]
           ,[status])
     VALUES
           (
		   'u_soap_page_results','Lab Results','Encounters','icon021.bmp','OK'	
		   )
GO



