$PBExportHeader$w_do_material.srw
forward
global type w_do_material from w_window_base
end type
type st_1 from statictext within w_do_material
end type
type cb_complete from commandbutton within w_do_material
end type
type cb_cancel from commandbutton within w_do_material
end type
type pb_cancel from u_picture_button within w_do_material
end type
type ole_1 from olecontrol within w_do_material
end type
type pb_ok from u_picture_button within w_do_material
end type
end forward

global type w_do_material from w_window_base
integer x = 5
integer y = 4
windowtype windowtype = response!
event post_open pbm_custom01
st_1 st_1
cb_complete cb_complete
cb_cancel cb_cancel
pb_cancel pb_cancel
ole_1 ole_1
pb_ok pb_ok
end type
global w_do_material w_do_material

type variables
string                                               material_desc
u_component_service_material      service
end variables

event post_open;Integer                   li_sts
Long                      ll_material_id
Blob				           ole_blob
string ls_extension
string ls_file

service = Message.Powerobjectparm

ll_material_id = service.treatment.material_id
material_desc = service.treatment.treatment_description

//This actually loads the ole control from the database into a blob variable
Selectblob object  into :ole_blob 
	From c_patient_material
 	Where material_id = :ll_material_id;

If Len(ole_blob) = 0 Then 
	pb_cancel.Event Clicked()
	Return 0
End If

SELECT extension
INTO :ls_extension
FROM c_Patient_Material
WHERE material_id = :ll_material_id;
if not tf_check() then return -1

ls_file = f_temp_file(ls_extension)
li_sts = log.file_write(ole_blob, ls_file)

ole_1.insertfile(ls_file)

Return 1
end event

on w_do_material.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_complete=create cb_complete
this.cb_cancel=create cb_cancel
this.pb_cancel=create pb_cancel
this.ole_1=create ole_1
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_complete
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.pb_cancel
this.Control[iCurrent+5]=this.ole_1
this.Control[iCurrent+6]=this.pb_ok
end on

on w_do_material.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_complete)
destroy(this.cb_cancel)
destroy(this.pb_cancel)
destroy(this.ole_1)
destroy(this.pb_ok)
end on

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:review the details of material
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

service = Message.Powerobjectparm
If not isnull(service.treatment.end_date) then
	cb_complete.visible = false
	cb_cancel.visible = false
	pb_cancel.visible = false
	pb_ok.visible = true
End If

title = current_patient.id_line()

postevent("post_open")
end event

type st_1 from statictext within w_do_material
integer x = 69
integer y = 64
integer width = 1563
integer height = 76
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65535
long backcolor = 33538240
boolean enabled = false
string text = "Click below to open Patient Education Material ..."
boolean focusrectangle = false
end type

type cb_complete from commandbutton within w_do_material
integer x = 1490
integer y = 1392
integer width = 837
integer height = 216
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Review Completed"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
Closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_do_material
integer x = 544
integer y = 1392
integer width = 837
integer height = 216
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Review Cancelled"
end type

event clicked;str_popup_return popup_return
integer li_sts

Openwithparm(w_pop_ok, "Cancel " + material_desc + "?")

if message.doubleparm <> 1 then return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)
end event

type pb_cancel from u_picture_button within w_do_material
integer x = 37
integer y = 1484
integer taborder = 30
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:No operation
//
// Created By:Sumathi Chinnasamy										Creation dt: 05/16/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type ole_1 from olecontrol within w_do_material
integer x = 37
integer y = 160
integer width = 2816
integer height = 1184
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_do_material.win"
omdisplaytype displaytype = displayascontent!
omcontentsallowed contentsallowed = containsany!
sizemode sizemode = clip!
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:review the details of material
//
// Created By:Sumathi Chinnasamy										Creation dt: 05/16/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

integer result

result = ole_1.Activate(OffSite!)
If result < 0 Then
	log.log(this,"w_do_material.ole_1.clicked:0014","Ole Error: "+String(result)+". Unable to "+&
					"open file ",4)
End If
end event

event constructor;resizable = false
end event

type pb_ok from u_picture_button within w_do_material
boolean visible = false
integer x = 2606
integer y = 1484
integer taborder = 40
boolean originalsize = false
string picturename = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
Closewithreturn(parent, popup_return)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_do_material.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_do_material.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
