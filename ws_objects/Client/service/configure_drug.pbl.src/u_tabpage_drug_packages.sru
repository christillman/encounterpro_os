$PBExportHeader$u_tabpage_drug_packages.sru
forward
global type u_tabpage_drug_packages from u_tabpage_drug_base
end type
type cb_edit_package from commandbutton within u_tabpage_drug_packages
end type
type cb_remove_package from commandbutton within u_tabpage_drug_packages
end type
type cb_add_package from commandbutton within u_tabpage_drug_packages
end type
type dw_packages from u_dw_pick_list within u_tabpage_drug_packages
end type
end forward

global type u_tabpage_drug_packages from u_tabpage_drug_base
cb_edit_package cb_edit_package
cb_remove_package cb_remove_package
cb_add_package cb_add_package
dw_packages dw_packages
end type
global u_tabpage_drug_packages u_tabpage_drug_packages

forward prototypes
public function integer initialize ()
public function integer add_package ()
public function integer edit_package (string ps_package_id)
public subroutine refresh ()
public function integer remove_package (string ps_package_id)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "single drug" or lower(drug_tab.drug.drug_type) = "compound drug" then
	visible = true
else
	visible = false
	return 1
end if

dw_packages.height = height
dw_packages.width = 1376

dw_packages.settransobject(sqlca)

return 1

end function

public function integer add_package ();str_popup popup
str_popup_return popup_return
string ls_package_id
string ls_description  
real lr_null
string ls_null
int li_null

SetNull(lr_null)
SetNull(ls_null)
SetNull(li_null)


open(w_drug_package_selection)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

ls_package_id = popup_return.items[1]
ls_description = popup_return.descriptions[1]

// DECLARE lsp_new_drug_package PROCEDURE FOR dbo.sp_new_drug_package  
//         @ps_drug_id = :drug_tab.drug.drug_id,   
//         @ps_package_id = :ls_package_id;
//
sqlca.sp_new_drug_package (drug_tab.drug.drug_id,ls_package_id,'Y',lr_null,ls_null,'N',li_null);
//EXECUTE lsp_new_drug_package;
if not tf_check() then return -1

return edit_package(ls_package_id)


end function

public function integer edit_package (string ps_package_id);str_popup popup
str_popup_return popup_return
long ll_row, ll_count
string ls_find
string ls_package_id
integer li_sort_order
string ls_prescription_flag
real lr_default_dispense_amount
string ls_default_dispense_unit
string ls_take_as_directed
string ls_description  

popup.title = drug_tab.drug.common_name
popup.data_row_count = 2
popup.items[1] = drug_tab.drug.drug_id
popup.items[2] = ps_package_id
openwithparm(w_drug_package, popup)

refresh()

return 1

end function

public subroutine refresh ();
dw_packages.retrieve(drug_tab.drug.drug_id)

cb_edit_package.enabled = false
cb_remove_package.enabled = false


end subroutine

public function integer remove_package (string ps_package_id);str_popup popup
str_popup_return popup_return

// DECLARE lsp_delete_drug_package PROCEDURE FOR dbo.sp_delete_drug_package 
//         @ps_drug_id = :drug_tab.drug.drug_id,   
//         @ps_package_id = :ps_package_id  ;


sqlca.sp_delete_drug_package(drug_tab.drug.drug_id,ps_package_id);
//EXECUTE lsp_delete_drug_package;
if not tf_check() then return -1

refresh()

return 1


end function

on u_tabpage_drug_packages.create
int iCurrent
call super::create
this.cb_edit_package=create cb_edit_package
this.cb_remove_package=create cb_remove_package
this.cb_add_package=create cb_add_package
this.dw_packages=create dw_packages
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_edit_package
this.Control[iCurrent+2]=this.cb_remove_package
this.Control[iCurrent+3]=this.cb_add_package
this.Control[iCurrent+4]=this.dw_packages
end on

on u_tabpage_drug_packages.destroy
call super::destroy
destroy(this.cb_edit_package)
destroy(this.cb_remove_package)
destroy(this.cb_add_package)
destroy(this.dw_packages)
end on

type cb_edit_package from commandbutton within u_tabpage_drug_packages
integer x = 1705
integer y = 688
integer width = 617
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Edit Package"
end type

event clicked;long ll_row
string ls_package_id

ll_row = dw_packages.get_selected_row()
if ll_row <= 0 then return

ls_package_id = dw_packages.object.package_id[ll_row]

edit_package(ls_package_id)

end event

type cb_remove_package from commandbutton within u_tabpage_drug_packages
integer x = 1705
integer y = 484
integer width = 617
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove Package"
end type

event clicked;long ll_row
string ls_package_id

ll_row = dw_packages.get_selected_row()
if ll_row <= 0 then return

ls_package_id = dw_packages.object.package_id[ll_row]

remove_package(ls_package_id)

end event

type cb_add_package from commandbutton within u_tabpage_drug_packages
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
string text = "Add Package"
end type

event clicked;add_package()
end event

type dw_packages from u_dw_pick_list within u_tabpage_drug_packages
integer width = 1376
integer height = 1424
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_drug_package_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_edit_package.enabled = true
cb_remove_package.enabled = true


end event

event unselected;call super::unselected;cb_edit_package.enabled = false
cb_remove_package.enabled = false


end event

