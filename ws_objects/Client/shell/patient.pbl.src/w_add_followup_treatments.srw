$PBExportHeader$w_add_followup_treatments.srw
forward
global type w_add_followup_treatments from window
end type
type st_no_items from statictext within w_add_followup_treatments
end type
type cb_done from commandbutton within w_add_followup_treatments
end type
type cb_add from commandbutton within w_add_followup_treatments
end type
type cb_all from commandbutton within w_add_followup_treatments
end type
type dw_therapies from u_dw_pick_list within w_add_followup_treatments
end type
type st_title from statictext within w_add_followup_treatments
end type
end forward

global type w_add_followup_treatments from window
integer x = 393
integer y = 96
integer width = 2025
integer height = 1708
windowtype windowtype = response!
long backcolor = 33538240
st_no_items st_no_items
cb_done cb_done
cb_add cb_add
cb_all cb_all
dw_therapies dw_therapies
st_title st_title
end type
global w_add_followup_treatments w_add_followup_treatments

type variables
string                          list_user_id,assessment_id,treatment_mode

long                           parent_definition_id

u_dw_pick_list          treatments
str_item_definition     istr_treatments[]


end variables

forward prototypes
public subroutine delete_treatment (long pl_row)
public function integer refresh ()
public subroutine composite_item_menu (long pl_row)
end prototypes

public subroutine delete_treatment (long pl_row);long ll_definition_id
long ll_rows
long i


ll_definition_id = dw_therapies.object.definition_id[pl_row]
ll_rows = treatments.filteredcount()

for i = ll_rows to 1 step -1
	if ll_definition_id = treatments.object.definition_id.filter[i] then treatments.object.update_flag.filter[i] = -1
next

refresh()

end subroutine

public function integer refresh ();long ll_rows
long i
long ll_row

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

Return ll_rows

end function

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
	log.log(this, "w_add_followup_treatments.open.0015", "Invalid Parameters", 4)
	close(this)
	return
end if

st_title.text             = popup.title
treatments                = popup.objectparm2
assessment_id             = popup.item
list_user_id              = popup.items[1]
parent_definition_id      = Long(popup.items[2])
treatment_mode				  = popup.items[3]
if (list_user_id = current_user.user_id or current_user.check_privilege("Common Treatment Lists")) then
	cb_add.visible = true
else
	cb_add.visible = false
end if

Refresh()


end event

on w_add_followup_treatments.create
this.st_no_items=create st_no_items
this.cb_done=create cb_done
this.cb_add=create cb_add
this.cb_all=create cb_all
this.dw_therapies=create dw_therapies
this.st_title=create st_title
this.Control[]={this.st_no_items,&
this.cb_done,&
this.cb_add,&
this.cb_all,&
this.dw_therapies,&
this.st_title}
end on

on w_add_followup_treatments.destroy
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

// Make sure that all followup treatments have the same onset and duration as the parent

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

type st_no_items from statictext within w_add_followup_treatments
integer x = 96
integer y = 472
integer width = 1824
integer height = 284
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "There are no items defined for this  treatment."
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_add_followup_treatments
integer x = 1358
integer y = 1552
integer width = 539
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

type cb_add from commandbutton within w_add_followup_treatments
integer x = 722
integer y = 1552
integer width = 539
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
String	ls_child_flag
Integer	li_return,li_tr_count = 1,li_attr_count
Integer  li_max,li_null,li_array_count
Long     ll_row

Setnull(li_null)
// User defined types
u_component_treatment	luo_treatment

treatments.Setredraw(False)
If upper(treatment_mode) = "FOLLOWUP" Then
	ls_child_flag = "F"
ElseIf upper(treatment_mode) = "REFERRAL" Then
	ls_child_flag = "R"
End If
ls_treatment_type = f_get_treatments_list(treatment_mode)
If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		luo_treatment.define_treatment()
		li_array_count = Upperbound(istr_treatments)
		li_max = Upperbound(luo_treatment.treatment_definition)
		If li_max <= 0 Then GOTO destroyobj
		// Loop thru all selected treatments and insert them into datawindow
		Do While li_tr_count <= li_max
			ls_description = luo_treatment.treatment_definition[li_tr_count].item_description
			ls_icon = datalist.treatment_type_icon(ls_treatment_type)

			ll_row = treatments.Insertrow(0)
			treatments.object.user_id[ll_row]                  = list_user_id
			treatments.object.assessment_id[ll_row]			   = assessment_id
			treatments.object.treatment_type[ll_row]				= ls_treatment_type
			treatments.object.treatment_description[ll_row] 	= ls_description
			treatments.object.parent_definition_id[ll_row]     = parent_definition_id
			treatments.object.sort_sequence[ll_row] 				= ll_row 
			treatments.object.selected_flag[ll_row]            = 1
			treatments.object.update_flag[ll_row]              = 2
			treatments.object.icon[ll_row]                     = ls_icon	
			treatments.object.child_flag[ll_row]               = ls_child_flag
			
			li_array_count++
			istr_treatments[li_array_count] = luo_treatment.treatment_definition[li_tr_count]
			li_tr_count++
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

type cb_all from commandbutton within w_add_followup_treatments
integer x = 87
integer y = 1552
integer width = 539
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

event clicked;long i, j
long ll_definition_id
long ll_rows

FOR i = 1 TO dw_therapies.rowcount()
	dw_therapies.object.selected_flag[i] = 1

	ll_definition_id = dw_therapies.object.definition_id[i]
	ll_rows = treatments.filteredcount()
	
	FOR j = 1 TO ll_rows
		IF ll_definition_id = treatments.object.definition_id.filter[j] THEN
			treatments.object.selected_flag.filter[j] = 1
			EXIT
		END IF
	NEXT
NEXT

end event

type dw_therapies from u_dw_pick_list within w_add_followup_treatments
integer x = 41
integer y = 108
integer width = 1934
integer height = 1380
integer taborder = 10
string dataobject = "dw_assessment_treatments"
boolean vscrollbar = true
boolean border = false
end type

on constructor;call u_dw_pick_list::constructor;multiselect = true
end on

event post_click;long ll_definition_id
long ll_rows
long i

if lasttype = 'compute' then
	if not lastselected then set_last()
	composite_item_menu(lastrow)
	if lastselected then clear_last()
	return
end if

ll_definition_id = object.definition_id[clicked_row]
ll_rows = treatments.filteredcount()

for i = 1 to ll_rows
	if ll_definition_id = treatments.object.definition_id.filter[i] then
		if lastselected then
			treatments.object.selected_flag.filter[i] = 1
		else
			treatments.object.selected_flag.filter[i] = 0
		end if
		return
	end if
next
	

end event

type st_title from statictext within w_add_followup_treatments
integer width = 2016
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

