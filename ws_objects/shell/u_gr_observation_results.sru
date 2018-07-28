HA$PBExportHeader$u_gr_observation_results.sru
forward
global type u_gr_observation_results from graph
end type
end forward

type str_series_data from structure
	long		encounter_id
	date		encounter_date
	long		age_days
	integer		objective_set
	string		location
	real		result_amount
end type

type str_series from structure
	string		name
	string		observation_id
	integer		result_sequence
	string		location
	integer		data_count
	str_series_data		data[]
	date		min_date
	date		max_date
end type

global type u_gr_observation_results from graph
int Width=1536
int Height=896
boolean Enabled=false
grGraphType GraphType=ScatterGraph!
grLegendType Legend=AtBottom!
int Depth=100
int Elevation=20
boolean FocusRectangle=false
int Perspective=2
int Rotation=-20
int Spacing=100
long BackColor=12632256
long ShadeColor=8355711
end type
global u_gr_observation_results u_gr_observation_results

type variables
string cpr_id
integer observation_count
str_observation_result_location observations[]

u_ds_data observation_data[]

integer color_count
long line_colors[]

end variables

forward prototypes
public subroutine refresh (date pd_begin_date, date pd_end_date)
public function integer initialize (string ps_title, integer pi_observation_count, str_observation_result_location pstra_observations[])
end prototypes

public subroutine refresh (date pd_begin_date, date pd_end_date);long i,j
integer li_sts
integer li_series
long ll_rows
datetime ldt_begin_date
real lr_amount
long ll_day
long ll_data_position
string ls_filter
long ll_color

ls_filter = "date(begin_date) >= date('" + string(pd_begin_date, "[shortdate]") + "')"
ls_filter += " and date(begin_date) <= date('" + string(pd_end_date, "[shortdate]") + "')"


setredraw(false)

reset(all!)

category.autoscale = false
category.majordivisions = 4
category.majorgridline = Dash!
category.minimumvalue = 0
category.maximumvalue = daysafter(pd_begin_date, pd_end_date)

for i = 1 to observation_count
	li_series = addseries(observations[i].name)
	if li_series > 0 then
		if i <= color_count then
			SetSeriesStyle (observations[i].name, Foreground!, line_colors[i])
		end if
		observation_data[i].setfilter(ls_filter)
		observation_data[i].filter()
		ll_rows = observation_data[i].rowcount()
		for j = 1 to ll_rows
			ldt_begin_date = observation_data[i].object.begin_date[j]
			lr_amount = observation_data[i].object.result_amount[j]
			if isnull(lr_amount) then continue
			ll_day = daysafter(pd_begin_date, date(ldt_begin_date))
			ll_data_position = adddata(li_series, ll_day, lr_amount)
		next
	end if
next

values.majorgridline = Dot!

legend = AtTop!
LegendDispAttr.facename = "ARIAL"
LegendDispAttr.AutoSize = false
LegendDispAttr.TextSize = -10
LegendDispAttr.Weight = 700


setredraw(true)



end subroutine

public function integer initialize (string ps_title, integer pi_observation_count, str_observation_result_location pstra_observations[]);integer li_sts
long i
long ll_rows

cpr_id = current_patient.cpr_id
observation_count = pi_observation_count
observations = pstra_observations

title = ps_title

for i = 1 to observation_count
	observation_data[i] = CREATE u_ds_data
	observation_data[i].set_dataobject("dw_observation_result_amounts")
	ll_rows = observation_data[i].retrieve( cpr_id, &
														 observations[i].observation_id, &
														 observations[i].result_sequence, &
														 observations[i].location)
	if not tf_check() then return -1
next


// Initialize the colors
color_count = 12
line_colors[1] = rgb(255,0,0)
line_colors[2] = rgb(0,0,255)
line_colors[3] = rgb(255,255,0)
line_colors[4] = rgb(255,0,255)
line_colors[5] = rgb(0,255,255)
line_colors[6] = rgb(255,128,128)
line_colors[7] = rgb(128,128,255)
line_colors[8] = rgb(0,0,0)
line_colors[9] = rgb(0,255,0)
line_colors[10] = rgb(255,255,128)
line_colors[11] = rgb(255,128,255)
line_colors[12] = rgb(128,255,255)

return 1


end function

on u_gr_observation_results.create
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
TitleDispAttr.BackColor=553648127
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.AutoScale=true
Category.ShadeBackEdge=true
Category.MajorDivisions=1
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.MajorTic=Outside!
Category.DataType=adtDouble!
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Arial"
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.TextColor=12632256
Category.DispAttr.BackColor=553648127
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.AutoSize=true
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Arial"
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MajorGridLine=transparent!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Arial"
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=400
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
Series.DispAttr.FaceName="Arial"
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=536870912
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.DispAttr.AutoSize=true
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Arial"
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
PieDispAttr.FaceName="Arial"
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on u_gr_observation_results.destroy
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

event destructor;integer i

for i = 1 to observation_count
	DESTROY observation_data[i]
next


end event

