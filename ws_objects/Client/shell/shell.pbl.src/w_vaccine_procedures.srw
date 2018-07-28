$PBExportHeader$w_vaccine_procedures.srw
forward
global type w_vaccine_procedures from w_window_base
end type
type pb_done from u_picture_button within w_vaccine_procedures
end type
type pb_cancel from u_picture_button within w_vaccine_procedures
end type
type st_title2 from statictext within w_vaccine_procedures
end type
type st_admin_proc from statictext within w_vaccine_procedures
end type
type st_title from statictext within w_vaccine_procedures
end type
end forward

global type w_vaccine_procedures from w_window_base
integer width = 1696
integer height = 1196
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title2 st_title2
st_admin_proc st_admin_proc
st_title st_title
end type
global w_vaccine_procedures w_vaccine_procedures

type variables
string vaccine_id
string admin_procedure_id

end variables

on w_vaccine_procedures.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title2=create st_title2
this.st_admin_proc=create st_admin_proc
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title2
this.Control[iCurrent+4]=this.st_admin_proc
this.Control[iCurrent+5]=this.st_title
end on

on w_vaccine_procedures.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title2)
destroy(this.st_admin_proc)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return

popup_return.item_count = 0

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

vaccine_id = popup.items[1]
if isnull(vaccine_id) or trim(vaccine_id) = "" then
	log.log(this, "open", "Invalid Vaccine_id", 4)
	closewithreturn(this, popup_return)
	return
end if

SELECT procedure_id,
		description
INTO :admin_procedure_id,
		:st_title.text
FROM c_Vaccine
WHERE vaccine_id = :vaccine_id;
if not tf_check() then
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "open", "Vaccine_id not found (" + vaccine_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

if isnull(admin_procedure_id) then
	st_admin_proc.text = "<None>"
else
	SELECT description
	INTO :st_admin_proc.text
	FROM c_Procedure
	WHERE procedure_id = :admin_procedure_id;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
	if sqlca.sqlcode = 100 then
		setnull(admin_procedure_id)
		st_admin_proc.text = "<None>"
	end if
end if





end event

type pb_epro_help from w_window_base`pb_epro_help within w_vaccine_procedures
integer x = 722
integer y = 936
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_vaccine_procedures
end type

type pb_done from u_picture_button within w_vaccine_procedures
integer x = 1321
integer y = 900
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = admin_procedure_id

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_vaccine_procedures
integer x = 105
integer y = 892
integer taborder = 20
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title2 from statictext within w_vaccine_procedures
integer x = 549
integer y = 364
integer width = 567
integer height = 76
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

type st_admin_proc from statictext within w_vaccine_procedures
integer x = 311
integer y = 452
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
string ls_procedure_id

popup.dataobject = "dw_procedure_by_type"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.add_blank_row = true
popup.blank_text = "<None>"
popup.argument[1] = "VACCINEADMIN"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <= 0 then return

ls_procedure_id = popup_return.items[1]
if trim(ls_procedure_id) = "" then setnull(ls_procedure_id)

UPDATE c_Vaccine
SET procedure_id = :ls_procedure_id
WHERE vaccine_id = :vaccine_id;
if not tf_check() then return

admin_procedure_id = ls_procedure_id
text = popup_return.descriptions[1]


end event

type st_title from statictext within w_vaccine_procedures
integer width = 1701
integer height = 136
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

