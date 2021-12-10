$PBExportHeader$w_data_address_builder_tree.srw
forward
global type w_data_address_builder_tree from w_window_base
end type
type cb_ok from commandbutton within w_data_address_builder_tree
end type
type st_property_path from statictext within w_data_address_builder_tree
end type
type st_title from statictext within w_data_address_builder_tree
end type
type st_property_path_title from statictext within w_data_address_builder_tree
end type
type tv_epro_objects from u_tv_epro_objects within w_data_address_builder_tree
end type
type st_property_value_title from statictext within w_data_address_builder_tree
end type
type st_property_value from statictext within w_data_address_builder_tree
end type
type st_clipboard_tip from statictext within w_data_address_builder_tree
end type
type mle_help from multilineedit within w_data_address_builder_tree
end type
type cbx_include_user_defined from checkbox within w_data_address_builder_tree
end type
type st_suffix_title from statictext within w_data_address_builder_tree
end type
type st_suffix from statictext within w_data_address_builder_tree
end type
type st_display_value from statictext within w_data_address_builder_tree
end type
type st_2 from statictext within w_data_address_builder_tree
end type
type cb_cancel from commandbutton within w_data_address_builder_tree
end type
end forward

global type w_data_address_builder_tree from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
st_property_path st_property_path
st_title st_title
st_property_path_title st_property_path_title
tv_epro_objects tv_epro_objects
st_property_value_title st_property_value_title
st_property_value st_property_value
st_clipboard_tip st_clipboard_tip
mle_help mle_help
cbx_include_user_defined cbx_include_user_defined
st_suffix_title st_suffix_title
st_suffix st_suffix
st_display_value st_display_value
st_2 st_2
cb_cancel cb_cancel
end type
global w_data_address_builder_tree w_data_address_builder_tree

type variables
str_property_address property_address
str_complete_context current_context
str_attributes current_attributes

// Current state
str_property selected_property

str_property_value last_value

// Suffix variables
str_property_suffix property_suffix

string root_property
end variables

forward prototypes
public function integer refresh ()
public subroutine show_property_suffix ()
public subroutine show_last_value ()
end prototypes

public function integer refresh ();long i
integer li_sts

show_property_suffix()

if cbx_include_user_defined.checked then
	tv_epro_objects.display_user_defined = 1
else
	tv_epro_objects.display_user_defined = 0
end if

li_sts = tv_epro_objects.display_properties(root_property, current_context, current_attributes)

return li_sts



end function

public subroutine show_property_suffix ();
// Set the suffix datatype from the last value
property_suffix.datatype = last_value.datatype

CHOOSE CASE lower(last_value.datatype)
	CASE "boolean", "datetime", "number", "string"
		st_suffix.enabled = true
		st_suffix.borderstyle = Styleraised!
	CASE ELSE
		property_suffix.display_code = false
		setnull(property_suffix.format_string)
		setnull(property_suffix.lookup_owner_id)
		setnull(property_suffix.lookup_code_domain)
		
		st_suffix.enabled = false
		st_suffix.borderstyle = Stylebox!
		st_suffix.text = ""
		return
END CHOOSE

st_suffix.text = f_suffix_string(property_suffix)

return

end subroutine

public subroutine show_last_value ();string ls_display_value
boolean lb_erase_suffix

f_edas_set_property_display_value(property_suffix, last_value)

st_property_value.text = left(last_value.value, 1000)
st_display_value.text = left(last_value.display_value, 1000)


end subroutine

on w_data_address_builder_tree.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_property_path=create st_property_path
this.st_title=create st_title
this.st_property_path_title=create st_property_path_title
this.tv_epro_objects=create tv_epro_objects
this.st_property_value_title=create st_property_value_title
this.st_property_value=create st_property_value
this.st_clipboard_tip=create st_clipboard_tip
this.mle_help=create mle_help
this.cbx_include_user_defined=create cbx_include_user_defined
this.st_suffix_title=create st_suffix_title
this.st_suffix=create st_suffix
this.st_display_value=create st_display_value
this.st_2=create st_2
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_property_path
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_property_path_title
this.Control[iCurrent+5]=this.tv_epro_objects
this.Control[iCurrent+6]=this.st_property_value_title
this.Control[iCurrent+7]=this.st_property_value
this.Control[iCurrent+8]=this.st_clipboard_tip
this.Control[iCurrent+9]=this.mle_help
this.Control[iCurrent+10]=this.cbx_include_user_defined
this.Control[iCurrent+11]=this.st_suffix_title
this.Control[iCurrent+12]=this.st_suffix
this.Control[iCurrent+13]=this.st_display_value
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.cb_cancel
end on

on w_data_address_builder_tree.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_property_path)
destroy(this.st_title)
destroy(this.st_property_path_title)
destroy(this.tv_epro_objects)
destroy(this.st_property_value_title)
destroy(this.st_property_value)
destroy(this.st_clipboard_tip)
destroy(this.mle_help)
destroy(this.cbx_include_user_defined)
destroy(this.st_suffix_title)
destroy(this.st_suffix)
destroy(this.st_display_value)
destroy(this.st_2)
destroy(this.cb_cancel)
end on

event open;call super::open;string ls_argument
string ls_objects_only
str_edas_context lstr_edas_context

if not isnull(message.powerobjectparm) and isvalid(message.powerobjectparm) then
	// If a powerobject parm is passed in then it's an edas context structure
	lstr_edas_context = message.powerobjectparm
	root_property = lstr_edas_context.root_object
	tv_epro_objects.objects_only = lstr_edas_context.objects_only
	current_context = lstr_edas_context.context
	
	// Check the values
	if isnull(root_property) or trim(root_property) = "" then
		root_property = "Root"
	end if
	if isnull(tv_epro_objects.objects_only) then
		tv_epro_objects.objects_only = false
	end if
else
	ls_argument = message.stringparm
	
	current_context = f_current_complete_context()
	
	if len(ls_argument) > 0 then
		f_split_string(ls_argument, "|", root_property, ls_objects_only)
		tv_epro_objects.objects_only = f_string_to_boolean(ls_objects_only)
	else
		root_property = "Root"
		tv_epro_objects.objects_only = false
	end if
end if

st_property_path_title.text = "Property Path from " + root_property

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_data_address_builder_tree
integer x = 2830
integer y = 12
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_data_address_builder_tree
integer x = 64
integer y = 1496
end type

type cb_ok from commandbutton within w_data_address_builder_tree
integer x = 2400
integer y = 1584
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
string text = "Done"
boolean default = true
end type

event clicked;string ls_edas

if len(st_property_path.text) > 0 then
	ls_edas = st_property_path.text
	if len(st_suffix.text) > 0 then
		ls_edas += "." + st_suffix.text
	end if
end if

if lower(root_property) <> "root" and left(ls_edas, 1) <> "." then
	ls_edas = "." + ls_edas
end if

clipboard(ls_edas)

closewithreturn(parent, ls_edas)

end event

type st_property_path from statictext within w_data_address_builder_tree
integer x = 78
integer y = 188
integer width = 1902
integer height = 88
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

type st_title from statictext within w_data_address_builder_tree
integer width = 2898
integer height = 112
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "EncounterPRO Data Address Builder"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_property_path_title from statictext within w_data_address_builder_tree
integer x = 78
integer y = 108
integer width = 1902
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Property Path"
boolean focusrectangle = false
end type

type tv_epro_objects from u_tv_epro_objects within w_data_address_builder_tree
integer x = 78
integer y = 496
integer width = 2720
integer height = 972
integer taborder = 10
boolean bringtotop = true
long backcolor = 12632256
borderstyle borderstyle = stylebox!
end type

event new_address;call super::new_address;string ls_display_value
boolean lb_erase_suffix

st_property_path.text = ps_new_address
mle_help.text = ps_new_help

lb_erase_suffix = false
CHOOSE CASE lower(pstr_new_value.datatype)
	CASE "boolean", "datetime", "number", "string"
		if lower(last_value.datatype) <> lower(pstr_new_value.datatype) then
			lb_erase_suffix = true
		end if
	CASE ELSE
		lb_erase_suffix = true
END CHOOSE

if lb_erase_suffix then
	property_suffix.display_code = false
	setnull(property_suffix.format_string)
	setnull(property_suffix.lookup_owner_id)
	setnull(property_suffix.lookup_code_domain)
end if

last_value = pstr_new_value

show_property_suffix()
show_last_value()


end event

type st_property_value_title from statictext within w_data_address_builder_tree
integer y = 308
integer width = 841
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Current Context: Raw Value:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_property_value from statictext within w_data_address_builder_tree
integer x = 850
integer y = 296
integer width = 1947
integer height = 88
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

event clicked;clipboard(last_value.value)

end event

type st_clipboard_tip from statictext within w_data_address_builder_tree
integer x = 2030
integer y = 1552
integer width = 357
integer height = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Property Path will be copied to clipboard"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_help from multilineedit within w_data_address_builder_tree
integer x = 78
integer y = 1496
integer width = 1669
integer height = 200
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
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
end type

type cbx_include_user_defined from checkbox within w_data_address_builder_tree
integer x = 1851
integer y = 1472
integer width = 946
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Include User Defined Properties"
end type

event clicked;refresh()

end event

type st_suffix_title from statictext within w_data_address_builder_tree
integer x = 2007
integer y = 108
integer width = 759
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Formatting/Code Lookups"
boolean focusrectangle = false
end type

type st_suffix from statictext within w_data_address_builder_tree
integer x = 1998
integer y = 188
integer width = 800
integer height = 88
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

event clicked;str_property_suffix lstr_property_suffix

openwithparm(w_data_address_suffix, property_suffix)

lstr_property_suffix = message.powerobjectparm
if isnull(lstr_property_suffix.datatype) then return

property_suffix = lstr_property_suffix

show_property_suffix()
show_last_value()


end event

type st_display_value from statictext within w_data_address_builder_tree
integer x = 850
integer y = 392
integer width = 1947
integer height = 88
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

event clicked;clipboard(last_value.display_value)

end event

type st_2 from statictext within w_data_address_builder_tree
integer x = 91
integer y = 404
integer width = 750
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Display Value:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_data_address_builder_tree
integer x = 1760
integer y = 1624
integer width = 238
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, "")


end event

