$PBExportHeader$w_location_domain_edit.srw
forward
global type w_location_domain_edit from w_window_base
end type
type pb_done from u_picture_button within w_location_domain_edit
end type
type pb_cancel from u_picture_button within w_location_domain_edit
end type
type st_title from statictext within w_location_domain_edit
end type
type dw_location from u_dw_pick_list within w_location_domain_edit
end type
type cb_new_location from commandbutton within w_location_domain_edit
end type
type cb_up from commandbutton within w_location_domain_edit
end type
type cb_down from commandbutton within w_location_domain_edit
end type
type cb_delete from commandbutton within w_location_domain_edit
end type
type cb_diffuse from commandbutton within w_location_domain_edit
end type
type pb_1 from u_pb_help_button within w_location_domain_edit
end type
end forward

global type w_location_domain_edit from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
dw_location dw_location
cb_new_location cb_new_location
cb_up cb_up
cb_down cb_down
cb_delete cb_delete
cb_diffuse cb_diffuse
pb_1 pb_1
end type
global w_location_domain_edit w_location_domain_edit

type variables
string location_domain
long current_selection

end variables

forward prototypes
public subroutine location_menu (long pl_row)
public subroutine new_location ()
public subroutine move_up ()
public subroutine move_down ()
public subroutine set_row (long pl_row)
end prototypes

public subroutine location_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_cpt_code
decimal ldc_charge

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
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
	CASE "EDIT"
	CASE "CHANGE"
	CASE "NA"
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine new_location ();str_popup popup
str_popup_return popup_return
integer li_sort_sequence
integer li_sts
long ll_row
long ll_key_value
string ls_location

li_sts = tf_get_next_key("!CPR", "LOCATION", ll_key_value)
if li_sts <= 0 then return

ls_location = "LOCATION" + string(ll_key_value)

popup.item = "Enter New Location:"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) or popup_return.item = "" then return

ll_row = dw_location.rowcount()
if ll_row > 0 then
	li_sort_sequence = dw_location.object.sort_sequence[ll_row] + 1
else
	li_sort_sequence = 1
end if

dw_location.clear_selected()

ll_row = dw_location.insertrow(0)
dw_location.setitem(ll_row, "location_domain", location_domain)
dw_location.setitem(ll_row, "location", ls_location)
dw_location.setitem(ll_row, "description", popup_return.item)
dw_location.setitem(ll_row, "sort_sequence", li_sort_sequence)
dw_location.setitem(ll_row, "diffuse_flag", "N")
dw_location.setitem(ll_row, "selected_flag", 1)

set_row(ll_row)

end subroutine

public subroutine move_up ();integer li_sort_sequence, li_sort_sequence_above
long ll_row

if current_selection > 1 then
	li_sort_sequence = dw_location.object.sort_sequence[current_selection]
	li_sort_sequence_above = dw_location.object.sort_sequence[current_selection - 1]
	dw_location.setitem(current_selection, "sort_sequence", li_sort_sequence_above)
	dw_location.setitem(current_selection - 1, "sort_sequence", li_sort_sequence)
	dw_location.sort()
	ll_row = dw_location.find("selected_flag=1", 1, dw_location.rowcount())
	set_row(ll_row)
end if


end subroutine

public subroutine move_down ();integer li_sort_sequence, li_sort_sequence_below
long ll_row

if current_selection <  dw_location.rowcount() then
	li_sort_sequence = dw_location.object.sort_sequence[current_selection]
	li_sort_sequence_below = dw_location.object.sort_sequence[current_selection + 1]
	dw_location.setitem(current_selection, "sort_sequence", li_sort_sequence_below)
	dw_location.setitem(current_selection + 1, "sort_sequence", li_sort_sequence)
	dw_location.sort()
	ll_row = dw_location.find("selected_flag=1", 1, dw_location.rowcount())
	set_row(ll_row)
end if


end subroutine

public subroutine set_row (long pl_row);if pl_row <= 0 then
	current_selection = 0
	cb_delete.enabled = false
	cb_down.enabled = false
	cb_up.enabled = false
	cb_diffuse.enabled = false
	return
end if


current_selection = pl_row
cb_delete.enabled = true
cb_diffuse.enabled = true

if pl_row < dw_location.rowcount() then
	cb_down.enabled = true
else
	cb_down.enabled = false
end if

if pl_row > 1 then
	cb_up.enabled = true
else
	cb_up.enabled = false
end if


end subroutine

on w_location_domain_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.dw_location=create dw_location
this.cb_new_location=create cb_new_location
this.cb_up=create cb_up
this.cb_down=create cb_down
this.cb_delete=create cb_delete
this.cb_diffuse=create cb_diffuse
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_location
this.Control[iCurrent+5]=this.cb_new_location
this.Control[iCurrent+6]=this.cb_up
this.Control[iCurrent+7]=this.cb_down
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.cb_diffuse
this.Control[iCurrent+10]=this.pb_1
end on

on w_location_domain_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.dw_location)
destroy(this.cb_new_location)
destroy(this.cb_up)
destroy(this.cb_down)
destroy(this.cb_delete)
destroy(this.cb_diffuse)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
long i
integer li_sort_sequence
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "w_location_domain_edit:open", "Invalid Parameters", 4)
	close(this)
	return
end if

location_domain = popup.items[1]

li_sts = tf_get_location_domain_description(location_domain, st_title.text)
if li_sts <= 0 then
	log.log(this, "w_location_domain_edit:open", "Unable to get description for location domain (" + location_domain + ")", 4)
	close(this)
	return
end if

dw_location.settransobject(sqlca)

dw_location.setredraw(false)
dw_location.retrieve(location_domain)
for i = 1 to dw_location.rowcount()
	li_sort_sequence = dw_location.object.sort_sequence[i]
	if li_sort_sequence <> i or isnull(li_sort_sequence) then dw_location.setitem(i, "sort_sequence", i)
next
dw_location.sort()
dw_location.setredraw(true)

set_row(0)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_location_domain_edit
end type

type pb_done from u_picture_button within w_location_domain_edit
integer x = 2569
integer y = 1556
integer taborder = 70
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long i
string ls_location
string ls_description
integer li_sort_sequence
string ls_diffuse_flag
dwItemStatus le_status

 DECLARE lsp_new_location PROCEDURE FOR dbo.sp_new_location  
         @ps_location = :ls_location,   
         @ps_location_domain = :location_domain,   
         @ps_description = :ls_description,   
         @pi_sort_sequence = :li_sort_sequence,   
         @ps_diffuse_flag = :ls_diffuse_flag  ;

 DECLARE lsp_update_location PROCEDURE FOR dbo.sp_update_location  
         @ps_location = :ls_location,   
         @pi_sort_sequence = :li_sort_sequence,   
         @ps_diffuse_flag = :ls_diffuse_flag  ;

 DECLARE lsp_delete_location PROCEDURE FOR dbo.sp_delete_location  
         @ps_location = :ls_location  ;


for i = 1 to dw_location.rowcount()
	le_status = dw_location.getitemstatus(i, 0, primary!)
	CHOOSE CASE le_status
		CASE DataModified!
			ls_location = dw_location.object.location[i]
			li_sort_sequence = dw_location.object.sort_sequence[i]
			ls_diffuse_flag = dw_location.object.diffuse_flag[i]
			EXECUTE lsp_update_location;
			if not tf_check() then return
		CASE NewModified!
			ls_location = dw_location.object.location[i]
			ls_description = dw_location.object.description[i]
			li_sort_sequence = dw_location.object.sort_sequence[i]
			ls_diffuse_flag = dw_location.object.diffuse_flag[i]
			EXECUTE lsp_new_location;
			if not tf_check() then return
	END CHOOSE
next

for i = 1 to dw_location.deletedcount()
	le_status = dw_location.getitemstatus(i, 0, delete!)
	if le_status = NotModified! or le_status = DataModified! then
		ls_location = dw_location.object.location.Delete.original[i]
		EXECUTE lsp_delete_location;
		if not tf_check() then return
	end if
next

close(parent)


end event

type pb_cancel from u_picture_button within w_location_domain_edit
integer x = 82
integer y = 1552
integer taborder = 80
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type st_title from statictext within w_location_domain_edit
integer width = 2917
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_location from u_dw_pick_list within w_location_domain_edit
integer x = 905
integer y = 192
integer width = 1147
integer height = 1512
integer taborder = 60
string dataobject = "dw_location_edit"
boolean vscrollbar = true
boolean border = false
end type

event selected;current_selection = selected_row
cb_delete.enabled = true
cb_diffuse.enabled = true

if current_selection < dw_location.rowcount() then
	cb_down.enabled = true
else
	cb_down.enabled = false
end if

if current_selection > 1 then
	cb_up.enabled = true
else
	cb_up.enabled = false
end if
end event

event unselected;current_selection = 0
cb_delete.enabled = false
cb_down.enabled = false
cb_up.enabled = false
cb_diffuse.enabled = false
end event

event post_click;call super::post_click;//if lastselected then set_row(clicked_row)
end event

type cb_new_location from commandbutton within w_location_domain_edit
integer x = 2277
integer y = 444
integer width = 471
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Location"
end type

event clicked;new_location()
end event

type cb_up from commandbutton within w_location_domain_edit
integer x = 2277
integer y = 1072
integer width = 471
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;move_up()
end event

type cb_down from commandbutton within w_location_domain_edit
integer x = 2277
integer y = 1268
integer width = 471
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;move_down()
end event

type cb_delete from commandbutton within w_location_domain_edit
event clicked pbm_bnclicked
integer x = 2277
integer y = 760
integer width = 471
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;if current_selection <= 0 then return

dw_location.deleterow(current_selection)

end event

type cb_diffuse from commandbutton within w_location_domain_edit
event clicked pbm_bnclicked
integer x = 187
integer y = 444
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Diffuse Term"
end type

event clicked;long i

if current_selection > 0 then
	for i = 1 to dw_location.rowcount()
		dw_location.setitem(i, "diffuse_flag", "N")
	next

	dw_location.setitem(current_selection, "diffuse_flag", "Y")
end if

end event

type pb_1 from u_pb_help_button within w_location_domain_edit
integer x = 2231
integer y = 1612
integer taborder = 20
boolean bringtotop = true
end type

