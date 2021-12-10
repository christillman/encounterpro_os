$PBExportHeader$w_folder_naming_rules.srw
forward
global type w_folder_naming_rules from w_window_base
end type
type st_name_supplied from statictext within w_folder_naming_rules
end type
type st_2 from statictext within w_folder_naming_rules
end type
type cb_ok from commandbutton within w_folder_naming_rules
end type
type st_4 from statictext within w_folder_naming_rules
end type
type st_folder from statictext within w_folder_naming_rules
end type
type st_folder_title from statictext within w_folder_naming_rules
end type
type st_name_folder from statictext within w_folder_naming_rules
end type
type st_name_other from statictext within w_folder_naming_rules
end type
type sle_other from singlelineedit within w_folder_naming_rules
end type
type st_5 from statictext within w_folder_naming_rules
end type
type st_prompt_yes from statictext within w_folder_naming_rules
end type
type st_prompt_no from statictext within w_folder_naming_rules
end type
type cb_1 from commandbutton within w_folder_naming_rules
end type
end forward

global type w_folder_naming_rules from w_window_base
integer y = 250
integer width = 2917
integer height = 1332
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_name_supplied st_name_supplied
st_2 st_2
cb_ok cb_ok
st_4 st_4
st_folder st_folder
st_folder_title st_folder_title
st_name_folder st_name_folder
st_name_other st_name_other
sle_other sle_other
st_5 st_5
st_prompt_yes st_prompt_yes
st_prompt_no st_prompt_no
cb_1 cb_1
end type
global w_folder_naming_rules w_folder_naming_rules

type variables
boolean prompt_user
integer default_name_choice
string folder

end variables

on w_folder_naming_rules.create
int iCurrent
call super::create
this.st_name_supplied=create st_name_supplied
this.st_2=create st_2
this.cb_ok=create cb_ok
this.st_4=create st_4
this.st_folder=create st_folder
this.st_folder_title=create st_folder_title
this.st_name_folder=create st_name_folder
this.st_name_other=create st_name_other
this.sle_other=create sle_other
this.st_5=create st_5
this.st_prompt_yes=create st_prompt_yes
this.st_prompt_no=create st_prompt_no
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_name_supplied
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_folder
this.Control[iCurrent+6]=this.st_folder_title
this.Control[iCurrent+7]=this.st_name_folder
this.Control[iCurrent+8]=this.st_name_other
this.Control[iCurrent+9]=this.sle_other
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_prompt_yes
this.Control[iCurrent+12]=this.st_prompt_no
this.Control[iCurrent+13]=this.cb_1
end on

on w_folder_naming_rules.destroy
call super::destroy
destroy(this.st_name_supplied)
destroy(this.st_2)
destroy(this.cb_ok)
destroy(this.st_4)
destroy(this.st_folder)
destroy(this.st_folder_title)
destroy(this.st_name_folder)
destroy(this.st_name_other)
destroy(this.sle_other)
destroy(this.st_5)
destroy(this.st_prompt_yes)
destroy(this.st_prompt_no)
destroy(this.cb_1)
end on

event open;call super::open;long ll_count
string ls_value

folder = message.stringparm


if isnull(folder) or trim(folder) = "" then
	log.log(this, "w_folder_naming_rules:open", "No folder name supplied", 4)
	close(this)
	return
end if

SELECT count(*)
INTO :ll_count
FROM c_Folder
WHERE folder = :folder;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_folder_naming_rules:open", "Folder not found (" + folder + ")", 4)
	close(this)
	return
end if

st_folder.text = wordcap(folder)

SELECT MAX(value)
INTO :ls_value
FROM c_Folder_Attribute
WHERE folder = :folder
AND attribute = 'Default Attachment Description';
if not tf_check() then
	close(this)
	return
end if

// Set the attachment naming rule
CHOOSE CASE lower(ls_value)
	CASE "%attachment tag%"
		default_name_choice = 1
		sle_other.visible = false
		st_name_supplied.backcolor = color_object_selected
	CASE ELSE
		if isnull(ls_value) or lower(ls_value) = lower(folder) then
			default_name_choice = 2
			sle_other.visible = false
			st_name_folder.backcolor = color_object_selected
		else
			default_name_choice = 3
			sle_other.visible = true
			sle_other.text = ls_value
			st_name_other.backcolor = color_object_selected
		end if
END CHOOSE

// Set the prompt rule
SELECT MAX(value)
INTO :ls_value
FROM c_Folder_Attribute
WHERE folder = :folder
AND attribute = 'Always Prompt';
if not tf_check() then
	close(this)
	return
end if
if isnull(ls_value) then ls_value = "True"

prompt_user = f_string_to_boolean(ls_value)
if prompt_user then
	st_prompt_yes.backcolor = color_object_selected
else
	st_prompt_no.backcolor = color_object_selected
end if


end event

event post_open;call super::post_open;//string ls_description
//sle_menu.text = menu_name
//ls_description = datalist.specialty_description(specialty_id)
//st_specialty.text = ls_description
//st_context_object.text = context_object	
//
//sle_menu.setfocus()
end event

type pb_epro_help from w_window_base`pb_epro_help within w_folder_naming_rules
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_folder_naming_rules
end type

type st_name_supplied from statictext within w_folder_naming_rules
integer x = 832
integer y = 476
integer width = 1307
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Name supplied by external Source"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_name_folder.backcolor = color_object
st_name_other.backcolor = color_object
sle_other.visible = false

default_name_choice = 1

end event

type st_2 from statictext within w_folder_naming_rules
integer x = 773
integer y = 356
integer width = 1431
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Default Name for New Attachments"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_folder_naming_rules
integer x = 2459
integer y = 1180
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;string ls_default_attachment_description
string ls_always_prompt

CHOOSE CASE default_name_choice
	CASE 1
		ls_default_attachment_description = "%Attachment Tag%"
	CASE 2
		ls_default_attachment_description = folder
	CASE 3
		if len(sle_other.text) > 0 then
			ls_default_attachment_description = sle_other.text
		else
			openwithparm(w_pop_message, "If you select ~"Other (Specify)~" you must supply a default name")
			return
		end if
END CHOOSE

DELETE c_Folder_Attribute
WHERE folder = :folder
AND attribute = 'Default Attachment Description';
if not tf_check() then return

INSERT INTO c_Folder_Attribute (
	folder,
	attribute,
	value)
VALUES (
	:folder,
	'Default Attachment Description',
	:ls_default_attachment_description);
if not tf_check() then return


ls_always_prompt = f_boolean_to_string(prompt_user)

DELETE c_Folder_Attribute
WHERE folder = :folder
AND attribute = 'Always Prompt';
if not tf_check() then return

INSERT INTO c_Folder_Attribute (
	folder,
	attribute,
	value)
VALUES (
	:folder,
	'Always Prompt',
	:ls_always_prompt);
if not tf_check() then return


close(parent)

end event

type st_4 from statictext within w_folder_naming_rules
integer width = 2917
integer height = 132
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Attachment Naming Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_folder from statictext within w_folder_naming_rules
integer x = 841
integer y = 204
integer width = 1285
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
boolean focusrectangle = false
end type

event clicked;//str_popup popup
//str_popup_return popup_return
//
//popup.dataobject = "dw_specialty_list"
//popup.datacolumn = 2
//popup.displaycolumn = 1
//popup.add_blank_row = true
//popup.blank_text = "<None>"
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return
//
//
//if popup_return.items[1] = "" then
//	text = "<None>"
//	setnull(specialty_id)
//else
//	text = popup_return.descriptions[1]
//	specialty_id = popup_return.items[1]
//end if
end event

type st_folder_title from statictext within w_folder_naming_rules
integer x = 507
integer y = 220
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Folder:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_name_folder from statictext within w_folder_naming_rules
integer x = 832
integer y = 612
integer width = 1307
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Folder Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_name_supplied.backcolor = color_object
st_name_other.backcolor = color_object
sle_other.visible = false

default_name_choice = 2

end event

type st_name_other from statictext within w_folder_naming_rules
integer x = 832
integer y = 748
integer width = 1307
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other (specify)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_name_supplied.backcolor = color_object
st_name_folder.backcolor = color_object
sle_other.visible = true

default_name_choice = 3

end event

type sle_other from singlelineedit within w_folder_naming_rules
integer x = 896
integer y = 884
integer width = 1184
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_folder_naming_rules
integer x = 361
integer y = 1036
integer width = 1010
integer height = 168
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Prompt user even if external source suppled name"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_prompt_yes from statictext within w_folder_naming_rules
integer x = 1472
integer y = 1064
integer width = 256
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_prompt_no.backcolor = color_object

prompt_user = true

end event

type st_prompt_no from statictext within w_folder_naming_rules
integer x = 1760
integer y = 1064
integer width = 256
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_prompt_yes.backcolor = color_object

prompt_user = false


end event

type cb_1 from commandbutton within w_folder_naming_rules
integer x = 32
integer y = 1180
integer width = 402
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

