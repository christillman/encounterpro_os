
-- mutually_exclusive_items not present in our database but is in the app

if not exists (select * from sys.columns where object_id = object_id('c_Workplan_Step') and
	 name = 'mutually_exclusive_items')
ALTER TABLE [dbo].[c_Workplan_Step]	ADD	[mutually_exclusive_items]  [bit] default 0 NOT NULL
