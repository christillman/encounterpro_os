HA$PBExportHeader$u_tabpage_drug_procedures.sru
forward
global type u_tabpage_drug_procedures from u_tabpage_drug_base
end type
type cb_clear_admin_proc from commandbutton within u_tabpage_drug_procedures
end type
type cb_edit_procedure from commandbutton within u_tabpage_drug_procedures
end type
type cb_set_primary from commandbutton within u_tabpage_drug_procedures
end type
type st_admin_proc from statictext within u_tabpage_drug_procedures
end type
type st_title2 from statictext within u_tabpage_drug_procedures
end type
type cb_add_procedure from commandbutton within u_tabpage_drug_procedures
end type
type cb_remove_procedure from commandbutton within u_tabpage_drug_procedures
end type
type st_procedure_title from statictext within u_tabpage_drug_procedures
end type
type dw_procedure from u_dw_pick_list within u_tabpage_drug_procedures
end type
end forward

global type u_tabpage_drug_procedures from u_tabpage_drug_base
integer width = 2606
cb_clear_admin_proc cb_clear_admin_proc
cb_edit_procedure cb_edit_procedure
cb_set_primary cb_set_primary
st_admin_proc st_admin_proc
st_title2 st_title2
cb_add_procedure cb_add_procedure
cb_remove_procedure cb_remove_procedure
st_procedure_title st_procedure_title
dw_procedure dw_procedure
end type
global u_tabpage_drug_procedures u_tabpage_drug_procedures

type variables
string admin_procedure_id
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_procedure ()
public function integer remove_procedure (string ps_procedure_id)
public function integer set_primary_procedure (string ps_procedure_id)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "vaccine" then
	visible = true
else
	visible = false
	return 1
end if

st_procedure_title.text = wordcap(drug_tab.drug.drug_type) + " Procedures"

st_procedure_title.width = 1376
st_procedure_title.height = 96

dw_procedure.y = st_procedure_title.height + 4
dw_procedure.width = st_procedure_title.width
dw_procedure.height = height - dw_procedure.y

dw_procedure.settransobject(sqlca)

return 1

end function

public subroutine refresh ();
// Display admin procedure
if st_admin_proc.visible then
	SELECT p.procedure_id,
			p.description
	INTO :admin_procedure_id,
			:st_admin_proc.text
	FROM c_Vaccine v
		INNER JOIN c_Procedure p
		ON v.procedure_id = p.procedure_id
	WHERE v.vaccine_id = :drug_tab.drug.drug_id;
	if not tf_check() then
		st_admin_proc.text = "<None>"
		cb_clear_admin_proc.visible = false
	elseif sqlca.sqlcode = 100 then
		st_admin_proc.text = "<None>"
		cb_clear_admin_proc.visible = false
	elseif isnull(admin_procedure_id) then
		cb_clear_admin_proc.visible = false
	else
		cb_clear_admin_proc.visible = true
	end if
else
	cb_clear_admin_proc.visible = false
end if

dw_procedure.retrieve(drug_tab.drug.drug_id)

cb_remove_procedure.enabled = false
cb_set_primary.enabled = false
cb_edit_procedure.enabled = false


end subroutine

public function integer add_procedure ();str_popup popup
str_popup_return popup_return
string ls_procedure_type
str_picked_procedures lstr_procedures

if lower(drug_tab.drug.drug_type) = "vaccine" then
	ls_procedure_type = "IMMUNIZATION"
else
	ls_procedure_type = "PROCEDURE"
end if

popup.data_row_count = 1
popup.items[1] = ls_procedure_type
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return 0


UPDATE c_Procedure
SET vaccine_id = :drug_tab.drug.drug_id
WHERE procedure_id = :lstr_procedures.procedures[1].procedure_id;
if not tf_check() then return -1


refresh()

return 1



end function

public function integer remove_procedure (string ps_procedure_id);
UPDATE c_Procedure
SET vaccine_id = NULL
WHERE procedure_id = :ps_procedure_id;
if not tf_check() then return -1

refresh()

return 1


end function

public function integer set_primary_procedure (string ps_procedure_id);
UPDATE c_Vaccine
SET procedure_id = :ps_procedure_id
WHERE vaccine_id = :drug_tab.drug.drug_id;
if not tf_check() then return -1

refresh()

return 1


end function

on u_tabpage_drug_procedures.create
int iCurrent
call super::create
this.cb_clear_admin_proc=create cb_clear_admin_proc
this.cb_edit_procedure=create cb_edit_procedure
this.cb_set_primary=create cb_set_primary
this.st_admin_proc=create st_admin_proc
this.st_title2=create st_title2
this.cb_add_procedure=create cb_add_procedure
this.cb_remove_procedure=create cb_remove_procedure
this.st_procedure_title=create st_procedure_title
this.dw_procedure=create dw_procedure
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear_admin_proc
this.Control[iCurrent+2]=this.cb_edit_procedure
this.Control[iCurrent+3]=this.cb_set_primary
this.Control[iCurrent+4]=this.st_admin_proc
this.Control[iCurrent+5]=this.st_title2
this.Control[iCurrent+6]=this.cb_add_procedure
this.Control[iCurrent+7]=this.cb_remove_procedure
this.Control[iCurrent+8]=this.st_procedure_title
this.Control[iCurrent+9]=this.dw_procedure
end on

on u_tabpage_drug_procedures.destroy
call super::destroy
destroy(this.cb_clear_admin_proc)
destroy(this.cb_edit_procedure)
destroy(this.cb_set_primary)
destroy(this.st_admin_proc)
destroy(this.st_title2)
destroy(this.cb_add_procedure)
destroy(this.cb_remove_procedure)
destroy(this.st_procedure_title)
destroy(this.dw_procedure)
end on

type cb_clear_admin_proc from commandbutton within u_tabpage_drug_procedures
integer x = 2391
integer y = 864
integer width = 178
integer height = 60
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;UPDATE c_Vaccine
SET procedure_id = NULL
WHERE vaccine_id = :drug_tab.drug.drug_id;
if not tf_check() then return

setnull(admin_procedure_id)
st_admin_proc.text = "<None>"

visible = false

end event

type cb_edit_procedure from commandbutton within u_tabpage_drug_procedures
integer x = 1705
integer y = 484
integer width = 718
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Edit Procedure"
end type

event clicked;long ll_row
string ls_procedure_id
string ls_procedure_type
str_popup popup

ll_row = dw_procedure.get_selected_row()
if ll_row <= 0 then return

ls_procedure_id = dw_procedure.object.procedure_id[ll_row]
ls_procedure_type = dw_procedure.object.procedure_type[ll_row]

popup.data_row_count = 2
popup.items[1] = ls_procedure_type
popup.items[2] = ls_procedure_id
openwithparm(w_procedure_definition, popup)

end event

type cb_set_primary from commandbutton within u_tabpage_drug_procedures
integer x = 1705
integer y = 688
integer width = 718
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Set Primary Procedure"
end type

event clicked;long ll_row
string ls_procedure_id

ll_row = dw_procedure.get_selected_row()
if ll_row <= 0 then return

ls_procedure_id = dw_procedure.object.procedure_id[ll_row]

set_primary_procedure(ls_procedure_id)

end event

type st_admin_proc from statictext within u_tabpage_drug_procedures
integer x = 1545
integer y = 932
integer width = 1024
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_procedure_type
str_picked_procedures lstr_procedures

if lower(drug_tab.drug.drug_type) = "vaccine" then
	ls_procedure_type = "VACCINEADMIN"
else
	ls_procedure_type = "DRUGADMIN"
end if

popup.data_row_count = 1
popup.items[1] = ls_procedure_type
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return

UPDATE c_Vaccine
SET procedure_id = :lstr_procedures.procedures[1].procedure_id
WHERE vaccine_id = :drug_tab.drug.drug_id;
if not tf_check() then return

admin_procedure_id = lstr_procedures.procedures[1].procedure_id
text = lstr_procedures.procedures[1].description

cb_clear_admin_proc.visible = true

end event

type st_title2 from statictext within u_tabpage_drug_procedures
integer x = 1774
integer y = 860
integer width = 567
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Admin Procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_procedure from commandbutton within u_tabpage_drug_procedures
integer x = 1705
integer y = 76
integer width = 718
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add procedure"
end type

event clicked;add_procedure()
end event

type cb_remove_procedure from commandbutton within u_tabpage_drug_procedures
integer x = 1705
integer y = 280
integer width = 718
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove procedure"
end type

event clicked;long ll_row
string ls_procedure_id

ll_row = dw_procedure.get_selected_row()
if ll_row <= 0 then return

ls_procedure_id = dw_procedure.object.procedure_id[ll_row]

remove_procedure(ls_procedure_id)

end event

type st_procedure_title from statictext within u_tabpage_drug_procedures
integer width = 1376
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Drug Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_procedure from u_dw_pick_list within u_tabpage_drug_procedures
integer y = 88
integer width = 1376
integer height = 1012
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_drug_procedure_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_procedure.enabled = true
cb_set_primary.enabled = true
cb_edit_procedure.enabled = true


end event

event unselected;call super::unselected;cb_remove_procedure.enabled = false
cb_set_primary.enabled = false
cb_edit_procedure.enabled = false

end event

