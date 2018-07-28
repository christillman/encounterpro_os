HA$PBExportHeader$u_admin_method_procedure.sru
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

