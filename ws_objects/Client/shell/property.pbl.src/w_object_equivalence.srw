$PBExportHeader$w_object_equivalence.srw
forward
global type w_object_equivalence from w_window_base
end type
type cb_finished from commandbutton within w_object_equivalence
end type
type st_1 from statictext within w_object_equivalence
end type
type st_3 from statictext within w_object_equivalence
end type
type st_4 from statictext within w_object_equivalence
end type
type st_description from statictext within w_object_equivalence
end type
type st_object_type from statictext within w_object_equivalence
end type
type cb_add_more from commandbutton within w_object_equivalence
end type
type cb_delete from commandbutton within w_object_equivalence
end type
type st_2 from statictext within w_object_equivalence
end type
type dw_equivalence from u_dw_pick_list within w_object_equivalence
end type
type pb_up from u_picture_button within w_object_equivalence
end type
type pb_down from u_picture_button within w_object_equivalence
end type
type st_page from statictext within w_object_equivalence
end type
end forward

global type w_object_equivalence from w_window_base
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_1 st_1
st_3 st_3
st_4 st_4
st_description st_description
st_object_type st_object_type
cb_add_more cb_add_more
cb_delete cb_delete
st_2 st_2
dw_equivalence dw_equivalence
pb_up pb_up
pb_down pb_down
st_page st_page
end type
global w_object_equivalence w_object_equivalence

type variables
long equivalence_group_id



end variables

forward prototypes
public function integer add_more_observation ()
public function integer refresh ()
public function integer add_more_result ()
public function integer add_more ()
end prototypes

public function integer add_more_observation ();str_popup popup
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_observations lw_pick
string ls_object_id

setnull(ls_object_id)

popup.data_row_count = 2
popup.title = "Select Equivalence Observations for '" + st_description.text + "'"
popup.multiselect = true
setnull(popup.items[1])
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count < 1 then return 0

for i = 1 to lstr_observations.observation_count
	ls_observation_id = lstr_observations.observation_id[i]
	sqlca.jmj_new_equivalence_item(equivalence_group_id, ls_object_id, ls_observation_id, current_scribe.user_id)
	if not tf_check() then return -1
next

return 1



end function

public function integer refresh ();integer li_sts

li_sts = dw_equivalence.retrieve(equivalence_group_id)
dw_equivalence.set_page(1, pb_up, pb_down, st_page)

return li_sts


end function

public function integer add_more_result ();str_popup popup
str_popup_return popup_return
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_observations lw_pick
string ls_object_id
integer li_result_sequence
string ls_object_key

setnull(ls_object_id)

popup.data_row_count = 2
popup.title = "Select Equivalence Observations for '" + st_description.text + "'"
popup.multiselect = false
setnull(popup.items[1])
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count < 1 then return 0
ls_observation_id = lstr_observations.observation_id[1]


popup.data_row_count = 0
popup.title = "Select Equivalence Result for '" + st_description.text + "'"
popup.dataobject = "dw_result_by_type_list"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = ls_observation_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return -1
li_result_sequence = integer(popup_return.items[1])

SELECT id
INTO :ls_object_id
FROM c_Observation_Result
WHERE observation_id = :ls_observation_id
AND result_sequence = :li_result_sequence;
if not tf_check() then return -1

ls_object_key = ls_observation_id + "|" + string(li_result_sequence)

sqlca.jmj_new_equivalence_item(equivalence_group_id, ls_object_id, ls_object_key, current_scribe.user_id)
if not tf_check() then return -1

return 1



end function

public function integer add_more ();str_content_object lstr_content_object

lstr_content_object = f_pick_content_object(st_object_type.text, "Select Equivalence " + wordcap(st_object_type.text) + "s for '" + st_description.text + "'")
if isnull(lstr_content_object.object_key) then return 0

sqlca.jmj_new_equivalence_item(equivalence_group_id, lstr_content_object.object_id, lstr_content_object.object_key, current_scribe.user_id)
if not tf_check() then return -1

return 1



end function

on w_object_equivalence.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_1=create st_1
this.st_3=create st_3
this.st_4=create st_4
this.st_description=create st_description
this.st_object_type=create st_object_type
this.cb_add_more=create cb_add_more
this.cb_delete=create cb_delete
this.st_2=create st_2
this.dw_equivalence=create dw_equivalence
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_description
this.Control[iCurrent+6]=this.st_object_type
this.Control[iCurrent+7]=this.cb_add_more
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.dw_equivalence
this.Control[iCurrent+11]=this.pb_up
this.Control[iCurrent+12]=this.pb_down
this.Control[iCurrent+13]=this.st_page
end on

on w_object_equivalence.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_description)
destroy(this.st_object_type)
destroy(this.cb_add_more)
destroy(this.cb_delete)
destroy(this.st_2)
destroy(this.dw_equivalence)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
end on

event open;call super::open;string ls_equivalence_group_id
str_content_object lstr_item

lstr_item = message.powerobjectparm

equivalence_group_id = sqlca.sp_get_equivalence_group(lstr_item.object_id, &
																			lstr_item.object_type, &
																			lstr_item.description, &
																			current_scribe.user_id)
if not tf_check() then
	close(this)
	return
end if

SELECT object_type,
		description
INTO :st_object_type.text,
		:st_description.text
FROM c_Equivalence_Group
WHERE equivalence_group_id = :equivalence_group_id;
if not tf_check() then
	close(this)
	return
end if

dw_equivalence.settransobject(sqlca)

postevent("post_open")


end event

event post_open;call super::post_open;
refresh()




end event

type pb_epro_help from w_window_base`pb_epro_help within w_object_equivalence
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_object_equivalence
end type

type cb_finished from commandbutton within w_object_equivalence
integer x = 2459
integer y = 1616
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type st_1 from statictext within w_object_equivalence
integer width = 2921
integer height = 124
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Equivalency Group"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_object_equivalence
integer x = 137
integer y = 252
integer width = 389
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Group Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_object_equivalence
integer x = 128
integer y = 148
integer width = 398
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Group Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_object_equivalence
integer x = 544
integer y = 144
integer width = 2258
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_object_type from statictext within w_object_equivalence
integer x = 544
integer y = 248
integer width = 864
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Observation"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_add_more from commandbutton within w_object_equivalence
integer x = 1189
integer y = 1616
integer width = 517
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add More"
end type

event clicked;integer li_sts

add_more()

//CHOOSE CASE lower(st_object_type.text)
//	CASE "assessment"
//	CASE "drug"
//	CASE "material"
//	CASE "procedure"
//	CASE "observation"
//		li_sts = add_more_observation()
//	CASE "result"
//		li_sts = add_more_result()
//END CHOOSE

refresh()



end event

type cb_delete from commandbutton within w_object_equivalence
integer x = 2482
integer y = 900
integer width = 302
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;string ls_object_id
string ls_observation_key
long ll_row

ll_row = dw_equivalence.get_selected_row()
if ll_row <= 0 then return

ls_object_id = dw_equivalence.object.object_id[ll_row]
ls_observation_key = dw_equivalence.object.object_key[ll_row]

sqlca.jmj_delete_equivalence_item(equivalence_group_id, ls_object_id, ls_observation_key, current_scribe.user_id)
if not tf_check() then return

refresh()

end event

type st_2 from statictext within w_object_equivalence
integer x = 183
integer y = 388
integer width = 2528
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "The following items are considered equivalent for reporting purposes"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_equivalence from u_dw_pick_list within w_object_equivalence
integer x = 622
integer y = 500
integer width = 1714
integer height = 1076
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_get_equivalence_group_items"
boolean vscrollbar = true
boolean border = false
end type

type pb_up from u_picture_button within w_object_equivalence
integer x = 2350
integer y = 508
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_equivalence.current_page

dw_equivalence.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_object_equivalence
integer x = 2350
integer y = 632
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_equivalence.current_page
li_last_page = dw_equivalence.last_page

dw_equivalence.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_object_equivalence
integer x = 2354
integer y = 752
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

