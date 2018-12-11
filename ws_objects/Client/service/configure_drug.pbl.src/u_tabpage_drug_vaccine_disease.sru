$PBExportHeader$u_tabpage_drug_vaccine_disease.sru
forward
global type u_tabpage_drug_vaccine_disease from u_tabpage_drug_base
end type
type cb_add_disease from commandbutton within u_tabpage_drug_vaccine_disease
end type
type cb_remove_disease from commandbutton within u_tabpage_drug_vaccine_disease
end type
type dw_diseases from u_dw_pick_list within u_tabpage_drug_vaccine_disease
end type
end forward

global type u_tabpage_drug_vaccine_disease from u_tabpage_drug_base
cb_add_disease cb_add_disease
cb_remove_disease cb_remove_disease
dw_diseases dw_diseases
end type
global u_tabpage_drug_vaccine_disease u_tabpage_drug_vaccine_disease

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_disease ()
public function integer remove_disease (long pl_disease_id)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "vaccine" then
	visible = true
else
	visible = false
	return 1
end if

dw_diseases.height = height
dw_diseases.width = 1376

dw_diseases.settransobject(sqlca)

return 1

end function

public subroutine refresh ();
dw_diseases.retrieve(drug_tab.drug.drug_id)

cb_remove_disease.enabled = false


end subroutine

public function integer add_disease ();str_popup popup
str_popup_return popup_return
long ll_disease_id
long ll_count
long i

popup.dataobject = "dw_diseases_to_attach"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = drug_tab.drug.drug_id
popup.add_blank_row = true
popup.blank_text = "<New Disease>"
popup.multiselect = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return 0

for i = 1 to popup_return.item_count
	if popup_return.items[i] = "" then
		ll_disease_id = f_new_disease()
		if ll_disease_id <= 0 then return 0
	else
		ll_disease_id = long(popup_return.items[i])
	end if
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Vaccine_Disease
	WHERE vaccine_id = :drug_tab.drug.drug_id
	AND disease_id = :ll_disease_id;
	if not tf_check() then return -1
	
	if ll_count = 0 then
		INSERT INTO c_Vaccine_Disease (
			vaccine_id,
			disease_id,
			units )
		VALUES (
			:drug_tab.drug.drug_id,
			:ll_disease_id,
			1);
		if not tf_check() then return -1
	end if
next

refresh()

return 1

end function

public function integer remove_disease (long pl_disease_id);

DELETE FROM c_Vaccine_Disease
WHERE vaccine_id = :drug_tab.drug.drug_id
AND disease_id = :pl_disease_id;
if not tf_check() then return -1


refresh()

return 1

end function

on u_tabpage_drug_vaccine_disease.create
int iCurrent
call super::create
this.cb_add_disease=create cb_add_disease
this.cb_remove_disease=create cb_remove_disease
this.dw_diseases=create dw_diseases
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_disease
this.Control[iCurrent+2]=this.cb_remove_disease
this.Control[iCurrent+3]=this.dw_diseases
end on

on u_tabpage_drug_vaccine_disease.destroy
call super::destroy
destroy(this.cb_add_disease)
destroy(this.cb_remove_disease)
destroy(this.dw_diseases)
end on

type cb_add_disease from commandbutton within u_tabpage_drug_vaccine_disease
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
string text = "Add Disease"
end type

event clicked;add_disease()
end event

type cb_remove_disease from commandbutton within u_tabpage_drug_vaccine_disease
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
string text = "Remove Disease"
end type

event clicked;long ll_row
long ll_disease_id

ll_row = dw_diseases.get_selected_row()
if ll_row <= 0 then return

ll_disease_id = dw_diseases.object.disease_id[ll_row]

remove_disease(ll_disease_id)

end event

type dw_diseases from u_dw_pick_list within u_tabpage_drug_vaccine_disease
integer width = 1376
integer height = 1100
integer taborder = 10
string dataobject = "dw_drug_disease_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_disease.enabled = true


end event

event unselected;call super::unselected;cb_remove_disease.enabled = false


end event

