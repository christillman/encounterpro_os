$PBExportHeader$u_current_meds_small.sru
forward
global type u_current_meds_small from userobject
end type
type st_meds_title from statictext within u_current_meds_small
end type
type st_meds from statictext within u_current_meds_small
end type
type st_more_meds from statictext within u_current_meds_small
end type
end forward

global type u_current_meds_small from userobject
integer width = 407
integer height = 348
long backcolor = 80269524
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event meds_clicked ( )
st_meds_title st_meds_title
st_meds st_meds
st_more_meds st_more_meds
end type
global u_current_meds_small u_current_meds_small

type variables
integer max_meds

end variables

forward prototypes
public function integer display_meds ()
end prototypes

public function integer display_meds ();Integer								i
Long									ll_count
String								ls_drug
String								ls_find
Integer								li_sts
string ls_meds
string ls_sep
integer li_drug_count
string ls_drug_id
str_drug_definition lstr_drug_definition

u_component_treatment 			luo_med
str_treatment_description 		lstra_treatments[]


/////////////////////////////////////////////////////
st_meds_title.x = 0
st_meds_title.y = 0
st_meds_title.height = 60
st_meds_title.width = width

st_meds.x = 8
st_meds.y = 64
st_meds.width = width - 18
st_meds.height = height - 96

st_more_meds.width = 137
st_more_meds.height = 60
st_more_meds.x = width - st_more_meds.width
st_more_meds.y = height - st_more_meds.height - 12

max_meds = st_meds.height / 50
/////////////////////////////////////////////////////


ls_meds = ""
ls_sep = ""
li_drug_count = 0
st_more_meds.visible = false

ls_find = "treatment_type='MEDICATION' AND ISNULL(treatment_status)"
ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)

// First display the ones with no associated assessment
FOR i = 1 TO ll_count
	if lstra_treatments[i].problem_count > 0 then continue
	
	ls_drug_id = current_patient.treatments.treatment_drug_id(lstra_treatments[i].treatment_id)
	IF isnull(ls_drug_id) THEN CONTINUE

	li_sts = drugdb.get_drug_definition( ls_drug_id, lstr_drug_definition)
	if li_sts <= 0 then
		log.log(this, "u_current_meds_small.display_meds.0053", "Drug_id not found (" + ls_drug_id + ")", 4)
		continue
	end if

	li_drug_count += 1
	if li_drug_count > max_meds then
		st_more_meds.visible = true
		EXIT
	end if
	ls_drug = left(lstr_drug_definition.common_name, integer(width / 25))
	ls_meds += ls_sep + ls_drug
	ls_sep = "~n"
NEXT

// Then display the ones with an associated assessment
FOR i = 1 TO ll_count
	if lstra_treatments[i].problem_count <= 0 then continue
	
	ls_drug_id = current_patient.treatments.treatment_drug_id(lstra_treatments[i].treatment_id)
	IF isnull(ls_drug_id) THEN CONTINUE

	li_sts = drugdb.get_drug_definition( ls_drug_id, lstr_drug_definition)
	if li_sts <= 0 then
		log.log(this, "u_current_meds_small.display_meds.0053", "Drug_id not found (" + ls_drug_id + ")", 4)
		continue
	end if

	li_drug_count += 1
	if li_drug_count > max_meds then
		st_more_meds.visible = true
		EXIT
	end if
	ls_drug = left(lstr_drug_definition.common_name, integer(width / 25))
	ls_meds += ls_sep + ls_drug
	ls_sep = "~n"
NEXT

if ls_meds = "" then ls_meds = "<No Meds>"

st_meds.text = ls_meds

DESTROY luo_med

return 1



end function

on u_current_meds_small.create
this.st_meds_title=create st_meds_title
this.st_meds=create st_meds
this.st_more_meds=create st_more_meds
this.Control[]={this.st_meds_title,&
this.st_meds,&
this.st_more_meds}
end on

on u_current_meds_small.destroy
destroy(this.st_meds_title)
destroy(this.st_meds)
destroy(this.st_more_meds)
end on

type st_meds_title from statictext within u_current_meds_small
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Meds"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_meds from statictext within u_current_meds_small
integer y = 60
integer width = 325
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Amox"
boolean focusrectangle = false
end type

event clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "current_meds_service")
if isnull(ls_service) then ls_service = "CURRENTMEDS"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_meds()

parent.event post meds_clicked()


end event

type st_more_meds from statictext within u_current_meds_small
integer x = 206
integer y = 240
integer width = 137
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = ". . ."
alignment alignment = center!
boolean focusrectangle = false
end type

