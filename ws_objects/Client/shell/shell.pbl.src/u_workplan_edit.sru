$PBExportHeader$u_workplan_edit.sru
forward
global type u_workplan_edit from userobject
end type
type pb_down from u_picture_button within u_workplan_edit
end type
type pb_up from u_picture_button within u_workplan_edit
end type
type st_page from statictext within u_workplan_edit
end type
type st_treatment_type_title from statictext within u_workplan_edit
end type
type st_treatment_type from statictext within u_workplan_edit
end type
type st_1 from statictext within u_workplan_edit
end type
type dw_workplans from u_dw_pick_list within u_workplan_edit
end type
type st_type from statictext within u_workplan_edit
end type
type pb_new_observation from u_picture_button within u_workplan_edit
end type
type st_title from statictext within u_workplan_edit
end type
type st_in_office_flag from statictext within u_workplan_edit
end type
type st_title_type from statictext within u_workplan_edit
end type
end forward

global type u_workplan_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
pb_down pb_down
pb_up pb_up
st_page st_page
st_treatment_type_title st_treatment_type_title
st_treatment_type st_treatment_type
st_1 st_1
dw_workplans dw_workplans
st_type st_type
pb_new_observation pb_new_observation
st_title st_title
st_in_office_flag st_in_office_flag
st_title_type st_title_type
end type
global u_workplan_edit u_workplan_edit

type variables
string workplan_type
string treatment_type
string in_office_flag



end variables

forward prototypes
public function integer initialize ()
public function integer show_workplans ()
public subroutine workplan_menu (long pl_row)
end prototypes

public function integer initialize ();
dw_workplans.settransobject(sqlca)

workplan_type = 'Patient'
st_type.text = workplan_type

st_treatment_type_title.visible = false
st_treatment_type.visible = false
setnull(treatment_type)

in_office_flag = "Y"
st_in_office_flag.text = "In Office"

show_workplans()

return 1

end function

public function integer show_workplans ();string ls_filter

if isnull(treatment_type) then
	dw_workplans.setfilter("")
else
	ls_filter = "treatment_type='" + treatment_type + "'"
	dw_workplans.setfilter(ls_filter)
end if

dw_workplans.retrieve(workplan_type, in_office_flag)
dw_workplans.last_page = 0
dw_workplans.set_page(1, st_page.text)
If dw_workplans.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
Else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
End if

Return 1
end function

public subroutine workplan_menu (long pl_row);Integer	button_pressed, li_sts, li_service_count
Integer	li_update_flag
Long		ll_workplan_id
String	ls_user_id,ls_temp,ls_referenced_table
String	buttons[]

str_popup popup
str_popup_return popup_return
window lw_pop_buttons

//CWW, BEGIN
u_ds_data luo_sp_delete_workplan
integer li_spdw_count
//DECLARE lsp_delete_workplan PROCEDURE FOR dbo.sp_delete_workplan  
// 			@pl_workplan_id = :ll_workplan_id,
//				@ps_referenced_table = :ls_referenced_table OUT;
//CWW, END
			

ll_workplan_id = dw_workplans.object.Workplan_id[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Workplan"
	popup.button_titles[popup.button_count] = "Delete Workplan"
	buttons[popup.button_count] = "DELETE"
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
	CASE "EDIT"
		popup.items[1] = string(ll_workplan_id)
		popup.data_row_count = 1
		openwithparm(w_Workplan_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_Workplans.setitem(pl_row, "description", popup_return.descriptions[1])
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the workplan '" + dw_workplans.object.description[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
//			sqlca.deleteworkplan(ll_workplan_id,ls_referenced_table)

			//CWW, BEGIN
//			EXECUTE lsp_delete_workplan;
//			if not tf_check() then return
//			FETCH lsp_delete_workplan INTO :ls_referenced_table;
//			if not tf_check() then return
//			CLOSE lsp_delete_workplan;
			luo_sp_delete_workplan = CREATE u_ds_data
			luo_sp_delete_workplan.set_dataobject("dw_sp_delete_workplan")
			li_spdw_count = luo_sp_delete_workplan.retrieve(ll_workplan_id)
			if li_spdw_count <= 0 then
				setnull(ls_referenced_table)
			else
				ls_referenced_table = luo_sp_delete_workplan.object.referenced_table[1]
			end if
			destroy luo_sp_delete_workplan
			//CWW, END
			
			If isnull(ls_referenced_table) Then // delete success
				dw_workplans.deleterow(pl_row)
			Else // this is referenced in other tables..
				messagebox("Referenced","Deletion Failed:This workplan is referenced in "+ls_referenced_table+" table")
				log.log(this,"workplan_menu()","workplan id "+string(ll_workplan_id)+" is referenced in "+ls_referenced_table,3)
			End If
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

on u_workplan_edit.create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_type=create st_treatment_type
this.st_1=create st_1
this.dw_workplans=create dw_workplans
this.st_type=create st_type
this.pb_new_observation=create pb_new_observation
this.st_title=create st_title
this.st_in_office_flag=create st_in_office_flag
this.st_title_type=create st_title_type
this.Control[]={this.pb_down,&
this.pb_up,&
this.st_page,&
this.st_treatment_type_title,&
this.st_treatment_type,&
this.st_1,&
this.dw_workplans,&
this.st_type,&
this.pb_new_observation,&
this.st_title,&
this.st_in_office_flag,&
this.st_title_type}
end on

on u_workplan_edit.destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_type)
destroy(this.st_1)
destroy(this.dw_workplans)
destroy(this.st_type)
destroy(this.pb_new_observation)
destroy(this.st_title)
destroy(this.st_in_office_flag)
destroy(this.st_title_type)
end on

event constructor;dw_workplans.height = height - 20



end event

type pb_down from u_picture_button within u_workplan_edit
integer x = 1353
integer y = 244
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_workplans.current_page
li_last_page = dw_workplans.last_page

dw_workplans.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type pb_up from u_picture_button within u_workplan_edit
integer x = 1527
integer y = 244
integer width = 137
integer height = 116
integer taborder = 20
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_workplans.current_page

dw_workplans.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_workplan_edit
integer x = 1381
integer y = 152
integer width = 352
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type_title from statictext within u_workplan_edit
integer x = 1586
integer y = 956
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within u_workplan_edit
integer x = 1472
integer y = 1032
integer width = 754
integer height = 168
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button
string ls_filter
string ls_in_office_flag

if in_office_flag = "Y" then
	ls_in_office_flag = "%"
else
	ls_in_office_flag = "N"
end if

popup.dataobject = "dw_workplan_treatment_type_list"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.add_blank_row = true
popup.blank_text = "<All Treatment Types>"
popup.argument_count = 1
popup.argument[1] = ls_in_office_flag
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(treatment_type)
else
	treatment_type = popup_return.items[1]
end if

show_workplans()




end event

type st_1 from statictext within u_workplan_edit
integer x = 1710
integer y = 1484
integer width = 274
integer height = 124
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_workplans from u_dw_pick_list within u_workplan_edit
integer x = 9
integer y = 8
integer width = 1317
integer height = 1696
integer taborder = 10
string dataobject = "dw_workplan_list"
boolean border = false
end type

event selected;call super::selected;workplan_menu(selected_row)
clear_selected()

end event

type st_type from statictext within u_workplan_edit
event clicked pbm_bnclicked
integer x = 1472
integer y = 732
integer width = 754
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
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
popup.argument[1] = "WORKPLAN_TYPE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

workplan_type = popup_return.items[1]
text = popup_return.items[1]

setnull(treatment_type)

show_workplans()

if workplan_type = "Treatment" then
	st_treatment_type.visible = true
	st_treatment_type_title.visible = true
	st_treatment_type.text = "<All Treatment Types>"
else
	st_treatment_type.visible = false
	st_treatment_type_title.visible = false
end if


end event

type pb_new_observation from u_picture_button within u_workplan_edit
event clicked pbm_bnclicked
integer x = 1719
integer y = 1264
integer taborder = 40
boolean default = true
string picturename = "b_new02.bmp"
string disabledname = "b_push02.bmp"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_selected_flag
long ll_row
long ll_workplan_id
string ls_description
string ls_treatment_type

 DECLARE lsp_new_workplan PROCEDURE FOR dbo.sp_new_workplan  
         @ps_workplan_type = :workplan_type,   
			@ps_treatment_type = :ls_treatment_type,
			@ps_in_office_flag = :in_office_flag,
         @ps_description = :ls_description,   
         @pl_workplan_id = :ll_workplan_id OUT ;

if isnull(treatment_type) and workplan_type = 'Treatment' then
	popup.dataobject = "dw_treatment_type_edit_list"
	popup.datacolumn = 2
	popup.displaycolumn = 4
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_treatment_type = popup_return.items[1]
else
	ls_treatment_type = treatment_type
end if

popup.title = "Enter new workplan description"

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]

EXECUTE lsp_new_workplan;
if not tf_check() then return

FETCH lsp_new_workplan INTO :ll_workplan_id;
if not tf_check() then return

CLOSE lsp_new_workplan;


popup.data_row_count = 1
popup.items[1] = string(ll_workplan_id)

openwithparm(w_workplan_definition, popup)
popup_return = message.powerobjectparm

show_workplans()



end event

type st_title from statictext within u_workplan_edit
integer x = 1330
integer y = 4
integer width = 1083
integer height = 128
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within u_workplan_edit
integer x = 1545
integer y = 412
integer width = 608
integer height = 104
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Out Of Office"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if in_office_flag = "Y" then
	in_office_flag = "N"
	text = "Out Of Office"
else
	in_office_flag = "Y"
	text = "In Office"
end if

show_workplans()

end event

type st_title_type from statictext within u_workplan_edit
integer x = 1586
integer y = 656
integer width = 521
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Type"
alignment alignment = center!
boolean focusrectangle = false
end type

