
ALTER TABLE [dbo].[c_Config_Object_Version_Dependency] ADD  CONSTRAINT [DF_c_Config_Object_Version_Dep_created]  DEFAULT (getdate()) FOR [created]
GO


