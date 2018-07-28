HA$PBExportHeader$u_tabpage_drug_mappings.sru
forward
global type u_tabpage_drug_mappings from u_tabpage_drug_base
end type
type sle_ndc_code from singlelineedit within u_tabpage_drug_mappings
end type
type st_ndc_code_title from statictext within u_tabpage_drug_mappings
end type
end forward

global type u_tabpage_drug_mappings from u_tabpage_drug_base
sle_ndc_code sle_ndc_code
st_ndc_code_title st_ndc_code_title
end type
global u_tabpage_drug_mappings u_tabpage_drug_mappings

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();long ll_count

if lower(drug_tab.drug.drug_type) = "vaccine" &
 or lower(drug_tab.drug.drug_type) = "compound drug" &
 or lower(drug_tab.drug.drug_type) = "single drug" then
	visible = true
else
	visible = false
	return 1
end if

//dw_makers.height = height
//dw_makers.width = 1376
//
//dw_makers.settransobject(sqlca)

return 1

end function

public subroutine refresh ();sle_ndc_code.text = drug_tab.drug.reference_ndc_code
end subroutine

on u_tabpage_drug_mappings.create
int iCurrent
call super::create
this.sle_ndc_code=create sle_ndc_code
this.st_ndc_code_title=create st_ndc_code_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ndc_code
this.Control[iCurrent+2]=this.st_ndc_code_title
end on

on u_tabpage_drug_mappings.destroy
call super::destroy
destroy(this.sle_ndc_code)
destroy(this.st_ndc_code_title)
end on

type sle_ndc_code from singlelineedit within u_tabpage_drug_mappings
integer x = 846
integer y = 452
integer width = 457
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;if len(sle_ndc_code.text) > 0 then
	drug_tab.drug.reference_ndc_code = sle_ndc_code.text
else
	setnull(drug_tab.drug.reference_ndc_code)
end if


end event

type st_ndc_code_title from statictext within u_tabpage_drug_mappings
integer x = 123
integer y = 476
integer width = 709
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Reference NDC Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

