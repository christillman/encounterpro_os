$PBExportHeader$u_st_observation_status.sru
forward
global type u_st_observation_status from statictext
end type
end forward

global type u_st_observation_status from statictext
integer width = 608
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Development"
alignment alignment = center!
boolean focusrectangle = false
boolean disabledlook = true
end type
global u_st_observation_status u_st_observation_status

type variables
string observation_id
string display_service

end variables

forward prototypes
public function integer initialize (string ps_observation_id, string ps_display_service)
public function integer refresh ()
end prototypes

public function integer initialize (string ps_observation_id, string ps_display_service);u_ds_observation_results luo_data
long ll_count

observation_id = ps_observation_id
display_service = ps_display_service

text = datalist.observation_description(observation_id)

return 1

end function

public function integer refresh ();u_ds_observation_results luo_data
long ll_count

luo_data = CREATE u_ds_observation_results
luo_data.set_dataobject("dw_sp_obstree_patient")

ll_count = luo_data.retrieve(current_patient.cpr_id, observation_id)

if luo_data.any_abnormal() then
	textcolor = color_text_error
else
	textcolor = color_text_normal
end if

DESTROY luo_data

return 1

end function

on u_st_observation_status.create
end on

on u_st_observation_status.destroy
end on

event clicked;str_attributes lstr_attributes

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "observation_id"
lstr_attributes.attribute[1].value = observation_id

service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, display_service, lstr_attributes)

refresh()

end event

