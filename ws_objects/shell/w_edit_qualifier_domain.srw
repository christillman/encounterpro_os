HA$PBExportHeader$w_edit_qualifier_domain.srw
forward
global type w_edit_qualifier_domain from w_window_base
end type
type pb_cancel from u_picture_button within w_edit_qualifier_domain
end type
type pb_done from u_picture_button within w_edit_qualifier_domain
end type
type dw_qualifiers from u_dw_pick_list within w_edit_qualifier_domain
end type
type st_q_title from statictext within w_edit_qualifier_domain
end type
type st_title from statictext within w_edit_qualifier_domain
end type
type cb_add_qualifier from commandbutton within w_edit_qualifier_domain
end type
type cb_move_up from commandbutton within w_edit_qualifier_domain
end type
type cb_move_down from commandbutton within w_edit_qualifier_domain
end type
type cb_remove from commandbutton within w_edit_qualifier_domain
end type
type st_qualifier_domain_title from statictext within w_edit_qualifier_domain
end type
type st_qualifier_domain_cat_title from statictext within w_edit_qualifier_domain
end type
type st_qualifier_domain_category from statictext within w_edit_qualifier_domain
end type
type st_qualifier_domain from statictext within w_edit_qualifier_domain
end type
type st_exclusive_flag from statictext within w_edit_qualifier_domain
end type
type st_3 from statictext within w_edit_qualifier_domain
end type
type pb_1 from u_pb_help_button within w_edit_qualifier_domain
end type
end forward

global type w_edit_qualifier_domain from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_cancel pb_cancel
pb_done pb_done
dw_qualifiers dw_qualifiers
st_q_title st_q_title
st_title st_title
cb_add_qualifier cb_add_qualifier
cb_move_up cb_move_up
cb_move_down cb_move_down
cb_remove cb_remove
st_qualifier_domain_title st_qualifier_domain_title
st_qualifier_domain_cat_title st_qualifier_domain_cat_title
st_qualifier_domain_category st_qualifier_domain_category
st_qualifier_domain st_qualifier_domain
st_exclusive_flag st_exclusive_flag
st_3 st_3
pb_1 pb_1
end type
global w_edit_qualifier_domain w_edit_qualifier_domain

type variables
long qualifier_domain_id
string exclusive_flag = "Y"
end variables

on w_edit_qualifier_domain.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.dw_qualifiers=create dw_qualifiers
this.st_q_title=create st_q_title
this.st_title=create st_title
this.cb_add_qualifier=create cb_add_qualifier
this.cb_move_up=create cb_move_up
this.cb_move_down=create cb_move_down
this.cb_remove=create cb_remove
this.st_qualifier_domain_title=create st_qualifier_domain_title
this.st_qualifier_domain_cat_title=create st_qualifier_domain_cat_title
this.st_qualifier_domain_category=create st_qualifier_domain_category
this.st_qualifier_domain=create st_qualifier_domain
this.st_exclusive_flag=create st_exclusive_flag
this.st_3=create st_3
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.dw_qualifiers
this.Control[iCurrent+4]=this.st_q_title
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_add_qualifier
this.Control[iCurrent+7]=this.cb_move_up
this.Control[iCurrent+8]=this.cb_move_down
this.Control[iCurrent+9]=this.cb_remove
this.Control[iCurrent+10]=this.st_qualifier_domain_title
this.Control[iCurrent+11]=this.st_qualifier_domain_cat_title
this.Control[iCurrent+12]=this.st_qualifier_domain_category
this.Control[iCurrent+13]=this.st_qualifier_domain
this.Control[iCurrent+14]=this.st_exclusive_flag
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.pb_1
end on

on w_edit_qualifier_domain.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.dw_qualifiers)
destroy(this.st_q_title)
destroy(this.st_title)
destroy(this.cb_add_qualifier)
destroy(this.cb_move_up)
destroy(this.cb_move_down)
destroy(this.cb_remove)
destroy(this.st_qualifier_domain_title)
destroy(this.st_qualifier_domain_cat_title)
destroy(this.st_qualifier_domain_category)
destroy(this.st_qualifier_domain)
destroy(this.st_exclusive_flag)
destroy(this.st_3)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup = message.powerobjectparm
popup_return.item_count = 0

if popup.data_row_count <> 1 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

qualifier_domain_id = long(popup.items[1])

SELECT c_Qualifier_Domain_Category.description,
		c_Qualifier_Domain.description
INTO :st_qualifier_domain_category.text,
		:st_qualifier_domain.text
FROM c_Qualifier_Domain_Category,
		c_Qualifier_Domain
WHERE c_Qualifier_Domain.qualifier_domain_id = :qualifier_domain_id
AND c_Qualifier_Domain.qualifier_domain_category_id = c_Qualifier_Domain_Category.qualifier_domain_category_id;
if not tf_check() then
	log.log(this, "open", "Error getting descriptions", 4)
	closewithreturn(this, popup_return)
	return
end if

dw_qualifiers.settransobject(sqlca)

li_sts = dw_qualifiers.retrieve(qualifier_domain_id)
if li_sts < 0 then
	log.log(this, "open", "Error getting qualifiers", 4)
	closewithreturn(this, popup_return)
	return
end if

cb_remove.enabled = false
cb_move_down.enabled = false
cb_move_up.enabled = false

end event

type pb_cancel from u_picture_button within w_edit_qualifier_domain
int X=87
int Y=1568
int TabOrder=40
boolean Visible=false
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_edit_qualifier_domain
int X=2569
int Y=1556
int TabOrder=10
boolean BringToTop=true
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type dw_qualifiers from u_dw_pick_list within w_edit_qualifier_domain
int X=274
int Y=348
int Width=1147
int Height=1236
int TabOrder=20
boolean BringToTop=true
string DataObject="dw_qualifier_edit_list"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

event selected;call super::selected;cb_remove.enabled = true
cb_move_down.enabled = true
cb_move_up.enabled = true

end event

type st_q_title from statictext within w_edit_qualifier_domain
int X=274
int Y=260
int Width=1047
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifiers"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_title from statictext within w_edit_qualifier_domain
int Width=2930
int Height=136
boolean Enabled=false
boolean BringToTop=true
string Text="Edit Qualifier Group"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-18
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_add_qualifier from commandbutton within w_edit_qualifier_domain
int X=1591
int Y=720
int Width=613
int Height=108
int TabOrder=30
boolean BringToTop=true
string Text="Add Qualifier"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_qualifier
long ll_row
integer li_sts

popup.title = "Enter New Qualifer"
popup.item = ""
openwithparm(w_new_qualifier, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

ls_qualifier = popup_return.items[1]

ll_row = dw_qualifiers.insertrow(0)
dw_qualifiers.object.qualifier_domain_id[ll_row] = qualifier_domain_id
dw_qualifiers.object.qualifier[ll_row] = ls_qualifier
dw_qualifiers.object.sort_sequence[ll_row] = ll_row

li_sts = dw_qualifiers.update()
if li_sts < 0 then return


end event

type cb_move_up from commandbutton within w_edit_qualifier_domain
int X=1591
int Y=1220
int Width=613
int Height=108
int TabOrder=60
boolean BringToTop=true
string Text="Move Up"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;integer li_sort_sequence, li_sort_sequence_above
long ll_row
long i

ll_row = dw_qualifiers.get_selected_row()

if ll_row > 1 then
	// Since we're not sure that the sort sequence field is populated, go ahead
	// and set them all the their current row numbers
	for i = 1 to dw_qualifiers.rowcount()
		dw_qualifiers.object.sort_sequence[i] = i
	next
	
	// The switch the ones the user wants to move
	li_sort_sequence = dw_qualifiers.object.sort_sequence[ll_row]
	li_sort_sequence_above = dw_qualifiers.object.sort_sequence[ll_row - 1]
	dw_qualifiers.setitem(ll_row, "sort_sequence", li_sort_sequence_above)
	dw_qualifiers.setitem(ll_row - 1, "sort_sequence", li_sort_sequence)
	dw_qualifiers.sort()
	dw_qualifiers.update()
	ll_row = dw_qualifiers.find("selected_flag=1", 1, dw_qualifiers.rowcount())
	dw_qualifiers.scrolltorow(ll_row)

	if ll_row = dw_qualifiers.rowcount() then
		cb_move_down.enabled = false
	else
		cb_move_down.enabled = true
	end if
	
	if ll_row = 1 then
		cb_move_up.enabled = false
	else
		cb_move_up.enabled = true
	end if

end if


end event

type cb_move_down from commandbutton within w_edit_qualifier_domain
int X=1591
int Y=1372
int Width=613
int Height=108
int TabOrder=70
boolean BringToTop=true
string Text="Move Down"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;integer li_sort_sequence, li_sort_sequence_below
long ll_row
long i

ll_row = dw_qualifiers.get_selected_row()

if ll_row < dw_qualifiers.rowcount() then
	// Since we're not sure that the sort sequence field is populated, go ahead
	// and set them all the their current row numbers
	for i = 1 to dw_qualifiers.rowcount()
		dw_qualifiers.object.sort_sequence[i] = i
	next
	
	// The switch the ones the user wants to move
	li_sort_sequence = dw_qualifiers.object.sort_sequence[ll_row]
	li_sort_sequence_below = dw_qualifiers.object.sort_sequence[ll_row + 1]
	dw_qualifiers.setitem(ll_row, "sort_sequence", li_sort_sequence_below)
	dw_qualifiers.setitem(ll_row + 1, "sort_sequence", li_sort_sequence)
	dw_qualifiers.sort()
	dw_qualifiers.update()
	ll_row = dw_qualifiers.find("selected_flag=1", 1, dw_qualifiers.rowcount())
	dw_qualifiers.scrolltorow(ll_row)
	
	if ll_row = dw_qualifiers.rowcount() then
		cb_move_down.enabled = false
	else
		cb_move_down.enabled = true
	end if
	
	if ll_row = 1 then
		cb_move_up.enabled = false
	else
		cb_move_up.enabled = true
	end if
end if


end event

type cb_remove from commandbutton within w_edit_qualifier_domain
int X=1591
int Y=996
int Width=613
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text="Remove"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long ll_row

ll_row = dw_qualifiers.get_selected_row()

dw_qualifiers.deleterow(ll_row)
dw_qualifiers.update()

end event

type st_qualifier_domain_title from statictext within w_edit_qualifier_domain
int X=1582
int Y=444
int Width=489
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifier Group"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_qualifier_domain_cat_title from statictext within w_edit_qualifier_domain
int X=1582
int Y=240
int Width=741
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifier Group Category"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_qualifier_domain_category from statictext within w_edit_qualifier_domain
int X=1582
int Y=312
int Width=1157
int Height=76
boolean Enabled=false
boolean BringToTop=true
boolean Border=true
string Text="none"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_qualifier_domain from statictext within w_edit_qualifier_domain
int X=1582
int Y=516
int Width=1157
int Height=76
boolean Enabled=false
boolean BringToTop=true
boolean Border=true
string Text="none"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_exclusive_flag from statictext within w_edit_qualifier_domain
int X=1001
int Y=1616
int Width=233
int Height=108
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Yes"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if exclusive_flag = "Y" then
	text = "No"
	exclusive_flag = "N"
else
	text = "Yes"
	exclusive_flag = "Y"
end if

end event

type st_3 from statictext within w_edit_qualifier_domain
int X=334
int Y=1636
int Width=649
int Height=84
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifiers Mutually Exclusive:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_1 from u_pb_help_button within w_edit_qualifier_domain
int X=2578
int Y=1240
int TabOrder=20
boolean BringToTop=true
end type

