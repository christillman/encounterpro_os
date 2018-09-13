$PBExportHeader$w_health_maintenance_procs.srw
forward
global type w_health_maintenance_procs from w_window_base
end type
type pb_done from u_picture_button within w_health_maintenance_procs
end type
type pb_cancel from u_picture_button within w_health_maintenance_procs
end type
type st_rule_description from statictext within w_health_maintenance_procs
end type
type st_rule_desc_title from statictext within w_health_maintenance_procs
end type
type cb_page from commandbutton within w_health_maintenance_procs
end type
type cb_new_alternate_code from commandbutton within w_health_maintenance_procs
end type
type st_no_alternate_codes from statictext within w_health_maintenance_procs
end type
type dw_procedures from u_dw_pick_list within w_health_maintenance_procs
end type
type st_procs_title from statictext within w_health_maintenance_procs
end type
type st_title from statictext within w_health_maintenance_procs
end type
end forward

global type w_health_maintenance_procs from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_rule_description st_rule_description
st_rule_desc_title st_rule_desc_title
cb_page cb_page
cb_new_alternate_code cb_new_alternate_code
st_no_alternate_codes st_no_alternate_codes
dw_procedures dw_procedures
st_procs_title st_procs_title
st_title st_title
end type
global w_health_maintenance_procs w_health_maintenance_procs

type variables
long maintenance_rule_id
end variables

forward prototypes
public subroutine proc_menu (long pl_row)
public function integer get_procs ()
public function integer add_proc ()
end prototypes

public subroutine proc_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long i

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set this assessment as the primary assessment"
	popup.button_titles[popup.button_count] = "Set Primary"
	buttons[popup.button_count] = "PRIMARY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Procedure From This Maintenance Rule"
	popup.button_titles[popup.button_count] = "Remove"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "PRIMARY"
		for i = 1 to dw_procedures.rowcount()
			if i = pl_row then
				dw_procedures.object.primary_flag[i] = "Y"
			else
				dw_procedures.object.primary_flag[i] = "N"
			end if
		next
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this procedure?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_procedures.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer get_procs ();dw_procedures.retrieve(maintenance_rule_id)

dw_procedures.set_page(1, cb_page.text)

return 1

end function

public function integer add_proc ();str_popup popup
string ls_procedure_type
string ls_description
integer li_sort_sequence
string ls_button
string ls_icon
integer li_sts
long ll_row
string ls_primary_flag
str_picked_procedures lstr_procedures

popup.data_row_count = 1
setnull(popup.items[1])
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm
if lstr_procedures.procedure_count <> 1 then return 0

SELECT t.procedure_type,
		t.description,
		t.sort_sequence,
		t.button,
		t.icon
INTO :ls_procedure_type,
		:ls_description,
		:li_sort_sequence,
		:ls_button,
		:ls_icon
FROM c_Procedure p, c_Procedure_Type t
WHERE p.procedure_id = :lstr_procedures.procedures[1].procedure_id
AND p.procedure_type = t.procedure_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_health_maintenance_procs.add_proc:0033", "procedure_type not found for procedure (" + lstr_procedures.procedures[1].procedure_id + ")", 4)
	return -1
end if

ll_row = dw_procedures.insertrow(0)

if ll_row = 1 then
	ls_primary_flag = "Y"
else
	ls_primary_flag = "N"
end if

dw_procedures.object.procedure_id[ll_row] = lstr_procedures.procedures[1].procedure_id
dw_procedures.object.description[ll_row] = lstr_procedures.procedures[1].description
dw_procedures.object.maintenance_rule_id[ll_row] = maintenance_rule_id
dw_procedures.object.primary_flag[ll_row] = ls_primary_flag
dw_procedures.object.procedure_type[ll_row] = ls_procedure_type
dw_procedures.object.procedure_type_description[ll_row] = ls_description
dw_procedures.object.procedure_type_sort_sequence[ll_row] = li_sort_sequence
dw_procedures.object.button[ll_row] = ls_button
dw_procedures.object.icon[ll_row] = ls_icon



return 1


end function

event open;call super::open;str_popup popup
integer li_sts


popup = message.powerobjectparm
if popup.data_row_count <> 2 then
	log.log(this, "w_health_maintenance_procs:open", "Invalid Parameters", 4)
	close(this)
	return
end if

maintenance_rule_id = long(popup.items[1])
st_rule_description.text = popup.items[2]

dw_procedures.settransobject(sqlca)

get_procs()

end event

on w_health_maintenance_procs.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_rule_description=create st_rule_description
this.st_rule_desc_title=create st_rule_desc_title
this.cb_page=create cb_page
this.cb_new_alternate_code=create cb_new_alternate_code
this.st_no_alternate_codes=create st_no_alternate_codes
this.dw_procedures=create dw_procedures
this.st_procs_title=create st_procs_title
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_rule_description
this.Control[iCurrent+4]=this.st_rule_desc_title
this.Control[iCurrent+5]=this.cb_page
this.Control[iCurrent+6]=this.cb_new_alternate_code
this.Control[iCurrent+7]=this.st_no_alternate_codes
this.Control[iCurrent+8]=this.dw_procedures
this.Control[iCurrent+9]=this.st_procs_title
this.Control[iCurrent+10]=this.st_title
end on

on w_health_maintenance_procs.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_rule_description)
destroy(this.st_rule_desc_title)
destroy(this.cb_page)
destroy(this.cb_new_alternate_code)
destroy(this.st_no_alternate_codes)
destroy(this.dw_procedures)
destroy(this.st_procs_title)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_health_maintenance_procs
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_health_maintenance_procs
end type

type pb_done from u_picture_button within w_health_maintenance_procs
integer x = 2569
integer y = 1532
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts

li_sts = dw_procedures.update()
if li_sts < 0 then return

close(parent)


end event

type pb_cancel from u_picture_button within w_health_maintenance_procs
integer x = 119
integer y = 1532
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type st_rule_description from statictext within w_health_maintenance_procs
integer x = 965
integer y = 156
integer width = 1678
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_rule_desc_title from statictext within w_health_maintenance_procs
integer x = 169
integer y = 172
integer width = 763
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Rule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_page from commandbutton within w_health_maintenance_procs
integer x = 2464
integer y = 436
integer width = 370
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99/99"
end type

event clicked;dw_procedures.set_page(dw_procedures.current_page + 1, text)

end event

type cb_new_alternate_code from commandbutton within w_health_maintenance_procs
integer x = 2464
integer y = 864
integer width = 370
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Proc"
end type

event clicked;add_proc()


end event

type st_no_alternate_codes from statictext within w_health_maintenance_procs
boolean visible = false
integer x = 736
integer y = 1052
integer width = 1504
integer height = 156
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "No Alternate Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_procedures from u_dw_pick_list within w_health_maintenance_procs
integer x = 434
integer y = 428
integer width = 2007
integer height = 1080
integer taborder = 10
string dataobject = "dw_maintenance_rule_procs"
boolean border = false
end type

event selected;call super::selected;proc_menu(selected_row)
clear_selected()

end event

type st_procs_title from statictext within w_health_maintenance_procs
integer x = 1262
integer y = 348
integer width = 366
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_health_maintenance_procs
integer width = 2926
integer height = 112
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

