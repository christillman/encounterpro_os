--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[pbcatcol]
Print 'Drop Table [dbo].[pbcatcol]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[pbcatcol]') AND [type]='U'))
DROP TABLE [dbo].[pbcatcol]
GO
-- Create Table [dbo].[pbcatcol]
Print 'Create Table [dbo].[pbcatcol]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[pbcatcol] (
		[pbc_tnam]     [char](30) NULL,
		[pbc_tid]      [int] NULL,
		[pbc_ownr]     [char](30) NULL,
		[pbc_cnam]     [char](30) NULL,
		[pbc_cid]      [smallint] NULL,
		[pbc_labl]     [varchar](254) NULL,
		[pbc_lpos]     [smallint] NULL,
		[pbc_hdr]      [varchar](254) NULL,
		[pbc_hpos]     [smallint] NULL,
		[pbc_jtfy]     [smallint] NULL,
		[pbc_mask]     [varchar](31) NULL,
		[pbc_case]     [smallint] NULL,
		[pbc_hght]     [smallint] NULL,
		[pbc_wdth]     [smallint] NULL,
		[pbc_ptrn]     [varchar](31) NULL,
		[pbc_bmap]     [char](1) NULL,
		[pbc_init]     [varchar](254) NULL,
		[pbc_cmnt]     [varchar](254) NULL,
		[pbc_edit]     [varchar](31) NULL,
		[pbc_tag]      [varchar](254) NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [pbcatcol_idx]
	ON [dbo].[pbcatcol] ([pbc_tnam], [pbc_ownr], [pbc_cnam]) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[pbcatcol] TO [public]
GO
GRANT INSERT ON [dbo].[pbcatcol] TO [public]
GO
GRANT SELECT ON [dbo].[pbcatcol] TO [public]
GO
GRANT UPDATE ON [dbo].[pbcatcol] TO [public]
GO
ALTER TABLE [dbo].[pbcatcol] SET (LOCK_ESCALATION = TABLE)
GO

