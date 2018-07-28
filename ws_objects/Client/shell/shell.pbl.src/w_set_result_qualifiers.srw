$PBExportHeader$w_set_result_qualifiers.srw
forward
global type w_set_result_qualifiers from w_window_base
end type
type pb_cancel from u_picture_button within w_set_result_qualifiers
end type
type pb_done from u_picture_button within w_set_result_qualifiers
end type
type dw_qualifier_domains from u_dw_pick_list within w_set_result_qualifiers
end type
type st_1 from statictext within w_set_result_qualifiers
end type
type st_observation from statictext within w_set_result_qualifiers
end type
type st_result_title from statictext within w_set_result_qualifiers
end type
type st_result from statictext within w_set_result_qualifiers
end type
type cb_add_qualifier_domain from commandbutton within w_set_result_qualifiers
end type
type cb_move_up from commandbutton within w_set_result_qualifiers
end type
type cb_move_down from commandbutton within w_set_result_qualifiers
end type
type cb_remove from commandbutton within w_set_result_qualifiers
end type
type dw_qualifiers from u_dw_pick_list within w_set_result_qualifiers
end type
type st_q_title from statictext within w_set_result_qualifiers
end type
type pb_1 from u_pb_help_button within w_set_result_qualifiers
end type
end forward

global type w_set_result_qualifiers from w_window_base
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
dw_qualifier_domains dw_qualifier_domains
st_1 st_1
st_observation st_observation
st_result_title st_result_title
st_result st_result
cb_add_qualifier_domain cb_add_qualifier_domain
cb_move_up cb_move_up
cb_move_down cb_move_down
cb_remove cb_remove
dw_qualifiers dw_qualifiers
st_q_title st_q_title
pb_1 pb_1
end type
global w_set_result_qualifiers w_set_result_qualifiers

type variables
string observation_id
integer result_sequence


end variables

on w_set_result_qualifiers.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.dw_qualifier_domains=create dw_qualifier_domains
this.st_1=create st_1
this.st_observation=create st_observation
this.st_result_title=create st_result_title
this.st_result=create st_result
this.cb_add_qualifier_domain=create cb_add_qualifier_domain
this.cb_move_up=create cb_move_up
this.cb_move_down=create cb_move_down
this.cb_remove=create cb_remove
this.dw_qualifiers=create dw_qualifiers
this.st_q_title=create st_q_title
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.dw_qualifier_domains
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_observation
this.Control[iCurrent+6]=this.st_result_title
this.Control[iCurrent+7]=this.st_result
this.Control[iCurrent+8]=this.cb_add_qualifier_domain
this.Control[iCurrent+9]=this.cb_move_up
this.Control[iCurrent+10]=this.cb_move_down
this.Control[iCurrent+11]=this.cb_remove
this.Control[iCurrent+12]=this.dw_qualifiers
this.Control[iCurrent+13]=this.st_q_title
this.Control[iCurrent+14]=this.pb_1
end on

on w_set_result_qualifiers.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.dw_qualifier_domains)
destroy(this.st_1)
destroy(this.st_observation)
destroy(this.st_result_title)
destroy(this.st_result)
destroy(this.cb_add_qualifier_domain)
destroy(this.cb_move_up)
destroy(this.cb_move_down)
destroy(this.cb_remove)
destroy(this.dw_qualifiers)
destroy(this.st_q_title)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup = message.powerobjectparm
popup_return.item_count = 0

if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

observation_id = popup.items[1]
result_sequence = integer(popup.items[2])


if not isnull(popup.title) and popup.title <> "" then
	st_observation.text = popup.title
else
	li_sts = tf_get_observation_description(observation_id, st_observation.text)
	if li_sts <= 0 then
		log.log(this, "open", "Invalid observation id (" + observation_id + ")", 4)
		close(this)
		return
	end if
end if

SELECT result
INTO :st_result.text
FROM c_Observation_Result
WHERE observation_id = :observation_id
AND result_sequence = :result_sequence;
if not tf_check() then
	log.log(this, "open", "Error getting result", 4)
	closewithreturn(this, popup_return)
	return
end if

if sqlca.sqlcode = 100 then
	log.log(this, "open", "Result not found", 4)
	closewithreturn(this, popup_return)
	return
end if

dw_qualifier_domains.settransobject(sqlca)
dw_qualifiers.settransobject(sqlca)

li_sts = dw_qualifier_domains.retrieve(observation_id, result_sequence)
if li_sts < 0 then
	log.log(this, "open", "Error getting qualifier domains", 4)
	closewithreturn(this, popup_return)
	return
end if


end event

type pb_cancel from u_picture_button within w_set_result_qualifiers
int X=87
int Y=1568
int TabOrder=50
boolean Visible=false
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_set_result_qualifiers
int X=2569
int Y=1556
int TabOrder=10
boolean BringToTop=true
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type dw_qualifier_domains from u_dw_pick_list within w_set_result_qualifiers
int X=105
int Y=472
int Width=1248
int Height=1288
int TabOrder=30
boolean BringToTop=true
string DataObject="dw_result_qualifier_domain_pick_list"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

event selected;call super::selected;long ll_qualifier_domain_id


cb_move_up.enabled = true
cb_move_down.enabled = true
cb_remove.enabled = true

ll_qualifier_domain_id = dw_qualifier_domains.object.qualifier_domain_id[selected_row]

dw_qualifiers.retrieve(ll_qualifier_domain_id)

pb_done.enabled = true

end event

type st_1 from statictext within w_set_result_qualifiers
int X=105
int Y=404
int Width=1147
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Attached Qualifier Groups"
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

type st_observation from statictext within w_set_result_qualifiers
int Width=2930
int Height=136
boolean Enabled=false
boolean BringToTop=true
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

type st_result_title from statictext within w_set_result_qualifiers
int X=325
int Y=200
int Width=251
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Result:"
Alignment Alignment=Right!
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

type st_result from statictext within w_set_result_qualifiers
int X=613
int Y=196
int Width=1797
int Height=76
boolean Enabled=false
boolean BringToTop=true
boolean Border=true
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

type cb_add_qualifier_domain from commandbutton within w_set_result_qualifiers
int X=2103
int Y=488
int Width=613
int Height=108
int TabOrder=40
boolean BringToTop=true
string Text="Add Qualifier Group"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_find
long ll_row
long i
integer li_sts
long ll_qualifier_domain_id
string ls_category_description

// Find out what type of qualifier domain the user wants
popup.title = "Select Qualifier Category"
popup.dataobject = "dw_qualifier_domain_cat_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ls_category_description = popup_return.descriptions[1]

// Now get the qualifier domain the user wants to add
popup.data_row_count = 1
popup.items[1] = popup_return.items[1]
popup.title = popup_return.descriptions[1]
openwithparm(w_pick_qualifier_domain, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

// Now attach the qualifier domain to the observation result
ll_qualifier_domain_id = long(popup_return.items[1])

ll_row = dw_qualifier_domains.insertrow(0)
dw_qualifier_domains.object.observation_id[ll_row] = observation_id
dw_qualifier_domains.object.result_sequence[ll_row] = result_sequence
dw_qualifier_domains.object.qualifier_domain_id[ll_row] = ll_qualifier_domain_id
dw_qualifier_domains.object.category_description[ll_row] = ls_category_description
dw_qualifier_domains.object.domain_description[ll_row] = popup_return.descriptions[1]

for i = 1 to ll_row
	dw_qualifier_domains.object.sort_sequence[i] = i
next

dw_qualifier_domains.update()

dw_qualifier_domains.clear_selected()
dw_qualifier_domains.object.selected_flag[ll_row] = 1
dw_qualifiers.retrieve(ll_qualifier_domain_id)

pb_done.enabled = true


end event

type cb_move_up from commandbutton within w_set_result_qualifiers
int X=1531
int Y=488
int Width=457
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

ll_row = dw_qualifier_domains.get_selected_row()

if ll_row > 1 then
	// Since we're not sure that the sort sequence field is populated, go ahead
	// and set them all the their current row numbers
	for i = 1 to dw_qualifier_domains.rowcount()
		dw_qualifier_domains.object.sort_sequence[i] = i
	next
	
	// The switch the ones the user wants to move
	li_sort_sequence = dw_qualifier_domains.object.sort_sequence[ll_row]
	li_sort_sequence_above = dw_qualifier_domains.object.sort_sequence[ll_row - 1]
	dw_qualifier_domains.setitem(ll_row, "sort_sequence", li_sort_sequence_above)
	dw_qualifier_domains.setitem(ll_row - 1, "sort_sequence", li_sort_sequence)
	dw_qualifier_domains.sort()
	dw_qualifier_domains.update()
	ll_row = dw_qualifier_domains.find("selected_flag=1", 1, dw_qualifier_domains.rowcount())
	dw_qualifier_domains.scrolltorow(ll_row)

	if ll_row = dw_qualifier_domains.rowcount() then
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

type cb_move_down from commandbutton within w_set_result_qualifiers
int X=1531
int Y=640
int Width=457
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

ll_row = dw_qualifier_domains.get_selected_row()

if ll_row < dw_qualifier_domains.rowcount() then
	// Since we're not sure that the sort sequence field is populated, go ahead
	// and set them all the their current row numbers
	for i = 1 to dw_qualifier_domains.rowcount()
		dw_qualifier_domains.object.sort_sequence[i] = i
	next
	
	// The switch the ones the user wants to move
	li_sort_sequence = dw_qualifier_domains.object.sort_sequence[ll_row]
	li_sort_sequence_below = dw_qualifier_domains.object.sort_sequence[ll_row + 1]
	dw_qualifier_domains.setitem(ll_row, "sort_sequence", li_sort_sequence_below)
	dw_qualifier_domains.setitem(ll_row + 1, "sort_sequence", li_sort_sequence)
	dw_qualifier_domains.sort()
	dw_qualifier_domains.update()
	ll_row = dw_qualifier_domains.find("selected_flag=1", 1, dw_qualifier_domains.rowcount())
	dw_qualifier_domains.scrolltorow(ll_row)
	
	if ll_row = dw_qualifier_domains.rowcount() then
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

type cb_remove from commandbutton within w_set_result_qualifiers
int X=2103
int Y=640
int Width=613
int Height=108
int TabOrder=80
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

ll_row = dw_qualifier_domains.get_selected_row()

dw_qualifier_domains.deleterow(ll_row)
dw_qualifier_domains.update()

end event

type dw_qualifiers from u_dw_pick_list within w_set_result_qualifiers
int X=1481
int Y=940
int Width=955
int Height=828
int TabOrder=20
boolean BringToTop=true
string DataObject="dw_qualifier_display_list_small"
BorderStyle BorderStyle=StyleRaised!
boolean HScrollBar=true
end type

event clicked;call super::clicked;str_popup popup
long ll_qualifier_domain_id
long ll_row

ll_row = dw_qualifier_domains.get_selected_row()
if ll_row <= 0 then return

ll_qualifier_domain_id = dw_qualifier_domains.object.qualifier_domain_id[ll_row]

popup.data_row_count = 1
popup.items[1] = string(ll_qualifier_domain_id)
openwithparm(w_edit_qualifier_domain, popup)

retrieve(ll_qualifier_domain_id)

end event

type st_q_title from statictext within w_set_result_qualifiers
int X=1481
int Y=856
int Width=955
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifiers"
Alignment Alignment=Center!
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

type pb_1 from u_pb_help_button within w_set_result_qualifiers
int X=2578
int Y=1336
int TabOrder=20
boolean BringToTop=true
end type

