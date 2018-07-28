HA$PBExportHeader$w_pop_preference_value.srw
forward
global type w_pop_preference_value from Window
end type
type st_help from statictext within w_pop_preference_value
end type
type sle_string from singlelineedit within w_pop_preference_value
end type
type pb_cancel from u_picture_button within w_pop_preference_value
end type
type st_title from statictext within w_pop_preference_value
end type
type pb_ok from u_picture_button within w_pop_preference_value
end type
end forward

global type w_pop_preference_value from Window
int X=434
int Y=604
int Width=2245
int Height=1044
long BackColor=33538240
WindowType WindowType=response!
st_help st_help
sle_string sle_string
pb_cancel pb_cancel
st_title st_title
pb_ok pb_ok
end type
global w_pop_preference_value w_pop_preference_value

type variables
string preference_type
string user_id
string preference_id

end variables

event open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

popup_return.item_count = 0

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

preference_type = popup.items[1]
user_id = popup.items[2]
preference_id = popup.items[3]

SELECT description, help
INTO :st_title.text, :st_help.text
FROM c_Preference
WHERE preference_type = :preference_type
AND preference_id = :preference_id;
if not tf_check() then
	log.log(this, "open", "Error getting preference details", 4)
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "open", "Preference not found (" + preference_type + ", " + preference_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

	
SELECT preference_value
INTO :sle_string.text
FROM o_Preferences
WHERE preference_type = :preference_type
AND user_id = :user_id
AND preference_id = :preference_id;
if not tf_check() then
	log.log(this, "open", "Error getting preference value", 4)
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlcode = 100 then sle_string.text = ""


sle_string.setfocus()


end event

on w_pop_preference_value.create
this.st_help=create st_help
this.sle_string=create sle_string
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.pb_ok=create pb_ok
this.Control[]={this.st_help,&
this.sle_string,&
this.pb_cancel,&
this.st_title,&
this.pb_ok}
end on

on w_pop_preference_value.destroy
destroy(this.st_help)
destroy(this.sle_string)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.pb_ok)
end on

type st_help from statictext within w_pop_preference_value
int X=183
int Y=264
int Width=1865
int Height=272
boolean Enabled=false
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

type sle_string from singlelineedit within w_pop_preference_value
int X=187
int Y=584
int Width=1824
int Height=96
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
long BackColor=16777215
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_cancel from u_picture_button within w_pop_preference_value
int X=64
int Y=748
int TabOrder=20
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_pop_preference_value
int Y=4
int Width=2240
int Height=196
boolean Enabled=false
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-12
int Weight=700
string FaceName="Arial"
boolean Underline=true
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_ok from u_picture_button within w_pop_preference_value
int X=1902
int Y=764
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="button26.bmp"
boolean Default=true
end type

event clicked;call super::clicked;str_popup_return popup_return

sle_string.text = trim(sle_string.text)

if trim(sle_string.text) = "" or isnull(sle_string.text) then
	DELETE FROM o_Preferences
	WHERE preference_type = :preference_type
	AND user_id = :user_id
	AND preference_id = :preference_id;
	if not tf_check() then return
else
	UPDATE o_Preferences
	SET preference_value = :sle_string.text
	WHERE preference_type = :preference_type
	AND user_id = :user_id
	AND preference_id = :preference_id;
	if not tf_check() then return
	if sqlca.sqlnrows = 0 then
		INSERT INTO o_Preferences (
			preference_type,
			user_id,
			preference_id,
			preference_value )
		VALUES (
			:preference_type,
			:user_id,
			:preference_id,
			:sle_string.text);
		if not tf_check() then return
	end if
end if

popup_return.item_count = 1
popup_return.items[1] = sle_string.text

closewithreturn(parent, popup_return)

end event

