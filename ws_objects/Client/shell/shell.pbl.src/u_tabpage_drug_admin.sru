$PBExportHeader$u_tabpage_drug_admin.sru
forward
global type u_tabpage_drug_admin from u_tabpage_drug_base
end type
type cb_add_administration from commandbutton within u_tabpage_drug_admin
end type
type cb_remove_administration from commandbutton within u_tabpage_drug_admin
end type
type dw_administration from u_dw_pick_list within u_tabpage_drug_admin
end type
end forward

global type u_tabpage_drug_admin from u_tabpage_drug_base
cb_add_administration cb_add_administration
cb_remove_administration cb_remove_administration
dw_administration dw_administration
end type
global u_tabpage_drug_admin u_tabpage_drug_admin

type variables
integer drug_admin_count
str_drug_administration drug_admin[]

end variables

forward prototypes
public function integer add_admin ()
public subroutine refresh ()
public function integer initialize ()
public function integer remove_admin (long pl_administration_sequence)
end prototypes

public function integer add_admin ();str_popup popup
str_popup_return popup_return
long ll_row, ll_count
string ls_find
integer li_temp
string ls_attribute_description
string ls_administer_frequency
string ls_administer_unit
real lr_administer_amount
string ls_mult_by_what
string ls_calc_per
string ls_description
integer li_administration_sequence

popup.title = drug_tab.drug.common_name
popup.data_row_count = 1
popup.items[1] = drug_tab.drug.drug_id
openwithparm(w_drug_administration, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

refresh()


return 1

end function

public subroutine refresh ();integer i
long ll_row

drug_admin_count = f_get_drug_administration(drug_tab.drug.drug_id, drug_admin)

dw_administration.setredraw(false)

dw_administration.reset()

for i = 1 to drug_admin_count
	ll_row = dw_administration.insertrow(0)
	dw_administration.object.administration_sequence[ll_row] = drug_admin[i].administration_sequence
	dw_administration.object.description[ll_row] = drug_admin[i].description
next

dw_administration.setredraw(true)

cb_remove_administration.enabled = false

end subroutine

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "single drug" &
  or lower(drug_tab.drug.drug_type) = "compound drug" &
  or lower(drug_tab.drug.drug_type) = "cocktail" then
	visible = true
else
	visible = false
	return 1
end if

dw_administration.height = height
dw_administration.width = 1376

dw_administration.settransobject(sqlca)

return 1

end function

public function integer remove_admin (long pl_administration_sequence);str_popup popup
str_popup_return popup_return
integer i

 DECLARE lsp_delete_drug_administration PROCEDURE FOR dbo.sp_delete_drug_administration  
         @ps_drug_id = :drug_tab.drug.drug_id,   
         @pi_administration_sequence = :pl_administration_sequence  ;


EXECUTE lsp_delete_drug_administration;
if not tf_check() then return -1

refresh()


return 1


end function

on u_tabpage_drug_admin.create
int iCurrent
call super::create
this.cb_add_administration=create cb_add_administration
this.cb_remove_administration=create cb_remove_administration
this.dw_administration=create dw_administration
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_administration
this.Control[iCurrent+2]=this.cb_remove_administration
this.Control[iCurrent+3]=this.dw_administration
end on

on u_tabpage_drug_admin.destroy
call super::destroy
destroy(this.cb_add_administration)
destroy(this.cb_remove_administration)
destroy(this.dw_administration)
end on

type cb_add_administration from commandbutton within u_tabpage_drug_admin
integer x = 1705
integer y = 280
integer width = 768
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Administration"
end type

event clicked;add_admin()
end event

type cb_remove_administration from commandbutton within u_tabpage_drug_admin
integer x = 1705
integer y = 484
integer width = 768
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove Administration"
end type

event clicked;long ll_row
long ll_administration_sequence

ll_row = dw_administration.get_selected_row()
if ll_row <= 0 then return

ll_administration_sequence = dw_administration.object.administration_sequence[ll_row]

remove_admin(ll_administration_sequence)

end event

type dw_administration from u_dw_pick_list within u_tabpage_drug_admin
integer width = 1376
integer height = 1460
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_drug_admin_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_administration.enabled = true
end event

event unselected;call super::unselected;cb_remove_administration.enabled = false

end event

