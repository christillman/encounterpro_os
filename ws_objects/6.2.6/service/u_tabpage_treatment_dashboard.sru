HA$PBExportHeader$u_tabpage_treatment_dashboard.sru
forward
global type u_tabpage_treatment_dashboard from u_tabpage
end type
type dw_treatment_prop_3 from u_dw_display within u_tabpage_treatment_dashboard
end type
type dw_treatment_body from u_dw_display within u_tabpage_treatment_dashboard
end type
type dw_treatment_prop_2 from u_dw_display within u_tabpage_treatment_dashboard
end type
type dw_treatment_prop_1 from u_dw_display within u_tabpage_treatment_dashboard
end type
type dw_treatment_header from u_dw_display within u_tabpage_treatment_dashboard
end type
end forward

global type u_tabpage_treatment_dashboard from u_tabpage
integer width = 3502
integer height = 1644
string text = "Treatment"
dw_treatment_prop_3 dw_treatment_prop_3
dw_treatment_body dw_treatment_body
dw_treatment_prop_2 dw_treatment_prop_2
dw_treatment_prop_1 dw_treatment_prop_1
dw_treatment_header dw_treatment_header
end type
global u_tabpage_treatment_dashboard u_tabpage_treatment_dashboard

type variables
u_component_treatment treatment

string datawindow_treatment_type

string header_datawindow
string body_datawindow
string prop_1_datawindow
string prop_2_datawindow
string prop_3_datawindow

string tt_preference_type = "Preferences"
string tt_preference_level = "TreatType"

string header_datawindow_preference_id = "header_datawindow"
string body_datawindow_preference_id = "body_datawindow"
string prop_1_datawindow_preference_id = "prop_1_datawindow"
string prop_2_datawindow_preference_id = "prop_2_datawindow"
string prop_3_datawindow_preference_id = "prop_3_datawindow"

long header_height
string header_datawindow_height_preference_id = "header_datawindow_height"

long prop_width
string properties_datawindow_width_preference_id = "properties_datawindow_width"


long prop1_min_height
long prop1_height_percent
long prop2_height_percent
string prop_1_datawindow_min_height_preference_id = "prop_1_datawindow_min_height"
string prop_1_datawindow_height_percent_preference_id = "prop_1_datawindow_height_percent"
string prop_2_datawindow_height_percent_preference_id = "prop_2_datawindow_height_percent"


end variables

forward prototypes
public function integer display_treatment ()
public function integer initialize (u_component_treatment puo_treatment)
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer display_treatment ();integer li_sts

if len(header_datawindow) > 0 then
	dw_treatment_header.attributes = parent_tab.service.get_attributes()
	dw_treatment_header.set_datawindow_config_object(header_datawindow)
	dw_treatment_header.refresh()
else
	dw_treatment_header.reset()
	openwithparm(w_pop_message, "No datawindow config object has been configured for this treatment type and there is no default treatment dashboard datawindow set in preferences")
end if

if len(body_datawindow) > 0 then
	dw_treatment_body.visible = true
	dw_treatment_body.attributes = parent_tab.service.get_attributes()
	dw_treatment_body.set_datawindow_config_object(body_datawindow)
	dw_treatment_body.refresh()
else
	dw_treatment_body.visible = false
end if

if len(prop_1_datawindow) > 0 then
	dw_treatment_prop_1.visible = true
	dw_treatment_prop_1.attributes = parent_tab.service.get_attributes()
	dw_treatment_prop_1.set_datawindow_config_object(prop_1_datawindow)
	dw_treatment_prop_1.refresh()
else
	dw_treatment_prop_1.visible = false
end if

if len(prop_2_datawindow) > 0 then
	dw_treatment_prop_2.visible = true
	dw_treatment_prop_2.attributes = parent_tab.service.get_attributes()
	dw_treatment_prop_2.set_datawindow_config_object(prop_2_datawindow)
	dw_treatment_prop_2.refresh()
else
	dw_treatment_prop_2.visible = false
end if

if len(prop_3_datawindow) > 0 then
	dw_treatment_prop_3.visible = true
	dw_treatment_prop_3.attributes = parent_tab.service.get_attributes()
	dw_treatment_prop_3.set_datawindow_config_object(prop_3_datawindow)
	dw_treatment_prop_3.refresh()
else
	dw_treatment_prop_3.visible = false
end if

return 1

end function

public function integer initialize (u_component_treatment puo_treatment);
//treatment = puo_treatment
//
//dw_properties.width = 1029
//dw_properties.height = height - 100
//dw_properties.x = width - dw_properties.width - 20
//dw_properties.y = 20
//
//dw_treatment.width = dw_properties.x - 20
//dw_treatment.height = height
//
return 1

end function

public function integer initialize ();string ls_temp
long ll_prop1_height
long ll_prop2_height
long ll_prop3_height

treatment = parent_tab.service.treatment
datawindow_treatment_type = treatment.treatment_type

header_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, header_datawindow_preference_id)
if isnull(header_datawindow) then
	datawindow_treatment_type = "Treatment"
	header_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, header_datawindow_preference_id)
end if

body_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, body_datawindow_preference_id)
prop_1_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_1_datawindow_preference_id)
prop_2_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_2_datawindow_preference_id)
prop_3_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_3_datawindow_preference_id)


ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, header_datawindow_height_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	header_height = long(ls_temp)
else
	header_height = height / 4
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, properties_datawindow_width_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop_width = long(ls_temp)
else
	prop_width = width / 4
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_1_datawindow_min_height_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop1_min_height = long(ls_temp)
else
	prop1_min_height = header_height
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_1_datawindow_height_percent_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop1_height_percent = long(ls_temp)
else
	prop1_height_percent = 0
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, datawindow_treatment_type, prop_2_datawindow_height_percent_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop2_height_percent = long(ls_temp)
else
	prop2_height_percent = 50
end if

dw_treatment_header.x = 0
dw_treatment_header.y = 0
dw_treatment_header.height = header_height
dw_treatment_header.width = width - prop_width

dw_treatment_body.x = 0
dw_treatment_body.y = header_height
dw_treatment_body.height = height - header_height
dw_treatment_body.width = dw_treatment_header.width

if isnull(prop_2_datawindow) then
	ll_prop1_height = height
else
	ll_prop1_height = prop1_height_percent * height / 100
	if ll_prop1_height < prop1_min_height then
		ll_prop1_height = prop1_min_height
	end if
end if

dw_treatment_prop_1.x = width - prop_width
dw_treatment_prop_1.y = 0
dw_treatment_prop_1.height = ll_prop1_height
dw_treatment_prop_1.width = prop_width

if isnull(prop_3_datawindow) then
	ll_prop2_height = height - ll_prop1_height
else
	ll_prop2_height = prop2_height_percent * height / 200
end if

dw_treatment_prop_2.x = width - prop_width
dw_treatment_prop_2.y = dw_treatment_prop_1.height
dw_treatment_prop_2.height = ll_prop2_height
dw_treatment_prop_2.width = prop_width

ll_prop3_height = height - dw_treatment_prop_2.y - dw_treatment_prop_2.height
dw_treatment_prop_3.x = width - prop_width
dw_treatment_prop_3.y = dw_treatment_prop_2.y + dw_treatment_prop_2.height
dw_treatment_prop_3.height = ll_prop3_height
dw_treatment_prop_3.width = prop_width


//
//dw_properties.width = 1029
//dw_properties.height = height - 100
//dw_properties.x = width - dw_properties.width - 20
//dw_properties.y = 20
//
//dw_treatment.width = dw_properties.x - 20
//dw_treatment.height = height
//
return 1

end function

public subroutine refresh ();
display_treatment()

end subroutine

on u_tabpage_treatment_dashboard.create
int iCurrent
call super::create
this.dw_treatment_prop_3=create dw_treatment_prop_3
this.dw_treatment_body=create dw_treatment_body
this.dw_treatment_prop_2=create dw_treatment_prop_2
this.dw_treatment_prop_1=create dw_treatment_prop_1
this.dw_treatment_header=create dw_treatment_header
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_treatment_prop_3
this.Control[iCurrent+2]=this.dw_treatment_body
this.Control[iCurrent+3]=this.dw_treatment_prop_2
this.Control[iCurrent+4]=this.dw_treatment_prop_1
this.Control[iCurrent+5]=this.dw_treatment_header
end on

on u_tabpage_treatment_dashboard.destroy
call super::destroy
destroy(this.dw_treatment_prop_3)
destroy(this.dw_treatment_body)
destroy(this.dw_treatment_prop_2)
destroy(this.dw_treatment_prop_1)
destroy(this.dw_treatment_header)
end on

type dw_treatment_prop_3 from u_dw_display within u_tabpage_treatment_dashboard
integer x = 2158
integer y = 952
integer width = 1079
integer height = 476
integer taborder = 70
boolean border = false
end type

event hotspot_hit;call super::hotspot_hit;refresh()

end event

type dw_treatment_body from u_dw_display within u_tabpage_treatment_dashboard
integer y = 476
integer width = 2144
integer height = 956
integer taborder = 60
boolean border = false
end type

event hotspot_hit;call super::hotspot_hit;refresh()

end event

type dw_treatment_prop_2 from u_dw_display within u_tabpage_treatment_dashboard
integer x = 2158
integer y = 476
integer width = 1079
integer height = 476
integer taborder = 60
boolean border = false
end type

event hotspot_hit;call super::hotspot_hit;refresh()

end event

type dw_treatment_prop_1 from u_dw_display within u_tabpage_treatment_dashboard
integer x = 2158
integer width = 1079
integer height = 476
integer taborder = 50
boolean border = false
end type

event hotspot_hit;call super::hotspot_hit;refresh()

end event

type dw_treatment_header from u_dw_display within u_tabpage_treatment_dashboard
integer width = 2144
integer height = 476
integer taborder = 30
boolean border = false
end type

event hotspot_hit;call super::hotspot_hit;refresh()

end event

