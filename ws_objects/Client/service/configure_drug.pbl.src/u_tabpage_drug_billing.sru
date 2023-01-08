$PBExportHeader$u_tabpage_drug_billing.sru
forward
global type u_tabpage_drug_billing from u_tabpage_drug_base
end type
type cb_edit_procedure from commandbutton within u_tabpage_drug_billing
end type
type cb_add_hcpcs from commandbutton within u_tabpage_drug_billing
end type
type cb_remove_hcpcs from commandbutton within u_tabpage_drug_billing
end type
type dw_hcpcs from u_dw_pick_list within u_tabpage_drug_billing
end type
type st_procedures_title from statictext within u_tabpage_drug_billing
end type
end forward

global type u_tabpage_drug_billing from u_tabpage_drug_base
cb_edit_procedure cb_edit_procedure
cb_add_hcpcs cb_add_hcpcs
cb_remove_hcpcs cb_remove_hcpcs
dw_hcpcs dw_hcpcs
st_procedures_title st_procedures_title
end type
global u_tabpage_drug_billing u_tabpage_drug_billing

type variables
string admin_procedure_id
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_hcpcs ()
public function integer remove_hcpcs (long pl_hcpcs_sequence)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "compound drug" &
 or lower(drug_tab.drug.drug_type) = "single drug" then
	visible = true
else
	visible = false
	return 1
end if

st_procedures_title.width = 1376
st_procedures_title.height = 96

dw_hcpcs.y = st_procedures_title.height + 4
dw_hcpcs.width = st_procedures_title.width
dw_hcpcs.height = height - dw_hcpcs.y

dw_hcpcs.settransobject(sqlca)

return 1

end function

public subroutine refresh ();

dw_hcpcs.retrieve(drug_tab.drug.drug_id)

cb_remove_hcpcs.enabled = false
cb_edit_procedure.enabled = false


end subroutine

public function integer add_hcpcs ();str_popup popup
str_popup_return popup_return
long ll_row
string ls_administer_unit
real lr_administer_amount
string ls_description
string ls_hcpcs_procedure_id

/* DECLARE lsp_new_drug_hcpcs PROCEDURE FOR dbo.sp_new_drug_hcpcs 
         @ps_drug_id = :drug.drug_id,   
         @pr_administer_amount = :lr_administer_amount,   
         @ps_administer_unit = :ls_administer_unit,   
         @ps_hcpcs_procedure_id = :ls_hcpcs_procedure_id;
*/
popup.title = drug_tab.drug.common_name
popup.data_row_count = 1
popup.items[1] = drug_tab.drug.drug_id
openwithparm(w_drug_hcpcs, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 4 then return 0

lr_administer_amount = real(popup_return.items[1])
ls_administer_unit = popup_return.items[2]
ls_hcpcs_procedure_id = popup_return.items[3]
ls_description = popup_return.items[4]

sqlca.sp_new_drug_hcpcs(drug_tab.drug.drug_id,lr_administer_amount,ls_administer_unit,ls_hcpcs_procedure_id)

//EXECUTE lsp_new_drug_hcpcs;
if not tf_check() then return -1

refresh()

return 1



end function

public function integer remove_hcpcs (long pl_hcpcs_sequence);str_popup popup
str_popup_return popup_return

// DECLARE lsp_delete_drug_hcpcs PROCEDURE FOR dbo.sp_delete_drug_hcpcs
//         @ps_drug_id = :drug_tab.drug.drug_id,   
//         @pl_hcpcs_sequence = :pl_hcpcs_sequence;
//
sqlca.sp_delete_drug_hcpcs(drug_tab.drug.drug_id, pl_hcpcs_sequence);
//EXECUTE lsp_delete_drug_hcpcs;
if not tf_check() then return -1

refresh()

return 1


end function

on u_tabpage_drug_billing.create
int iCurrent
call super::create
this.cb_edit_procedure=create cb_edit_procedure
this.cb_add_hcpcs=create cb_add_hcpcs
this.cb_remove_hcpcs=create cb_remove_hcpcs
this.dw_hcpcs=create dw_hcpcs
this.st_procedures_title=create st_procedures_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_edit_procedure
this.Control[iCurrent+2]=this.cb_add_hcpcs
this.Control[iCurrent+3]=this.cb_remove_hcpcs
this.Control[iCurrent+4]=this.dw_hcpcs
this.Control[iCurrent+5]=this.st_procedures_title
end on

on u_tabpage_drug_billing.destroy
call super::destroy
destroy(this.cb_edit_procedure)
destroy(this.cb_add_hcpcs)
destroy(this.cb_remove_hcpcs)
destroy(this.dw_hcpcs)
destroy(this.st_procedures_title)
end on

type cb_edit_procedure from commandbutton within u_tabpage_drug_billing
integer x = 1705
integer y = 688
integer width = 677
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Edit HCPCS"
end type

event clicked;long ll_row
string ls_procedure_id
string ls_procedure_type
str_popup popup

ll_row = dw_hcpcs.get_selected_row()
if ll_row <= 0 then return

ls_procedure_id = dw_hcpcs.object.procedure_id[ll_row]
ls_procedure_type = dw_hcpcs.object.procedure_type[ll_row]

popup.data_row_count = 2
popup.items[1] = ls_procedure_type
popup.items[2] = ls_procedure_id
openwithparm(w_procedure_definition, popup)

end event

type cb_add_hcpcs from commandbutton within u_tabpage_drug_billing
integer x = 1705
integer y = 280
integer width = 677
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add HCPCS"
end type

event clicked;add_hcpcs()
end event

type cb_remove_hcpcs from commandbutton within u_tabpage_drug_billing
integer x = 1705
integer y = 484
integer width = 677
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove HCPCS"
end type

event clicked;long ll_row
long ll_hcpcs_sequence

ll_row = dw_hcpcs.get_selected_row()
if ll_row <= 0 then return

ll_hcpcs_sequence = dw_hcpcs.object.hcpcs_sequence[ll_row]

remove_hcpcs(ll_hcpcs_sequence)

end event

type dw_hcpcs from u_dw_pick_list within u_tabpage_drug_billing
integer y = 88
integer width = 1376
integer height = 1012
integer taborder = 10
string dataobject = "dw_drug_hcpcs_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_hcpcs.enabled = true
cb_edit_procedure.enabled = true


end event

event unselected;call super::unselected;cb_remove_hcpcs.enabled = false
cb_edit_procedure.enabled = false


end event

type st_procedures_title from statictext within u_tabpage_drug_billing
integer width = 1376
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "HCPCS Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

