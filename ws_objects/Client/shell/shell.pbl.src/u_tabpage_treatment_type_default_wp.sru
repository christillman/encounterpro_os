$PBExportHeader$u_tabpage_treatment_type_default_wp.sru
forward
global type u_tabpage_treatment_type_default_wp from u_tabpage
end type
type st_1 from statictext within u_tabpage_treatment_type_default_wp
end type
type st_title from statictext within u_tabpage_treatment_type_default_wp
end type
type cb_edit_display_script from commandbutton within u_tabpage_treatment_type_default_wp
end type
type st_workplan_title from statictext within u_tabpage_treatment_type_default_wp
end type
type st_workplan from statictext within u_tabpage_treatment_type_default_wp
end type
end forward

global type u_tabpage_treatment_type_default_wp from u_tabpage
integer width = 2802
integer height = 1000
st_1 st_1
st_title st_title
cb_edit_display_script cb_edit_display_script
st_workplan_title st_workplan_title
st_workplan st_workplan
end type
global u_tabpage_treatment_type_default_wp u_tabpage_treatment_type_default_wp

type variables
string treatment_type
long workplan_id

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
public function integer save_changes ()
end prototypes

public subroutine refresh ();long ll_count
long i
string ls_room_name
string ls_room_id,ls_desc,ls_icon
string ls_description

SELECT workplan_id
INTO :workplan_id
FROM c_treatment_Type
WHERE treatment_type = :treatment_type;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	log.log(this, "u_tabpage_treatment_type_default_wp.refresh.0013", "treatment_type not found (" + treatment_type + ")", 4)
	return
end if


if isnull(workplan_id) then
	st_workplan.text = ""
else
	SELECT description
	INTO :st_workplan.text
	FROM c_Workplan
	WHERE workplan_id = :workplan_id;
	if not tf_check() then return
end if


return


end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

return 1

end function

public function integer save_changes ();integer li_sts

UPDATE c_treatment_Type
SET workplan_id = :workplan_id
WHERE treatment_type = :treatment_type;
if not tf_check() then return -1

datalist.clear_cache("treatment_types")

return 1

end function

on u_tabpage_treatment_type_default_wp.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_title=create st_title
this.cb_edit_display_script=create cb_edit_display_script
this.st_workplan_title=create st_workplan_title
this.st_workplan=create st_workplan
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_edit_display_script
this.Control[iCurrent+4]=this.st_workplan_title
this.Control[iCurrent+5]=this.st_workplan
end on

on u_tabpage_treatment_type_default_wp.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_title)
destroy(this.cb_edit_display_script)
destroy(this.st_workplan_title)
destroy(this.st_workplan)
end on

type st_1 from statictext within u_tabpage_treatment_type_default_wp
integer x = 1056
integer y = 736
integer width = 681
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "(Version 4 Only)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_treatment_type_default_wp
integer width = 2802
integer height = 268
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "The default workplan is used for any treatment which does not have a treatment mode assigned.  This is provided for backward compatibility with EncounterPRO Version 4.  For EncounterPRO Version 5, the Default Treatment Modes tab should be used to specify the default behavior for this treatment type."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_edit_display_script from commandbutton within u_tabpage_treatment_type_default_wp
integer x = 1989
integer y = 644
integer width = 297
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;w_window_base lw_edit_window
str_popup popup
string ls_id

if isnull(workplan_id) or workplan_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_workplan
WHERE workplan_id = :workplan_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 2
popup.items[1] = ls_id
popup.items[2] = "true"

openwithparm(lw_edit_window, popup, "w_Workplan_definition_display")

end event

type st_workplan_title from statictext within u_tabpage_treatment_type_default_wp
integer x = 1056
integer y = 444
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Default Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan from statictext within u_tabpage_treatment_type_default_wp
integer x = 818
integer y = 540
integer width = 1152
integer height = 188
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = "Treatment"
lstr_workplan_context.in_office_flag = "?" // Let the user pick

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return

workplan_id = lstr_workplan.workplan_id
text = lstr_workplan.description

save_changes()

end event

