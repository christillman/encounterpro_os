$PBExportHeader$w_twain_scanner.srw
forward
global type w_twain_scanner from w_window_base
end type
type st_1 from statictext within w_twain_scanner
end type
type st_scan_into_title from statictext within w_twain_scanner
end type
type st_one_document from statictext within w_twain_scanner
end type
type st_separate_documents from statictext within w_twain_scanner
end type
type cb_start_scanning from commandbutton within w_twain_scanner
end type
type cb_cancel from commandbutton within w_twain_scanner
end type
type cb_setup from commandbutton within w_twain_scanner
end type
type ole_twain_scanner from u_twain_scanner within w_twain_scanner
end type
type cb_select_scanner from commandbutton within w_twain_scanner
end type
type st_2 from statictext within w_twain_scanner
end type
type st_show_setup from statictext within w_twain_scanner
end type
end forward

global type w_twain_scanner from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_scan_into_title st_scan_into_title
st_one_document st_one_document
st_separate_documents st_separate_documents
cb_start_scanning cb_start_scanning
cb_cancel cb_cancel
cb_setup cb_setup
ole_twain_scanner ole_twain_scanner
cb_select_scanner cb_select_scanner
st_2 st_2
st_show_setup st_show_setup
end type
global w_twain_scanner w_twain_scanner

type variables
u_component_observation component

boolean seperate_documents
boolean show_setup
end variables

forward prototypes
public subroutine start_scanning ()
end prototypes

public subroutine start_scanning ();//Private Sub CmdTemplate_Click()
//    ImgScan1.ScanTo = UseFileTemplateOnly '4
//    'Set the image property to a template name.
//    ImgScan1.Image = "C:\image2\img"
//    'MultiPage property must be set to true in order to create 
//    'files with more than one page.
//    ImgScan1.MultiPage = True
//    'Create 3 page image files.
//    ImgScan1.PageCount = 3
//    'Do not show the scanner's TWAIN UI.
//    ImgScan1.ShowSetupBeforeScan = False
//    'Scan without using dialog box.
//    ImgScan1.StartScan 
//End Sub
//    'Use the ImgAdmin control to select a file for display
//    'in the ImgEdit control.
//    ImgAdmin1.ShowFileDialog OpenDlg  '0
//    ImgEdit1.Image = ImgAdmin1.Image
//    ImgEdit1.Display
//    'For insert or append, set the Scan control's 
//    'Image property.
//    ImgScan1.Image = ImgAdmin1.Image
//    'MultiPage must be set to True in order to create
//    'files with more than one page.
//    ImgScan1.MultiPage = True
//    ImgScan1.PageOption = InsertPages '3
//    ImgScan1.Page = 1
//    ImgScan1.FileType = TIFF '1
//    'Scan using the Scan Page dialog box.
//    ImgScan1.ShowScanPage
//

string ls_file_template
string ls_file_search

str_file_attributes lstra_files[]
long ll_file_count
long i
str_popup_return popup_return

// 4 = UseFileTemplateOnly
ole_twain_scanner.object.ScanTo = 4

// construct the template and make sure there aren't any files which match it
ls_file_template = left("x" + string(computer_id) + "____", 4)
ls_file_search = temp_path + "\" + ls_file_template + "*.*"
ll_file_count = log.directory_list(ls_file_search, lstra_files)
for i = 1 to ll_file_count
	filedelete(temp_path + "\" + lstra_files[i].filename)
next

//Set the image property to a template name.
ole_twain_scanner.object.Image = temp_path + "\" + ls_file_template

ole_twain_scanner.object.PageOption = 0

ole_twain_scanner.object.MultiPage = (not seperate_documents)

//Do not show the scanner's TWAIN UI.
ole_twain_scanner.object.ShowSetupBeforeScan = show_setup

//Scan without using dialog box.
ole_twain_scanner.object.StartScan()

// Now see how many files were created
popup_return.item_count = log.directory_list(ls_file_search, lstra_files)
for i = 1 to popup_return.item_count
	popup_return.items[i] = temp_path + "\" + lstra_files[i].filename
next

if popup_return.item_count > 0 then
	closewithreturn(this, popup_return)
end if


end subroutine

on w_twain_scanner.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_scan_into_title=create st_scan_into_title
this.st_one_document=create st_one_document
this.st_separate_documents=create st_separate_documents
this.cb_start_scanning=create cb_start_scanning
this.cb_cancel=create cb_cancel
this.cb_setup=create cb_setup
this.ole_twain_scanner=create ole_twain_scanner
this.cb_select_scanner=create cb_select_scanner
this.st_2=create st_2
this.st_show_setup=create st_show_setup
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_scan_into_title
this.Control[iCurrent+3]=this.st_one_document
this.Control[iCurrent+4]=this.st_separate_documents
this.Control[iCurrent+5]=this.cb_start_scanning
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_setup
this.Control[iCurrent+8]=this.ole_twain_scanner
this.Control[iCurrent+9]=this.cb_select_scanner
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_show_setup
end on

on w_twain_scanner.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_scan_into_title)
destroy(this.st_one_document)
destroy(this.st_separate_documents)
destroy(this.cb_start_scanning)
destroy(this.cb_cancel)
destroy(this.cb_setup)
destroy(this.ole_twain_scanner)
destroy(this.cb_select_scanner)
destroy(this.st_2)
destroy(this.st_show_setup)
end on

event open;call super::open;string ls_temp,ls_external_source,ls_external_source_description

component = message.powerobjectparm

ls_external_source = component.get_attribute("external_source")
if isnull(ls_external_source) then
	log.log(this, "w_twain_scanner.open.0007", "External source not found", 4)
	return -1
end if

SELECT description
INTO :ls_external_source_description
FROM c_External_Source
WHERE external_source = :ls_external_source;

If Not isnull(ls_external_source_description) Then
	st_1.text = ls_external_source_description
End If
ls_temp = component.get_attribute("seperate_documents")
if isnull(ls_temp) then
	seperate_documents = true
else
	seperate_documents = f_string_to_boolean(ls_temp)
end if

ls_temp = component.get_attribute("show_setup")
if isnull(ls_temp) then
	show_setup = true
else
	show_setup = f_string_to_boolean(ls_temp)
end if
if show_setup then
	st_show_setup.text = "Yes"
else
	st_show_setup.text = "No"
end if
	
if seperate_documents then
	st_separate_documents.backcolor = color_object_selected
else
	st_one_document.backcolor = color_object_selected
end if

postevent("post_open")

end event

event post_open;call super::post_open;boolean lb_scanner_available
str_popup_return popup_return

popup_return.item_count = 0

lb_scanner_available = ole_twain_scanner.object.scanneravailable()

if not lb_scanner_available then
	openwithparm(w_pop_message, "No TWAIN compatible scanner exists on this workstation")
	closewithreturn(this, popup_return)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_twain_scanner
end type

type st_1 from statictext within w_twain_scanner
integer width = 2903
integer height = 156
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "TWAIN Compatible Device"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_scan_into_title from statictext within w_twain_scanner
integer x = 1221
integer y = 340
integer width = 462
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Download to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_one_document from statictext within w_twain_scanner
integer x = 750
integer y = 452
integer width = 677
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Single Document"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;seperate_documents = false
backcolor = color_object_selected
st_separate_documents.backcolor = color_object

end event

type st_separate_documents from statictext within w_twain_scanner
integer x = 1486
integer y = 452
integer width = 677
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Separate Documents"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;seperate_documents = true
backcolor = color_object_selected
st_one_document.backcolor = color_object

end event

type cb_start_scanning from commandbutton within w_twain_scanner
integer x = 1065
integer y = 868
integer width = 768
integer height = 188
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start DownLoad"
end type

event clicked;start_scanning()

end event

type cb_cancel from commandbutton within w_twain_scanner
integer x = 297
integer y = 1436
integer width = 681
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_setup from commandbutton within w_twain_scanner
integer x = 1925
integer y = 1436
integer width = 681
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = " Preferences"
end type

event clicked;ole_twain_scanner.object.showscanpreferences()

end event

type ole_twain_scanner from u_twain_scanner within w_twain_scanner
boolean visible = false
integer x = 261
integer y = 932
integer width = 1317
integer height = 768
integer taborder = 20
boolean bringtotop = true
string binarykey = "w_twain_scanner.win"
end type

type cb_select_scanner from commandbutton within w_twain_scanner
integer x = 1111
integer y = 1436
integer width = 713
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Twain device"
end type

event clicked;ole_twain_scanner.object.showselectscanner()

end event

type st_2 from statictext within w_twain_scanner
integer x = 1120
integer y = 728
integer width = 398
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Setup:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_show_setup from statictext within w_twain_scanner
integer x = 1536
integer y = 708
integer width = 229
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if show_setup then
	show_setup = false
	text = "No"
else
	show_setup = true
	text = "Yes"
end if

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
09w_twain_scanner.bin 
2800000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000726bdc4001c26ee600000003000000800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff0000000384926ca0101c2941600e6f817f4b111300000000726a55a001c26ee6726bdc4001c26ee6000000000000000000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffff00000004ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0200000100000008000000000000000000000000001bb6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000034f0000034f0000000000fffeff00fffeff000000017fff0001000100000000000000010001001a000500000000c80000000000014200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000003a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19w_twain_scanner.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
