$PBExportHeader$u_tabpage_drug_makers.sru
forward
global type u_tabpage_drug_makers from u_tabpage_drug_base
end type
type cb_add_maker from commandbutton within u_tabpage_drug_makers
end type
type cb_remove_maker from commandbutton within u_tabpage_drug_makers
end type
type dw_makers from u_dw_pick_list within u_tabpage_drug_makers
end type
end forward

global type u_tabpage_drug_makers from u_tabpage_drug_base
cb_add_maker cb_add_maker
cb_remove_maker cb_remove_maker
dw_makers dw_makers
end type
global u_tabpage_drug_makers u_tabpage_drug_makers

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer add_maker ()
public function integer remove_maker (string ps_maker_id)
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "vaccine" &
 or lower(drug_tab.drug.drug_type) = "compound drug" &
 or lower(drug_tab.drug.drug_type) = "single drug" then
	visible = true
else
	visible = false
	return 1
end if

dw_makers.height = height
dw_makers.width = 1376

dw_makers.settransobject(sqlca)

return 1

end function

public subroutine refresh ();
dw_makers.retrieve(drug_tab.drug.drug_id)

cb_remove_maker.enabled = false


end subroutine

public function integer add_maker ();long i
str_popup popup
str_popup_return popup_return
string ls_maker_id
long ll_count

popup.dataobject = "dw_maker_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = drug_tab.drug.drug_id
popup.multiselect = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return 0

for i = 1 to popup_return.item_count
	ls_maker_id = popup_return.items[i]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Vaccine_Maker
	WHERE vaccine_id = :drug_tab.drug.drug_id
	AND maker_id = :ls_maker_id;
	if not tf_check() then return -1
	
	if ll_count = 0 then
		INSERT INTO c_Vaccine_Maker (
			vaccine_id,
			maker_id )
		VALUES (
			:drug_tab.drug.drug_id,
			:ls_maker_id);
		if not tf_check() then return -1
	end if
next

refresh()

return 1

end function

public function integer remove_maker (string ps_maker_id);

DELETE FROM c_Vaccine_Maker
WHERE vaccine_id = :drug_tab.drug.drug_id
AND maker_id = :ps_maker_id;
if not tf_check() then return -1


refresh()

return 1

end function

on u_tabpage_drug_makers.create
int iCurrent
call super::create
this.cb_add_maker=create cb_add_maker
this.cb_remove_maker=create cb_remove_maker
this.dw_makers=create dw_makers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_maker
this.Control[iCurrent+2]=this.cb_remove_maker
this.Control[iCurrent+3]=this.dw_makers
end on

on u_tabpage_drug_makers.destroy
call super::destroy
destroy(this.cb_add_maker)
destroy(this.cb_remove_maker)
destroy(this.dw_makers)
end on

type cb_add_maker from commandbutton within u_tabpage_drug_makers
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
string text = "Add Maker"
end type

event clicked;add_maker()
end event

type cb_remove_maker from commandbutton within u_tabpage_drug_makers
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
string text = "Remove Maker"
end type

event clicked;long ll_row
string ls_maker_id

ll_row = dw_makers.get_selected_row()
if ll_row <= 0 then return

ls_maker_id = dw_makers.object.maker_id[ll_row]

remove_maker(ls_maker_id)

end event

type dw_makers from u_dw_pick_list within u_tabpage_drug_makers
integer width = 1376
integer height = 1100
integer taborder = 10
string dataobject = "dw_drug_maker_display_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove_maker.enabled = true


end event

event unselected;call super::unselected;cb_remove_maker.enabled = false


end event

