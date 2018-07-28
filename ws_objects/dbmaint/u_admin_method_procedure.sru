HA$PBExportHeader$u_admin_method_procedure.sru
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http://www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version. 
forward
global type u_admin_method_procedure from statictext
end type
end forward

global type u_admin_method_procedure from statictext
int Width=690
int Height=88
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=15780004
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_admin_method_procedure u_admin_method_procedure

type variables
string procedure_id
end variables

forward prototypes
public function integer get_default (string ps_administer_method)
public function integer set_value (string ps_procedure_id)
public function integer set_value (string ps_procedure_id, string ps_description)
end prototypes

public function integer get_default (string ps_administer_method);string ls_procedure_id
integer li_sts

li_sts = tf_get_default_admin_procedure(ps_administer_method, ls_procedure_id)

if li_sts > 0 then
	set_value(ls_procedure_id)
end if

return li_sts
end function

public function integer set_value (string ps_procedure_id);string ls_procedure_description
integer li_sts

if isnull(ps_procedure_id) or ps_procedure_id = "" then
	setnull(procedure_id)
	text = "N/A"
	return 1
end if

li_sts = tf_get_procedure_description(ps_procedure_id, ls_procedure_description)
if li_sts > 0 then
	text = ls_procedure_description
	procedure_id = ps_procedure_id
end if

return li_sts
end function

public function integer set_value (string ps_procedure_id, string ps_description);string ls_procedure_description
integer li_sts

procedure_id = ps_procedure_id
if procedure_id = "" then setnull(procedure_id)

if isnull(procedure_id) then
	text = "N/A"
else
	text = ps_description
end if

return 1

end function

