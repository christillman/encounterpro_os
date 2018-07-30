$PBExportHeader$w_assessment_menu.srw
forward
global type w_assessment_menu from w_window_base
end type
type mle_long_description from multilineedit within w_assessment_menu
end type
type cb_select from commandbutton within w_assessment_menu
end type
end forward

global type w_assessment_menu from w_window_base
integer y = 400
integer height = 1048
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
integer max_buttons = 8
mle_long_description mle_long_description
cb_select cb_select
end type
global w_assessment_menu w_assessment_menu

type variables
string current_search
string assessment_id
boolean allow_editing
string mode
string specialty_id
end variables

forward prototypes
public function integer button_pressed (integer pi_button_index)
end prototypes

public function integer button_pressed (integer pi_button_index);closewithreturn(this, buttons_base.button[pi_button_index].action)
return 1

end function

event open;call super::open;str_popup popup
string ls_long_description
string ls_description
string ls_icd10_code
string ls_null

setnull(ls_null)

popup = message.powerobjectparm
if popup.data_row_count <> 5 then
	log.log(this, "open", "invalid parameters", 4)
	closewithreturn(this, ls_null)
	return
end if

assessment_id = popup.items[1]
current_search = popup.items[2]
allow_editing = f_string_to_boolean(popup.items[3])
mode = popup.items[4]
specialty_id = popup.items[5]

if upper(mode) = "PICK" then
	cb_select.visible = true
else
	cb_select.visible = false
end if

if current_search <> "TOP20" then
	add_button("button17.bmp", &
					"Personal Short List", &
					"Add Assessment to personal Short List List", &
					"TOP20PERSONAL", &
					"")
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	add_button("button17.bmp", &
					"Common Short List", &
					"Add Assessment to common Short List List", &
					"TOP20COMMON", &
					"")
end if

if current_search = "TOP20" then
	add_button("button13.bmp", &
					"Remove Short List", &
					"Remove item from Short List", &
					"REMOVE", &
					"")
end if

if current_search = "TOP20" then
	add_button("buttonmove.bmp", &
					"Move", &
					"Move record up or down", &
					"MOVE", &
					"")
end if

if current_search = "TOP20" then
	add_button("buttonx3.bmp", &
					"Sort", &
					"Sort Items Aphabetically", &
					"SORT", &
					"")
end if

if current_search <> "TOP20" and isnull(specialty_id) then
	add_button("button10.bmp", &
					"Add To Specialty", &
					"Add Assessment to Specialty Specific List", &
					"ADDSPECIALTY", &
					"")
end if

if allow_editing &
		and user_list.is_user_service(current_user.user_id, "Edit Assessment") then
	add_button("button17.bmp", &
					"Edit Assessment", &
					"Edit Assessment", &
					"EDIT", &
					"")
else
	add_button("button17.bmp", &
					"Display Assessment", &
					"Display Assessment", &
					"EDIT", &
					"")
end if

if true then
	add_button("button11.bmp", &
					"Cancel", &
					"Cancel", &
					"CANCEL", &
					"")
end if


SELECT description,
	long_description,
	icd10_code
INTO :ls_description,
	:ls_long_description,
	:ls_icd10_code
FROM c_Assessment
WHERE assessment_id = :assessment_id;
if not tf_check() then
	log.log(this, "open", "Error selecting assessment", 4)
	closewithreturn(this, ls_null)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "open", "Assessment not found (" + assessment_id + ")", 4)
	closewithreturn(this, ls_null)
	return
end if

title = ls_description
if not isnull(ls_icd10_code) then title += " (" + ls_icd10_code + ")"

if isnull(ls_long_description) or trim(ls_long_description) = "" then
	ls_long_description = ls_description
end if

mle_long_description.text = ls_long_description



end event

on w_assessment_menu.create
int iCurrent
call super::create
this.mle_long_description=create mle_long_description
this.cb_select=create cb_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_long_description
this.Control[iCurrent+2]=this.cb_select
end on

on w_assessment_menu.destroy
call super::destroy
destroy(this.mle_long_description)
destroy(this.cb_select)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_menu
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_menu
end type

type mle_long_description from multilineedit within w_assessment_menu
integer x = 142
integer y = 96
integer width = 2619
integer height = 388
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_select from commandbutton within w_assessment_menu
integer x = 2423
integer y = 792
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select"
end type

event clicked;closewithreturn(parent, "SELECT")

end event

