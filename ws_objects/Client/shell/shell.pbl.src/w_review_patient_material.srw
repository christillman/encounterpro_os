$PBExportHeader$w_review_patient_material.srw
forward
global type w_review_patient_material from window
end type
type pb_cancel from u_picture_button within w_review_patient_material
end type
type ole_1 from olecontrol within w_review_patient_material
end type
type st_category from statictext within w_review_patient_material
end type
type st_cat from statictext within w_review_patient_material
end type
type sle_title from singlelineedit within w_review_patient_material
end type
type st_2 from statictext within w_review_patient_material
end type
type pb_ok from u_picture_button within w_review_patient_material
end type
end forward

global type w_review_patient_material from window
integer x = 5
integer y = 4
integer width = 2926
integer height = 1832
windowtype windowtype = response!
long backcolor = 33538240
event post_open ( )
pb_cancel pb_cancel
ole_1 ole_1
st_category st_category
st_cat st_cat
sle_title sle_title
st_2 st_2
pb_ok pb_ok
end type
global w_review_patient_material w_review_patient_material

type variables
Long                    material_id, material_category_id
Boolean               ib_modified = false
end variables

event post_open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:review the details of material
//
// Created By:Sumathi Chinnasamy										Creation dt: 12/19/2001
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

Blob				ole_blob
string ls_extension
integer li_sts
string ls_file

DECLARE lsp_get_patient_material PROCEDURE FOR dbo.sp_get_patient_material  
        @pi_material_id = :material_id;

Execute lsp_get_patient_material;
If Not tf_check() Then Return 

FETCH lsp_get_patient_material INTO :sle_title.text,:material_category_id,:st_category.text;
If Not tf_check() Then Return 

Close lsp_get_patient_material;
//This actually loads the ole control from the database into a blob variable
Selectblob object  into :ole_blob 
	From c_patient_material
 	Where material_id = :material_id;

If Len(ole_blob) = 0 Then 
	pb_cancel.Event Clicked()
	Return
End If

SELECT extension
INTO :ls_extension
FROM c_Patient_Material
WHERE material_id = :material_id;
if not tf_check() then return 

ls_file = f_temp_file(ls_extension)
li_sts = log.file_write(ole_blob, ls_file)

ole_1.insertfile(ls_file)
end event

on w_review_patient_material.create
this.pb_cancel=create pb_cancel
this.ole_1=create ole_1
this.st_category=create st_category
this.st_cat=create st_cat
this.sle_title=create sle_title
this.st_2=create st_2
this.pb_ok=create pb_ok
this.Control[]={this.pb_cancel,&
this.ole_1,&
this.st_category,&
this.st_cat,&
this.sle_title,&
this.st_2,&
this.pb_ok}
end on

on w_review_patient_material.destroy
destroy(this.pb_cancel)
destroy(this.ole_1)
destroy(this.st_category)
destroy(this.st_cat)
destroy(this.sle_title)
destroy(this.st_2)
destroy(this.pb_ok)
end on

event open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:review the details of material
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup	popup

popup = Message.Powerobjectparm
material_id = long(popup.item)
postevent("post_open")

end event

type pb_cancel from u_picture_button within w_review_patient_material
integer x = 69
integer y = 1512
integer taborder = 40
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Cancel the operation
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type ole_1 from olecontrol within w_review_patient_material
integer x = 59
integer y = 292
integer width = 2793
integer height = 1156
integer taborder = 20
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_review_patient_material.win"
omdisplaytype displaytype = displayascontent!
omcontentsallowed contentsallowed = containsany!
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:review the details of material
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/09/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

integer result

result = ole_1.Activate(OffSite!)
If result < 0 Then
	log.log(this,"doubleclicked","Ole Error: "+String(result)+". Unable to "+&
					"open file "+sle_title.text,4)
End If
end event

event constructor;resizable = false
end event

event save;ib_modified = true
end event

type st_category from statictext within w_review_patient_material
integer x = 1787
integer y = 120
integer width = 1019
integer height = 120
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return

popup.dataobject = "dw_material_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return
If material_category_id = Long(popup_return.items[1]) Then Return

material_category_id = Long(popup_return.items[1])
Text = popup_return.descriptions[1]
ib_modified = true

end event

type st_cat from statictext within w_review_patient_material
integer x = 2194
integer y = 36
integer width = 293
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Category:"
boolean focusrectangle = false
end type

type sle_title from singlelineedit within w_review_patient_material
integer x = 55
integer y = 112
integer width = 1678
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event modified;ib_modified = true
end event

type st_2 from statictext within w_review_patient_material
integer x = 864
integer y = 24
integer width = 160
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Title:"
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_review_patient_material
integer x = 2459
integer y = 1524
integer taborder = 30
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Update the material data.
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

Long             ll_material_id
Blob             ole_data
Integer          li_id
str_popup_return popup_return

DECLARE lsp_insert_patient_material PROCEDURE FOR dbo.sp_insert_patient_material  
        @ps_title = :sle_title.text,   
        @pi_category_id = :material_category_id,   
        @pi_material_id = :li_id OUT;

ll_material_id = material_id
If ib_modified Then
//	Set the previous record status as 'NA'
	Update c_patient_material
		Set status = 'NA'
		Where material_id = :material_id;

	If Not tf_check() Then GOTO nextstep
	Commit using SQLCA;
	
	Execute lsp_insert_patient_material;
	If tf_check() Then 

		Fetch lsp_insert_patient_material  Into :ll_material_id;
		If Not tf_check() Then GOTO closeproc

		Close lsp_insert_patient_material;
		Commit Using SQLCA;

		// Update the blob column
		ole_data = ole_1.objectdata
		UpdateBlob c_patient_material
			Set object = :ole_data 
			Where material_id = :ll_material_id;
	
		If tf_check() Then
			// Commit the transaction
			Commit Using SQLCA;
		End If
		GOTO nextstep
	End If
   closeproc:
	Close lsp_insert_patient_material;
End If
nextstep:
// Close the window
popup_return.item_count = 1
popup_return.item = string(ll_material_id)
popup_return.items[1] = sle_title.text

Closewithreturn(parent, popup_return)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
01w_review_patient_material.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11w_review_patient_material.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
