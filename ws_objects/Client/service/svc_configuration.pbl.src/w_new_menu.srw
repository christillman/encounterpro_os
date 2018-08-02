$PBExportHeader$w_new_menu.srw
forward
global type w_new_menu from w_window_base
end type
type sle_menu from singlelineedit within w_new_menu
end type
type st_specialty from statictext within w_new_menu
end type
type st_context_object from statictext within w_new_menu
end type
type st_1 from statictext within w_new_menu
end type
type st_2 from statictext within w_new_menu
end type
type st_3 from statictext within w_new_menu
end type
type pb_ok from u_picture_button within w_new_menu
end type
type pb_cancel from u_picture_button within w_new_menu
end type
end forward

global type w_new_menu from w_window_base
integer height = 1396
string title = "Menu"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_menu sle_menu
st_specialty st_specialty
st_context_object st_context_object
st_1 st_1
st_2 st_2
st_3 st_3
pb_ok pb_ok
pb_cancel pb_cancel
end type
global w_new_menu w_new_menu

type variables
string menu_name,specialty_id,context_object
long menu_id
end variables

on w_new_menu.create
int iCurrent
call super::create
this.sle_menu=create sle_menu
this.st_specialty=create st_specialty
this.st_context_object=create st_context_object
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.pb_ok=create pb_ok
this.pb_cancel=create pb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_menu
this.Control[iCurrent+2]=this.st_specialty
this.Control[iCurrent+3]=this.st_context_object
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.pb_ok
this.Control[iCurrent+8]=this.pb_cancel
end on

on w_new_menu.destroy
call super::destroy
destroy(this.sle_menu)
destroy(this.st_specialty)
destroy(this.st_context_object)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_ok)
destroy(this.pb_cancel)
end on

event open;call super::open;string ls_description
str_menu	lstr_menu

lstr_menu = message.powerobjectparm
menu_id = lstr_menu.menu_id
menu_name = lstr_menu.description
specialty_id = lstr_menu.specialty_id
context_object = lstr_menu.context_object

postevent("post_open")
end event

event post_open;call super::post_open;string ls_description
sle_menu.text = menu_name
ls_description = datalist.specialty_description(specialty_id)
st_specialty.text = ls_description
st_context_object.text = context_object	

sle_menu.setfocus()
end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_menu
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_menu
end type

type sle_menu from singlelineedit within w_new_menu
integer x = 603
integer y = 204
integer width = 2171
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type st_specialty from statictext within w_new_menu
integer x = 603
integer y = 424
integer width = 1038
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
else
	text = datalist.specialty_description(ls_specialty_id)
	specialty_id = ls_specialty_id
end if


end event

type st_context_object from statictext within w_new_menu
integer x = 603
integer y = 620
integer width = 1042
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return popup_return

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(context_object)
else
	context_object = popup_return.items[1]
end if
text = context_object
end event

type st_1 from statictext within w_new_menu
integer x = 101
integer y = 224
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Name"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_new_menu
integer x = 101
integer y = 432
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Specialty"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_new_menu
integer x = 37
integer y = 636
integer width = 494
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Context"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_new_menu
integer x = 2400
integer y = 956
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long ll_menu_id
string ls_menu_name
str_menu lstr_menu

DECLARE lsp_set_menu PROCEDURE FOR dbo.sp_set_menu
         @pl_menu_id = :menu_id,
			@ps_description = :ls_menu_name,
			@ps_specialty_id = :specialty_id,
			@ps_context_object = :context_object,
			@pl_rtn_menu_id = :ll_menu_id OUT
 USING sqlca;
 
ls_menu_name = sle_menu.text

if isnull(ls_menu_name) and len(ls_menu_name) <= 0 then
	openwithparm(w_pop_message,"Enter a valid menu name")
	sle_menu.setfocus()
	return
end if
// insert or update the menu item record
EXECUTE lsp_set_menu;
if not tf_check() then
	log.log(this,"w_new_menu.pb_ok.clicked.0023","unable to execute sp_set_menu storedprocedure",3)
	pb_cancel.event clicked()
	return
end if

FETCH lsp_set_menu INTO :ll_menu_id;
if not tf_check() then
	log.log(this,"w_new_menu.pb_ok.clicked.0023","unable to get output from sp_set_menu storedprocedure",3)
	pb_cancel.event clicked()
	return
end if
menu_id = ll_menu_id

CLOSE lsp_set_menu;

lstr_menu.menu_id = menu_id
lstr_menu.description = ls_menu_name
lstr_menu.specialty_id = specialty_id
lstr_menu.context_object = context_object

Closewithreturn(parent,lstr_menu)
end event

type pb_cancel from u_picture_button within w_new_menu
integer x = 261
integer y = 960
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_menu lstr_menu

setnull(lstr_menu.menu_id)
closewithreturn(parent,lstr_menu)
end event

