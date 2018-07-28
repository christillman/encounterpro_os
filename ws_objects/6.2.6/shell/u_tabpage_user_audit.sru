HA$PBExportHeader$u_tabpage_user_audit.sru
forward
global type u_tabpage_user_audit from u_tabpage_user_base
end type
type cbx_include_object_updates from checkbox within u_tabpage_user_audit
end type
type cb_next_day from commandbutton within u_tabpage_user_audit
end type
type cb_prev_day from commandbutton within u_tabpage_user_audit
end type
type st_audit_date from statictext within u_tabpage_user_audit
end type
type st_audit_date_title from statictext within u_tabpage_user_audit
end type
type dw_audit from u_dw_pick_list within u_tabpage_user_audit
end type
end forward

global type u_tabpage_user_audit from u_tabpage_user_base
string tag = "User"
integer width = 2912
integer height = 1508
cbx_include_object_updates cbx_include_object_updates
cb_next_day cb_next_day
cb_prev_day cb_prev_day
st_audit_date st_audit_date
st_audit_date_title st_audit_date_title
dw_audit dw_audit
end type
global u_tabpage_user_audit u_tabpage_user_audit

type variables
date audit_date

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();string ls_cpr_id
long ll_encounter_id
string ls_include_object_updates
string ls_include_patient_info

setnull(ls_cpr_id)
setnull(ll_encounter_id)

st_audit_date.y = height - st_audit_date.height - 20
st_audit_date_title.y = st_audit_date.y + 20

dw_audit.width = width
dw_audit.height = st_audit_date.y - 20

st_audit_date.text = string(audit_date)

dw_audit.reset()

dw_audit.object.compute_action.width = width - 2700
dw_audit.object.compute_object.width = width - 662
dw_audit.object.l_header.x2 = width

if cbx_include_object_updates.checked then
	ls_include_object_updates = "Y"
else
	ls_include_object_updates = "N"
end if

if current_user.clinical_access_flag then
	ls_include_patient_info = "Y"
else
	ls_include_patient_info = "N"
end if

dw_audit.settransobject(sqlca)
dw_audit.retrieve(ls_cpr_id, ll_encounter_id, st_audit_date.text, st_audit_date.text, user.user_id, ls_include_object_updates, ls_include_patient_info)

cb_prev_day.x = st_audit_date.x - cb_prev_day.width - 20
cb_prev_day.y = st_audit_date.y

cb_next_day.x = st_audit_date.x + st_audit_date.width + 20
cb_next_day.y = st_audit_date.y

cbx_include_object_updates.x = width - cbx_include_object_updates.width - 50
cbx_include_object_updates.y = cb_next_day.y + 16

end subroutine

public function integer initialize ();integer li_sts

audit_date = today()

return 1

end function

on u_tabpage_user_audit.create
int iCurrent
call super::create
this.cbx_include_object_updates=create cbx_include_object_updates
this.cb_next_day=create cb_next_day
this.cb_prev_day=create cb_prev_day
this.st_audit_date=create st_audit_date
this.st_audit_date_title=create st_audit_date_title
this.dw_audit=create dw_audit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_include_object_updates
this.Control[iCurrent+2]=this.cb_next_day
this.Control[iCurrent+3]=this.cb_prev_day
this.Control[iCurrent+4]=this.st_audit_date
this.Control[iCurrent+5]=this.st_audit_date_title
this.Control[iCurrent+6]=this.dw_audit
end on

on u_tabpage_user_audit.destroy
call super::destroy
destroy(this.cbx_include_object_updates)
destroy(this.cb_next_day)
destroy(this.cb_prev_day)
destroy(this.st_audit_date)
destroy(this.st_audit_date_title)
destroy(this.dw_audit)
end on

type cbx_include_object_updates from checkbox within u_tabpage_user_audit
integer x = 2025
integer y = 1408
integer width = 795
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Object Updates"
boolean checked = true
end type

event clicked;refresh()

end event

type cb_next_day from commandbutton within u_tabpage_user_audit
integer x = 1723
integer y = 1396
integer width = 155
integer height = 104
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;audit_date = relativedate(audit_date, 1)

refresh()

end event

type cb_prev_day from commandbutton within u_tabpage_user_audit
integer x = 1074
integer y = 1396
integer width = 155
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;audit_date = relativedate(audit_date, -1)

refresh()

end event

type st_audit_date from statictext within u_tabpage_user_audit
integer x = 1248
integer y = 1396
integer width = 457
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_text
date ld_date

ld_date = date(audit_date)

ls_text = f_select_date(ld_date, "Select Audit Date")
if isnull(ls_text) then return

text = ls_text

audit_date = date(ls_text)

refresh()

end event

type st_audit_date_title from statictext within u_tabpage_user_audit
integer x = 645
integer y = 1412
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Audit Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_audit from u_dw_pick_list within u_tabpage_user_audit
integer width = 2912
integer height = 1372
integer taborder = 10
string dataobject = "dw_fn_audit"
boolean vscrollbar = true
end type

