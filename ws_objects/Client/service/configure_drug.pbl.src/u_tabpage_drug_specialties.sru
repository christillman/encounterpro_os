$PBExportHeader$u_tabpage_drug_specialties.sru
forward
global type u_tabpage_drug_specialties from u_tabpage_drug_base
end type
type cb_add_specialty from commandbutton within u_tabpage_drug_specialties
end type
type cb_remove_specialty from commandbutton within u_tabpage_drug_specialties
end type
type dw_specialties from u_dw_pick_list within u_tabpage_drug_specialties
end type
end forward

global type u_tabpage_drug_specialties from u_tabpage_drug_base
cb_add_specialty cb_add_specialty
cb_remove_specialty cb_remove_specialty
dw_specialties dw_specialties
end type
global u_tabpage_drug_specialties u_tabpage_drug_specialties

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_specialty ()
public function integer remove_specialty (string ps_specialty_id)
end prototypes

public function integer initialize ();long ll_count

visible = true

dw_specialties.height = height
dw_specialties.width = 1376

dw_specialties.settransobject(sqlca)

return 1

end function

public subroutine refresh ();
dw_specialties.retrieve(drug_tab.drug.drug_id)

cb_remove_specialty.enabled = false


end subroutine

public function integer add_specialty ();str_popup popup
str_popup_return popup_return
string ls_specialty_id
long i
long ll_count

popup.dataobject = "dw_specialty_list"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.multiselect = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return 0


for i = 1 to popup_return.item_count
	ls_specialty_id = popup_return.items[i]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Common_Drug
	WHERE drug_id = :drug_tab.drug.drug_id
	AND specialty_id = :ls_specialty_id;
	if not tf_check() then return -1
	
	if ll_count = 0 then
		INSERT INTO c_Common_Drug (
			drug_id,
			specialty_id )
		VALUES (
			:drug_tab.drug.drug_id,
			:ls_specialty_id);
		if not tf_check() then return -1
	end if
next

refresh()

return 1

end function

public function integer remove_specialty (string ps_specialty_id);

DELETE FROM c_common_drug
WHERE drug_id = :drug_tab.drug.drug_id
AND specialty_id = :ps_specialty_id;
if not tf_check() then return -1


refresh()

return 1

end function

on u_tabpage_drug_specialties.create
int iCurrent
call super::create
this.cb_add_specialty=create cb_add_specialty
this.cb_remove_specialty=create cb_remove_specialty
this.dw_specialties=create dw_specialties
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_specialty
this.Control[iCurrent+2]=this.cb_remove_specialty
this.Control[iCurrent+3]=this.dw_specialties
end on

on u_tabpage_drug_specialties.destroy
call super::destroy
destroy(this.cb_add_specialty)
destroy(this.cb_remove_specialty)
destroy(this.dw_specialties)
end on

type cb_add_specialty from commandbutton within u_tabpage_drug_specialties
integer x = 1705
integer y = 280
integer width = 617
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add specialty"
end type

event clicked;add_specialty()
end event

type cb_remove_specialty from commandbutton within u_tabpage_drug_specialties
integer x = 1705
integer y = 484
integer width = 617
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove specialty"
end type

event clicked;long ll_row
string ls_specialty_id

ll_row = dw_specialties.get_selected_row()
if ll_row <= 0 then return

ls_specialty_id = dw_specialties.object.specialty_id[ll_row]

remove_specialty(ls_specialty_id)

end event

type dw_specialties from u_dw_pick_list within u_tabpage_drug_specialties
integer width = 1376
integer height = 1100
integer taborder = 10
string dataobject = "dw_drug_specialty_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_specialty.enabled = true


end event

event unselected;call super::unselected;cb_remove_specialty.enabled = false


end event

