HA$PBExportHeader$u_tabpage_drug_categories.sru
forward
global type u_tabpage_drug_categories from u_tabpage_drug_base
end type
type cb_add_category from commandbutton within u_tabpage_drug_categories
end type
type cb_remove_category from commandbutton within u_tabpage_drug_categories
end type
type dw_categories from u_dw_pick_list within u_tabpage_drug_categories
end type
end forward

global type u_tabpage_drug_categories from u_tabpage_drug_base
cb_add_category cb_add_category
cb_remove_category cb_remove_category
dw_categories dw_categories
end type
global u_tabpage_drug_categories u_tabpage_drug_categories

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_category ()
public function integer remove_category (string ps_drug_category_id)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "compound drug" &
 or lower(drug_tab.drug.drug_type) = "single drug" then
	visible = true
else
	visible = false
	return 1
end if

dw_categories.height = height
dw_categories.width = 1376

dw_categories.settransobject(sqlca)

return 1

end function

public subroutine refresh ();
dw_categories.retrieve(drug_tab.drug.drug_id)

cb_remove_category.enabled = false


end subroutine

public function integer add_category ();str_popup popup
str_popup_return popup_return
string ls_category_id
long ll_count
long i

popup.dataobject = "dw_drug_categories"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = drug_tab.drug.drug_id
popup.multiselect = true

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return 0

for i = 1 to popup_return.item_count
	ls_category_id = popup_return.items[i]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Drug_Drug_category
	WHERE drug_id = :drug_tab.drug.drug_id
	AND drug_category_id = :ls_category_id;
	if not tf_check() then return -1
	
	if ll_count = 0 then
		INSERT INTO c_Drug_Drug_category (
			drug_id,
			drug_category_id )
		VALUES (
			:drug_tab.drug.drug_id,
			:ls_category_id);
		if not tf_check() then return -1
	end if
next

refresh()

return 1

end function

public function integer remove_category (string ps_drug_category_id);

DELETE FROM c_Drug_Drug_category
WHERE drug_id = :drug_tab.drug.drug_id
AND drug_category_id = :ps_drug_category_id;
if not tf_check() then return -1


refresh()

return 1

end function

on u_tabpage_drug_categories.create
int iCurrent
call super::create
this.cb_add_category=create cb_add_category
this.cb_remove_category=create cb_remove_category
this.dw_categories=create dw_categories
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_category
this.Control[iCurrent+2]=this.cb_remove_category
this.Control[iCurrent+3]=this.dw_categories
end on

on u_tabpage_drug_categories.destroy
call super::destroy
destroy(this.cb_add_category)
destroy(this.cb_remove_category)
destroy(this.dw_categories)
end on

type cb_add_category from commandbutton within u_tabpage_drug_categories
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
string text = "Add category"
end type

event clicked;add_category()
end event

type cb_remove_category from commandbutton within u_tabpage_drug_categories
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
string text = "Remove category"
end type

event clicked;long ll_row
string ls_drug_category_id

ll_row = dw_categories.get_selected_row()
if ll_row <= 0 then return

ls_drug_category_id = dw_categories.object.drug_category_id[ll_row]

remove_category(ls_drug_category_id)

end event

type dw_categories from u_dw_pick_list within u_tabpage_drug_categories
integer width = 1376
integer height = 1100
integer taborder = 10
string dataobject = "dw_drug_category_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_category.enabled = true


end event

event unselected;call super::unselected;cb_remove_category.enabled = false


end event

