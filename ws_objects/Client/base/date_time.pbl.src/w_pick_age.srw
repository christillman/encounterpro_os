$PBExportHeader$w_pick_age.srw
forward
global type w_pick_age from w_window_base
end type
type pb_done from u_picture_button within w_pick_age
end type
type pb_cancel from u_picture_button within w_pick_age
end type
type dw_from_age from u_dw_pick_list within w_pick_age
end type
type st_title from statictext within w_pick_age
end type
type st_from_age_title from statictext within w_pick_age
end type
type st_to_age_title from statictext within w_pick_age
end type
type dw_to_age from u_dw_pick_list within w_pick_age
end type
type cb_from_more from commandbutton within w_pick_age
end type
type cb_to_more from commandbutton within w_pick_age
end type
end forward

global type w_pick_age from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=false
long backcolor = 7191717
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
dw_from_age dw_from_age
st_title st_title
st_from_age_title st_from_age_title
st_to_age_title st_to_age_title
dw_to_age dw_to_age
cb_from_more cb_from_more
cb_to_more cb_to_more
end type
global w_pick_age w_pick_age

type variables
integer from_age
integer to_age

end variables

on w_pick_age.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_from_age=create dw_from_age
this.st_title=create st_title
this.st_from_age_title=create st_from_age_title
this.st_to_age_title=create st_to_age_title
this.dw_to_age=create dw_to_age
this.cb_from_more=create cb_from_more
this.cb_to_more=create cb_to_more
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_from_age
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_from_age_title
this.Control[iCurrent+6]=this.st_to_age_title
this.Control[iCurrent+7]=this.dw_to_age
this.Control[iCurrent+8]=this.cb_from_more
this.Control[iCurrent+9]=this.cb_to_more
end on

on w_pick_age.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_from_age)
destroy(this.st_title)
destroy(this.st_from_age_title)
destroy(this.st_to_age_title)
destroy(this.dw_to_age)
destroy(this.cb_from_more)
destroy(this.cb_to_more)
end on

event open;call super::open;str_popup popup
integer li_pos
integer i
long ll_row
integer li_day

popup = message.powerobjectparm
if len(popup.title) > 0 then
	st_title.text = popup.title
else
	st_title.text = "Select Age Range"
end if


for i = 1 to 120
	ll_row = dw_from_age.insertrow(0)
	dw_from_age.object.age[ll_row] = i
	ll_row = dw_to_age.insertrow(0)
	dw_to_age.object.age[ll_row] = i
next

string ls_temp

dw_from_age.set_page(1, ls_temp)
dw_to_age.set_page(1, ls_temp)

setnull(from_age)
setnull(to_age)

end event

type pb_done from u_picture_button within w_pick_age
int X=2560
int Y=1544
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 2
popup_return.items[1] = string(from_age)
popup_return.items[2] = string(to_age)

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_pick_age
int X=78
int Y=1544
int TabOrder=50
string PictureName="button11.bmp"
string DisabledName="button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type dw_from_age from u_dw_pick_list within w_pick_age
int X=398
int Y=320
int Width=878
int Height=1444
int TabOrder=40
boolean BringToTop=true
string DataObject="dw_age_pick"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean LiveScroll=false
end type

event selected;call super::selected;from_age = object.age[selected_row]

end event

type st_title from statictext within w_pick_age
int Width=2917
int Height=136
boolean Enabled=false
boolean BringToTop=true
string Text="Select Age Range"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-18
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_from_age_title from statictext within w_pick_age
int X=398
int Y=216
int Width=878
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="From Age"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_to_age_title from statictext within w_pick_age
int X=1577
int Y=216
int Width=878
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="To Age"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_to_age from u_dw_pick_list within w_pick_age
int X=1577
int Y=320
int Width=878
int Height=1444
int TabOrder=20
boolean BringToTop=true
string DataObject="dw_age_pick"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean LiveScroll=false
end type

event selected;call super::selected;to_age = object.age[selected_row]

end event

type cb_from_more from commandbutton within w_pick_age
int X=1294
int Y=328
int Width=192
int Height=108
int TabOrder=30
boolean BringToTop=true
string Text="More"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string ls_temp

dw_from_age.set_page(dw_from_age.current_page + 1, ls_temp)


end event

type cb_to_more from commandbutton within w_pick_age
int X=2473
int Y=328
int Width=192
int Height=108
int TabOrder=30
boolean BringToTop=true
string Text="More"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string ls_temp

dw_to_age.set_page(dw_to_age.current_page + 1, ls_temp)


end event

