$PBExportHeader$w_pick_composite_treatments.srw
forward
global type w_pick_composite_treatments from window
end type
type cb_none from commandbutton within w_pick_composite_treatments
end type
type pb_down from u_picture_button within w_pick_composite_treatments
end type
type pb_up from u_picture_button within w_pick_composite_treatments
end type
type st_no_items from statictext within w_pick_composite_treatments
end type
type cb_done from commandbutton within w_pick_composite_treatments
end type
type cb_add from commandbutton within w_pick_composite_treatments
end type
type cb_all from commandbutton within w_pick_composite_treatments
end type
type dw_therapies from u_dw_pick_list within w_pick_composite_treatments
end type
type st_title from statictext within w_pick_composite_treatments
end type
end forward

global type w_pick_composite_treatments from window
integer x = 393
integer y = 96
integer width = 2222
integer height = 1708
windowtype windowtype = response!
long backcolor = 33538240
cb_none cb_none
pb_down pb_down
pb_up pb_up
st_no_items st_no_items
cb_done cb_done
cb_add cb_add
cb_all cb_all
dw_therapies dw_therapies
st_title st_title
end type
global w_pick_composite_treatments w_pick_composite_treatments

type variables
string                          list_user_id

str_assessment_description assessment

long                           parent_definition_id

u_dw_pick_list          treatments
str_item_definition     istr_treatments[]

u_ds_data efficacy
u_ds_data formulary

string composite_treatment_list_id
end variables

forward prototypes
public function integer refresh ()
public subroutine delete_treatment (long pl_row)
public subroutine composite_item_menu (long pl_row)
public subroutine set_treatment_selected (long pl_row, boolean pb_selected)
end prototypes

public function integer refresh ();long ll_rows
long i
long ll_row
string ls_temp

dw_therapies.Setredraw(False)

dw_therapies.Reset()

ll_rows = treatments.filteredcount()

For i = 1 To ll_rows
	If treatments.object.parent_definition_id.filter[i] = parent_definition_id &
	 And treatments.object.update_flag.filter[i] >= 0 Then
		ll_row = dw_therapies.insertrow(0)
		dw_therapies.object.data.primary[ll_row] = treatments.object.data.filter[i]
	End if
Next

if dw_therapies.rowcount() = 0 then
	st_no_items.visible = true
	dw_therapies.visible = false
	cb_all.enabled = false
else
	st_no_items.visible = false
	dw_therapies.visible = true
	cb_all.enabled = true
end if

dw_therapies.Sort()

dw_therapies.Setredraw(true)

dw_therapies.last_page = 0
dw_therapies.set_page(1, ls_temp)
if dw_therapies.last_page < 2 then
	pb_up.visible = false
	pb_down.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

Return ll_rows

end function

public subroutine delete_treatment (long pl_row);Long 		ll_definition_id,ll_rows,i
String 	ls_treatment_type,ls_treatment_desc

ll_definition_id = dw_therapies.object.definition_id[pl_row]
ll_rows = treatments.filteredcount()

If Isnull(ll_definition_id) OR ll_definition_id > 0 Then // new treatments
	ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
	ls_treatment_desc = dw_therapies.object.treatment_description[pl_row]
	For i = ll_rows to 1 Step -1
		
		If (parent_definition_id = treatments.object.parent_definition_id.filter[i]) AND &
			(ls_treatment_type = treatments.object.treatment_type.filter[i]) AND &
			(ls_treatment_desc = treatments.object.treatment_description.filter[i]) Then &
			treatments.object.update_flag.filter[i] = -1
	Next
Else
	For i = ll_rows to 1 Step -1
		If ll_definition_id = treatments.object.definition_id.filter[i] Then &
			treatments.object.update_flag.filter[i] = -1
	Next
End If
dw_therapies.deleterow(pl_row)

refresh()

end subroutine

public subroutine composite_item_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag


if ls_user_id = current_user.user_id or current_user.check_privilege("Common Treatment Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Item"
	popup.button_titles[popup.button_count] = "Delete Item"
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
	CASE "DELETE"
		this.function POST delete_treatment(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine set_treatment_selected (long pl_row, boolean pb_selected);long ll_definition_id
long ll_rows
long i
string ls_treatment_type
string ls_treatment_description
integer li_selected_flag

if pb_selected then
	li_selected_flag = 1
else
	li_selected_flag = 0
end if

ll_definition_id = dw_therapies.object.definition_id[pl_row]
ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_treatment_description = dw_therapies.object.treatment_description[pl_row]

ll_rows = treatments.filteredcount()

for i = 1 to ll_rows
	if isnull(ll_definition_id) then
		if ls_treatment_type = treatments.object.treatment_type.filter[i] &
		 and ls_treatment_description = treatments.object.treatment_description.filter[i] then
			treatments.object.selected_flag.filter[i] = li_selected_flag
		end if
	else
		if ll_definition_id = treatments.object.definition_id.filter[i] then
			treatments.object.selected_flag.filter[i] = li_selected_flag
		end if
	end if
next
	

end subroutine

event open;str_popup popup
string ls_null
string ls_in_office_flag
boolean lb_in_office
long i
long ll_rows
long ll_row
string ls_temp

setnull(ls_null)

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "w_pick_composite_treatments:open", "Invalid Parameters", 4)
	close(this)
	return
end if

st_title.text             = popup.title
assessment                = popup.objectparm
treatments                = popup.objectparm1
efficacy                  = popup.objectparm2
formulary                 = popup.objectparm3
list_user_id              = popup.items[1]
parent_definition_id      = Long(popup.items[2])
composite_treatment_list_id = popup.items[3]

if (list_user_id = current_user.user_id or current_user.check_privilege("Common Treatment Lists")) then
	cb_add.visible = true
else
	cb_add.visible = false
end if

Refresh()


end event

on w_pick_composite_treatments.create
this.cb_none=create cb_none
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_no_items=create st_no_items
this.cb_done=create cb_done
this.cb_add=create cb_add
this.cb_all=create cb_all
this.dw_therapies=create dw_therapies
this.st_title=create st_title
this.Control[]={this.cb_none,&
this.pb_down,&
this.pb_up,&
this.st_no_items,&
this.cb_done,&
this.cb_add,&
this.cb_all,&
this.dw_therapies,&
this.st_title}
end on

on w_pick_composite_treatments.destroy
destroy(this.cb_none)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_no_items)
destroy(this.cb_done)
destroy(this.cb_add)
destroy(this.cb_all)
destroy(this.dw_therapies)
destroy(this.st_title)
end on

event close;long i
long ll_rows
datetime ldt_composite_onset
datetime ldt_composite_duration

// Make sure that all composite treatments have the same onset and duration as the parent

// First, get the onset and duration of the parent
ll_rows = treatments.rowcount()
for i = 1 to ll_rows
	if parent_definition_id = treatments.object.definition_id[i] then
		ldt_composite_onset = treatments.object.onset[i]
		ldt_composite_duration = treatments.object.duration[i]
		exit
	end if
next

// Then set all the children to the same values

ll_rows = treatments.filteredcount()

for i = 1 to ll_rows
	if parent_definition_id = treatments.object.parent_definition_id.filter[i] then
		treatments.object.onset.filter[i] = ldt_composite_onset
		treatments.object.duration.filter[i] = ldt_composite_duration
	end if
next

end event

type cb_none from commandbutton within w_pick_composite_treatments
integer x = 480
integer y = 1552
integer width = 389
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select None"
end type

event clicked;long i

for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.selected_flag[i] = 0

	set_treatment_selected(i, false)
next

end event

type pb_down from u_picture_button within w_pick_composite_treatments
integer x = 2021
integer y = 240
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_therapies.current_page
li_last_page = dw_therapies.last_page

dw_therapies.set_page(li_page + 1, ls_temp)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_pick_composite_treatments
integer x = 2021
integer y = 112
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_therapies.current_page

dw_therapies.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_no_items from statictext within w_pick_composite_treatments
integer x = 187
integer y = 472
integer width = 1627
integer height = 272
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "There are no items defined for this composite treatment."
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_pick_composite_treatments
integer x = 1637
integer y = 1552
integer width = 498
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
boolean default = true
end type

event clicked;Long					ll_row
String				ls_find
str_popup         popuprtn

// If there are no constituent items selected, then de-select the composite treatment
ll_row = dw_therapies.get_selected_row()
If ll_row <= 0 Then
	ls_find = "definition_id =" + String(parent_definition_id)
	ll_row = treatments.find(ls_find, 1, treatments.rowcount())
	If ll_row > 0 Then treatments.object.selected_flag[ll_row] = 0
End If	
popuprtn.anyparm = istr_treatments
Closewithreturn(parent,popuprtn)

end event

type cb_add from commandbutton within w_pick_composite_treatments
integer x = 1111
integer y = 1552
integer width = 498
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment"
end type

event clicked;////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Load selected treatments from different treatment types into datawindow.
//
//
// Created By:Sumathi Chinnasamy													Created On: 03/10/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_type,ls_icon,ls_description
Integer	li_return,li_tr_count = 1,li_attr_count
Integer  li_max,li_null,li_array_count
Long     ll_row,ll_find
integer 	li_sort_sequence
string 	ls_treatment_key,ls_find
integer 	li_rating

Setnull(li_null)
// User defined types
u_component_treatment	luo_treatment

treatments.Setredraw(False)
ls_treatment_type = f_get_treatments_list(composite_treatment_list_id)
If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		luo_treatment.define_treatment(assessment)
		li_array_count = Upperbound(istr_treatments)
		li_max = Upperbound(luo_treatment.treatment_definition)
		If li_max <= 0 Then GOTO destroyobj
		// Loop thru all selected treatments and insert them into datawindow
		Do While li_tr_count <= li_max
			ls_description = luo_treatment.treatment_definition[li_tr_count].item_description
			if len(ls_description) > 255 then
				openwithparm(w_pop_message, "The description for an item in a treatment list cannot exceed 255 characters.  The description has been truncated.")
				ls_description = left(ls_description, 255)
			end if
			
			ls_icon = datalist.treatment_type_icon(ls_treatment_type)

			ll_row = treatments.Insertrow(0)
			if ll_row <= 1 then
				setnull(li_sort_sequence)
			else
				li_sort_sequence = treatments.object.sort_sequence[ll_row - 1]
				if not isnull(li_sort_sequence) then li_sort_sequence += 1
			end if

			treatments.object.user_id[ll_row]                  = list_user_id
			treatments.object.assessment_id[ll_row]			   = assessment.assessment_id
			treatments.object.treatment_type[ll_row]				= ls_treatment_type
			treatments.object.treatment_description[ll_row] 	= ls_description
			treatments.object.parent_definition_id[ll_row]     = parent_definition_id
			treatments.object.sort_sequence[ll_row] 				= li_sort_sequence 
			treatments.object.selected_flag[ll_row]            = 1
			treatments.object.update_flag[ll_row]              = 2 // By default save this treatments
			treatments.object.icon[ll_row]                     = ls_icon	
			treatments.object.type_sort_sequence[ll_row]			= datalist.treatment_type_sort_sequence(ls_treatment_type)
			
			li_array_count++
			istr_treatments[li_array_count] = luo_treatment.treatment_definition[li_tr_count]
			li_tr_count++
			
			ls_treatment_key = f_get_treatment_key(ls_treatment_type, &
																	  istr_treatments[li_array_count].attribute_count, &
																	  istr_treatments[li_array_count].attribute, &
																	  istr_treatments[li_array_count].value)
			
			treatments.object.treatment_key[ll_row] = ls_treatment_key
			
			if not isnull(ls_treatment_key) then
				ls_find = "treatment_type='" + ls_treatment_type + "'"
				ls_find += " and treatment_key='" + ls_treatment_key + "'"
				ll_find = efficacy.find(ls_find, 1, efficacy.rowcount())
				if ll_find > 0 then
					treatments.object.rating[ll_row] = efficacy.object.rating[ll_find]
				end if
				
				ll_find = formulary.find(ls_find, 1, formulary.rowcount())
				if ll_find > 0 then
					treatments.object.formulary_icon[ll_row] = formulary.object.icon[ll_find]
				end if
			end if
	
		Loop
	End If
End If
treatments.filter()
Refresh()
treatments.Setredraw(True)
destroyobj:
// Destroy the component
component_manager.destroy_component(luo_treatment)

Return
end event

type cb_all from commandbutton within w_pick_composite_treatments
integer x = 64
integer y = 1552
integer width = 389
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long i

for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.selected_flag[i] = 1

	set_treatment_selected(i, true)
next

end event

type dw_therapies from u_dw_pick_list within w_pick_composite_treatments
integer x = 41
integer y = 108
integer width = 1970
integer height = 1380
integer taborder = 10
string dataobject = "dw_assessment_treatments"
boolean vscrollbar = true
boolean border = false
end type

on constructor;call u_dw_pick_list::constructor;multiselect = true
end on

event post_click;call super::post_click;long ll_definition_id
long ll_rows
long i
string ls_treatment_type
string ls_treatment_description

if lasttype = 'compute' then
	if not lastselected then set_last()
	composite_item_menu(lastrow)
	if lastselected then clear_last()
	return
end if

set_treatment_selected(clicked_row, lastselected)

end event

type st_title from statictext within w_pick_composite_treatments
integer width = 2217
integer height = 84
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

