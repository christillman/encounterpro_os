$PBExportHeader$w_document_element_mapping_edit.srw
forward
global type w_document_element_mapping_edit from w_window_base
end type
type cb_finished from commandbutton within w_document_element_mapping_edit
end type
type st_1 from statictext within w_document_element_mapping_edit
end type
type cb_cancel from commandbutton within w_document_element_mapping_edit
end type
type tab_mappings from u_tab_element_sets within w_document_element_mapping_edit
end type
type tab_mappings from u_tab_element_sets within w_document_element_mapping_edit
end type
end forward

global type w_document_element_mapping_edit from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_1 st_1
cb_cancel cb_cancel
tab_mappings tab_mappings
end type
global w_document_element_mapping_edit w_document_element_mapping_edit

type variables
str_document_element_context document_element_context

str_document_elements original_document_elements


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

tab_mappings.refresh()

return 1

end function

on w_document_element_mapping_edit.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.tab_mappings=create tab_mappings
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.tab_mappings
end on

on w_document_element_mapping_edit.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.tab_mappings)
end on

event open;call super::open;long ll_element_width
long ll_row
long i
str_property_value lstr_property_value
str_attributes lstr_attributes

document_element_context = message.powerobjectparm
original_document_elements = document_element_context.document_elements

tab_mappings.initialize(document_element_context)

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_document_element_mapping_edit
integer x = 2830
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_document_element_mapping_edit
end type

type cb_finished from commandbutton within w_document_element_mapping_edit
integer x = 2405
integer y = 1584
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;

closewithreturn(parent, tab_mappings.document_elements)

end event

type st_1 from statictext within w_document_element_mapping_edit
integer width = 2894
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Document Field Mappings"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_document_element_mapping_edit
integer x = 41
integer y = 1584
integer width = 402
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

event clicked;

closewithreturn(parent, original_document_elements)

end event

type tab_mappings from u_tab_element_sets within w_document_element_mapping_edit
integer y = 112
integer width = 2894
integer height = 1444
integer taborder = 20
boolean bringtotop = true
long backcolor = COLOR_BACKGROUND
end type

