$PBExportHeader$w_top_20_list_edit.srw
forward
global type w_top_20_list_edit from w_window_base
end type
type pb_done from u_picture_button within w_top_20_list_edit
end type
type pb_cancel from u_picture_button within w_top_20_list_edit
end type
type uo_top_20_list_edit from u_top_20_list_edit within w_top_20_list_edit
end type
end forward

global type w_top_20_list_edit from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1920
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
uo_top_20_list_edit uo_top_20_list_edit
end type
global w_top_20_list_edit w_top_20_list_edit

type variables
string top_20_code
string description
boolean use_default
long selected_row
long proposed_row
boolean propose_list

boolean user_only = false

end variables

event open;call super::open;str_popup popup

popup = message.powerobjectparm

top_20_code = popup.item

if popup.data_row_count = 1 then
	if popup.items[1] = "USER_ONLY" then
		user_only = true
	end if
end if

postevent("post_open")


end event

on w_top_20_list_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.uo_top_20_list_edit=create uo_top_20_list_edit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.uo_top_20_list_edit
end on

on w_top_20_list_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.uo_top_20_list_edit)
end on

event post_open;call super::post_open;
uo_top_20_list_edit.user_only = user_only
uo_top_20_list_edit.initialize(top_20_code)

end event

type pb_done from u_picture_button within w_top_20_list_edit
int X=2619
int Y=1648
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;uo_top_20_list_edit.save_changes()

close(parent)

end event

type pb_cancel from u_picture_button within w_top_20_list_edit
int X=2619
int Y=1336
int TabOrder=20
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
end type

event clicked;
close(parent)

end event

type uo_top_20_list_edit from u_top_20_list_edit within w_top_20_list_edit
int X=0
int Y=0
int Height=1916
int TabOrder=10
boolean BringToTop=true
end type

on uo_top_20_list_edit.destroy
call u_top_20_list_edit::destroy
end on

