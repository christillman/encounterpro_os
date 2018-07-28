$PBExportHeader$u_cpr_family_history.sru
forward
global type u_cpr_family_history from u_cpr_page_base
end type
type dw_history from u_dw_pick_list within u_cpr_family_history
end type
type cb_new_relation from commandbutton within u_cpr_family_history
end type
end forward

global type u_cpr_family_history from u_cpr_page_base
dw_history dw_history
cb_new_relation cb_new_relation
end type
global u_cpr_family_history u_cpr_family_history

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
public subroutine family_menu (long pl_row)
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

cb_new_relation.x = width - cb_new_relation.width - 25
dw_history.width = cb_new_relation.x - 25
dw_history.height = height

if isnull(current_patient.open_encounter) then
	cb_new_relation.visible = false
else
	cb_new_relation.visible = true
end if

dw_history.settransobject(sqlca)

end subroutine

public subroutine refresh ();dw_history.retrieve(current_patient.cpr_id)

end subroutine

public subroutine family_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts
window lw_pop_buttons
string ls_assessment_id
integer li_birth_year
integer li_age_at_death
long ll_family_history_sequence
integer li_age

DECLARE lsp_update_family_history PROCEDURE FOR dbo.sp_update_family_history  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_family_history_sequence = :ll_family_history_sequence,
         @ps_name = :popup_return.items[2],   
         @ps_relation = :popup_return.items[1],   
         @pi_birth_year = :li_birth_year,   
         @pi_age_at_death = :li_age_at_death,   
         @ps_cause_of_death = :popup_return.items[5]  ;

 DECLARE lsp_new_family_illness PROCEDURE FOR dbo.sp_new_family_illness  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :current_patient.open_encounter.encounter_id,   
         @pl_family_history_sequence = :ll_family_history_sequence,   
         @ps_assessment_id = :popup_return.items[1],   
         @pi_age = :li_age  ;

if isnull(current_patient.open_encounter) then return

ls_assessment_id = dw_history.object.assessment_id[pl_row]
ll_family_history_sequence = dw_history.object.family_history_sequence[pl_row]

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Relative"
//	popup.button_titles[popup.button_count] = "Edit Relative"
//	buttons[popup.button_count] = "EDITRELATIVE"
//end if

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Relative"
//	popup.button_titles[popup.button_count] = "Delete Relative"
//	buttons[popup.button_count] = "DELETERELATIVE"
//end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_new22.bmp"
	popup.button_helps[popup.button_count] = "Record an illness for this relative"
	popup.button_titles[popup.button_count] = "New Illness"
	buttons[popup.button_count] = "NEWILLNESS"
end if

//if not isnull(ls_assessment_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Illness"
//	popup.button_titles[popup.button_count] = "Edit Illness"
//	buttons[popup.button_count] = "EDITILLNESS"
//end if

//if not isnull(ls_assessment_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Illness"
//	popup.button_titles[popup.button_count] = "Delete Illness"
//	buttons[popup.button_count] = "DELETEILLNESS"
//end if

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
	CASE "EDITRELATIVE"
		popup.item = string(ll_family_history_sequence)
		openwithparm(w_relative, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 5 then
			li_birth_year = integer(popup_return.items[3])
			li_age_at_death = integer(popup_return.items[4])
			EXECUTE lsp_update_family_history;
			if not tf_check() then return
			refresh()
		end if

	CASE "DELETERELATIVE"
	CASE "NEWILLNESS"
		popup.data_row_count = 1
		popup.items[1] = string(ll_family_history_sequence)
		openwithparm(w_family_illness, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		li_age = integer(popup_return.items[2])
		
		EXECUTE lsp_new_family_illness;
		if not tf_check() then return
		refresh()
	CASE "EDITILLNESS"
	CASE "DELETEILLNESS"
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

on u_cpr_family_history.create
int iCurrent
call super::create
this.dw_history=create dw_history
this.cb_new_relation=create cb_new_relation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
this.Control[iCurrent+2]=this.cb_new_relation
end on

on u_cpr_family_history.destroy
call super::destroy
destroy(this.dw_history)
destroy(this.cb_new_relation)
end on

type dw_history from u_dw_pick_list within u_cpr_family_history
int X=0
int Y=0
int Width=2405
string DataObject="dw_family_history"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event constructor;call super::constructor;active_header = true

end event

event post_click;call super::post_click;family_menu(clicked_row)


end event

type cb_new_relation from commandbutton within u_cpr_family_history
event clicked pbm_bnclicked
int X=2459
int Y=24
int Width=201
int Height=156
int TabOrder=2
string Text="New"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_birth_year, li_age_at_death

 DECLARE lsp_new_family_history PROCEDURE FOR dbo.sp_new_family_history  
         @ps_cpr_id = :current_patient.cpr_id,
			@pl_encounter_id = :current_patient.open_encounter.encounter_id,
         @ps_name = :popup_return.items[2],   
         @ps_relation = :popup_return.items[1],   
         @pi_birth_year = :li_birth_year,   
         @pi_age_at_death = :li_age_at_death,   
         @ps_cause_of_death = :popup_return.items[5]  ;

setnull(popup.item)
openwithparm(w_relative, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 5 then
	li_birth_year = integer(popup_return.items[3])
	li_age_at_death = integer(popup_return.items[4])
	EXECUTE lsp_new_family_history;
	if not tf_check() then return
	refresh()
end if

end event

