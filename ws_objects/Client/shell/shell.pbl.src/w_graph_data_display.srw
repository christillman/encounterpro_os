$PBExportHeader$w_graph_data_display.srw
forward
global type w_graph_data_display from w_window_base
end type
type pb_done from u_picture_button within w_graph_data_display
end type
type pb_cancel from u_picture_button within w_graph_data_display
end type
type gr_data from graph within w_graph_data_display
end type
type cb_print from commandbutton within w_graph_data_display
end type
type cb_copy from commandbutton within w_graph_data_display
end type
type cb_save_data from commandbutton within w_graph_data_display
end type
end forward

global type w_graph_data_display from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
gr_data gr_data
cb_print cb_print
cb_copy cb_copy
cb_save_data cb_save_data
end type
global w_graph_data_display w_graph_data_display

type variables
u_graph_properties graph_properties

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long i,j
integer li_sts
long ll_rows
long ll_data_position
long ll_category
string ls_category
date ld_category
long ll_data
long li_series
string ls_query
long ll_others
long ll_series_count
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_database(sqlca)

gr_data.setredraw(false)

gr_data.reset(all!)

gr_data.graphtype = graph_properties.get_graph_type()
gr_data.seriessort = graph_properties.get_series_sort()
gr_data.categorysort = graph_properties.get_category_sort()
gr_data.legend = graph_properties.get_legend_loc()

if isnull(graph_properties.category_id) then return 0
//gr_data.category.autoscale = true
//category.majordivisions = 4
//category.majorgridline = Dash!
//category.minimumvalue = 0
//category.maximumvalue = daysafter(pd_begin_date, pd_end_date)

gr_data.category.label = graph_properties.axis_title
gr_data.title = graph_properties.description

ll_series_count = graph_properties.data_series.rowcount()
for i = 1 to ll_series_count
	li_series = gr_data.addseries(graph_properties.series_description(i))
	ls_query = graph_properties.get_query(i)
	ll_rows = luo_data.load_query(ls_query)
	for j = 1 to ll_rows
		ll_data = luo_data.getitemnumber(j, 2)
		if j < graph_properties.max_categories or ll_rows <= graph_properties.max_categories then
			CHOOSE CASE graph_properties.category_type()
				CASE "STRING"
					ls_category = luo_data.getitemstring(j, 1)
					ll_data_position = gr_data.adddata(li_series, ll_data, ls_category)
				CASE "NUMBER"
					ll_category = luo_data.getitemnumber(j, 1)
					ll_data_position = gr_data.adddata(li_series, ll_data, ll_category)
				CASE "DATE"
					ld_category = luo_data.getitemdate(j, 1)
					ll_data_position = gr_data.adddata(li_series, ll_data, ld_category)
			END CHOOSE
		else
			ll_others += ll_data
		end if
	next
	if ll_rows > graph_properties.max_categories then
		CHOOSE CASE graph_properties.category_type()
			CASE "STRING"
				ls_category = "All Others"
				ll_data_position = gr_data.adddata(li_series, ll_others, ls_category)
//			CASE "NUMBER"
//				ll_category = luo_data.getitemnumber(j, 1)
//				ll_data_position = gr_data.adddata(li_series, ll_others, ll_category)
//			CASE "DATE"
//				ld_category = luo_data.getitemdate(j, 1)
//				ll_data_position = gr_data.adddata(li_series, ll_others, ld_category)
		END CHOOSE
	end if
next

gr_data.values.majorgridline = Dot!

//gr_data.LegendDispAttr.facename = "ARIAL"
//gr_data.LegendDispAttr.AutoSize = false
//gr_data.LegendDispAttr.TextSize = -10
//gr_data.LegendDispAttr.Weight = 700
//

gr_data.setredraw(true)

DESTROY luo_data

return 1

end function

on w_graph_data_display.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.gr_data=create gr_data
this.cb_print=create cb_print
this.cb_copy=create cb_copy
this.cb_save_data=create cb_save_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.gr_data
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_copy
this.Control[iCurrent+6]=this.cb_save_data
end on

on w_graph_data_display.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.gr_data)
destroy(this.cb_print)
destroy(this.cb_copy)
destroy(this.cb_save_data)
end on

event open;call super::open;str_popup popup

graph_properties = message.powerobjectparm

refresh()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_graph_data_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_graph_data_display
end type

type pb_done from u_picture_button within w_graph_data_display
integer x = 2551
integer y = 1564
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_graph_data_display
boolean visible = false
integer x = 82
integer y = 1552
integer taborder = 20
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

type gr_data from graph within w_graph_data_display
integer width = 2926
integer height = 1492
boolean bringtotop = true
boolean enabled = false
grgraphtype graphtype = piegraph!
long backcolor = 33538240
long shadecolor = 4210688
integer spacing = 100
integer elevation = 20
integer rotation = -20
integer perspective = 2
integer depth = 100
grlegendtype legend = atleft!
boolean focusrectangle = false
grsorttype seriessort = ascending!
grsorttype categorysort = ascending!
end type

on gr_data.create
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
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.OriginLine=transparent!
Category.MajorTic=Outside!
Category.DataType=adtText!
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Arial"
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
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
LegendDispAttr.DisplayExpression="category"
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

on gr_data.destroy
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

type cb_print from commandbutton within w_graph_data_display
integer x = 146
integer y = 1612
integer width = 549
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;long ll_job

//gr_data.setredraw(false)

gr_data.backcolor = color_white

ll_job = printopen()
gr_data.print(ll_job, 0, 0)
printclose(ll_job)

gr_data.backcolor = color_background

//gr_data.setredraw(true)

end event

type cb_copy from commandbutton within w_graph_data_display
integer x = 750
integer y = 1612
integer width = 549
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy To Clipboard"
end type

event clicked;gr_data.clipboard()

end event

type cb_save_data from commandbutton within w_graph_data_display
integer x = 1362
integer y = 1612
integer width = 549
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Data to File"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_filepath
string ls_filename
string ls_filetype
string ls_temp
integer li_pos
integer li_sts
string lsa_saveastype[]
SaveAsType lea_saveastype[]
string lsa_extenstion[]
string lsa_filter[]
integer i
integer li_count

SaveAsType le_saveastype

li_count = 9

lsa_saveastype[1] = "Comma Separated"
lea_saveastype[1] = CSV!
lsa_extenstion[1] = "txt"
lsa_filter[1] = "Text Files, *.csv, Text Files, *.txt"

lsa_saveastype[2] = "Tab Separated"
lea_saveastype[2] = Text!
lsa_extenstion[2] = "txt"
lsa_filter[2] = "Text Files, *.txt"

lsa_saveastype[3] = "dBase-II"
lea_saveastype[3] = dBASE2!
lsa_extenstion[3] = "dbf"
lsa_filter[3] = "DBF Files, *.dbf"

lsa_saveastype[4] = "dBase-III"
lea_saveastype[4] = dBASE3!
lsa_extenstion[4] = "dbf"
lsa_filter[4] = "DBF Files, *.dbf"

lsa_saveastype[5] = "Data Interchange Format"
lea_saveastype[5] = DIF!
lsa_extenstion[5] = "dif"
lsa_filter[5] = "DIF Files, *.dif"

lsa_saveastype[6] = "Microsoft Excel"
lea_saveastype[6] = Excel!
lsa_extenstion[6] = "xls"
lsa_filter[6] = "Excel Files, *.xls"

lsa_saveastype[7] = "Lotus 1-2-3 WKS"
lea_saveastype[7] = Excel!
lsa_extenstion[7] = "wks"
lsa_filter[7] = "WKS Files, *.wks"

lsa_saveastype[8] = "Lotus 1-2-3 WK1"
lea_saveastype[8] = Excel!
lsa_extenstion[8] = "wk1"
lsa_filter[8] = "WK1 Files, *.wk1"

lsa_saveastype[9] = "Windows Metafile Format"
lea_saveastype[9] = WMF!
lsa_extenstion[9] = "wmf"
lsa_filter[9] = "WMF Files, *.wmf"


popup.data_row_count = li_count
popup.items = lsa_saveastype
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
le_saveastype = lea_saveastype[popup_return.item_indexes[1]]

gr_data.SaveAs("", le_saveastype, true )





//CSV! — Comma-separated values¨	
//dBASE2! — dBASE-II format¨	
//dBASE3! — dBASE-III format¨	
//DIF! — Data Interchange Format¨	
//Excel! — Microsoft Excel format¨	
//PSReport! — Powersoft Report (PSR) format¨	
//SQLInsert! — SQL syntax¨	
//SYLK! — Microsoft Multiplan format¨	
//Text! — (Default) Tab-separated columns with a return at the end of each row¨	
//WKS! — Lotus 1-2-3 format¨	
//WK1! — Lotus 1-2-3 format¨	
//WMF! — Windows Metafile format

end event

