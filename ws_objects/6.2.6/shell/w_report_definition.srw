HA$PBExportHeader$w_report_definition.srw
forward
global type w_report_definition from w_window_full_response
end type
type st_title from statictext within w_report_definition
end type
type sle_description from singlelineedit within w_report_definition
end type
type st_description from statictext within w_report_definition
end type
type sle_report_class from singlelineedit within w_report_definition
end type
type st_report_class from statictext within w_report_definition
end type
type sle_setup_class from singlelineedit within w_report_definition
end type
type st_setup_class from statictext within w_report_definition
end type
type sle_ui_class from singlelineedit within w_report_definition
end type
type st_ui_class from statictext within w_report_definition
end type
type st_report_type from statictext within w_report_definition
end type
type st_report_type_title from statictext within w_report_definition
end type
end forward

global type w_report_definition from w_window_full_response
st_title st_title
sle_description sle_description
st_description st_description
sle_report_class sle_report_class
st_report_class st_report_class
sle_setup_class sle_setup_class
st_setup_class st_setup_class
sle_ui_class sle_ui_class
st_ui_class st_ui_class
st_report_type st_report_type
st_report_type_title st_report_type_title
end type
global w_report_definition w_report_definition

type variables
string report_id
string report_type

end variables

on w_report_definition.create
int iCurrent
call super::create
this.st_title=create st_title
this.sle_description=create sle_description
this.st_description=create st_description
this.sle_report_class=create sle_report_class
this.st_report_class=create st_report_class
this.sle_setup_class=create sle_setup_class
this.st_setup_class=create st_setup_class
this.sle_ui_class=create sle_ui_class
this.st_ui_class=create st_ui_class
this.st_report_type=create st_report_type
this.st_report_type_title=create st_report_type_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.sle_description
this.Control[iCurrent+3]=this.st_description
this.Control[iCurrent+4]=this.sle_report_class
this.Control[iCurrent+5]=this.st_report_class
this.Control[iCurrent+6]=this.sle_setup_class
this.Control[iCurrent+7]=this.st_setup_class
this.Control[iCurrent+8]=this.sle_ui_class
this.Control[iCurrent+9]=this.st_ui_class
this.Control[iCurrent+10]=this.st_report_type
this.Control[iCurrent+11]=this.st_report_type_title
end on

on w_report_definition.destroy
call super::destroy
destroy(this.st_title)
destroy(this.sle_description)
destroy(this.st_description)
destroy(this.sle_report_class)
destroy(this.st_report_class)
destroy(this.sle_setup_class)
destroy(this.st_setup_class)
destroy(this.sle_ui_class)
destroy(this.st_ui_class)
destroy(this.st_report_type)
destroy(this.st_report_type_title)
end on

event open;str_popup popup
integer li_sts


popup = message.powerobjectparm

if popup.data_row_count = 0 then
elseif popup.data_row_count = 1 then
	report_id = popup.items[1]


	li_sts = tf_get_report_definition(report_id, &
												 sle_description.text, &
												 sle_report_class.text, &
												 sle_setup_class.text, &
												 sle_ui_class.text )

	li_sts = tf_get_report_type(report_id, &
										 report_type, &
										 st_report_type.text)
	if isnull(report_type) then st_report_type.text = "<< Blank >>"
else
	log.log(this, "open", "Invalid Argument", 4)
	close(this)
end if


end event

type pb_done from w_window_full_response`pb_done within w_report_definition
int TabOrder=10
end type

event pb_done::clicked;call super::clicked;integer li_sts
string ls_report_class
string ls_setup_class
string ls_ui_class

ls_report_class = sle_report_class.text
ls_setup_class = sle_setup_class.text
ls_ui_class = sle_ui_class.text

if ls_report_class = "" then setnull(ls_report_class)
if ls_setup_class = "" then setnull(ls_setup_class)
if ls_ui_class = "" then setnull(ls_ui_class)

li_sts = tf_set_report_definition(report_id, &
											 sle_description.text, &
											 report_type, &
											 ls_report_class, &
											 ls_setup_class, &
											 ls_ui_class)

close(parent)

end event

type pb_cancel from w_window_full_response`pb_cancel within w_report_definition
int TabOrder=60
boolean BringToTop=true
end type

event pb_cancel::clicked;call super::clicked;close(parent)

end event

type st_title from statictext within w_report_definition
int Width=2926
int Height=164
boolean Enabled=false
boolean BringToTop=true
string Text="Report Definition"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-22
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_description from singlelineedit within w_report_definition
int X=873
int Y=344
int Width=1696
int Height=92
int TabOrder=50
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_description from statictext within w_report_definition
int X=416
int Y=356
int Width=443
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Description:"
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

type sle_report_class from singlelineedit within w_report_definition
int X=873
int Y=564
int Width=1696
int Height=92
int TabOrder=20
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_report_class from statictext within w_report_definition
int X=178
int Y=576
int Width=681
int Height=92
boolean Enabled=false
boolean BringToTop=true
string Text="Report Class:"
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

type sle_setup_class from singlelineedit within w_report_definition
int X=873
int Y=696
int Width=1696
int Height=92
int TabOrder=30
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_setup_class from statictext within w_report_definition
int X=178
int Y=708
int Width=681
int Height=92
boolean Enabled=false
boolean BringToTop=true
string Text="Setup Class:"
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

type sle_ui_class from singlelineedit within w_report_definition
int X=873
int Y=828
int Width=1696
int Height=92
int TabOrder=40
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_ui_class from statictext within w_report_definition
int X=178
int Y=840
int Width=681
int Height=92
boolean Enabled=false
boolean BringToTop=true
string Text="User Interface Class:"
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

type st_report_type from statictext within w_report_definition
int X=1120
int Y=1068
int Width=873
int Height=128
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="none"
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

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_report_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(report_type)
else
	report_type = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

type st_report_type_title from statictext within w_report_definition
int X=416
int Y=1092
int Width=681
int Height=92
boolean Enabled=false
boolean BringToTop=true
string Text="Report Type:"
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

