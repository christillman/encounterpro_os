$PBExportHeader$u_package_description.sru
forward
global type u_package_description from userobject
end type
type st_form_title from statictext within u_package_description
end type
type st_dosage_form from statictext within u_package_description
end type
type st_strength_title from statictext within u_package_description
end type
type st_strength from statictext within u_package_description
end type
type st_package_name from statictext within u_package_description
end type
type st_name_title from statictext within u_package_description
end type
end forward

global type u_package_description from userobject
integer width = 1477
integer height = 800
boolean border = true
long backcolor = 33538240
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_form_title st_form_title
st_dosage_form st_dosage_form
st_strength_title st_strength_title
st_strength st_strength
st_package_name st_package_name
st_name_title st_name_title
end type
global u_package_description u_package_description

type variables
string package_id
string package_description
string administer_unit
string dose_unit
real administer_per_dose
string dosage_form
real dose_amount
string dosage_form_description
string dosage_form_abbreviation

end variables

forward prototypes
public function integer set_package (string ps_package_id)
end prototypes

public function integer set_package (string ps_package_id);string ls_temp
string ls_strength

package_id = ps_package_id

if isnull(package_id) then
	st_package_name.text = ""
	st_dosage_form.text = ""
	st_strength.text = ""
	return 0
end if
// administer_method no longer part of package
SELECT c_Package.description,   
		c_Package.administer_unit,   
		c_Package.dose_unit,   
		c_Package.administer_per_dose,   
		c_Package.dosage_form,   
		c_Package.dose_amount,   
		c_Dosage_Form.description,   
		c_Dosage_Form.abbreviation  
 INTO:package_description,   
		:administer_unit,   
		:dose_unit,   
		:administer_per_dose,   
		:dosage_form,   
		:dose_amount, 
		:dosage_form_description,   
		:dosage_form_abbreviation  
 FROM c_Package   
LEFT JOIN c_Dosage_Form  ON c_Package.dosage_form = c_Dosage_Form.dosage_form
WHERE c_Package.package_id = :package_id   ;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_package_description.set_package:0042", "Package not found (" + package_id + ")", 4)
	setnull(package_id)
	st_package_name.text = ""
	st_dosage_form.text = ""
	st_strength.text = ""
	return 0
end if

st_package_name.text = package_description
st_dosage_form.text = dosage_form_description

if isnull(dose_amount) then dose_amount = 1

ls_temp = f_pretty_amount_unit(dose_amount, dose_unit)
st_strength.text = "Each " + ls_temp
ls_temp = f_pretty_amount_unit(administer_per_dose, administer_unit)
st_strength.text += " Contains " + ls_temp + " of drug"

return 1



end function

on u_package_description.create
this.st_form_title=create st_form_title
this.st_dosage_form=create st_dosage_form
this.st_strength_title=create st_strength_title
this.st_strength=create st_strength
this.st_package_name=create st_package_name
this.st_name_title=create st_name_title
this.Control[]={this.st_form_title,&
this.st_dosage_form,&
this.st_strength_title,&
this.st_strength,&
this.st_package_name,&
this.st_name_title}
end on

on u_package_description.destroy
destroy(this.st_form_title)
destroy(this.st_dosage_form)
destroy(this.st_strength_title)
destroy(this.st_strength)
destroy(this.st_package_name)
destroy(this.st_name_title)
end on

type st_form_title from statictext within u_package_description
integer x = 14
integer y = 432
integer width = 512
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
string text = "Dosage Form:"
boolean focusrectangle = false
end type

type st_dosage_form from statictext within u_package_description
integer x = 14
integer y = 508
integer width = 1426
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_strength_title from statictext within u_package_description
integer x = 14
integer y = 168
integer width = 512
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
string text = "Strength:"
boolean focusrectangle = false
end type

type st_strength from statictext within u_package_description
integer x = 14
integer y = 244
integer width = 1426
integer height = 168
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_package_name from statictext within u_package_description
integer x = 14
integer y = 80
integer width = 1426
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_name_title from statictext within u_package_description
integer x = 14
integer y = 4
integer width = 512
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Package Name:"
boolean focusrectangle = false
end type

