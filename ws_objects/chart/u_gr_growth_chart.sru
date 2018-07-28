HA$PBExportHeader$u_gr_growth_chart.sru
forward
global type u_gr_growth_chart from graph
end type
end forward

global type u_gr_growth_chart from graph
integer width = 1006
integer height = 720
boolean border = true
grgraphtype graphtype = linegraph!
long textcolor = 33554432
long backcolor = 30331862
integer spacing = 100
integer elevation = 20
integer rotation = -20
integer perspective = 2
integer depth = 100
grlegendtype legend = atright!
boolean focusrectangle = false
grsorttype categorysort = ascending!
end type
global u_gr_growth_chart u_gr_growth_chart

type variables
string graph_title
string	patient_info

u_ds_data cdc_data
u_ds_data patient_data

decimal avg_days_per_month = 30.417

boolean use_cached_growth_charts


end variables

forward prototypes
public function integer display_growth_chart (string ps_infant_child, string ps_type, string ps_visit, string ps_unit_preference)
public function integer display_height_vs_weight (string ps_infant_child, string ps_visit, string ps_unit_preference)
end prototypes

public function integer display_growth_chart (string ps_infant_child, string ps_type, string ps_visit, string ps_unit_preference);Datetime			ldt_birth_dt
Long				ll_cdc_rowcount,ll_patient_rowcount
Long				ll_row=1,ll_count=1
Long				ll_age
long ll_last_age
String			ls_obs_id,ls_cpr_id
String			ls_category_label
string ls_metric_value_label
Integer			li_sex
double			ld_age_start_days, ld_age_end_days
double			ld_height,ld_weight,ld_bmi
string ls_recorded_value
string ls_graph_value
string ls_unit
string ls_observation_id
u_unit luo_unit
u_unit luo_unit_kg
u_unit luo_unit_cm
double ld_value
double ld_metric_min_value
double ld_metric_max_value
double ld_age_category_units
double ld_age_months
double ld_cdc_age_time_intervals
long i, j
string ls_graph_file
string ls_english_value_label
double ld_english_min_value
double ld_english_max_value
double ld_english_multiplier
double ld_metric_scale_increment
double ld_english_scale_increment
integer lia_series[10]
long ll_displayeverynlabels
long ll_time_interval_start
long ll_time_interval_end
long ll_time_intervals_per_category_unit
long ll_months_per_category_unit
long ll_series_count = 7
double ld_last_cdc_age
double ld_next_cdc_age
double lda_last_cdc_value[]
double lda_next_cdc_value[]
double lda_value[]
long ll_next_cdc_row
double ld_fraction
long ll_age_days
long ll_age_time_intervals
string ls_english
double ld_min_value
double ld_max_value
boolean lb_metric
string ls_null
long ll_time_intervals_per_month = 10

setnull(ls_null)

if upper(ps_type) = "WEIGHTVSHEIGHT" then
	return display_height_vs_weight(ps_infant_child, ps_visit, ps_unit_preference)
end if

// Initialize the graph
//initialize_graph_properties()
cdc_data = CREATE u_ds_data
patient_data = CREATE u_ds_data

CHOOSE CASE lower(ps_infant_child)
	CASE "infant"
		// Plot data point in time intervals of 1/10th of a month
		ll_time_intervals_per_month = 10
		
		// Set the apparent date of birth to the gaa-adjusted date of birth to compensate for premature babies
		ldt_birth_dt = datetime(current_patient.gaa_date_of_birth)
		
		// Run the graph from birth to 3 years
		ld_age_start_days = 0
		ld_age_end_days = daysafter(current_patient.gaa_date_of_birth, f_add_years(current_patient.gaa_date_of_birth, 3))
		
		// calculate the number of time intervals represented by the start and end of the plotted age range
		ll_time_interval_start = ld_age_start_days * ll_time_intervals_per_month / avg_days_per_month
		ll_time_interval_end = ld_age_end_days * ll_time_intervals_per_month / avg_days_per_month
		
		// Define the category (x-axis) parameters
		ll_months_per_category_unit = 1  // 1 month per category unit
		ll_time_intervals_per_category_unit = ll_time_intervals_per_month * ll_months_per_category_unit
		ll_displayeverynlabels = ll_time_intervals_per_month * 3  // 3 months
		ls_category_label = "Age (Months)"
		
		Choose Case upper(ps_type)
			Case "WEIGHT"
				cdc_data.dataobject = "d_cdc_wtageinf"
				graph_title = "Weight vs Age"
				ls_metric_value_label = "Weight (Kgs)"
				ls_english_value_label = "Weight (Lbs)"
				ld_english_multiplier =  2.205
				ld_metric_scale_increment = 2
				ld_english_scale_increment = 5
				ls_obs_id = "WGT"
			Case "HEIGHT"
				cdc_data.dataobject = "d_cdc_lenageinf"
				graph_title = "Length vs Age"
				ls_metric_value_label = "Length (cm)"
				ls_english_value_label = "Length (inches)"
				ld_english_multiplier =  0.3937
				ld_metric_scale_increment = 5
				ld_english_scale_increment = 2
				ls_obs_id = "HGT"
			Case "HC"
				cdc_data.dataobject = "d_cdc_hcageinf"
				graph_title = "HC vs Age"
				ls_metric_value_label = "Head Circumference (cm)"
				ls_english_value_label = "Head Circumference (inches)"
				ld_english_multiplier =  0.3937
				ld_metric_scale_increment = 2
				ld_english_scale_increment = 1
				ls_obs_id = "HC"
		End Choose
	CASE ELSE
		// Plot data point in time intervals of 1/10th of a month
		ll_time_intervals_per_month = 2
		
		// Use the actual date of birth (don't adjust for premature babies)
		ldt_birth_dt = datetime(current_patient.date_of_birth)
		
		// calculate the number of time intervals represented by the start and end of the plotted age range
		ll_time_interval_start = ll_time_intervals_per_month * 24  // Start at 2 years
		ll_time_interval_end = ll_time_intervals_per_month * 240  // End at 20 years
		ld_age_start_days = (double(ll_time_interval_start) * avg_days_per_month) / ll_time_intervals_per_month
		ld_age_end_days = (double(ll_time_interval_end) * avg_days_per_month) / ll_time_intervals_per_month

		// Define the category (x-axis) parameters
		ll_months_per_category_unit = 12 // 12 months per category unit
		ll_time_intervals_per_category_unit = ll_time_intervals_per_month * ll_months_per_category_unit
		ll_displayeverynlabels = ll_time_intervals_per_month * 24  // 2 years
		ls_category_label = "Age (Years)"
		
		Choose Case upper(ps_type)
			Case "WEIGHT"
				cdc_data.dataobject = "d_cdc_wtage"
				graph_title = "Weight vs Age"
				ls_metric_value_label = "Weight (Kgs)"
				ls_english_value_label = "Weight (Lbs)"
				ld_english_multiplier =  2.205
				ld_metric_scale_increment = 10
				ld_english_scale_increment = 20
				ls_obs_id = "WGT"
				ps_infant_child = "child"
			Case "HEIGHT"
				cdc_data.dataobject = "d_cdc_statage"
				graph_title = "Stature vs Age"
				ls_metric_value_label = "Stature (cm)"
				ls_english_value_label = "Stature (Inches)"
				ld_english_multiplier = 0.3937
				ld_metric_scale_increment = 10
				ld_english_scale_increment = 5
				ls_obs_id = "HGT"
				ps_infant_child = "child"
			Case "BMI"
				cdc_data.dataobject = "d_cdc_bmiage"
				graph_title = "BMI vs Age"
				ls_metric_value_label = "Body Mass Index (kg/m$$HEX1$$b200$$ENDHEX$$)"
				ld_metric_scale_increment = 2
				ld_english_scale_increment = 1
				ps_unit_preference = "METRIC"  // there is no such thing as an English BMI
			Case Else
				log.log(this,"children_growth_charts()","Growth type "+ps_type+" not found..",3)
				return -1
		End Choose
END CHOOSE

if upper(ps_unit_preference) = "ENGLISH" then
	lb_metric = false
else
	lb_metric = true
end if


ls_cpr_id = current_patient.cpr_id
// If 'Female' set the sex number '2' else '1'
If current_patient.sex = "F" Then li_sex = 2 Else li_sex = 1

setnull(ld_english_multiplier)

// Get records from cdc table
cdc_data.Settransobject(SQLCA)
cdc_data.retrieve(li_sex)
If Not tf_check() Then return -1

ll_cdc_rowcount = cdc_data.rowcount()
If ll_cdc_rowcount <= 0 Then
	log.log(this,"children_growth_charts()","Cdc data for this '"+ps_type+"' not found..",3)
	return -1
End If


luo_unit_kg = unit_list.find_unit("KG")
luo_unit_cm = unit_list.find_unit("CM")

setredraw(false)

reset(all!)

// Set the metric value axis scale
ld_metric_min_value = int(cdc_data.getitemdecimal(1,"p5") / ld_metric_scale_increment) * ld_metric_scale_increment - (2 * ld_metric_scale_increment)
if ld_metric_min_value < 0 then ld_metric_min_value = 0
ld_metric_max_value = (int(cdc_data.getitemdecimal(ll_cdc_rowcount,"p95") / ld_metric_scale_increment) *ld_metric_scale_increment) + (2 * ld_metric_scale_increment)

// Set the english value axis scale
ld_min_value = cdc_data.getitemdecimal(1,"p5")
ld_max_value = cdc_data.getitemdecimal(ll_cdc_rowcount,"p95")
Choose Case upper(ps_type)
	Case "WEIGHT"
		// convert cdc weight from kg to lb
		ls_english = luo_unit_kg.convert("LB", string(ld_min_value), ls_null, false)
		ld_english_min_value = double(ls_english)
		ls_english = luo_unit_kg.convert("LB", string(ld_max_value), ls_null, false)
		ld_english_max_value = double(ls_english)
	Case "HEIGHT"
		// convert cdc height from cm to inch
		ls_english = luo_unit_cm.convert("INCH", string(ld_min_value), ls_null, false)
		ld_english_min_value = double(ls_english)
		ls_english = luo_unit_cm.convert("INCH", string(ld_max_value), ls_null, false)
		ld_english_max_value = double(ls_english)
	Case "HC"
		// convert cdc hc from cm to inch
		ls_english = luo_unit_cm.convert("INCH", string(ld_min_value), ls_null, false)
		ld_english_min_value = double(ls_english)
		ls_english = luo_unit_cm.convert("INCH", string(ld_max_value), ls_null, false)
		ld_english_max_value = double(ls_english)
END CHOOSE

ld_english_min_value = int(ld_english_min_value/ ld_english_scale_increment) * ld_english_scale_increment - (2 * ld_english_scale_increment)
if ld_english_min_value < 0 then ld_english_min_value = 0

ld_english_max_value = (int(ld_english_max_value / ld_english_scale_increment) *ld_english_scale_increment) + (2 * ld_english_scale_increment)


// The min BMI is actually around 6 years old, so for BMI, hard code the min at 12
if upper(ps_type) = "BMI" then
	ld_metric_min_value = 12
end if

// get patient growth records
If upper(ps_type) = "BMI" Then
	patient_data.dataobject = "d_patient_growth_data_htwt"
	patient_data.Settransobject(SQLCA)
	ll_patient_rowcount = patient_data.retrieve(ls_cpr_id,ldt_birth_dt,ld_age_start_days,ld_age_end_days,ps_visit)
	If ll_patient_rowcount < 0 Then return -1
Else
	patient_data.dataobject = "d_patient_growth_data"
	patient_data.Settransobject(SQLCA)
	ll_patient_rowcount = patient_data.retrieve(ls_cpr_id,ls_obs_id,ldt_birth_dt,ld_age_start_days,ld_age_end_days,ps_visit)
	If ll_patient_rowcount < 0 Then return -1
End If


 
Title = graph_title
if len(patient_info) > 0 then
	title += "   " + patient_info
end if

category.label = ls_category_label
if graphtype = scattergraph! then
	category.autoscale = false
	category.minimumvalue = double(ll_time_interval_start) / ll_time_intervals_per_category_unit
	category.maximumvalue = double(ll_time_interval_end) / ll_time_intervals_per_category_unit
	category.majordivisions = (ll_time_interval_end - ll_time_interval_start) / (ll_time_intervals_per_category_unit * ll_displayeverynlabels)
else
	category.autoscale = true
	category.displayeverynlabels = ll_displayeverynlabels
end if

values.autoscale = false
if lb_metric then
	values.label = ls_metric_value_label
	values.minimumvalue = ld_metric_min_value
	values.maximumvalue = ld_metric_max_value
	values.majordivisions = (ld_metric_max_value - ld_metric_min_value) / ld_metric_scale_increment
else
	values.label = ls_english_value_label
	values.minimumvalue = ld_english_min_value
	values.maximumvalue = ld_english_max_value
	values.majordivisions = (ld_english_max_value - ld_english_min_value) / ld_english_scale_increment
end if

// Add the series
lia_series[1] = addseries("95%")
lia_series[2] = addseries("90%")
lia_series[3] = addseries("75%")
lia_series[4] = addseries("50%")
lia_series[5] = addseries("25%")
lia_series[6] = addseries("10%")
lia_series[7] = addseries("5%")

SetSeriesStyle ("95%", LineColor!, RGB(196,62,28))
SetSeriesStyle ("90%", LineColor!, RGB(43,30,193))
SetSeriesStyle ("75%", LineColor!, RGB(86,158,65))
SetSeriesStyle ("50%", LineColor!, RGB(207,16,203))
SetSeriesStyle ("25%", LineColor!, RGB(0,183,183))
SetSeriesStyle ("10%", LineColor!, RGB(128,128,255))
SetSeriesStyle ("5%", LineColor!, RGB(255,128,128))

SetSeriesStyle ("5%", NoSymbol!)
SetSeriesStyle ("10%", NoSymbol!)
SetSeriesStyle ("25%", NoSymbol!)
SetSeriesStyle ("50%", NoSymbol!)
SetSeriesStyle ("75%", NoSymbol!)
SetSeriesStyle ("90%", NoSymbol!)
SetSeriesStyle ("95%", NoSymbol!)

SetSeriesStyle ("50%", Continuous!, 3)

// Set the initial cdc vector
ll_next_cdc_row = 1
ld_last_cdc_age = cdc_data.object.data[ll_next_cdc_row,1]
lda_last_cdc_value[1] = cdc_data.object.p95[ll_next_cdc_row]
lda_last_cdc_value[2] = cdc_data.object.p90[ll_next_cdc_row]
lda_last_cdc_value[3] = cdc_data.object.p75[ll_next_cdc_row]
lda_last_cdc_value[4] = cdc_data.object.p50[ll_next_cdc_row]
lda_last_cdc_value[5] = cdc_data.object.p25[ll_next_cdc_row]
lda_last_cdc_value[6] = cdc_data.object.p10[ll_next_cdc_row]
lda_last_cdc_value[7] = cdc_data.object.p5[ll_next_cdc_row]
ld_next_cdc_age = ld_last_cdc_age
lda_next_cdc_value = lda_last_cdc_value

for i = ll_time_interval_start to ll_time_interval_end
	ld_age_months = double(i) / ll_time_intervals_per_month
	ld_age_category_units = double(i) / ll_time_intervals_per_category_unit
	addcategory(ld_age_category_units)
	
	if ld_next_cdc_age < ld_age_months then
		// if the cat age is outside our cdc range then increment the cdc row
		ld_last_cdc_age = ld_next_cdc_age
		lda_last_cdc_value = lda_next_cdc_value
		
		DO WHILE ld_next_cdc_age < ld_age_months
			if ll_next_cdc_row < ll_cdc_rowcount then
				ll_next_cdc_row += 1
				ld_next_cdc_age = cdc_data.object.data[ll_next_cdc_row,1]
				lda_next_cdc_value[1] = cdc_data.object.p95[ll_next_cdc_row]
				lda_next_cdc_value[2] = cdc_data.object.p90[ll_next_cdc_row]
				lda_next_cdc_value[3] = cdc_data.object.p75[ll_next_cdc_row]
				lda_next_cdc_value[4] = cdc_data.object.p50[ll_next_cdc_row]
				lda_next_cdc_value[5] = cdc_data.object.p25[ll_next_cdc_row]
				lda_next_cdc_value[6] = cdc_data.object.p10[ll_next_cdc_row]
				lda_next_cdc_value[7] = cdc_data.object.p5[ll_next_cdc_row]
			else
				// we've reached the end of the CDC data so stop plotting cdc points
				ll_next_cdc_row = 0
				exit
			end if
		LOOP
	end if

	if ll_next_cdc_row = 0 then continue
	
	if ld_age_category_units <= ld_last_cdc_age then
		lda_value = lda_last_cdc_value
	elseif ld_age_category_units >= ld_next_cdc_age then
		lda_value = lda_next_cdc_value
	else
		// If we get here then we need to interpolate
		ld_fraction = (ld_age_category_units - ld_last_cdc_age) / (ld_next_cdc_age - ld_last_cdc_age)
		for j = 1 to ll_series_count
			lda_value[j] = lda_last_cdc_value[j] + ((lda_next_cdc_value[j] - lda_last_cdc_value[j]) * ld_fraction)
		next
	end if

	
	for j = 1 to ll_series_count
		if lb_metric then
			ld_value = lda_value[j]
		else
			Choose Case upper(ps_type)
				Case "WEIGHT"
					// convert cdc weight from kg to lb
					ls_english = luo_unit_kg.convert("LB", string(lda_value[j]), ls_null, false)
					ld_value = double(ls_english)
				Case "HEIGHT"
					// convert cdc height from cm to inch
					ls_english = luo_unit_cm.convert("INCH", string(lda_value[j]), ls_null, false)
					ld_value = double(ls_english)
				Case "HC"
					// convert cdc hc from cm to inch
					ls_english = luo_unit_cm.convert("INCH", string(lda_value[j]), ls_null, false)
					ld_value = double(ls_english)
			END CHOOSE
		end if
	
		if graphtype = scattergraph! then
			adddata(lia_series[j], ld_age_category_units, ld_value)
		else
			adddata(lia_series[j], ld_value, ld_age_category_units)
		end if
	next
next


// Plot the patient data
lia_series[8] = addseries("Data")
SetSeriesStyle ("Data", SymbolPlus!)
SetSeriesStyle ("Data", LineColor!, RGB(0,128,0))

if upper(ps_type) = "BMI" then
//	Calculate BMI Value
// 
// BMI = weight(kg) % height(in cm) % height(in cm) * 10,000
//
	ll_last_age = -1
	setnull(ld_height)
	setnull(ld_weight)
	// Loop through each record
	for ll_count = 1 to ll_patient_rowcount
		ll_age = patient_data.object.age[ll_count]
		if ll_age > ll_last_age then
			// If the age has changed, see if we have both height and weight for the last age value
			if not isnull(ld_height) and not isnull(ld_weight) then
				// If we have both values, then plot the bmi
				ld_bmi = (ld_weight/(ld_height * ld_height)) * 10000
				
				// Determine which category (age) this observation is closest to
				ll_age_days = ll_last_age
				ll_age_time_intervals = long(round((double(ll_age_days) * ll_time_intervals_per_month) / avg_days_per_month, 0))
				ld_age_category_units = double(ll_age_time_intervals) / ll_time_intervals_per_category_unit
				
				// Plot the data point
				if graphtype = scattergraph! then
					adddata(lia_series[8], ld_age_category_units, ld_bmi)
				else
					adddata(lia_series[8], ld_bmi, ld_age_category_units)
				end if
			end if
			// Reset the variables
			ll_last_age = ll_age
			setnull(ld_height)
			setnull(ld_weight)
		end if
		
		// Now for the next value, see what it is and convert it and store it appropriately
		ls_observation_id = patient_data.object.observation_id[ll_count]
		ls_recorded_value = patient_data.object.result_value[ll_count]
		ls_unit = patient_data.object.result_unit[ll_count]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) and not isnull(ls_recorded_value) then
			CHOOSE CASE upper(ls_observation_id)
				CASE "HGT"
					ls_graph_value = luo_unit.convert("CM", ls_recorded_value, ls_null, false)
					ld_height = double(ls_graph_value)
				CASE "WGT"
					ls_graph_value = luo_unit.convert("KG", ls_recorded_value, ls_null, false)
					ld_weight = double(ls_graph_value)
			END CHOOSE
		end if
	next
	// If we exited the loop with both an height and weight value, then plot the last data point
	if not isnull(ld_height) and not isnull(ld_weight) then
		// If we have both values, then plot the bmi
		ld_bmi = (ld_weight/(ld_height * ld_height)) * 10000
		
		// Determine which category (age) this observation is closest to
		ll_age_days = ll_age
		ll_age_time_intervals = long(round((double(ll_age_days) * ll_time_intervals_per_month) / avg_days_per_month, 0))
		ld_age_category_units = double(ll_age_time_intervals) / ll_time_intervals_per_category_unit
		
		// Plot the data point
		if graphtype = scattergraph! then
			adddata(lia_series[8], ld_age_category_units, ld_bmi)
		else
			adddata(lia_series[8], ld_bmi, ld_age_category_units)
		end if
	end if
else
	for ll_count = 1 to ll_patient_rowcount
		ls_observation_id = patient_data.object.observation_id[ll_count]
		ls_recorded_value = patient_data.object.result_value[ll_count]
		ls_unit = patient_data.object.result_unit[ll_count]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) and not isnull(ls_recorded_value) then
			CHOOSE CASE upper(ls_observation_id)
				CASE "HGT"
					if lb_metric then
						ls_graph_value = luo_unit.convert("CM", ls_recorded_value, ls_null, false)
					else
						ls_graph_value = luo_unit.convert("INCH", ls_recorded_value, ls_null, false)
					end if
				CASE "WGT"
					if lb_metric then
						ls_graph_value = luo_unit.convert("KG", ls_recorded_value, ls_null, false)
					else
						ls_graph_value = luo_unit.convert("LB", ls_recorded_value, ls_null, false)
					end if
				CASE "HC"
					if lb_metric then
						ls_graph_value = luo_unit.convert("CM", ls_recorded_value, ls_null, false)
					else
						ls_graph_value = luo_unit.convert("INCH", ls_recorded_value, ls_null, false)
					end if
			END CHOOSE
		end if
		ld_value = double(ls_graph_value)
		if not isnull(ld_value) then
			// Determine which category (age) this observation is closest to
			ll_age_days = patient_data.object.age[ll_count]
			ll_age_time_intervals = long(round((double(ll_age_days) * ll_time_intervals_per_month) / avg_days_per_month, 0))
			ld_age_category_units = double(ll_age_time_intervals) / ll_time_intervals_per_category_unit
			
			// Plot the data point
			if graphtype = scattergraph! then
				adddata(lia_series[8], ld_age_category_units, ld_value)
			else
				adddata(lia_series[8], ld_value, ld_age_category_units)
			end if
		end if
	next
end if


setredraw(true)

return 1

end function

public function integer display_height_vs_weight (string ps_infant_child, string ps_visit, string ps_unit_preference);Datetime			ldt_birth_dt
Long				ll_cdc_rowcount,ll_patient_rowcount
Long				ll_row=1,ll_count=1
Long				ll_age
long ll_last_age
String			ls_obs_id,ls_cpr_id
string ls_metric_category_label
string ls_english_category_label
string ls_metric_value_label
Integer			li_sex
double			ld_age_divisor,ld_age_start, ld_age_end
double			ld_height,ld_weight,ld_bmi
string ls_recorded_value
string ls_graph_value
string ls_unit
string ls_observation_id
u_unit luo_unit
u_unit luo_unit_kg
u_unit luo_unit_cm
double ld_value
double ld_metric_min_value
double ld_metric_max_value
//double ld_age
//double ld_age_half_months
double ld_cdc_cat_half_months
long i, j
string ls_graph_file
string ls_english_value_label
double ld_english_min_value
double ld_english_max_value
double ld_english_multiplier
double ld_metric_scale_increment
double ld_english_scale_increment
integer lia_series[10]
long ll_displayeverynlabels
long ll_half_month_start
long ll_half_month_end
long ll_half_months_per_category_unit
long ll_category_count
long ll_category_month_divisor
long ll_series_count = 7
double ld_last_cdc_cat
double ld_next_cdc_cat
double lda_last_cdc_value[]
double lda_next_cdc_value[]
double lda_value[]
long ll_next_cdc_row
double ld_fraction
//long ll_age_days
//long ll_age_half_months
string ls_english
double ld_min_value
double ld_max_value
boolean lb_metric
string ls_null
double ld_cat_min_value
double ld_cat_max_value
double ld_cat_scale_increment
long ll_height_parts
double ld_cat_value
long ll_height_parts_per_unit = 5
double ld_height_increment
double ld_weight_min_value
double ld_weight_max_value
long ll_majordivisions

setnull(ls_null)

// Initialize the graph
//initialize_graph_properties()
cdc_data = CREATE u_ds_data
patient_data = CREATE u_ds_data

CHOOSE CASE lower(ps_infant_child)
	CASE "infant"
		// Set the age limits to filter only those records
		ld_age_start = 0
		ld_age_end = 365*3
		ld_age_divisor = avg_days_per_month
		ldt_birth_dt = datetime(current_patient.gaa_date_of_birth)
		
		ll_half_month_start = 0
		ll_half_month_end = 72
		ll_half_months_per_category_unit = 2  // 1 Month Units
		ll_displayeverynlabels = 6  // 3 months
		ll_category_month_divisor = 1  // 1 month per category unit
		
		cdc_data.dataobject = "d_cdc_wtleninf"
		ls_metric_category_label = "Length (cm)"
		ls_english_category_label = "Length (inch)"
		ld_english_multiplier =  2.205
		ld_metric_scale_increment = 2
		graph_title = "Length vs Height"

		ls_metric_value_label = "Weight (Kgs)"
		ls_english_value_label = "Weight (Lbs)"
		ld_english_multiplier =  2.205
		ld_metric_scale_increment = 2
		ld_english_scale_increment = 5
		ls_obs_id = "WGT"
	CASE ELSE
		// Set the age limits to filter only those records
		ld_age_start = 365*2
		ld_age_end = 365*20
		ld_age_divisor = 365
		ldt_birth_dt = datetime(current_patient.date_of_birth)
		
		ll_half_month_start = 48
		ll_half_month_end = 480
		ll_half_months_per_category_unit = 24  // 1 Year Units
		ll_displayeverynlabels = 48  // 2 years
		ll_category_month_divisor = 12 // 12 months per category unit
		
		cdc_data.dataobject = "d_cdc_wtstat"
		ls_metric_category_label = "Stature (cm)"
		ls_english_category_label = "Stature (inch)"
		ld_english_multiplier =  2.205
		ld_metric_scale_increment = 2
		ld_english_scale_increment = 5
		graph_title = "Weight vs Stature"
	
		ls_metric_value_label = "Weight (Kgs)"
		ls_english_value_label = "Weight (Lbs)"
		ls_obs_id = "WGT"
END CHOOSE

if upper(ps_unit_preference) = "ENGLISH" then
	lb_metric = false
else
	lb_metric = true
end if


ls_cpr_id = current_patient.cpr_id
// If 'Female' set the sex number '2' else '1'
If current_patient.sex = "F" Then li_sex = 2 Else li_sex = 1

setnull(ld_english_multiplier)

// Get records from cdc table
cdc_data.Settransobject(SQLCA)
cdc_data.retrieve(li_sex)
If Not tf_check() Then return -1

ll_cdc_rowcount = cdc_data.rowcount()
If ll_cdc_rowcount <= 0 Then
	log.log(this,"children_growth_charts()","Cdc data for this '"+cdc_data.dataobject +"' not found..",3)
	return -1
End If


luo_unit_kg = unit_list.find_unit("KG")
luo_unit_cm = unit_list.find_unit("CM")

setredraw(false)

reset(all!)

// Set the metric category axis scale
ld_min_value = cdc_data.getitemdecimal(1,1)
ld_max_value = cdc_data.getitemdecimal(ll_cdc_rowcount,1)
if lb_metric then
	ld_cat_scale_increment = 5
	
	ld_cat_min_value = int(cdc_data.getitemdecimal(1,1) / ld_cat_scale_increment) * ld_cat_scale_increment
	if ld_cat_min_value < 0 then ld_cat_min_value = 0
	ld_cat_max_value = (int(cdc_data.getitemdecimal(ll_cdc_rowcount,1) / ld_cat_scale_increment) *ld_cat_scale_increment) + (1 * ld_cat_scale_increment)
else
	ld_cat_scale_increment = 2
	
	ls_english = luo_unit_cm.convert("INCH", string(ld_min_value), ls_null, false)
	ld_cat_min_value = double(ls_english)
	ls_english = luo_unit_cm.convert("INCH", string(ld_max_value), ls_null, false)
	ld_cat_max_value = double(ls_english)
	
	ld_cat_min_value = int(ld_cat_min_value / ld_cat_scale_increment) * ld_cat_scale_increment
	if ld_cat_min_value < 0 then ld_cat_min_value = 0
	ld_cat_max_value = (int(ld_cat_max_value / ld_cat_scale_increment) *ld_cat_scale_increment) + (1 * ld_cat_scale_increment)
end if

// Set the metric value axis scale
ld_metric_min_value = int(cdc_data.getitemdecimal(1,"p5") / ld_metric_scale_increment) * ld_metric_scale_increment - (1 * ld_metric_scale_increment)
if ld_metric_min_value < 0 then ld_metric_min_value = 0
ld_metric_max_value = (int(cdc_data.getitemdecimal(ll_cdc_rowcount,"p95") / ld_metric_scale_increment) *ld_metric_scale_increment) + (1 * ld_metric_scale_increment)

// Set the english value axis scale
ld_min_value = cdc_data.getitemdecimal(1,"p5")
ld_max_value = cdc_data.getitemdecimal(ll_cdc_rowcount,"p95")
// convert cdc weight from kg to lb
ls_english = luo_unit_kg.convert("LB", string(ld_min_value), ls_null, false)
ld_english_min_value = double(ls_english)
ls_english = luo_unit_kg.convert("LB", string(ld_max_value), ls_null, false)
ld_english_max_value = double(ls_english)

ld_english_min_value = int(ld_english_min_value/ ld_english_scale_increment) * ld_english_scale_increment - (1 * ld_english_scale_increment)
if ld_english_min_value < 0 then ld_english_min_value = 0

ld_english_max_value = (int(ld_english_max_value / ld_english_scale_increment) *ld_english_scale_increment) + (1 * ld_english_scale_increment)


patient_data.dataobject = "d_patient_growth_data_htwt"
patient_data.Settransobject(SQLCA)
ll_patient_rowcount = patient_data.retrieve(ls_cpr_id,ldt_birth_dt,ld_age_start,ld_age_end,ps_visit)
If ll_patient_rowcount < 0 Then return -1


Title = graph_title
if len(patient_info) > 0 then
	title += "   " + patient_info
end if
 
if graphtype = scattergraph! then
	category.autoscale = false
	category.minimumvalue = double(ll_half_month_start) / ll_half_months_per_category_unit
	category.maximumvalue = double(ll_half_month_end) / ll_half_months_per_category_unit
	category.majordivisions = (ll_half_month_end - ll_half_month_start) / (ll_half_months_per_category_unit * ll_displayeverynlabels)
else
	category.autoscale = true
	category.displayeverynlabels = ld_cat_scale_increment * ll_height_parts_per_unit
end if

values.autoscale = false
if lb_metric then
	category.label = ls_metric_category_label
	values.label = ls_metric_value_label
	
	ld_weight_min_value = ld_metric_min_value
	ld_weight_max_value = ld_metric_max_value
	ll_majordivisions = (ld_metric_max_value - ld_metric_min_value) / ld_metric_scale_increment
else
	category.label = ls_english_category_label
	values.label = ls_english_value_label
	
	ld_weight_min_value = ld_english_min_value
	ld_weight_max_value = ld_english_max_value
	ll_majordivisions = (ld_english_max_value - ld_english_min_value) / ld_english_scale_increment
end if

values.minimumvalue = ld_weight_min_value
values.maximumvalue = ld_weight_max_value
values.majordivisions = ll_majordivisions

// Add the series
lia_series[1] = addseries("95%")
lia_series[2] = addseries("90%")
lia_series[3] = addseries("75%")
lia_series[4] = addseries("50%")
lia_series[5] = addseries("25%")
lia_series[6] = addseries("10%")
lia_series[7] = addseries("5%")

SetSeriesStyle ("95%", LineColor!, RGB(196,62,28))
SetSeriesStyle ("90%", LineColor!, RGB(43,30,193))
SetSeriesStyle ("75%", LineColor!, RGB(86,158,65))
SetSeriesStyle ("50%", LineColor!, RGB(207,16,203))
SetSeriesStyle ("25%", LineColor!, RGB(255,255,128))
SetSeriesStyle ("10%", LineColor!, RGB(128,128,255))
SetSeriesStyle ("5%", LineColor!, RGB(255,128,128))

SetSeriesStyle ("5%", NoSymbol!)
SetSeriesStyle ("10%", NoSymbol!)
SetSeriesStyle ("25%", NoSymbol!)
SetSeriesStyle ("50%", NoSymbol!)
SetSeriesStyle ("75%", NoSymbol!)
SetSeriesStyle ("90%", NoSymbol!)
SetSeriesStyle ("95%", NoSymbol!)

SetSeriesStyle ("50%", Continuous!, 3)

// Add the categories (each category is a half month)
ll_category_count = ll_half_month_end - ll_half_month_start

ll_next_cdc_row = 1
if lb_metric then
	ld_last_cdc_cat = cdc_data.object.data[ll_next_cdc_row,1]
else
	// convert cdc length from cm to inch
	ld_last_cdc_cat = cdc_data.object.data[ll_next_cdc_row,1]
	ls_english = luo_unit_cm.convert("INCH", string(ld_last_cdc_cat), ls_null, false)
	ld_last_cdc_cat = double(ls_english)
end if
lda_last_cdc_value[1] = cdc_data.object.p95[ll_next_cdc_row]
lda_last_cdc_value[2] = cdc_data.object.p90[ll_next_cdc_row]
lda_last_cdc_value[3] = cdc_data.object.p75[ll_next_cdc_row]
lda_last_cdc_value[4] = cdc_data.object.p50[ll_next_cdc_row]
lda_last_cdc_value[5] = cdc_data.object.p25[ll_next_cdc_row]
lda_last_cdc_value[6] = cdc_data.object.p10[ll_next_cdc_row]
lda_last_cdc_value[7] = cdc_data.object.p5[ll_next_cdc_row]
ld_next_cdc_cat = ld_last_cdc_cat
lda_next_cdc_value = lda_last_cdc_value

ld_height_increment = double(1.0) / ll_height_parts_per_unit
ll_height_parts = (ld_cat_max_value - ld_cat_min_value) * ll_height_parts_per_unit

for i = 0 to ll_height_parts -1
	ld_cat_value = ld_cat_min_value + (i * ld_height_increment)
	addcategory(ld_cat_value)
	
	if ld_next_cdc_cat < ld_cat_value then
		// if the cat length is outside our cdc range then increment the cdc row
		ld_last_cdc_cat = ld_next_cdc_cat
		lda_last_cdc_value = lda_next_cdc_value
		
		DO WHILE ld_next_cdc_cat < ld_cat_value
			if ll_next_cdc_row < ll_cdc_rowcount then
				ll_next_cdc_row += 1
				if lb_metric then
					ld_next_cdc_cat = cdc_data.object.data[ll_next_cdc_row,1]
				else
					// convert cdc length from cm to inch
					ld_next_cdc_cat = cdc_data.object.data[ll_next_cdc_row,1]
					ls_english = luo_unit_cm.convert("INCH", string(ld_next_cdc_cat), ls_null, false)
					ld_next_cdc_cat = double(ls_english)
				end if
				lda_next_cdc_value[1] = cdc_data.object.p95[ll_next_cdc_row]
				lda_next_cdc_value[2] = cdc_data.object.p90[ll_next_cdc_row]
				lda_next_cdc_value[3] = cdc_data.object.p75[ll_next_cdc_row]
				lda_next_cdc_value[4] = cdc_data.object.p50[ll_next_cdc_row]
				lda_next_cdc_value[5] = cdc_data.object.p25[ll_next_cdc_row]
				lda_next_cdc_value[6] = cdc_data.object.p10[ll_next_cdc_row]
				lda_next_cdc_value[7] = cdc_data.object.p5[ll_next_cdc_row]
			else
				// we've reached the end of the CDC data so stop plotting cdc points
				ll_next_cdc_row = 0
				exit
			end if
		LOOP
	end if

	if ll_next_cdc_row = 0 then continue
	
	if ld_cat_value < ld_last_cdc_cat then
		continue
	elseif ld_cat_value = ld_last_cdc_cat then
		lda_value = lda_last_cdc_value
	elseif ld_cat_value >= ld_next_cdc_cat then
		lda_value = lda_next_cdc_value
	else
		// If we get here then we need to interpolate
		ld_fraction = (ld_cat_value - ld_last_cdc_cat) / (ld_next_cdc_cat - ld_last_cdc_cat)
		for j = 1 to ll_series_count
			lda_value[j] = lda_last_cdc_value[j] + ((lda_next_cdc_value[j] - lda_last_cdc_value[j]) * ld_fraction)
		next
	end if

	
	for j = 1 to ll_series_count
		if lb_metric then
			ld_value = lda_value[j]
		else
			// convert cdc weight from kg to lb
			ls_english = luo_unit_kg.convert("LB", string(lda_value[j]), ls_null, false)
			ld_value = double(ls_english)
		end if
	
		if graphtype = scattergraph! then
			adddata(lia_series[j], ld_cat_value, ld_value)
		else
			adddata(lia_series[j], ld_value, ld_cat_value)
		end if
	next
next


// Plot the patient data
lia_series[8] = addseries("Data")
SetSeriesStyle ("Data", SymbolPlus!)


ll_last_age = -1
setnull(ld_height)
setnull(ld_weight)
// Loop through each record
for ll_count = 1 to ll_patient_rowcount
	ll_age = patient_data.object.age[ll_count]
	if ll_age > ll_last_age then
		// If the age has changed, see if we have both height and weight for the last age value
		if not isnull(ld_height) and not isnull(ld_weight) then
			// Round the height to the right fraction
			ld_height = round(ld_height * ll_height_parts_per_unit, 0) / ll_height_parts_per_unit
			
			// Plot the data point
			if graphtype = scattergraph! then
				adddata(lia_series[8], ld_height, ld_weight)
			else
				adddata(lia_series[8], ld_weight, ld_height)
			end if
		end if
		// Reset the variables
		ll_last_age = ll_age
		setnull(ld_height)
		setnull(ld_weight)
	end if
	
	// Now for the next value, see what it is and convert it and store it appropriately
	ls_observation_id = patient_data.object.observation_id[ll_count]
	ls_recorded_value = patient_data.object.result_value[ll_count]
	ls_unit = patient_data.object.result_unit[ll_count]
	luo_unit = unit_list.find_unit(ls_unit)
	if not isnull(luo_unit) and not isnull(ls_recorded_value) then
		CHOOSE CASE upper(ls_observation_id)
			CASE "HGT"
				if lb_metric then
					ls_graph_value = luo_unit.convert("CM", ls_recorded_value, ls_null, false)
				else
					ls_graph_value = luo_unit.convert("INCH", ls_recorded_value, ls_null, false)
				end if
				ld_height = double(ls_graph_value)
				if ld_height < ld_cat_min_value then setnull(ld_height)
				if ld_height > ld_cat_max_value then setnull(ld_height)
			CASE "WGT"
				if lb_metric then
					ls_graph_value = luo_unit.convert("KG", ls_recorded_value, ls_null, false)
				else
					ls_graph_value = luo_unit.convert("LB", ls_recorded_value, ls_null, false)
				end if
				ld_weight = double(ls_graph_value)
				if ld_weight < ld_weight_min_value then setnull(ld_weight)
				if ld_weight > ld_weight_max_value then setnull(ld_weight)
		END CHOOSE
	end if
next
// If we exited the loop with both an height and weight value, then plot the last data point
if not isnull(ld_height) and not isnull(ld_weight) then
	// Round the height to the right fraction
	ld_height = round(ld_height * ll_height_parts_per_unit, 0) / ll_height_parts_per_unit
			
	// Plot the data point
	if graphtype = scattergraph! then
		adddata(lia_series[8], ld_height, ld_weight)
	else
		adddata(lia_series[8], ld_weight, ld_height)
	end if
end if


setredraw(true)

return 1


//Long				ll_age,ll_last_age
//String			ls_cpr_id
//Datetime			ldt_birth_dt
//Long				ll_cdc_rowcount,ll_patient_rowcount
//Long				ll_count,ll_row
//String			graph_title,ls_category_label,ls_value_label
//Integer			li_sex
//Decimal			ld_age_divisor,ld_age_start, ld_age_end
//decimal ld_height
//decimal ld_weight
//string ls_observation_id
//string ls_recorded_value
//string ls_graph_value
//string ls_unit
//u_unit luo_unit
//long i
//decimal lda_months[]
//decimal lda_p5[]
//decimal lda_p10[]
//decimal lda_p25[]
//decimal lda_p50[]
//decimal lda_p75[]
//decimal lda_p90[]
//decimal lda_p95[]
//string ls_graph_file
//string ls_english_value_label
//decimal ld_english_multiplier
//decimal ld_metric_min_value
//decimal ld_metric_max_value
//decimal ld_english_min_value
//decimal ld_english_max_value
//decimal ld_metric_scale_increment
//
//// Initialize the graph
//initialize_graph_properties()
//ldt_birth_dt = datetime(current_patient.date_of_birth)
//ls_cpr_id = current_patient.cpr_id
//// If 'Female' set the sex number '2' else '1'
//If current_patient.sex = "F" Then li_sex = 2 Else li_sex = 1
//
//If ps_type = "WtStat" Then
//	cdc_data.dataobject = "d_cdc_wtstat"
//	ls_category_label = "Stature (cm)"
//	ls_value_label = "Weight (Kgs)"
//	ls_english_value_label = "Weight (Lbs)"
//	ld_english_multiplier =  2.205
//	ld_metric_scale_increment = 2
//	graph_title = "Weight vs Stature      " + patient_info
//	ld_age_start = 365*3
//	ld_age_end = 365*20
//	ld_age_divisor = 365
//Else
//	cdc_data.dataobject = "d_cdc_wtleninf"
//	ls_category_label = "Length (cm)"
//	ls_value_label = "Weight (Kgs)"
//	ls_english_value_label = "Weight (Lbs)"
//	ld_english_multiplier =  2.205
//	ld_metric_scale_increment = 2
//	graph_title = "Length vs Height      " + patient_info
//	ld_age_start = 0
//	ld_age_end = 365*3
//	ld_age_divisor = avg_days_per_month
//End If
//
//// Get records from cdc table
//cdc_data.Settransobject(SQLCA)
//cdc_data.retrieve(li_sex)
//If Not tf_check() Then GOTO error
//ll_cdc_rowcount = cdc_data.rowcount()
//If ll_cdc_rowcount <= 0 Then
//	log.log(this,"htwt_growth_charts()","Cdc data for this '"+ps_type+"' not found..",3)
//	GOTO Error
//End If
//
//// Set the metric value axis scale
//ld_metric_min_value = int(cdc_data.getitemdecimal(1,"p5") / ld_metric_scale_increment) * ld_metric_scale_increment
//ld_metric_max_value = (int(cdc_data.getitemdecimal(ll_cdc_rowcount,"p95") / ld_metric_scale_increment) *ld_metric_scale_increment) + ld_metric_scale_increment
//
//// get patient growth records
//patient_data.dataobject = "d_patient_growth_data_htwt"
//patient_data.Settransobject(SQLCA)
//patient_data.retrieve(ls_cpr_id,ldt_birth_dt,ld_age_start,ld_age_end,ps_visit)
//If Not tf_check() Then GOTO error
//ll_patient_rowcount = patient_data.rowcount()
//
//// Set the graph title
//object.GraphTitle = graph_title
//object.FontOpen("Times New Roman,12,B")
//object.GraphTitleFont = object.FontCurrent
//
//object.FontOpen("Times New Roman,10,B")
//
//// Set the category axis scale
//object.axis=0
//object.axistitle = ls_category_label
//object.axistitlefont = object.FontCurrent
//object.axisscalemanual = true
//object.axisscalemin = cdc_data.getitemdecimal(1,1)
//object.axisscalemax = cdc_data.getitemdecimal(ll_cdc_rowcount,1)
//object.axisscaleinc = 5
//
//// Set the value axis scale
//object.axis=1
//object.axistitle = ls_value_label
//object.axistitlefont = object.FontCurrent
//object.axisscalemanual = true
//object.axisscalemin = ld_metric_min_value
//object.axisscalemax = ld_metric_max_value
//object.axisscaleinc = 2
//object.AxisGrid = True
//object.AxisGridPattern = 1
//
//if not isnull(ld_english_multiplier) then
//	ld_english_min_value = ld_metric_min_value * ld_english_multiplier
//	ld_english_max_value = ld_metric_max_value * ld_english_multiplier
//	// Set the English Equivalent Axis
//	object.axis=2
//	object.axisgone = false
//	object.axistitle = ls_english_value_label
//	object.axistitlefont = object.FontCurrent
//	object.axisscalemanual = true
//	object.axisscalemin = ld_english_min_value
//	object.axisscalemax = ld_english_max_value
//	object.axisscaleinc = 5
//else
//	object.axisgone = true
//end if
//
//// If we've already saved this graph, load it from the file
//ls_graph_file = program_directory + "\jmjgrf_" + f_string_to_filename(f_app_version()) + "_" + ps_type + "_" + string(li_sex) + ".dat"
//if fileexists(ls_graph_file) and use_cached_growth_charts then
//	object.loadgraph(ls_graph_file)
//else
//	// set the datavalues for a graph
//	for i = 1 to ll_cdc_rowcount
//		object.datavalue[i,0] = dec(cdc_data.object.data[i,1])
//		object.datavalue[i,1] = dec(cdc_data.object.p5[i])
//		object.datavalue[i,2] = dec(cdc_data.object.p10[i])
//		object.datavalue[i,3] = dec(cdc_data.object.p25[i])
//		object.datavalue[i,4] = dec(cdc_data.object.p50[i])
//		object.datavalue[i,5] = dec(cdc_data.object.p75[i])
//		object.datavalue[i,6] = dec(cdc_data.object.p90[i])
//		object.datavalue[i,7] = dec(cdc_data.object.p95[i])
//		if not isnull(ld_english_multiplier) then
//			if i = 1 then object.datavalue[i,9] = ld_english_min_value
//			if i = ll_cdc_rowcount then object.datavalue[i,10] =ld_english_max_value
//		end if
//	next
//	
//	if use_cached_growth_charts then object.savegraph(ls_graph_file)
//end if
//
//// Set ll_row to the number of data points plotted
//ll_row = ll_cdc_rowcount
//
//// Set the graph title
//object.GraphTitle = graph_title
//object.FontOpen("Times New Roman,12,B")
//object.GraphTitleFont = object.FontCurrent
//
//ll_last_age = -1
//setnull(ld_height)
//setnull(ld_weight)
//// Loop through each record
//for ll_count = 1 to ll_patient_rowcount
//	ll_age = patient_data.object.age[ll_count]
//	if ll_age > ll_last_age then
//		// If the age has changed, see if we have both height and weight for the last age value
//		if not isnull(ld_height) and not isnull(ld_weight) then
//			// If we have both values, then plot the point
//			ll_row += 1
//			object.datavalue[ll_row,0] = ld_height
//			object.datavalue[ll_row,8] = ld_weight
//		end if
//		// Reset the variables
//		ll_last_age = ll_age
//		setnull(ld_height)
//		setnull(ld_weight)
//	end if
//	
//	// Now for the next value, see what it is and convert it and store it appropriately
//	ls_observation_id = patient_data.object.observation_id[ll_count]
//	ls_recorded_value = patient_data.object.result_value[ll_count]
//	ls_unit = patient_data.object.result_unit[ll_count]
//	luo_unit = unit_list.find_unit(ls_unit)
//	if not isnull(luo_unit) and not isnull(ls_recorded_value) then
//		CHOOSE CASE upper(ls_observation_id)
//			CASE "HGT"
//				ls_graph_value = luo_unit.convert("CM", ls_recorded_value)
//				ld_height = dec(ls_graph_value)
//			CASE "WGT"
//				ls_graph_value = luo_unit.convert("KG", ls_recorded_value)
//				ld_weight = dec(ls_graph_value)
//		END CHOOSE
//	end if
//next
//// If we exited the loop with both an height and weight value, then plot the last data point
//if not isnull(ld_height) and not isnull(ld_weight) then
//	// If we have both values, then plot the point
//	ll_row += 1
//	object.datavalue[ll_row,0] = ld_height
//	object.datavalue[ll_row,8] = ld_weight
//end if
//
//
/////////////////////////////////////////////////
//// Reset the axis boundaries
/////////////////////////////////////////////////
//object.axis=0
//object.axisscalemanual = true
//object.axisscalemin = cdc_data.getitemdecimal(1,1)
//object.axisscalemax = cdc_data.getitemdecimal(ll_cdc_rowcount,1)
//object.axisscaleinc = 5
//
//// Set the value axis scale
//object.axis=1
//object.axisscalemanual = true
//object.axisscalemin = ld_metric_min_value
//object.axisscalemax = ld_metric_max_value
//object.axisscaleinc = 2
//
//if not isnull(ld_english_multiplier) then
//	ld_english_min_value = ld_metric_min_value * ld_english_multiplier
//	ld_english_max_value = ld_metric_max_value * ld_english_multiplier
//	// Set the English Equivalent Axis
//	object.axis=2
//	object.axisscalemanual = true
//	object.axisscalemin = ld_english_min_value
//	object.axisscalemax = ld_english_max_value
//	object.axisscaleinc = 5
//end if
//
//
//object.Graphareabottom = 93
//object.LegendColumns = -1
//object.LegendFrameStyle = 2
//
//error:
////Destroy cdc_data
////Destroy patient_data

Return 1




end function

on u_gr_growth_chart.create
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
TitleDispAttr.FontCharSet=DefaultCharSet!
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=536870912
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.ShadeBackEdge=true
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.DataType=adtDouble!
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Arial"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.AutoSize=true
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Arial"
Category.LabelDispAttr.FontCharSet=DefaultCharSet!
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.Label="(None)"
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MajorGridLine=dot!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Arial"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=400
Values.LabelDispAttr.FaceName="Arial"
Values.LabelDispAttr.FontCharSet=DefaultCharSet!
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
LegendDispAttr.TextSize=16
LegendDispAttr.Weight=700
LegendDispAttr.FaceName="Arial"
LegendDispAttr.FontCharSet=DefaultCharSet!
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=536870912
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
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

on u_gr_growth_chart.destroy
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

