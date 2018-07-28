HA$PBExportHeader$u_cpr_page_growth_percentiles.sru
forward
global type u_cpr_page_growth_percentiles from u_cpr_page_base
end type
type st_development from u_st_observation_status within u_cpr_page_growth_percentiles
end type
type cb_growth_charts from commandbutton within u_cpr_page_growth_percentiles
end type
type tab_growth_data from tab within u_cpr_page_growth_percentiles
end type
type tabpage_graph from userobject within tab_growth_data
end type
type cbx_bmi from checkbox within tabpage_graph
end type
type cbx_hgtvswgt from checkbox within tabpage_graph
end type
type cbx_hc from checkbox within tabpage_graph
end type
type cbx_height from checkbox within tabpage_graph
end type
type cbx_weight from checkbox within tabpage_graph
end type
type gr_growth from graph within tabpage_graph
end type
type tabpage_graph from userobject within tab_growth_data
cbx_bmi cbx_bmi
cbx_hgtvswgt cbx_hgtvswgt
cbx_hc cbx_hc
cbx_height cbx_height
cbx_weight cbx_weight
gr_growth gr_growth
end type
type tabpage_data from userobject within tab_growth_data
end type
type cb_new_data from commandbutton within tabpage_data
end type
type cb_print from commandbutton within tabpage_data
end type
type st_unit_preference from statictext within tabpage_data
end type
type st_unit_preference_title from statictext within tabpage_data
end type
type dw_report from u_dw_pick_list within tabpage_data
end type
type tabpage_data from userobject within tab_growth_data
cb_new_data cb_new_data
cb_print cb_print
st_unit_preference st_unit_preference
st_unit_preference_title st_unit_preference_title
dw_report dw_report
end type
type tab_growth_data from tab within u_cpr_page_growth_percentiles
tabpage_graph tabpage_graph
tabpage_data tabpage_data
end type
type st_encounter_types_title_2 from statictext within u_cpr_page_growth_percentiles
end type
type st_encounters_well from statictext within u_cpr_page_growth_percentiles
end type
type st_encounters_all from statictext within u_cpr_page_growth_percentiles
end type
type st_encounter_types_title_1 from statictext within u_cpr_page_growth_percentiles
end type
type str_datapoint from structure within u_cpr_page_growth_percentiles
end type
type str_series from structure within u_cpr_page_growth_percentiles
end type
type str_serieses from structure within u_cpr_page_growth_percentiles
end type
end forward

type str_datapoint from structure
	long		age_days
	double		value
end type

type str_series from structure
	string		series_name
	long		datapoint_count
	str_datapoint		datapoint[]
	checkbox		checkbox
end type

type str_serieses from structure
	long		series_count
	str_series		series[]
end type

global type u_cpr_page_growth_percentiles from u_cpr_page_base
boolean resize_objects = false
st_development st_development
cb_growth_charts cb_growth_charts
tab_growth_data tab_growth_data
st_encounter_types_title_2 st_encounter_types_title_2
st_encounters_well st_encounters_well
st_encounters_all st_encounters_all
st_encounter_types_title_1 st_encounter_types_title_1
end type
global u_cpr_page_growth_percentiles u_cpr_page_growth_percentiles

type variables
integer 		growth_type // 1 - Infants 2 - Children 3-adults

u_unit hgt_unit
u_unit wgt_unit
u_unit hc_unit

string well_or_all = "WELL"



double avg_days_per_month = 30.417


private str_serieses serieses

 
end variables

forward prototypes
public function decimal getpercentile (decimal pd_x, decimal pd_l, decimal pd_m, decimal pd_s)
public subroutine refresh ()
public subroutine refresh_tab ()
public subroutine finished ()
public subroutine refresh_graphs ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine show_data ()
public subroutine set_units ()
public subroutine add_datapoint (string ps_series_name, long pl_age_days, double pd_value)
public subroutine plot_datapoints ()
public subroutine init_datapoints ()
end prototypes

public function decimal getpercentile (decimal pd_x, decimal pd_l, decimal pd_m, decimal pd_s);/////////////////////////////////////////////////////////////////////////////////////////////
//  
//        Z     = 	((X/M)**L) - 1
//                  ---------------       
//                        LS
//                                2
//        				            z
//                            - ---
//								1		   2
//      f(z,0,2)  = --------- e            [Cumulative Distribution Formula]
//                   Sqrt(2pi)
//
//////////////////////////////////////////////////////////////////////////////////////////////

double	z
double b1,b2,b3,b4,b5,ab,k,temp


b1 = 0.31938153
b2 = -0.356563782
b3 = 1.781477937
b4 = -1.821255978
b5 = 1.330274429
ab = 0.2316419

// Find Z value
z = ((pd_x/pd_m) ^ pd_l) - 1
z = z/(pd_l*pd_s)

// Find Percentile from Z value
k = 1 / (1 + ab * Abs(z))
temp = b1 * k + b2 * k ^ 2 + b3 * k ^ 3 + b4 * k ^ 4 + b5 * k ^ 5
temp = 1 - (1 / Sqrt(2 * Pi(1))) * Exp(-(Abs(z) ^ 2) / 2) * temp

If z > 0 then
	return temp
Else
	return 1 - temp
End if
end function

public subroutine refresh ();
if well_or_all = "WELL" then
	st_encounters_well.backcolor = color_object_selected
	st_encounters_all.backcolor = color_object
else
	st_encounters_well.backcolor = color_object
	st_encounters_all.backcolor = color_object_selected
end if

tab_growth_data.tabpage_data.st_unit_preference.text = wordcap(unit_preference)

st_development.refresh()

refresh_graphs()
refresh_tab()


end subroutine

public subroutine refresh_tab ();tabtextcolor = st_development.textcolor
end subroutine

public subroutine finished (); 
end subroutine

public subroutine refresh_graphs ();String		ls_cpr_id,ls_obs_id
string ls_htwt_over
string ls_htwt_under
string ls_months_under
string ls_months_over
Long			ll_age,ll_ages[],ll_data = 1
Long			ll_row = 1,ll_count,ll_last,ll_rowcount
Long			ll_bmiage,ll_wtage,ll_statage,ll_wtstat
Long			ll_wtageinf,ll_lenageinf,ll_hcageinf,ll_wtleninf
integer		li_age_child,li_sex
Decimal		l1, m1, s1, l2, m2, s2
decimal ld_percentile1, ld_percentile2, ld_percentile_interpolated
decimal ld_bmi,ld_age_divisor
Decimal		ld_weight[],ld_height[],ld_hc[]
Decimal		ld_temp
decimal ld_height1, ld_height2
Datetime 	ldt_birth_dt
integer li_percentile
string ls_wtstat_find
string ls_unit
u_unit luo_unit
string ls_stored_value
string ls_graph_value
decimal {1} ld_age
long ll_row_under
long ll_row_over
decimal ld_months1, ld_months2
string ls_report_value
string ls_title
integer li_sts
long ll_days_premature

Datastore 	lds_patient_data
Datastore	lds_bmiage,lds_wtage,lds_statage,lds_wtstat
Datastore	lds_wtageinf,lds_lenageinf,lds_hcageinf,lds_wtleninf

tab_growth_data.tabpage_data.dw_report.dataobject = "dw_growth_percentile_data"
tab_growth_data.tabpage_data.dw_report.reset()

init_datapoints()

ldt_birth_dt = datetime(current_patient.gaa_date_of_birth)
ls_cpr_id = current_patient.cpr_id
li_age_child = 365*20
ll_days_premature = 0
// If 'Female' set the sex number '2' else '1'
If current_patient.sex = "F" Then li_sex = 2 Else li_sex = 1
If growth_type = 1 Then 
	ld_age_divisor = avg_days_per_month
	ls_title = "Age In Months"
	if current_patient.weeks_premature >= 3 then
		ll_days_premature = current_patient.weeks_premature * 7
		ls_title += " - GAA (" + string(current_patient.weeks_premature) + " Weeks Premature)"
	end if
	tab_growth_data.tabpage_data.dw_report.object.age_title.text = ls_title
ElseIf growth_type = 2 Then
	ld_age_divisor = 365
	tab_growth_data.tabpage_data.dw_report.object.age_title.text = "Age In Years"
Else
	show_data()
	Return
End If


ls_title = "Hgt (" + hgt_unit.description + ")"
tab_growth_data.tabpage_data.dw_report.object.hgt_title.text = ls_title

ls_title = "Wgt (" + wgt_unit.description + ")"
tab_growth_data.tabpage_data.dw_report.object.wgt_title.text = ls_title

ls_title = "HC (" + hc_unit.description + ")"
tab_growth_data.tabpage_data.dw_report.object.hc_title.text = ls_title

// load all CDC data
lds_bmiage = Create datastore
lds_bmiage.dataobject = "d_cdc_bmiage"
lds_bmiage.Settransobject(SQLCA)
lds_bmiage.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_bmiage = lds_bmiage.rowcount()

lds_wtage = Create datastore
lds_wtage.dataobject = "d_cdc_wtage"
lds_wtage.Settransobject(SQLCA)
lds_wtage.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_wtage = lds_wtage.rowcount()

lds_statage = Create datastore
lds_statage.dataobject = "d_cdc_statage"
lds_statage.Settransobject(SQLCA)
lds_statage.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_statage = lds_statage.rowcount()

lds_wtstat = Create datastore
lds_wtstat.dataobject = "d_cdc_wtstat"
lds_wtstat.Settransobject(SQLCA)
lds_wtstat.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_wtstat = lds_wtstat.rowcount()

lds_hcageinf = Create datastore
lds_hcageinf.dataobject = "d_cdc_hcageinf"
lds_hcageinf.Settransobject(SQLCA)
lds_hcageinf.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_hcageinf = lds_hcageinf.rowcount()

lds_wtageinf = Create datastore
lds_wtageinf.dataobject = "d_cdc_wtageinf"
lds_wtageinf.Settransobject(SQLCA)
lds_wtageinf.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_wtageinf = lds_wtageinf.rowcount()

lds_lenageinf = Create datastore
lds_lenageinf.dataobject = "d_cdc_lenageinf"
lds_lenageinf.Settransobject(SQLCA)
lds_lenageinf.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_lenageinf = lds_lenageinf.rowcount()

lds_wtleninf = Create datastore
lds_wtleninf.dataobject = "d_cdc_wtleninf"
lds_wtleninf.Settransobject(SQLCA)
lds_wtleninf.retrieve(li_sex)
If Not tf_check() Then GOTO error
ll_wtleninf = lds_wtleninf.rowcount()

ll_last = -99

lds_patient_data = Create Datastore
lds_patient_data.dataobject = "d_patient_growth_data_htwthc"
lds_patient_data.Settransobject(SQLCA)
ll_rowcount = lds_patient_data.retrieve(ls_cpr_id, ldt_birth_dt, -210, li_age_child, well_or_all)
If Not tf_check() Then GOTO error
// get data values
Do While ll_row <= ll_rowcount
	ll_age = lds_patient_data.getitemnumber(ll_row,"age")
	If ll_age <> ll_last Then 
		ll_count++
		ll_ages[ll_count] = ll_age
		Setnull(ld_hc[ll_count])
		Setnull(ld_height[ll_count])
		Setnull(ld_weight[ll_count])
		ll_last = ll_age
		ld_age = ll_age/ld_age_divisor
		tab_growth_data.tabpage_data.dw_report.object.age[ll_count] = ld_age
		tab_growth_data.tabpage_data.dw_report.object.encounter_date[ll_count] = lds_patient_data.getitemdate(ll_row,"encounter_date")
	End If
	ls_stored_value = lds_patient_data.object.result_value[ll_row]
	ls_unit = lds_patient_data.object.result_unit[ll_row]
	luo_unit = unit_list.find_unit(ls_unit)
	if not isnull(ls_stored_value) and not isnull(luo_unit) then
		ls_obs_id = upper(string(lds_patient_data.object.observation_id[ll_row]))
		If ls_obs_id = "HC" Then
			ls_report_value = luo_unit.convert(hc_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("CM", ls_stored_value)
			li_sts = hc_unit.check_value(ls_report_value)
			ld_hc[ll_count] = dec(ls_graph_value)
			tab_growth_data.tabpage_data.dw_report.object.hc[ll_count] = dec(ls_report_value)
		End If
		If ls_obs_id = "HGT" Then 
			ls_report_value = luo_unit.convert(hgt_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("CM", ls_stored_value)
			li_sts = hgt_unit.check_value(ls_report_value)
			ld_height[ll_count] = dec(ls_graph_value)
			tab_growth_data.tabpage_data.dw_report.object.ht[ll_count] = dec(ls_report_value)
		End If
		If ls_obs_id = "WGT" Then 
			ls_report_value = luo_unit.convert(wgt_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("KG", ls_stored_value)
			li_sts = wgt_unit.check_value(ls_report_value)
			ld_weight[ll_count] = dec(ls_graph_value)
			tab_growth_data.tabpage_data.dw_report.object.wt[ll_count] = dec(ls_report_value)
		End If
	end if
	
	ll_row++
Loop
// plot percentile graph
Do While ll_data <= ll_count
	// Set the age value
	ld_age = ll_ages[ll_data]/ld_age_divisor
//	//ole_series.object.datavalue[ll_data,0] = ld_age
	
	ld_age = ll_ages[ll_data]/avg_days_per_month
	if ld_age < 0 then ld_age = 0
	ls_months_over = "months >= "+string(ld_age)
	ls_months_under = "months <= "+string(ld_age)
	
	setnull(ld_percentile_interpolated)
	
	If Not Isnull(ld_weight[ll_data]) Then
		ll_row_over = lds_wtageinf.find(ls_months_over, 1, ll_wtageinf)
		ll_row_under = lds_wtageinf.find(ls_months_under, ll_wtageinf, 1)
		If ll_row_over > 0 and ll_row_under > 0 Then
			// Get the "under" percentile
			ld_months1 = lds_wtageinf.object.months[ll_row_under]
			l1 = lds_wtageinf.object.l[ll_row_under]
			m1 = lds_wtageinf.object.m[ll_row_under]
			s1 = lds_wtageinf.object.s[ll_row_under]
			ld_percentile1 = getpercentile(ld_weight[ll_data],l1,m1,s1)
			
			// Get the "over" percentile
			ld_months2 = lds_wtageinf.object.months[ll_row_over]
			l2 = lds_wtageinf.object.l[ll_row_over]
			m2 = lds_wtageinf.object.m[ll_row_over]
			s2 = lds_wtageinf.object.s[ll_row_over]
			ld_percentile2 = getpercentile(ld_weight[ll_data],l2,m2,s2)
			
			// Now interpolate to get the graphed percentile
			if ld_age = ld_months1 then
				ld_percentile_interpolated = ld_percentile1
			else
				ld_percentile_interpolated = ld_percentile1 + ((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) / (ld_months2 - ld_months1) )
			end if

			//ole_series.object.datavalue[ll_data,1] = (ld_percentile_interpolated * 100)
			add_datapoint("Weight", ll_ages[ll_data], ld_percentile_interpolated * 100)
		Else
			ll_row_over = lds_wtage.find(ls_months_over, 1, ll_wtage)
			ll_row_under = lds_wtage.find(ls_months_under, ll_wtage, 1)
			If ll_row_over > 0 and ll_row_under > 0 Then
				// Get the "under" percentile
				ld_months1 = lds_wtage.object.months[ll_row_under]
				l1 = lds_wtage.object.l[ll_row_under]
				m1 = lds_wtage.object.m[ll_row_under]
				s1 = lds_wtage.object.s[ll_row_under]
				ld_percentile1 = getpercentile(ld_weight[ll_data],l1,m1,s1)
				
				// Get the "over" percentile
				ld_months2 = lds_wtage.object.months[ll_row_over]
				l2 = lds_wtage.object.l[ll_row_over]
				m2 = lds_wtage.object.m[ll_row_over]
				s2 = lds_wtage.object.s[ll_row_over]
				ld_percentile2 = getpercentile(ld_weight[ll_data],l2,m2,s2)
				
				// Now interpolate to get the graphed percentile
				if ld_age = ld_months1 then
					ld_percentile_interpolated = ld_percentile1
				else
					ld_percentile_interpolated = ld_percentile1 + &
															((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) &
															/ (ld_months2 - ld_months1) )
				end if

				//ole_series.object.datavalue[ll_data,1] = (ld_percentile_interpolated * 100)
				add_datapoint("Weight", ll_ages[ll_data], ld_percentile_interpolated * 100)
			End If	
		End If
		if not isnull(ld_percentile_interpolated) then
			li_percentile = int(ld_percentile_interpolated * 100)
			tab_growth_data.tabpage_data.dw_report.object.wt_percentile[ll_data] = li_percentile
		end if
	End If
	
	setnull(ld_percentile_interpolated)

	If Not Isnull(ld_height[ll_data]) Then
		ll_row_over = lds_lenageinf.find(ls_months_over, 1, ll_lenageinf)
		ll_row_under = lds_lenageinf.find(ls_months_under, ll_lenageinf, 1)
		If ll_row_over > 0 and ll_row_under > 0 Then
			// Get the "under" percentile
			ld_months1 = lds_lenageinf.object.months[ll_row_under]
			l1 = lds_lenageinf.object.l[ll_row_under]
			m1 = lds_lenageinf.object.m[ll_row_under]
			s1 = lds_lenageinf.object.s[ll_row_under]
			ld_percentile1 = getpercentile(ld_height[ll_data],l1,m1,s1)
			
			// Get the "over" percentile
			ld_months2 = lds_lenageinf.object.months[ll_row_over]
			l2 = lds_lenageinf.object.l[ll_row_over]
			m2 = lds_lenageinf.object.m[ll_row_over]
			s2 = lds_lenageinf.object.s[ll_row_over]
			ld_percentile2 = getpercentile(ld_height[ll_data],l2,m2,s2)
			
			// Now interpolate to get the graphed percentile
			if ld_age = ld_months1 then
				ld_percentile_interpolated = ld_percentile1
			else
				ld_percentile_interpolated = ld_percentile1 + &
														((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) &
														/ (ld_months2 - ld_months1) )
			end if

			//ole_series.object.datavalue[ll_data,2] = (ld_percentile_interpolated * 100)
			add_datapoint("Height", ll_ages[ll_data], ld_percentile_interpolated * 100)
		Else
			ll_row_over = lds_statage.find(ls_months_over, 1, ll_statage)
			ll_row_under = lds_statage.find(ls_months_under, ll_statage, 1)
			If ll_row_over > 0 and ll_row_under > 0 Then
				// Get the "under" percentile
				ld_months1 = lds_statage.object.months[ll_row_under]
				l1 = lds_statage.object.l[ll_row_under]
				m1 = lds_statage.object.m[ll_row_under]
				s1 = lds_statage.object.s[ll_row_under]
				ld_percentile1 = getpercentile(ld_height[ll_data],l1,m1,s1)
				
				// Get the "over" percentile
				ld_months2 = lds_statage.object.months[ll_row_over]
				l2 = lds_statage.object.l[ll_row_over]
				m2 = lds_statage.object.m[ll_row_over]
				s2 = lds_statage.object.s[ll_row_over]
				ld_percentile2 = getpercentile(ld_height[ll_data],l2,m2,s2)
				
				// Now interpolate to get the graphed percentile
				if ld_age = ld_months1 then
					ld_percentile_interpolated = ld_percentile1
				else
					ld_percentile_interpolated = ld_percentile1 + &
															((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) &
															/ (ld_months2 - ld_months1) )
				end if

				//ole_series.object.datavalue[ll_data,2] = (ld_percentile_interpolated * 100)
				add_datapoint("Height", ll_ages[ll_data], ld_percentile_interpolated * 100)
			End If
		End If
		if not isnull(ld_percentile_interpolated) then
			li_percentile = int(ld_percentile_interpolated * 100)
			tab_growth_data.tabpage_data.dw_report.object.ht_percentile[ll_data] = li_percentile
		end if
	End If
	If Not Isnull(ld_hc[ll_data]) Then
		ll_row_over = lds_hcageinf.find(ls_months_over, 1, ll_hcageinf)
		ll_row_under = lds_hcageinf.find(ls_months_under, ll_hcageinf, 1)
		If ll_row_over > 0 and ll_row_under > 0 Then
			// Get the "under" percentile
			ld_months1 = lds_hcageinf.object.months[ll_row_under]
			l1 = lds_hcageinf.object.l[ll_row_under]
			m1 = lds_hcageinf.object.m[ll_row_under]
			s1 = lds_hcageinf.object.s[ll_row_under]
			ld_percentile1 = getpercentile(ld_hc[ll_data],l1,m1,s1)
			
			// Get the "over" percentile
			ld_months2 = lds_hcageinf.object.months[ll_row_over]
			l2 = lds_hcageinf.object.l[ll_row_over]
			m2 = lds_hcageinf.object.m[ll_row_over]
			s2 = lds_hcageinf.object.s[ll_row_over]
			ld_percentile2 = getpercentile(ld_hc[ll_data],l2,m2,s2)
			
			// Now interpolate to get the graphed percentile
			if ld_age = ld_months1 then
				ld_percentile_interpolated = ld_percentile1
			else
				ld_percentile_interpolated = ld_percentile1 + &
														((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) &
														/ (ld_months2 - ld_months1) )
			end if

			//ole_series.object.datavalue[ll_data,3] = (ld_percentile_interpolated * 100)
			add_datapoint("HC", ll_ages[ll_data], ld_percentile_interpolated * 100)
			li_percentile = int(ld_percentile_interpolated * 100)
			tab_growth_data.tabpage_data.dw_report.object.hc_percentile[ll_data] = li_percentile
		End If
	End If
	If Not Isnull(ld_height[ll_data]) and Not Isnull(ld_weight[ll_data]) Then
		// If we have both height and weight then plot the percentile
		ls_htwt_over = "length >= "+string(ld_height[ll_data])
		ls_htwt_under = "length <= "+string(ld_height[ll_data])

		ll_row_over = lds_wtleninf.find(ls_htwt_over, 1, ll_wtleninf)
		ll_row_under = lds_wtleninf.find(ls_htwt_under, ll_wtleninf, 1)
		If ll_row_over > 0 and ll_row_under > 0 Then
			// Get the "under" percentile
			ld_height1 = lds_wtleninf.object.length[ll_row_under]
			l1 = lds_wtleninf.object.l[ll_row_under]
			m1 = lds_wtleninf.object.m[ll_row_under]
			s1 = lds_wtleninf.object.s[ll_row_under]
			ld_percentile1 = getpercentile(ld_weight[ll_data],l1,m1,s1)
			
			// Get the "over" percentile
			ld_height2 = lds_wtleninf.object.length[ll_row_over]
			l2 = lds_wtleninf.object.l[ll_row_over]
			m2 = lds_wtleninf.object.m[ll_row_over]
			s2 = lds_wtleninf.object.s[ll_row_over]
			ld_percentile2 = getpercentile(ld_weight[ll_data],l2,m2,s2)
			
			// Now interpolate to get the graphed percentile
			if ld_height[ll_data] <= ld_height1 then
				ld_percentile_interpolated = ld_percentile1
			else
				ld_percentile_interpolated = ld_percentile1 + &
														((ld_height[ll_data] - ld_height1) * (ld_percentile2 - ld_percentile1) &
														/ (ld_height2 - ld_height1) )
			end if
			
			//ole_series.object.datavalue[ll_data,4] = (ld_percentile_interpolated*100)
			add_datapoint("Hgt vs Wgt", ll_ages[ll_data], ld_percentile_interpolated * 100)
		Else
			ls_htwt_over = "height >= "+string(ld_height[ll_data])
			ls_htwt_under = "height <= "+string(ld_height[ll_data])
	
			ll_row_over = lds_wtstat.find(ls_htwt_over, 1, ll_wtstat)
			ll_row_under = lds_wtstat.find(ls_htwt_under, ll_wtstat, 1)
			If ll_row_over > 0 and ll_row_under > 0 Then
				// Get the "under" percentile
				ld_height1 = lds_wtstat.object.height[ll_row_under]
				l1 = lds_wtstat.object.l[ll_row_under]
				m1 = lds_wtstat.object.m[ll_row_under]
				s1 = lds_wtstat.object.s[ll_row_under]
				ld_percentile1 = getpercentile(ld_weight[ll_data],l1,m1,s1)
				
				// Get the "over" percentile
				ld_height2 = lds_wtstat.object.height[ll_row_over]
				l2 = lds_wtstat.object.l[ll_row_over]
				m2 = lds_wtstat.object.m[ll_row_over]
				s2 = lds_wtstat.object.s[ll_row_over]
				ld_percentile2 = getpercentile(ld_weight[ll_data],l2,m2,s2)
				
				// Now interpolate to get the graphed percentile
				if ld_height[ll_data] <= ld_height1 then
					ld_percentile_interpolated = ld_percentile1
				else
					ld_percentile_interpolated = ld_percentile1 + &
															((ld_height[ll_data] - ld_height1) * (ld_percentile2 - ld_percentile1) &
															/ (ld_height2 - ld_height1) )
				end if
				
				//ole_series.object.datavalue[ll_data,4] = (ld_percentile_interpolated*100)
				add_datapoint("Hgt vs Wgt", ll_ages[ll_data], ld_percentile_interpolated * 100)
			End If
		end if

		// Find BMI (Body Mass Index) value 
		// 
		// BMI = weight(kg) % height(in cm) % height(in cm) * 10,000
		//
		if ld_height[ll_data] > 0 then
			ld_bmi = (ld_weight[ll_data]/(ld_height[ll_data] * ld_height[ll_data]))
			ld_bmi = ld_bmi * 10000
		else
			setnull(ld_bmi)
		end if
		tab_growth_data.tabpage_data.dw_report.object.bmi[ll_data] = ld_bmi
		If ld_bmi > 0 Then
			ll_row_over = lds_bmiage.find(ls_months_over, 1, ll_bmiage)
			ll_row_under = lds_bmiage.find(ls_months_under, ll_bmiage, 1)
			If ll_row_over > 0 and ll_row_under > 0 Then
				// Get the "under" percentile
				ld_months1 = lds_bmiage.object.months[ll_row_under]
				l1 = lds_bmiage.object.l[ll_row_under]
				m1 = lds_bmiage.object.m[ll_row_under]
				s1 = lds_bmiage.object.s[ll_row_under]
				ld_percentile1 = getpercentile(ld_bmi,l1,m1,s1)
				
				// Get the "over" percentile
				ld_months2 = lds_bmiage.object.months[ll_row_over]
				l2 = lds_bmiage.object.l[ll_row_over]
				m2 = lds_bmiage.object.m[ll_row_over]
				s2 = lds_bmiage.object.s[ll_row_over]
				ld_percentile2 = getpercentile(ld_bmi,l2,m2,s2)
				
				// Now interpolate to get the graphed percentile
				if ld_age = ld_months1 then
					ld_percentile_interpolated = ld_percentile1
				else
					ld_percentile_interpolated = ld_percentile1 + &
															((ld_age - ld_months1) * (ld_percentile2 - ld_percentile1) &
															/ (ld_months2 - ld_months1) )
				end if
				
				//ole_series.object.datavalue[ll_data,5] = (ld_percentile_interpolated*100)
				add_datapoint("BMI", ll_ages[ll_data], ld_percentile_interpolated * 100)
				li_percentile = int(ld_percentile_interpolated * 100)
				tab_growth_data.tabpage_data.dw_report.object.bmi_percentile[ll_data] = li_percentile
			End If
		End If
	End If
	ll_data++
Loop
tab_growth_data.tabpage_data.dw_report.sort()

plot_datapoints()

error:
destroy lds_patient_data
destroy lds_bmiage
destroy lds_wtage
destroy lds_statage
destroy lds_wtstat
destroy lds_hcageinf
destroy lds_wtageinf
destroy lds_lenageinf
destroy lds_wtleninf

Return
end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);string ls_observation_id
string ls_display_service
string ls_unit_preference
long ll_diff

this_section = puo_section
this_page = pi_page

this_section.load_params( this_page)

ls_observation_id = current_patient.get_property_value("DEVEL_OBSERVATION_ID")
if isnull(ls_observation_id) then ls_observation_id = this_section.get_attribute(this_page, "devel_observation_id")
if isnull(ls_observation_id) then ls_observation_id = "!DVMILESTONES"

ls_display_service = this_section.get_attribute(this_page, "display_service")
if isnull(ls_display_service) then ls_display_service = "HISTORY_DISPLAY"

st_development.initialize(ls_observation_id, ls_display_service)

st_development.refresh()
tabtextcolor = st_development.textcolor

// Resize stuff
//ole_series.width = width
//dw_report.height = height - 20
real lr_x_factor
real lr_y_factor

lr_x_factor = width / 2875
lr_y_factor = height / 1272

//f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)


//if growth_type = 3 then
////	ole_series.visible = false
//	gr_growth.visible = false
//	dw_report.visible = true
//	cb_print.visible = true
//	st_toggle.visible = false
//else
//	dw_report.visible = false
//	cb_print.visible = false
//
////	ole_series.visible = true
//	gr_growth.visible = true
//
//	st_toggle.text = "Show Data"
//end if
//
//


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tab Control
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
tab_growth_data.width = width
tab_growth_data.height = height - 200

st_encounter_types_title_1.y = tab_growth_data.height + 8
st_encounters_well.y = st_encounter_types_title_1.y + st_encounter_types_title_1.height
st_encounters_all.y = st_encounters_well.y
st_encounter_types_title_2.y = st_encounters_well.y + st_encounters_well.height

cb_growth_charts.x = ((width - 1874) / 2) + 430
st_development.x = cb_growth_charts.x + cb_growth_charts.width + 100

cb_growth_charts.y = tab_growth_data.height + 36
st_development.y = cb_growth_charts.y

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data tab
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
tab_growth_data.tabpage_data.st_unit_preference_title.height = 64
tab_growth_data.tabpage_data.st_unit_preference.height = 96
tab_growth_data.tabpage_data.cb_new_data.height = 96
tab_growth_data.tabpage_data.cb_print.height = 96

tab_growth_data.tabpage_data.dw_report.width = 2542
tab_growth_data.tabpage_data.dw_report.height = tab_growth_data.tabpage_data.height

ll_diff = tab_growth_data.tabpage_data.width - tab_growth_data.tabpage_data.dw_report.width
if ll_diff > 800 then
	tab_growth_data.tabpage_data.dw_report.x = ll_diff / 2
	tab_growth_data.tabpage_data.st_unit_preference_title.width = 352
	tab_growth_data.tabpage_data.st_unit_preference_title.x = tab_growth_data.tabpage_data.width - (ll_diff / 4) - (tab_growth_data.tabpage_data.st_unit_preference_title.width / 2)
elseif ll_diff > 400 then
	tab_growth_data.tabpage_data.dw_report.x = 0
	tab_growth_data.tabpage_data.st_unit_preference_title.width = 352
	tab_growth_data.tabpage_data.st_unit_preference_title.x = tab_growth_data.tabpage_data.width - (ll_diff / 2) - (tab_growth_data.tabpage_data.st_unit_preference_title.width / 2)
else
	tab_growth_data.tabpage_data.dw_report.x = 0
	tab_growth_data.tabpage_data.st_unit_preference_title.width = ll_diff - 24
	tab_growth_data.tabpage_data.st_unit_preference_title.x = tab_growth_data.tabpage_data.dw_report.width + 12
end if

tab_growth_data.tabpage_data.st_unit_preference.width = tab_growth_data.tabpage_data.st_unit_preference_title.width
tab_growth_data.tabpage_data.cb_new_data.width = tab_growth_data.tabpage_data.st_unit_preference_title.width
tab_growth_data.tabpage_data.cb_print.width = tab_growth_data.tabpage_data.st_unit_preference_title.width

tab_growth_data.tabpage_data.st_unit_preference.x = tab_growth_data.tabpage_data.st_unit_preference_title.x
tab_growth_data.tabpage_data.cb_new_data.x = tab_growth_data.tabpage_data.st_unit_preference_title.x
tab_growth_data.tabpage_data.cb_print.x = tab_growth_data.tabpage_data.st_unit_preference_title.x

set_units()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Graph tab
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
tab_growth_data.tabpage_graph.gr_growth.width = tab_growth_data.tabpage_graph.width
tab_growth_data.tabpage_graph.gr_growth.height = tab_growth_data.tabpage_graph.height - 100

tab_growth_data.tabpage_graph.cbx_weight.x = (tab_growth_data.tabpage_graph.width - 1396) / 2
tab_growth_data.tabpage_graph.cbx_height.x = tab_growth_data.tabpage_graph.cbx_weight.x + tab_growth_data.tabpage_graph.cbx_weight.width + 20
tab_growth_data.tabpage_graph.cbx_hc.x = tab_growth_data.tabpage_graph.cbx_height.x + tab_growth_data.tabpage_graph.cbx_height.width + 20
tab_growth_data.tabpage_graph.cbx_hgtvswgt.x = tab_growth_data.tabpage_graph.cbx_hc.x + tab_growth_data.tabpage_graph.cbx_hc.width + 20
tab_growth_data.tabpage_graph.cbx_bmi.x = tab_growth_data.tabpage_graph.cbx_hgtvswgt.x + tab_growth_data.tabpage_graph.cbx_hgtvswgt.width + 20

tab_growth_data.tabpage_graph.cbx_weight.y = tab_growth_data.tabpage_graph.gr_growth.height
tab_growth_data.tabpage_graph.cbx_height.y = tab_growth_data.tabpage_graph.gr_growth.height
tab_growth_data.tabpage_graph.cbx_hc.y = tab_growth_data.tabpage_graph.gr_growth.height
tab_growth_data.tabpage_graph.cbx_hgtvswgt.y = tab_growth_data.tabpage_graph.gr_growth.height
tab_growth_data.tabpage_graph.cbx_bmi.y = tab_growth_data.tabpage_graph.gr_growth.height




if cb_configure_tab.visible then
	cb_configure_tab.bringtotop = true
end if

end subroutine

public subroutine show_data ();datetime		ldt_birth_dt
string 		ls_cpr_id,ls_unit,ls_obs_id,ls_stored_value,ls_graph_value,ls_report_value
long 			ll_row=1,ll_rowcount,ll_age,ll_last,ll_count
integer 		li_null
decimal 		ld_age_divisor = 365
decimal {1} ld_age
decimal		ld_weight,ld_height,ld_bmi
string ls_title
integer li_sts

datastore 	lds_patient_data
u_unit		luo_unit

Setnull(li_null)
ldt_birth_dt = datetime(current_patient.date_of_birth )
ls_cpr_id = current_patient.cpr_id

lds_patient_data = Create Datastore
lds_patient_data.dataobject = "d_patient_growth_data_htwthc"
lds_patient_data.Settransobject(SQLCA)
ll_rowcount = lds_patient_data.retrieve(ls_cpr_id, ldt_birth_dt, 0, li_null, well_or_all)
If not tf_check() then return

tab_growth_data.tabpage_data.dw_report.dataobject = "dw_adult_growth_data"
tab_growth_data.tabpage_data.dw_report.reset()


ls_title = "Hgt (" + hgt_unit.description + ")"
tab_growth_data.tabpage_data.dw_report.object.hgt_title.text = ls_title

ls_title = "Wgt (" + wgt_unit.description + ")"
tab_growth_data.tabpage_data.dw_report.object.wgt_title.text = ls_title


// get data values
Do While ll_row <= ll_rowcount
	ll_age = lds_patient_data.getitemnumber(ll_row,"age")
	If ll_age <> ll_last Then 
		ll_last = ll_age
		ld_age = ll_age/ld_age_divisor
		ll_count = tab_growth_data.tabpage_data.dw_report.insertrow(0)
		tab_growth_data.tabpage_data.dw_report.object.age[ll_count] = ld_age
		tab_growth_data.tabpage_data.dw_report.object.encounter_date[ll_count] = lds_patient_data.getitemdate(ll_row,"encounter_date")
	End If
	ls_stored_value = lds_patient_data.object.result_value[ll_row]
	ls_unit = lds_patient_data.object.result_unit[ll_row]
	luo_unit = unit_list.find_unit(ls_unit)
	if not isnull(ls_stored_value) and not isnull(luo_unit) then
		ls_obs_id = upper(string(lds_patient_data.object.observation_id[ll_row]))
		If ls_obs_id = "HC" Then
			ls_report_value = luo_unit.convert(hc_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("CM", ls_stored_value)
			li_sts = hc_unit.check_value(ls_report_value)
			tab_growth_data.tabpage_data.dw_report.object.hc[ll_count] = dec(ls_report_value)
		End If
		If ls_obs_id = "HGT" Then 
			ls_report_value = luo_unit.convert(hgt_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("CM", ls_stored_value)
			li_sts = hgt_unit.check_value(ls_report_value)
			tab_growth_data.tabpage_data.dw_report.object.ht_cm[ll_count] = dec(ls_graph_value)
			tab_growth_data.tabpage_data.dw_report.object.ht[ll_count] = dec(ls_report_value)
		End If
		If ls_obs_id = "WGT" Then 
			ls_report_value = luo_unit.convert(wgt_unit.unit_id, ls_stored_value)
			ls_graph_value = luo_unit.convert("KG", ls_stored_value)
			li_sts = wgt_unit.check_value(ls_report_value)
			tab_growth_data.tabpage_data.dw_report.object.wt_kg[ll_count] = dec(ls_graph_value)
			tab_growth_data.tabpage_data.dw_report.object.wt[ll_count] = dec(ls_report_value)
		End If
		If ls_obs_id = 'BPSIT-SYS' Then
//			ls_report_value = luo_unit.convert(wgt_unit.unit_id, ls_stored_value)
//			ls_graph_value = luo_unit.convert("M", ls_stored_value)
			tab_growth_data.tabpage_data.dw_report.object.bpsys[ll_count] = dec(ls_stored_value)
		End If
		If ls_obs_id = 'BPSIT-DIA' Then
//			ls_report_value = luo_unit.convert(wgt_unit.unit_id, ls_stored_value)
//			ls_graph_value = luo_unit.convert("M", ls_stored_value)
			tab_growth_data.tabpage_data.dw_report.object.bpdia[ll_count] = dec(ls_stored_value)
		End If
	end if
	
	ll_row++
Loop
ll_rowcount = tab_growth_data.tabpage_data.dw_report.rowcount()
For ll_row = 1 to ll_rowcount
	ld_weight = tab_growth_data.tabpage_data.dw_report.object.wt_kg[ll_row]
	ld_height = tab_growth_data.tabpage_data.dw_report.object.ht_cm[ll_row]
	if ld_height > 0 then
		ld_bmi = f_get_bmi(ld_weight,ld_height)
		tab_growth_data.tabpage_data.dw_report.object.bmi[ll_row] = ld_bmi
	end if
Next
tab_growth_data.tabpage_data.dw_report.sort()
Return
end subroutine

public subroutine set_units ();string ls_unit_preference

SELECT unit_preference
INTO :ls_unit_preference
FROM c_Observation_Result
WHERE observation_id = 'HGT'
AND result_sequence = -1;
if not tf_check() then setnull(ls_unit_preference)

if isnull(ls_unit_preference) then ls_unit_preference = unit_preference

if upper(ls_unit_preference) = "ENGLISH" then
	hgt_unit = unit_list.find_unit("INCH")
else
	hgt_unit = unit_list.find_unit("CM")
end if

SELECT unit_preference
INTO :ls_unit_preference
FROM c_Observation_Result
WHERE observation_id = 'WGT'
AND result_sequence = -1;
if not tf_check() then setnull(ls_unit_preference)

if isnull(ls_unit_preference) then ls_unit_preference = unit_preference

if upper(ls_unit_preference) = "ENGLISH" then
	wgt_unit = unit_list.find_unit("LB")
else
	wgt_unit = unit_list.find_unit("KG")
end if

SELECT unit_preference
INTO :ls_unit_preference
FROM c_Observation_Result
WHERE observation_id = 'HC'
AND result_sequence = -1;
if not tf_check() then setnull(ls_unit_preference)

if isnull(ls_unit_preference) then ls_unit_preference = unit_preference

if upper(ls_unit_preference) = "ENGLISH" then
	hc_unit = unit_list.find_unit("INCH")
else
	hc_unit = unit_list.find_unit("CM")
end if


end subroutine

public subroutine add_datapoint (string ps_series_name, long pl_age_days, double pd_value);long i

for i = 1 to serieses.series_count
	if serieses.series[i].series_name = ps_series_name then
		serieses.series[i].datapoint_count +=1 
		serieses.series[i].datapoint[serieses.series[i].datapoint_count].age_days = pl_age_days
		serieses.series[i].datapoint[serieses.series[i].datapoint_count].value = pd_value
	end if
next

end subroutine

public subroutine plot_datapoints ();long i, j
integer li_series_number
long ll_age
string ls_age_unit
double ld_age
long ll_temp

tab_growth_data.tabpage_graph.gr_growth.setredraw(false)
tab_growth_data.tabpage_graph.gr_growth.reset(all!)

f_pretty_age_unit(current_patient.date_of_birth, today(), ll_age, ls_age_unit)

tab_growth_data.tabpage_graph.gr_growth.category.label = "Age (" + wordcap(ls_age_unit) + "s)"
CHOOSE CASE upper(ls_age_unit)
	CASE "DAY"
		tab_growth_data.tabpage_graph.gr_growth.category.minimumvalue = 0
		tab_growth_data.tabpage_graph.gr_growth.category.maximumvalue = 7
		tab_growth_data.tabpage_graph.gr_growth.category.majordivisions = 7
	CASE "WEEK"
		tab_growth_data.tabpage_graph.gr_growth.category.minimumvalue = 0
		tab_growth_data.tabpage_graph.gr_growth.category.maximumvalue = 8
		tab_growth_data.tabpage_graph.gr_growth.category.majordivisions = 8
	CASE "MONTH"
		tab_growth_data.tabpage_graph.gr_growth.category.minimumvalue = 0
		tab_growth_data.tabpage_graph.gr_growth.category.maximumvalue = 36
		tab_growth_data.tabpage_graph.gr_growth.category.majordivisions = 12
	CASE "YEAR"
		tab_growth_data.tabpage_graph.gr_growth.category.minimumvalue = 0
		tab_growth_data.tabpage_graph.gr_growth.category.maximumvalue = 20
		tab_growth_data.tabpage_graph.gr_growth.category.majordivisions = 10
END CHOOSE

for i = 1 to serieses.series_count
	if not serieses.series[i].checkbox.checked then continue
	
	li_series_number = tab_growth_data.tabpage_graph.gr_growth.addseries(serieses.series[i].series_name)
	
	CHOOSE CASE i
		CASE 1
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, Foreground!, RGB(196,62,28))
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, SymbolPlus!)
		CASE 2
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, Foreground!,  RGB(43,30,193))
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, SymbolX!)
		CASE 3
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, Foreground!, RGB(86,158,65))
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, SymbolHollowCircle!)
		CASE 4
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, Foreground!, RGB(255,192,0))
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, SymbolStar!)
		CASE 5
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, Foreground!, RGB(255,255,128))
			tab_growth_data.tabpage_graph.gr_growth.SetSeriesStyle(serieses.series[i].series_name, SymbolPlus!)
	END CHOOSE
	
	for j = 1 to serieses.series[i].datapoint_count
		CHOOSE CASE upper(ls_age_unit)
			CASE "DAY"
				ld_age = double(serieses.series[i].datapoint[j].age_days)
			CASE "WEEK"
				ld_age = double(serieses.series[i].datapoint[j].age_days) / 7
			CASE "MONTH"
				ld_age = double(serieses.series[i].datapoint[j].age_days) / avg_days_per_month
			CASE "YEAR"
				ld_age = double(serieses.series[i].datapoint[j].age_days) / 365
		END CHOOSE
		tab_growth_data.tabpage_graph.gr_growth.adddata(li_series_number, ld_age, serieses.series[i].datapoint[j].value)
	next
next


tab_growth_data.tabpage_graph.gr_growth.setredraw(true)


return

end subroutine

public subroutine init_datapoints ();long i

serieses.series_count = 5

serieses.series[1].series_name = "Weight"
serieses.series[2].series_name = "Height"
serieses.series[3].series_name = "HC"
serieses.series[4].series_name = "Hgt vs Wgt"
serieses.series[5].series_name = "BMI"

serieses.series[1].checkbox = tab_growth_data.tabpage_graph.cbx_weight
serieses.series[2].checkbox = tab_growth_data.tabpage_graph.cbx_height
serieses.series[3].checkbox = tab_growth_data.tabpage_graph.cbx_hc
serieses.series[4].checkbox = tab_growth_data.tabpage_graph.cbx_HgtvsWgt
serieses.series[5].checkbox = tab_growth_data.tabpage_graph.cbx_bmi


for i = 1 to serieses.series_count
	serieses.series[i].datapoint_count = 0
next


//Long 		ll_col
//String	ls_Series[5] = {"Weight","Height","HC","Hgt vs Wgt","BMI"}
//Long     ll_color[5] 
//string ls_title
//
//// Set the colors for series
//ll_color[1] = RGB(196,62,28)
//ll_color[2] = RGB(43,30,193)
//ll_color[3] = RGB(86,158,65)
//ll_color[4] = RGB(255,192,0)
//ll_color[5] = RGB(255,255,128)
//
//ole_series.object.DataInit = 6 							// includes all series plus category axis
//ole_series.object.ToolTips = 0
//
//ole_series.object.Column = 0  							// Focus on column 0     
//ole_series.object.ColumnAxis = 0   					// Assign column to axis 0 (X axis)
//
//FOR ll_col = 1 TO 5
// ole_series.object.Column = ll_col    				 
// ole_series.object.ColumnAxis = 1  					// Assign column to axis 1 (Y axis)
// ole_series.object.ColumnType = 1   					// Display as Line graph
// ole_series.object.ColumnLegend = ls_Series[ll_col] // Add Column Legends    
// ole_series.object.Columncolor = ll_color[ll_col] // set the series color
// ole_series.object.ColumnStyle = 12
// ole_series.object.ColumnLineWidth = 2
//NEXT
//ole_series.object.LegendColumns = -1
//ole_series.object.Graphareabottom = 92
// 
//// Set the graph & frame background color
//ole_series.object.Graphframecolor = ole_series.object.colortable(21) 
//ole_series.object.GraphBorderColor = ole_series.object.colortable(20) 
//ole_series.object.Graphbackcolor = ole_series.object.colortable(15)
//ole_series.object.backcolor = COLOR_BACKGROUND
//
//ole_series.object.FontOpen("Times New Roman,10,B")
//
//// Set the category axis scale
//ole_series.object.axis=0
//ole_series.object.axistitlefont = ole_series.object.FontCurrent
//ole_series.object.axisscalemanual = true
//If growth_type = 1 Then 
//	if current_patient.weeks_premature >= 3 then
//		ole_series.object.axisscalemin = -current_patient.weeks_premature
//	else
//		ole_series.object.axisscalemin = 0
//	end if
//	ole_series.object.axisscalemax = 36 
//	ole_series.object.axisscaleinc = 3
//	
//	ls_title = "Age In Months"
//	if current_patient.weeks_premature >= 3 then
//		ls_title += " - GAA (" + string(current_patient.weeks_premature) + " Weeks Premature)"
//	end if
//	ole_series.object.axistitle = ls_title
//	ole_series.object.GraphTitle = "Infants"
//Else
//	ole_series.object.axisscalemin = 0
//	ole_series.object.axisscalemax = 20
//	ole_series.object.axisscaleinc = 2
//	ole_series.object.axistitle = "Years"
//	ole_series.object.GraphTitle = "Children"
//End If
//
//
//// Set the value axis scale
//ole_series.object.axis=1
//ole_series.object.axistitle = "Percentile"
//ole_series.object.axistitlefont = ole_series.object.FontCurrent
//ole_series.object.axisscalemanual = true
//ole_series.object.axisscalemin = 0
//ole_series.object.axisscalemax = 100
//ole_series.object.axisscaleinc = 10
//ole_series.object.AxisGrid = True
//ole_series.object.AxisGridPattern = 1

end subroutine

on u_cpr_page_growth_percentiles.create
int iCurrent
call super::create
this.st_development=create st_development
this.cb_growth_charts=create cb_growth_charts
this.tab_growth_data=create tab_growth_data
this.st_encounter_types_title_2=create st_encounter_types_title_2
this.st_encounters_well=create st_encounters_well
this.st_encounters_all=create st_encounters_all
this.st_encounter_types_title_1=create st_encounter_types_title_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_development
this.Control[iCurrent+2]=this.cb_growth_charts
this.Control[iCurrent+3]=this.tab_growth_data
this.Control[iCurrent+4]=this.st_encounter_types_title_2
this.Control[iCurrent+5]=this.st_encounters_well
this.Control[iCurrent+6]=this.st_encounters_all
this.Control[iCurrent+7]=this.st_encounter_types_title_1
end on

on u_cpr_page_growth_percentiles.destroy
call super::destroy
destroy(this.st_development)
destroy(this.cb_growth_charts)
destroy(this.tab_growth_data)
destroy(this.st_encounter_types_title_2)
destroy(this.st_encounters_well)
destroy(this.st_encounters_all)
destroy(this.st_encounter_types_title_1)
end on

event constructor;call super::constructor;// growth_type = 1 for 'Infants' 2 for 'Children'
If daysafter(current_patient.date_of_birth,today()) < 365 * 3 Then 
	growth_type = 1 
Elseif daysafter(current_patient.date_of_birth,today()) < 365 * 20 Then
	growth_type = 2
Else
	growth_type = 3
End if
end event

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_cpr_page_growth_percentiles
end type

type st_development from u_st_observation_status within u_cpr_page_growth_percentiles
integer x = 1710
integer y = 1124
integer width = 672
integer height = 108
boolean border = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;refresh_tab()
parent.postevent("refresh")

end event

type cb_growth_charts from commandbutton within u_cpr_page_growth_percentiles
integer x = 965
integer y = 1124
integer width = 672
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CDC Charts"
end type

event clicked;str_service_info lstr_service

//Open(w_growth_charts)

lstr_service.service = "Growth Chart"
service_list.do_service(lstr_service)


end event

type tab_growth_data from tab within u_cpr_page_growth_percentiles
event create ( )
event destroy ( )
integer width = 2880
integer height = 1088
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean focusonbuttondown = true
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
tabpage_graph tabpage_graph
tabpage_data tabpage_data
end type

on tab_growth_data.create
this.tabpage_graph=create tabpage_graph
this.tabpage_data=create tabpage_data
this.Control[]={this.tabpage_graph,&
this.tabpage_data}
end on

on tab_growth_data.destroy
destroy(this.tabpage_graph)
destroy(this.tabpage_data)
end on

type tabpage_graph from userobject within tab_growth_data
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 2843
integer height = 968
long backcolor = 12632256
string text = "Graph"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cbx_bmi cbx_bmi
cbx_hgtvswgt cbx_hgtvswgt
cbx_hc cbx_hc
cbx_height cbx_height
cbx_weight cbx_weight
gr_growth gr_growth
end type

on tabpage_graph.create
this.cbx_bmi=create cbx_bmi
this.cbx_hgtvswgt=create cbx_hgtvswgt
this.cbx_hc=create cbx_hc
this.cbx_height=create cbx_height
this.cbx_weight=create cbx_weight
this.gr_growth=create gr_growth
this.Control[]={this.cbx_bmi,&
this.cbx_hgtvswgt,&
this.cbx_hc,&
this.cbx_height,&
this.cbx_weight,&
this.gr_growth}
end on

on tabpage_graph.destroy
destroy(this.cbx_bmi)
destroy(this.cbx_hgtvswgt)
destroy(this.cbx_hc)
destroy(this.cbx_height)
destroy(this.cbx_weight)
destroy(this.gr_growth)
end on

type cbx_bmi from checkbox within tabpage_graph
integer x = 1344
integer y = 896
integer width = 242
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "BMI"
boolean checked = true
end type

event clicked;plot_datapoints()

end event

type cbx_hgtvswgt from checkbox within tabpage_graph
integer x = 955
integer y = 896
integer width = 375
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Hgt vs Wgt"
boolean checked = true
end type

event clicked;plot_datapoints()

end event

type cbx_hc from checkbox within tabpage_graph
integer x = 741
integer y = 896
integer width = 201
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "HC"
boolean checked = true
end type

event clicked;plot_datapoints()

end event

type cbx_height from checkbox within tabpage_graph
integer x = 475
integer y = 896
integer width = 251
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Height"
boolean checked = true
end type

event clicked;plot_datapoints()

end event

type cbx_weight from checkbox within tabpage_graph
integer x = 192
integer y = 896
integer width = 270
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Weight"
boolean checked = true
end type

event clicked;plot_datapoints()

end event

type gr_growth from graph within tabpage_graph
event create ( )
event destroy ( )
integer width = 2693
integer height = 884
boolean bringtotop = true
boolean border = true
grgraphtype graphtype = scattergraph!
long textcolor = 33554432
long backcolor = 12632256
integer spacing = 100
string title = "Normalized Growth Percentiles by Age"
integer elevation = 20
integer rotation = -20
integer perspective = 2
integer depth = 100
grlegendtype legend = atbottom!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
grsorttype categorysort = ascending!
end type

on gr_growth.create
TitleDispAttr = create grDispAttr
LegendDispAttr = create grDispAttr
PieDispAttr = create grDispAttr
Series = create grAxis
Series.DispAttr = create grDispAttr
Series.LabelDispAttr = create grDispAttr
Category = create grAxis
Category.DispAttr = create grDispAttr
Category.LabelDispAttr = create grDispAttr
Values = create grAxis
Values.DispAttr = create grDispAttr
Values.LabelDispAttr = create grDispAttr
TitleDispAttr.Weight=700
TitleDispAttr.FaceName="Arial"
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=536870912
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.Label="Age"
Category.ShadeBackEdge=true
Category.MaximumValue=90
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.MajorTic=Outside!
Category.DataType=adtDouble!
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Tahoma"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.AutoSize=true
Category.LabelDispAttr.Weight=700
Category.LabelDispAttr.FaceName="Arial"
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.Label="Percentile"
Values.MaximumValue=100
Values.MajorDivisions=10
Values.SecondaryLine=transparent!
Values.MajorGridLine=dot!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Tahoma"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=700
Values.LabelDispAttr.FaceName="Arial"
Values.LabelDispAttr.FontFamily=Swiss!
Values.LabelDispAttr.FontPitch=Variable!
Values.LabelDispAttr.Alignment=Center!
Values.LabelDispAttr.BackColor=536870912
Values.LabelDispAttr.Format="[General]"
Values.LabelDispAttr.DisplayExpression="valuesaxislabel"
Values.LabelDispAttr.AutoSize=true
Values.LabelDispAttr.Escapement=900
Series.Label="(None)"
Series.AutoScale=true
Series.SecondaryLine=transparent!
Series.MajorGridLine=transparent!
Series.MinorGridLine=transparent!
Series.DropLines=transparent!
Series.OriginLine=transparent!
Series.MajorTic=Outside!
Series.DataType=adtText!
Series.DispAttr.Weight=400
Series.DispAttr.FaceName="Tahoma"
Series.DispAttr.FontCharSet=DefaultCharSet!
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=536870912
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.DispAttr.AutoSize=true
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Tahoma"
Series.LabelDispAttr.FontCharSet=DefaultCharSet!
Series.LabelDispAttr.FontFamily=Swiss!
Series.LabelDispAttr.FontPitch=Variable!
Series.LabelDispAttr.Alignment=Center!
Series.LabelDispAttr.BackColor=536870912
Series.LabelDispAttr.Format="[General]"
Series.LabelDispAttr.DisplayExpression="seriesaxislabel"
Series.LabelDispAttr.AutoSize=true
LegendDispAttr.Weight=400
LegendDispAttr.FaceName="Arial"
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=536870912
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
LegendDispAttr.AutoSize=true
PieDispAttr.Weight=400
PieDispAttr.FaceName="Tahoma"
PieDispAttr.FontCharSet=DefaultCharSet!
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on gr_growth.destroy
destroy TitleDispAttr
destroy LegendDispAttr
destroy PieDispAttr
destroy Series.DispAttr
destroy Series.LabelDispAttr
destroy Series
destroy Category.DispAttr
destroy Category.LabelDispAttr
destroy Category
destroy Values.DispAttr
destroy Values.LabelDispAttr
destroy Values
end on

type tabpage_data from userobject within tab_growth_data
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 2843
integer height = 968
long backcolor = 12632256
string text = "Data"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_new_data cb_new_data
cb_print cb_print
st_unit_preference st_unit_preference
st_unit_preference_title st_unit_preference_title
dw_report dw_report
end type

on tabpage_data.create
this.cb_new_data=create cb_new_data
this.cb_print=create cb_print
this.st_unit_preference=create st_unit_preference
this.st_unit_preference_title=create st_unit_preference_title
this.dw_report=create dw_report
this.Control[]={this.cb_new_data,&
this.cb_print,&
this.st_unit_preference,&
this.st_unit_preference_title,&
this.dw_report}
end on

on tabpage_data.destroy
destroy(this.cb_new_data)
destroy(this.cb_print)
destroy(this.st_unit_preference)
destroy(this.st_unit_preference_title)
destroy(this.dw_report)
end on

type cb_new_data from commandbutton within tabpage_data
integer x = 2473
integer y = 720
integer width = 352
integer height = 96
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Data"
end type

event clicked;long ll_menu_id

ll_menu_id = f_get_context_menu("Patient", "New Vitals")
if ll_menu_id > 0 then
	f_display_menu(ll_menu_id, true)
end if

refresh()
parent.postevent("refresh")
end event

type cb_print from commandbutton within tabpage_data
integer x = 2473
integer y = 476
integer width = 352
integer height = 96
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;

tab_growth_data.tabpage_data.dw_report.object.t_patient.text = current_patient.name()
tab_growth_data.tabpage_data.dw_report.object.datawindow.footer.height = 200
tab_growth_data.tabpage_data.dw_report.print(false)
tab_growth_data.tabpage_data.dw_report.object.datawindow.footer.height = 0


end event

type st_unit_preference from statictext within tabpage_data
integer x = 2473
integer y = 96
integer width = 352
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Metric"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
f_toggle_unit_preference()

set_units()

refresh()

end event

type st_unit_preference_title from statictext within tabpage_data
integer x = 2473
integer y = 20
integer width = 352
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Unit Pref"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_report from u_dw_pick_list within tabpage_data
integer width = 2542
integer height = 864
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_growth_percentile_data"
boolean vscrollbar = true
end type

type st_encounter_types_title_2 from statictext within u_cpr_page_growth_percentiles
integer x = 18
integer y = 1216
integer width = 411
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounters"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_encounters_well from statictext within u_cpr_page_growth_percentiles
integer x = 18
integer y = 1148
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Well"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;well_or_all = "WELL"
refresh()


end event

type st_encounters_all from statictext within u_cpr_page_growth_percentiles
integer x = 256
integer y = 1148
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;well_or_all = "ALL"
refresh()

end event

type st_encounter_types_title_1 from statictext within u_cpr_page_growth_percentiles
integer x = 18
integer y = 1092
integer width = 411
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Data From"
alignment alignment = center!
boolean focusrectangle = false
end type

