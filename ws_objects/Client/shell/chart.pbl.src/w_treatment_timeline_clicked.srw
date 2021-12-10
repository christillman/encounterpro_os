$PBExportHeader$w_treatment_timeline_clicked.srw
forward
global type w_treatment_timeline_clicked from w_window_base
end type
type pb_done from u_picture_button within w_treatment_timeline_clicked
end type
type pb_cancel from u_picture_button within w_treatment_timeline_clicked
end type
type dw_treatments from u_dw_pick_list within w_treatment_timeline_clicked
end type
type st_no_treatments from statictext within w_treatment_timeline_clicked
end type
end forward

global type w_treatment_timeline_clicked from w_window_base
int X=480
int Y=156
int Width=1979
int Height=1112
WindowType WindowType=response!
boolean TitleBar=false
long backcolor = 7191717
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
dw_treatments dw_treatments
st_no_treatments st_no_treatments
end type
global w_treatment_timeline_clicked w_treatment_timeline_clicked

type variables
long problem_id
string assessment_id

str_treatment_description treatments[]

end variables

on w_treatment_timeline_clicked.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_treatments=create dw_treatments
this.st_no_treatments=create st_no_treatments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_treatments
this.Control[iCurrent+4]=this.st_no_treatments
end on

on w_treatment_timeline_clicked.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_treatments)
destroy(this.st_no_treatments)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer i
integer ll_rows
date ld_selected_date

popup_return.item_count = 0

popup = message.powerobjectparm

if popup.data_row_count <> 4 then
	log.log(this, "w_treatment_timeline_clicked:open", "Invalid Arguments", 4)
	closewithreturn(this, popup_return)
	return
end if

problem_id = long(popup.items[1])
assessment_id = popup.items[2]

treatments = popup.anyparm


ll_rows = upperbound(treatments)

if ll_rows <= 0 then
	dw_treatments.visible = false
	st_no_treatments.visible = true
	st_no_treatments.text = "There were no treatments for " + popup.items[3] + " on " + popup.items[4]
else
	st_no_treatments.visible = false
	for i = 1 to ll_rows
		dw_treatments.object.treatment_id[i] = treatments[i].treatment_id
		dw_treatments.object.treatment_type[i] = treatments[i].treatment_type
		dw_treatments.object.treatment_description[i] = treatments[i].treatment_description
		dw_treatments.object.begin_date[i] = treatments[i].begin_date
		dw_treatments.object.end_date[i] = treatments[i].end_date
		dw_treatments.object.treatment_status[i] = treatments[i].treatment_status
		if treatments[i].color > 0 then dw_treatments.object.color[i] = treatments[i].color
	next
end if


end event

type pb_done from u_picture_button within w_treatment_timeline_clicked
int X=1678
int Y=856
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_treatment_timeline_clicked
int X=1824
int Y=800
int TabOrder=30
boolean Visible=false
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type dw_treatments from u_dw_pick_list within w_treatment_timeline_clicked
int X=27
int Y=24
int Width=1609
int Height=1052
int TabOrder=20
boolean BringToTop=true
string DataObject="dw_treatment_descriptions_display"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

type st_no_treatments from statictext within w_treatment_timeline_clicked
int X=133
int Y=288
int Width=1710
int Height=300
boolean Enabled=false
boolean BringToTop=true
string Text="There were no treatments on 99/99/9999"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

