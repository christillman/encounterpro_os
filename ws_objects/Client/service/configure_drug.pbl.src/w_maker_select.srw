$PBExportHeader$w_maker_select.srw
forward
global type w_maker_select from w_window_base
end type
type pb_done from u_picture_button within w_maker_select
end type
type pb_cancel from u_picture_button within w_maker_select
end type
type dw_makers from u_dw_pick_list within w_maker_select
end type
type st_title from statictext within w_maker_select
end type
end forward

global type w_maker_select from w_window_base
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
dw_makers dw_makers
st_title st_title
end type
global w_maker_select w_maker_select

type variables
u_ds_data makers

string vaccine_id


end variables

forward prototypes
public function integer load_makers ()
public function integer save_makers ()
end prototypes

public function integer load_makers ();integer li_sts
integer i
string ls_find
string ls_maker_id
long ll_row

dw_makers.multiselect = true
dw_makers.settransobject(sqlca)
dw_makers.retrieve()

makers.set_database(sqlca)
li_sts = makers.retrieve(vaccine_id)
if li_sts < 0 then
	log.log(this, "w_maker_select.load_makers:0014", "Error retrieving makers", 4)
	return -1
end if

for i = 1 to makers.rowcount()
	ls_maker_id = makers.object.maker_id[i]
	ls_find = "maker_id='" + ls_maker_id + "'"
	ll_row = dw_makers.find(ls_find, 1, dw_makers.rowcount())
	if ll_row <= 0 then continue
	dw_makers.object.selected_flag[ll_row] = 1
	dw_makers.object.original_selected_flag[ll_row] = 1
next


return li_sts

end function

public function integer save_makers ();integer i
long ll_row
integer li_selected_flag
integer li_original_selected_flag
string ls_maker_id
string ls_find
integer li_sts

for i = 1 to dw_makers.rowcount()
	li_selected_flag = dw_makers.object.selected_flag[i]
	li_original_selected_flag = dw_makers.object.original_selected_flag[i]
	ls_maker_id = dw_makers.object.maker_id[i]
	
	if li_selected_flag = 0 and li_original_selected_flag > 0 then
		ls_find = "maker_id='" + ls_maker_id + "'"
		ll_row = makers.find(ls_find, 1, makers.rowcount())
		if ll_row <= 0 then continue
		makers.deleterow(ll_row)
	elseif li_selected_flag > 0 and li_original_selected_flag = 0 then
		ll_row = makers.insertrow(0)
		makers.object.vaccine_id[ll_row] = vaccine_id
		makers.object.maker_id[ll_row] = ls_maker_id
	end if
next

li_sts = makers.update()

return li_sts

end function

on w_maker_select.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_makers=create dw_makers
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_makers
this.Control[iCurrent+4]=this.st_title
end on

on w_maker_select.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_makers)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count < 2 then
	log.log(this, "w_maker_select:open", "Invalid parameters", 4)
	close(this)
	return
end if

st_title.text = popup.title + " Makers"

makers = CREATE u_ds_data

if popup.items[1] = "VACCINE" then
	vaccine_id = popup.items[2]
	makers.dataobject = "dw_vaccine_maker_data"
else
	// For later when drug makers are implemented
	//ls_query = "SELECT drug_id, package_id, maker_id FROM c_Drug_Package_Maker WHERE drug_id = '" + popup.items[2] + "'"
end if

li_sts = load_makers()
if li_sts < 0 then
	log.log(this, "w_maker_select:open", "Error loading makers", 4)
	close(this)
	return
end if

end event

type pb_done from u_picture_button within w_maker_select
int X=2569
int Y=1552
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;integer li_sts

li_sts = save_makers()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error Saving Makers")
	return
end if

close(parent)
return

end event

type pb_cancel from u_picture_button within w_maker_select
int X=82
int Y=1552
int TabOrder=20
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;close(parent)
return

end event

type dw_makers from u_dw_pick_list within w_maker_select
int X=942
int Y=192
int Width=1179
int Height=1540
int TabOrder=10
boolean BringToTop=true
string DataObject="dw_maker_pick_list"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

type st_title from statictext within w_maker_select
int Width=2912
int Height=160
boolean Enabled=false
boolean BringToTop=true
string Text="Rotovirus Makers"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-16
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

