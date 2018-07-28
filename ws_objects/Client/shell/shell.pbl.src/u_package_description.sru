$PBExportHeader$u_package_description.sru
forward
global type u_package_description from UserObject
end type
type st_admin_title from statictext within u_package_description
end type
type st_admin_method from statictext within u_package_description
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

global type u_package_description from UserObject
int Width=1477
int Height=800
boolean Border=true
long BackColor=33538240
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
st_admin_title st_admin_title
st_admin_method st_admin_method
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
string administer_method
string package_description
string administer_unit
string dose_unit
real administer_per_dose
string dosage_form
real dose_amount
string admin_method_description
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
	st_admin_method.text = ""
	st_dosage_form.text = ""
	st_strength.text = ""
	return 0
end if

SELECT c_Package.administer_method,   
		c_Package.description,   
		c_Package.administer_unit,   
		c_Package.dose_unit,   
		c_Package.administer_per_dose,   
		c_Package.dosage_form,   
		c_Package.dose_amount,   
		c_Administration_Method.description,   
		c_Dosage_Form.description,   
		c_Dosage_Form.abbreviation  
 INTO :administer_method,   
		:package_description,   
		:administer_unit,   
		:dose_unit,   
		:administer_per_dose,   
		:dosage_form,   
		:dose_amount,   
		:admin_method_description,   
		:dosage_form_description,   
		:dosage_form_abbreviation  
 FROM c_Package,   
		c_Administration_Method,   
		c_Dosage_Form  
WHERE ( c_Package.administer_method = c_Administration_Method.administer_method ) and  
		( c_Package.dosage_form = c_Dosage_Form.dosage_form ) and  
		( ( c_Package.package_id = :package_id ) )   ;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "set_package()", "Package not found (" + package_id + ")", 4)
	setnull(package_id)
	st_package_name.text = ""
	st_admin_method.text = ""
	st_dosage_form.text = ""
	st_strength.text = ""
	return 0
end if


st_package_name.text = package_description
st_admin_method.text = admin_method_description
st_dosage_form.text = dosage_form_description

if isnull(dose_amount) then dose_amount = 1

ls_temp = f_pretty_amount_unit(dose_amount, dose_unit)
st_strength.text = "Each " + ls_temp
ls_temp = f_pretty_amount_unit(administer_per_dose, administer_unit)
st_strength.text += " Contains " + ls_temp + " of drug"

return 1



end function

on u_package_description.create
this.st_admin_title=create st_admin_title
this.st_admin_method=create st_admin_method
this.st_form_title=create st_form_title
this.st_dosage_form=create st_dosage_form
this.st_strength_title=create st_strength_title
this.st_strength=create st_strength
this.st_package_name=create st_package_name
this.st_name_title=create st_name_title
this.Control[]={this.st_admin_title,&
this.st_admin_method,&
this.st_form_title,&
this.st_dosage_form,&
this.st_strength_title,&
this.st_strength,&
this.st_package_name,&
this.st_name_title}
end on

on u_package_description.destroy
destroy(this.st_admin_title)
destroy(this.st_admin_method)
destroy(this.st_form_title)
destroy(this.st_dosage_form)
destroy(this.st_strength_title)
destroy(this.st_strength)
destroy(this.st_package_name)
destroy(this.st_name_title)
end on

type st_admin_title from statictext within u_package_description
int X=14
int Y=604
int Width=512
int Height=76
boolean Enabled=false
string Text="Admin Method:"
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

type st_admin_method from statictext within u_package_description
int X=14
int Y=680
int Width=1426
int Height=76
boolean Enabled=false
boolean Border=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_form_title from statictext within u_package_description
int X=14
int Y=432
int Width=512
int Height=76
boolean Enabled=false
string Text="Dosage Form:"
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

type st_dosage_form from statictext within u_package_description
int X=14
int Y=508
int Width=1426
int Height=76
boolean Enabled=false
boolean Border=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_strength_title from statictext within u_package_description
int X=14
int Y=168
int Width=512
int Height=76
boolean Enabled=false
string Text="Strength:"
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

type st_strength from statictext within u_package_description
int X=14
int Y=244
int Width=1426
int Height=168
boolean Enabled=false
boolean Border=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_package_name from statictext within u_package_description
int X=14
int Y=80
int Width=1426
int Height=76
boolean Enabled=false
boolean Border=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_name_title from statictext within u_package_description
int X=14
int Y=4
int Width=512
int Height=72
boolean Enabled=false
string Text="Package Name:"
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

