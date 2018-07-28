
ALTER TABLE [dbo].[c_Config_Object_Version_Dependency] ADD  CONSTRAINT [DF_c_Config_Object_Version_Dep_or_later]  DEFAULT ((1)) FOR [or_later]
GO

