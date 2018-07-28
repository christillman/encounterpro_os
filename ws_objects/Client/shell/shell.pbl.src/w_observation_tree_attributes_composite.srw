$PBExportHeader$w_observation_tree_attributes_composite.srw
forward
global type w_observation_tree_attributes_composite from w_window_base
end type
type st_child_observation from statictext within w_observation_tree_attributes_composite
end type
type st_description_title from statictext within w_observation_tree_attributes_composite
end type
type sle_description from singlelineedit within w_observation_tree_attributes_composite
end type
type pb_done from u_picture_button within w_observation_tree_attributes_composite
end type
type pb_cancel from u_picture_button within w_observation_tree_attributes_composite
end type
type st_title from statictext within w_observation_tree_attributes_composite
end type
type pb_1 from u_pb_help_button within w_observation_tree_attributes_composite
end type
type st_tag_title from statictext within w_observation_tree_attributes_composite
end type
type st_observation_tag from statictext within w_observation_tree_attributes_composite
end type
end forward

global type w_observation_tree_attributes_composite from w_window_base
integer x = 210
integer y = 500
integer width = 2510
integer height = 868
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_child_observation st_child_observation
st_description_title st_description_title
sle_description sle_description
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
pb_1 pb_1
st_tag_title st_tag_title
st_observation_tag st_observation_tag
end type
global w_observation_tree_attributes_composite w_observation_tree_attributes_composite

type variables
string parent_observation_id
string child_observation_id
string location
integer result_sequence
integer result_sequence_2
integer followon_severity
string followon_observation_id

string perform_location_domain

string observation_tag

boolean allow_editing

end variables

on w_observation_tree_attributes_composite.create
int iCurrent
call super::create
this.st_child_observation=create st_child_observation
this.st_description_title=create st_description_title
this.sle_description=create sle_description
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.pb_1=create pb_1
this.st_tag_title=create st_tag_title
this.st_observation_tag=create st_observation_tag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_child_observation
this.Control[iCurrent+2]=this.st_description_title
this.Control[iCurrent+3]=this.sle_description
this.Control[iCurrent+4]=this.pb_done
this.Control[iCurrent+5]=this.pb_cancel
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.st_tag_title
this.Control[iCurrent+9]=this.st_observation_tag
end on

on w_observation_tree_attributes_composite.destroy
call super::destroy
destroy(this.st_child_observation)
destroy(this.st_description_title)
destroy(this.sle_description)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.pb_1)
destroy(this.st_tag_title)
destroy(this.st_observation_tag)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 4 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

child_observation_id = popup.items[1]
st_child_observation.text = datalist.observation_description(child_observation_id)

if isnull(popup.items[2]) or trim(popup.items[2]) = "" then
	sle_description.text = st_child_observation.text
else
	sle_description.text = popup.items[2]
end if

observation_tag = popup.items[3]
allow_editing = f_string_to_boolean(popup.items[4])

if isnull(observation_tag) then
	st_observation_tag.text = "N/A"
else
	st_observation_tag.text = observation_tag
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_tree_attributes_composite
end type

type st_child_observation from statictext within w_observation_tree_attributes_composite
integer y = 136
integer width = 2501
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "child observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description_title from statictext within w_observation_tree_attributes_composite
integer x = 64
integer y = 272
integer width = 384
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
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_observation_tree_attributes_composite
integer x = 453
integer y = 260
integer width = 1966
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type pb_done from u_picture_button within w_observation_tree_attributes_composite
integer x = 2167
integer y = 580
integer taborder = 10
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return

if allow_editing then
	popup_return.item_count = 2
	
	if trim(sle_description.text) = trim(st_child_observation.text) or isnull(sle_description.text) or trim(sle_description.text) = "" then
		setnull(popup_return.items[1])
	else
		popup_return.items[1] = sle_description.text
	end if
	popup_return.descriptions[1] = sle_description.text
	popup_return.items[2] = observation_tag
	popup_return.descriptions[2] = observation_tag
else
	popup_return.item_count = 0
end if

closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_observation_tree_attributes_composite
integer x = 87
integer y = 580
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_observation_tree_attributes_composite
integer width = 2501
integer height = 116
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "parent observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_help_button within w_observation_tree_attributes_composite
integer x = 1902
integer y = 692
integer taborder = 20
boolean bringtotop = true
end type

type st_tag_title from statictext within w_observation_tree_attributes_composite
integer x = 873
integer y = 472
integer width = 695
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
string text = "Observation Tag"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_observation_tag from statictext within w_observation_tree_attributes_composite
integer x = 873
integer y = 556
integer width = 695
integer height = 112
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

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "OBSERVATION_TAG"
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(observation_tag)
else
	observation_tag = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

