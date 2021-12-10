$PBExportHeader$u_tabpage_hm_class_metric.sru
forward
global type u_tabpage_hm_class_metric from u_tabpage_hm_class_base
end type
type cb_delete from commandbutton within u_tabpage_hm_class_metric
end type
type st_interval_unit from statictext within u_tabpage_hm_class_metric
end type
type st_interval from statictext within u_tabpage_hm_class_metric
end type
type st_interval_title from statictext within u_tabpage_hm_class_metric
end type
type st_title from statictext within u_tabpage_hm_class_metric
end type
end forward

global type u_tabpage_hm_class_metric from u_tabpage_hm_class_base
cb_delete cb_delete
st_interval_unit st_interval_unit
st_interval st_interval
st_interval_title st_interval_title
st_title st_title
end type
global u_tabpage_hm_class_metric u_tabpage_hm_class_metric

type variables
long metric_index

end variables

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);
metric_index = pl_index


st_title.width = width

cb_delete.y = height - cb_delete.height - 20

st_interval_title.y = height - st_interval_title.height - 30
st_interval.y = height - st_interval.height - 20
st_interval_unit.y = height - st_interval_unit.height - 20

st_title.text = hmclasstab.hm_class.metric[metric_index].description

st_interval.text = string(hmclasstab.hm_class.metric[metric_index].interval)
st_interval_unit.text = wordcap(hmclasstab.hm_class.metric[metric_index].interval_unit)

return 1

end function

on u_tabpage_hm_class_metric.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.st_interval_unit=create st_interval_unit
this.st_interval=create st_interval
this.st_interval_title=create st_interval_title
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.st_interval_unit
this.Control[iCurrent+3]=this.st_interval
this.Control[iCurrent+4]=this.st_interval_title
this.Control[iCurrent+5]=this.st_title
end on

on u_tabpage_hm_class_metric.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.st_interval_unit)
destroy(this.st_interval)
destroy(this.st_interval_title)
destroy(this.st_title)
end on

type cb_delete from commandbutton within u_tabpage_hm_class_metric
integer x = 9
integer y = 1420
integer width = 480
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove Metric"
end type

event clicked;str_popup_return popup_return
u_tab_hm_class_metrics luo_tab

openwithparm(w_pop_yes_no, "Are you sure you want to remove this metric?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

luo_tab = hmclasstab

luo_tab.remove_metric(metric_index)

return

end event

type st_interval_unit from statictext within u_tabpage_hm_class_metric
integer x = 2272
integer y = 1404
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	hmclasstab.hm_class.metric[metric_index].interval_unit = "DAY"
	text = "Days"
elseif li_index = 2 then
	hmclasstab.hm_class.metric[metric_index].interval_unit = "MONTH"
	text = "Months"
else
	hmclasstab.hm_class.metric[metric_index].interval_unit = "YEAR"
	text = "Years"
end if

UPDATE c_Maintenance_metric
SET interval_unit = :hmclasstab.hm_class.metric[metric_index].interval_unit
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id
AND metric_sequence = :hmclasstab.hm_class.metric[metric_index].metric_sequence;
if not tf_check() then return



end event

type st_interval from statictext within u_tabpage_hm_class_metric
integer x = 1952
integer y = 1404
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(hmclasstab.hm_class.metric[metric_index].interval)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

hmclasstab.hm_class.metric[metric_index].interval = long(popup_return.realitem)
text = string(hmclasstab.hm_class.metric[metric_index].interval)

UPDATE c_Maintenance_metric
SET interval = :hmclasstab.hm_class.metric[metric_index].interval
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id
AND metric_sequence = :hmclasstab.hm_class.metric[metric_index].metric_sequence;
if not tf_check() then return


end event

type st_interval_title from statictext within u_tabpage_hm_class_metric
integer x = 1015
integer y = 1416
integer width = 933
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Perform Every Interval of:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_hm_class_metric
integer width = 2578
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

