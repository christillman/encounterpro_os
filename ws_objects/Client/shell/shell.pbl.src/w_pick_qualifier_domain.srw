$PBExportHeader$w_pick_qualifier_domain.srw
forward
global type w_pick_qualifier_domain from w_window_base
end type
type pb_cancel from u_picture_button within w_pick_qualifier_domain
end type
type pb_done from u_picture_button within w_pick_qualifier_domain
end type
type st_cat_title from statictext within w_pick_qualifier_domain
end type
type st_title from statictext within w_pick_qualifier_domain
end type
type cb_new_qualifier_domain from commandbutton within w_pick_qualifier_domain
end type
type dw_qualifier_domains from u_dw_pick_list within w_pick_qualifier_domain
end type
type dw_qualifiers from u_dw_pick_list within w_pick_qualifier_domain
end type
type st_q_title from statictext within w_pick_qualifier_domain
end type
type pb_1 from u_pb_help_button within w_pick_qualifier_domain
end type
end forward

global type w_pick_qualifier_domain from w_window_base
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
st_cat_title st_cat_title
st_title st_title
cb_new_qualifier_domain cb_new_qualifier_domain
dw_qualifier_domains dw_qualifier_domains
dw_qualifiers dw_qualifiers
st_q_title st_q_title
pb_1 pb_1
end type
global w_pick_qualifier_domain w_pick_qualifier_domain

type variables
long qualifier_domain_category_id



end variables

forward prototypes
public function integer display_qualifiers (long pl_qualifier_domain_id)
end prototypes

public function integer display_qualifiers (long pl_qualifier_domain_id);integer li_sts

li_sts = dw_qualifiers.retrieve(pl_qualifier_domain_id)

return li_sts

end function

on w_pick_qualifier_domain.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_cat_title=create st_cat_title
this.st_title=create st_title
this.cb_new_qualifier_domain=create cb_new_qualifier_domain
this.dw_qualifier_domains=create dw_qualifier_domains
this.dw_qualifiers=create dw_qualifiers
this.st_q_title=create st_q_title
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.st_cat_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_new_qualifier_domain
this.Control[iCurrent+6]=this.dw_qualifier_domains
this.Control[iCurrent+7]=this.dw_qualifiers
this.Control[iCurrent+8]=this.st_q_title
this.Control[iCurrent+9]=this.pb_1
end on

on w_pick_qualifier_domain.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_cat_title)
destroy(this.st_title)
destroy(this.cb_new_qualifier_domain)
destroy(this.dw_qualifier_domains)
destroy(this.dw_qualifiers)
destroy(this.st_q_title)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_qualifier_class

popup = message.powerobjectparm
popup_return.item_count = 0

if popup.data_row_count <> 1 then
	log.log(this, "w_pick_qualifier_domain.open.0010", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

qualifier_domain_category_id = long(popup.items[1])
st_cat_title.text = popup.title + " Qualifier Groups"

ls_qualifier_class = datalist.qualifier_class(qualifier_domain_category_id)
if ls_qualifier_class = "ENUMERATED" then
	dw_qualifiers.visible = true
	st_q_title.visible = true
else
	dw_qualifiers.visible = false
	st_q_title.visible = false
end if

dw_qualifier_domains.settransobject(sqlca)
dw_qualifiers.settransobject(sqlca)

li_sts = dw_qualifier_domains.retrieve(qualifier_domain_category_id)
if li_sts < 0 then
	log.log(this, "w_pick_qualifier_domain.open.0010", "Error getting qualifier domains", 4)
	closewithreturn(this, popup_return)
	return
end if

pb_done.enabled = false

end event

type pb_cancel from u_picture_button within w_pick_qualifier_domain
int X=87
int Y=1568
int TabOrder=50
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_pick_qualifier_domain
int X=2569
int Y=1556
int TabOrder=10
boolean BringToTop=true
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
long ll_row

ll_row = dw_qualifier_domains.get_selected_row()
if ll_row <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = string(dw_qualifier_domains.object.qualifier_domain_id[ll_row])
popup_return.descriptions[1] = string(dw_qualifier_domains.object.description[ll_row])

closewithreturn(parent, popup_return)

end event

type st_cat_title from statictext within w_pick_qualifier_domain
int X=279
int Y=272
int Width=1499
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Qualifier Groups"
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

type st_title from statictext within w_pick_qualifier_domain
int Width=2930
int Height=136
boolean Enabled=false
boolean BringToTop=true
string Text="Select Qualifier Group"
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

type cb_new_qualifier_domain from commandbutton within w_pick_qualifier_domain
int X=1879
int Y=348
int Width=622
int Height=108
int TabOrder=40
boolean BringToTop=true
string Text="New Qualifier Group"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
long ll_row
integer li_sts
integer i
long ll_qualifier_domain_id

popup.title = "Enter New Qualifer Group Description"
popup.item = ""
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

ls_description = popup_return.items[1]

ll_row = dw_qualifier_domains.insertrow(0)
dw_qualifier_domains.object.qualifier_domain_category_id[ll_row] = qualifier_domain_category_id
dw_qualifier_domains.object.description[ll_row] = ls_description
dw_qualifier_domains.object.exclusive_flag[ll_row] = "Y"
dw_qualifier_domains.object.status[ll_row] = "OK"

for i = 1 to ll_row
	dw_qualifier_domains.object.sort_sequence[i] = i
next

li_sts = dw_qualifier_domains.update()
if li_sts < 0 then return

dw_qualifier_domains.clear_selected()
dw_qualifier_domains.object.selected_flag[ll_row] = 1

pb_done.enabled = true

ll_qualifier_domain_id = dw_qualifier_domains.object.qualifier_domain_id[ll_row]


popup.data_row_count = 1
popup.items[1] = string(ll_qualifier_domain_id)
openwithparm(w_edit_qualifier_domain, popup)


dw_qualifiers.retrieve(ll_qualifier_domain_id)


end event

type dw_qualifier_domains from u_dw_pick_list within w_pick_qualifier_domain
int X=453
int Y=340
int Width=1248
int Height=1364
int TabOrder=30
boolean BringToTop=true
string DataObject="dw_qualifier_domain_pick_list"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

event selected;call super::selected;long ll_qualifier_domain_id

ll_qualifier_domain_id = dw_qualifier_domains.object.qualifier_domain_id[selected_row]

dw_qualifiers.retrieve(ll_qualifier_domain_id)

pb_done.enabled = true

end event

event unselected;call super::unselected;pb_done.enabled = false

end event

type dw_qualifiers from u_dw_pick_list within w_pick_qualifier_domain
int X=1851
int Y=608
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

type st_q_title from statictext within w_pick_qualifier_domain
int X=1851
int Y=528
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

type pb_1 from u_pb_help_button within w_pick_qualifier_domain
int X=2021
int Y=1596
int TabOrder=20
boolean BringToTop=true
end type

