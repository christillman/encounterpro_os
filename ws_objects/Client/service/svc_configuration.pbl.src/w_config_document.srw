$PBExportHeader$w_config_document.srw
forward
global type w_config_document from w_window_base
end type
type cb_finished from commandbutton within w_config_document
end type
type st_1 from statictext within w_config_document
end type
type st_2 from statictext within w_config_document
end type
type st_external_source_description from statictext within w_config_document
end type
type cb_pick_external_source from commandbutton within w_config_document
end type
type cb_new_external_source from commandbutton within w_config_document
end type
type cb_printers from commandbutton within w_config_document
end type
type cb_change_status from commandbutton within w_config_document
end type
type st_external_source from statictext within w_config_document
end type
type st_external_source_title from statictext within w_config_document
end type
type cb_template from commandbutton within w_config_document
end type
type dw_external_source_attributes from u_dw_pick_list within w_config_document
end type
type st_external_source_attributes_title from statictext within w_config_document
end type
type st_attributes_office from statictext within w_config_document
end type
type st_5 from statictext within w_config_document
end type
type st_status from statictext within w_config_document
end type
type st_status_title from statictext within w_config_document
end type
type st_context_object from statictext within w_config_document
end type
type st_context_object_title from statictext within w_config_document
end type
type st_component from statictext within w_config_document
end type
type st_component_title from statictext within w_config_document
end type
type cb_change_component from commandbutton within w_config_document
end type
type cb_change_context from commandbutton within w_config_document
end type
type st_no_attributes_defined from statictext within w_config_document
end type
type cb_define_params from commandbutton within w_config_document
end type
type st_external_source_category from statictext within w_config_document
end type
type st_external_source_category_title from statictext within w_config_document
end type
type cb_change_external_source_category from commandbutton within w_config_document
end type
type dw_component_attributes from u_dw_pick_list within w_config_document
end type
type st_component_attributes_title from statictext within w_config_document
end type
type st_no_component_attributes_defined from statictext within w_config_document
end type
end forward

global type w_config_document from w_window_base
boolean visible = false
string title = "Document Configuration"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_1 st_1
st_2 st_2
st_external_source_description st_external_source_description
cb_pick_external_source cb_pick_external_source
cb_new_external_source cb_new_external_source
cb_printers cb_printers
cb_change_status cb_change_status
st_external_source st_external_source
st_external_source_title st_external_source_title
cb_template cb_template
dw_external_source_attributes dw_external_source_attributes
st_external_source_attributes_title st_external_source_attributes_title
st_attributes_office st_attributes_office
st_5 st_5
st_status st_status
st_status_title st_status_title
st_context_object st_context_object
st_context_object_title st_context_object_title
st_component st_component
st_component_title st_component_title
cb_change_component cb_change_component
cb_change_context cb_change_context
st_no_attributes_defined st_no_attributes_defined
cb_define_params cb_define_params
st_external_source_category st_external_source_category
st_external_source_category_title st_external_source_category_title
cb_change_external_source_category cb_change_external_source_category
dw_component_attributes dw_component_attributes
st_component_attributes_title st_component_attributes_title
st_no_component_attributes_defined st_no_component_attributes_defined
end type
global w_config_document w_config_document

type variables
u_ds_data external_source_data

string external_source

string displayed_office_id

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_sts
string ls_status
string ls_component_id
long ll_owner_id

st_external_source.text = external_source

if isnull(external_source) or trim(external_source) = "" then
	log.log(this, "refresh()", "Invalid external_source", 4)
	return -1
end if

external_source_data.set_dataobject("dw_external_source_data")
ll_sts = external_source_data.retrieve(external_source)
if ll_sts < 0 then
	log.log(this, "refresh()", "Error retrieving external_source data (" + external_source + ")", 4)
	return -1
end if
if ll_sts = 0 then
	log.log(this, "refresh()", "external_source not found (" + external_source + ")", 4)
	return -1
end if

st_external_source_description.text = external_source_data.object.description[1]
st_external_source_category.text = external_source_data.object.external_source_category[1]
st_context_object.text = external_source_data.object.external_source_type[1]
ll_owner_id = external_source_data.object.owner_id[1]
ls_component_id = external_source_data.object.component_id[1]

// Component logic
SELECT description
INTO :st_component.text
FROM dbo.fn_components()
WHERE component_id = :ls_component_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then st_component.text = "NA"

if lower(ls_component_id) = "rpt_rtf" then
	cb_template.visible = true
else
	cb_template.visible = false
end if


ls_status = external_source_data.object.status[1]

if ls_status = "OK" then
	st_status.text = "Active"
	cb_change_status.text = "Make Inactive"
else
	st_status.text = "Inactive"
	cb_change_status.text = "Make Active"
end if

if len(displayed_office_id) > 0 and displayed_office_id <> "<Default>" then
	SELECT description
	INTO :st_attributes_office.text
	FROM c_Office
	WHERE office_id = :displayed_office_id;
	if not tf_check() then return -1
else
	displayed_office_id = "<Default>"
	st_attributes_office.text = "<Default>"
end if

dw_external_source_attributes.settransobject(sqlca)
ll_sts = dw_external_source_attributes.retrieve(external_source, displayed_office_id, "Config")
if ll_sts <= 0 then
	st_no_attributes_defined.visible = true
else
	st_no_attributes_defined.visible = false
end if

dw_component_attributes.settransobject(sqlca)
ll_sts = dw_component_attributes.retrieve(external_source, "Config")
if ll_sts <= 0 then
	st_no_component_attributes_defined.visible = true
else
	st_no_component_attributes_defined.visible = false
end if

if ll_owner_id = sqlca.customer_id then
	cb_change_context.visible = true
	cb_change_component.visible = true
	st_no_component_attributes_defined.enabled = true
	dw_component_attributes.enabled = true
else
	cb_change_context.visible = false
	cb_change_component.visible = false
	st_no_component_attributes_defined.enabled = false
	dw_component_attributes.enabled = false
end if


return 1

end function

on w_config_document.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_1=create st_1
this.st_2=create st_2
this.st_external_source_description=create st_external_source_description
this.cb_pick_external_source=create cb_pick_external_source
this.cb_new_external_source=create cb_new_external_source
this.cb_printers=create cb_printers
this.cb_change_status=create cb_change_status
this.st_external_source=create st_external_source
this.st_external_source_title=create st_external_source_title
this.cb_template=create cb_template
this.dw_external_source_attributes=create dw_external_source_attributes
this.st_external_source_attributes_title=create st_external_source_attributes_title
this.st_attributes_office=create st_attributes_office
this.st_5=create st_5
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_context_object=create st_context_object
this.st_context_object_title=create st_context_object_title
this.st_component=create st_component
this.st_component_title=create st_component_title
this.cb_change_component=create cb_change_component
this.cb_change_context=create cb_change_context
this.st_no_attributes_defined=create st_no_attributes_defined
this.cb_define_params=create cb_define_params
this.st_external_source_category=create st_external_source_category
this.st_external_source_category_title=create st_external_source_category_title
this.cb_change_external_source_category=create cb_change_external_source_category
this.dw_component_attributes=create dw_component_attributes
this.st_component_attributes_title=create st_component_attributes_title
this.st_no_component_attributes_defined=create st_no_component_attributes_defined
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_external_source_description
this.Control[iCurrent+5]=this.cb_pick_external_source
this.Control[iCurrent+6]=this.cb_new_external_source
this.Control[iCurrent+7]=this.cb_printers
this.Control[iCurrent+8]=this.cb_change_status
this.Control[iCurrent+9]=this.st_external_source
this.Control[iCurrent+10]=this.st_external_source_title
this.Control[iCurrent+11]=this.cb_template
this.Control[iCurrent+12]=this.dw_external_source_attributes
this.Control[iCurrent+13]=this.st_external_source_attributes_title
this.Control[iCurrent+14]=this.st_attributes_office
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.st_status
this.Control[iCurrent+17]=this.st_status_title
this.Control[iCurrent+18]=this.st_context_object
this.Control[iCurrent+19]=this.st_context_object_title
this.Control[iCurrent+20]=this.st_component
this.Control[iCurrent+21]=this.st_component_title
this.Control[iCurrent+22]=this.cb_change_component
this.Control[iCurrent+23]=this.cb_change_context
this.Control[iCurrent+24]=this.st_no_attributes_defined
this.Control[iCurrent+25]=this.cb_define_params
this.Control[iCurrent+26]=this.st_external_source_category
this.Control[iCurrent+27]=this.st_external_source_category_title
this.Control[iCurrent+28]=this.cb_change_external_source_category
this.Control[iCurrent+29]=this.dw_component_attributes
this.Control[iCurrent+30]=this.st_component_attributes_title
this.Control[iCurrent+31]=this.st_no_component_attributes_defined
end on

on w_config_document.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_external_source_description)
destroy(this.cb_pick_external_source)
destroy(this.cb_new_external_source)
destroy(this.cb_printers)
destroy(this.cb_change_status)
destroy(this.st_external_source)
destroy(this.st_external_source_title)
destroy(this.cb_template)
destroy(this.dw_external_source_attributes)
destroy(this.st_external_source_attributes_title)
destroy(this.st_attributes_office)
destroy(this.st_5)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_context_object)
destroy(this.st_context_object_title)
destroy(this.st_component)
destroy(this.st_component_title)
destroy(this.cb_change_component)
destroy(this.cb_change_context)
destroy(this.st_no_attributes_defined)
destroy(this.cb_define_params)
destroy(this.st_external_source_category)
destroy(this.st_external_source_category_title)
destroy(this.cb_change_external_source_category)
destroy(this.dw_component_attributes)
destroy(this.st_component_attributes_title)
destroy(this.st_no_component_attributes_defined)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

external_source = message.stringparm

postevent("post_open")

end event

event post_open;call super::post_open;integer li_sts
str_popup_return popup_return
w_window_base lw_window

external_source_data = CREATE u_ds_data
if isnull(external_source) or trim(external_source) = "" then
	setnull(external_source)
//	open(w_pick_external_source)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		popup_return.item_count = 1
		popup_return.items[1] = "OK"
		closewithreturn(this, popup_return)
	else
		external_source = popup_return.items[1]
		refresh()

		// Make the window visible now and force focus to it
		lw_window = this
		lw_window.visible = true
		EnableWindow(handle(lw_window), true)
	end if
else
	cb_new_external_source.visible = false
	cb_pick_external_source.visible = false
	li_sts = refresh()
	if li_sts <= 0 then
		log.log(this, "open", "Error opening external_source (" + external_source + ")", 4)
		popup_return.item_count = 1
		popup_return.items[1] = "OK"
		
		closewithreturn(this, popup_return)
	end if
	visible = true
end if





end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_document
boolean visible = true
integer x = 2094
integer y = 1604
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_document
integer x = 64
integer y = 1512
end type

type cb_finished from commandbutton within w_config_document
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_1 from statictext within w_config_document
integer width = 2917
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_config_document
integer x = 14
integer y = 148
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_external_source_description from statictext within w_config_document
integer x = 439
integer y = 148
integer width = 1906
integer height = 200
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_pick_external_source from commandbutton within w_config_document
integer x = 2377
integer y = 152
integer width = 521
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Name"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
long ll_count

DO WHILE true
	popup.title = "Enter title of new external_source"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_description = popup_return.items[1]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_external_source_Definition
	WHERE description = :ls_description;
	if not tf_check() then return
	if ll_count > 0 then
		openwithparm(w_pop_message, "There is already a external_source with that title.  Please enter a different title for the new external_source.")
	else
		exit
	end if
LOOP

openwithparm(w_pop_yes_no, "Are you sure you wish to update the name of this external_source to " + ls_description + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_external_source_Definition
SET description = :ls_description
WHERE external_source = :external_source;
if not tf_check() then return

refresh()

end event

type cb_new_external_source from commandbutton within w_config_document
integer x = 2377
integer y = 268
integer width = 521
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Copy"
end type

event clicked;string ls_external_source
str_popup_return popup_return

openwithparm(w_pop_yes_no, "This will create a new external_source which is a copy of the ~"" + st_external_source_description.text + "~" external_source.  Are you sure you wish to do this?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

//ls_external_source = f_copy_external_source(external_source)
if len(ls_external_source) > 0 then
	external_source = ls_external_source
	refresh()
	return
end if

end event

type cb_printers from commandbutton within w_config_document
integer x = 50
integer y = 1596
integer width = 608
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure Printers"
end type

event clicked;
//openwithparm(w_external_source_printer, st_external_source.text)

end event

type cb_change_status from commandbutton within w_config_document
integer x = 910
integer y = 916
integer width = 434
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Make Inactive"
end type

event clicked;string ls_status
string ls_state
str_popup_return popup_return

ls_status = external_source_data.object.status[1]

if ls_status = "OK" then
	ls_status = "NA"
	ls_state = "inactive"
else
	ls_status = "OK"
	ls_state = "active"
end if

openwithparm(w_pop_yes_no, "Are you sure you wish to make this external_source " + ls_state + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_external_source_Definition
SET status = :ls_status
WHERE external_source = :st_external_source.text;
if not tf_check() then return

refresh()

end event

type st_external_source from statictext within w_config_document
integer x = 439
integer y = 404
integer width = 1239
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_external_source_title from statictext within w_config_document
integer x = 14
integer y = 408
integer width = 421
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document ID: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_template from commandbutton within w_config_document
integer x = 1157
integer y = 1596
integer width = 608
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Template"
end type

event clicked;

//openwithparm(w_encounterpro_external_source_template_edit, st_external_source.text)

end event

type dw_external_source_attributes from u_dw_pick_list within w_config_document
integer x = 1774
integer y = 688
integer width = 1029
integer height = 592
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_external_source_att_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;
f_configure_external_source(external_source, displayed_office_id)

refresh()

end event

type st_external_source_attributes_title from statictext within w_config_document
integer x = 1911
integer y = 428
integer width = 754
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Attributes for Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_attributes_office from statictext within w_config_document
integer x = 1856
integer y = 492
integer width = 864
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Default>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Default>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

displayed_office_id = popup_return.items[1]

if displayed_office_id = "" then setnull(displayed_office_id)

refresh()

end event

type st_5 from statictext within w_config_document
integer x = 1774
integer y = 620
integer width = 1029
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Config Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_config_document
integer x = 443
integer y = 916
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_status_title from statictext within w_config_document
integer x = 18
integer y = 920
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Status: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_context_object from statictext within w_config_document
integer x = 439
integer y = 532
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_config_document
integer x = 14
integer y = 536
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Context: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component from statictext within w_config_document
integer x = 439
integer y = 660
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_component_title from statictext within w_config_document
integer x = 14
integer y = 664
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Component: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_component from commandbutton within w_config_document
integer x = 1051
integer y = 660
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_component_id

popup.dataobject = "dw_component_pick"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = "external_source"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_component_id = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the external_source component for this external_source to " + popup_return.descriptions[1] + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_external_source_Definition
SET component_id = :ls_component_id
WHERE external_source = :external_source;
if not tf_check() then return

refresh()

end event

type cb_change_context from commandbutton within w_config_document
integer x = 1051
integer y = 532
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_context_object

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_context_object = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the context for this external_source to " + popup_return.descriptions[1] + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_external_source_Definition
SET external_source_type = :ls_context_object
WHERE external_source = :external_source;
if not tf_check() then return

refresh()

end event

type st_no_attributes_defined from statictext within w_config_document
integer x = 1870
integer y = 928
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No Config Attributes Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
f_configure_external_source(external_source, displayed_office_id)

refresh()

end event

type cb_define_params from commandbutton within w_config_document
integer x = 1925
integer y = 1340
integer width = 827
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Define Document Atributes"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = "Define Config Attributes"
popup.items[2] = "Define Runtime Attributes"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

popup.data_row_count = 2
popup.items[1] = external_source
if popup_return.item_indexes[1] = 1 then
	popup.items[2] = "Config"
else
	popup.items[2] = "Runtime"
end if

openwithparm(w_component_params_edit, popup)

refresh()

end event

type st_external_source_category from statictext within w_config_document
integer x = 434
integer y = 788
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_external_source_category_title from statictext within w_config_document
integer x = 14
integer y = 792
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Category: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_external_source_category from commandbutton within w_config_document
integer x = 1051
integer y = 788
integer width = 434
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_external_source_category

popup.dataobject = "dw_external_source_category_pick"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = st_context_object.text
openwithparm(w_pop_pick, popup, parent)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_external_source_category = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the external_source category for this external_source to " + ls_external_source_category + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_external_source_Definition
SET external_source_category = :ls_external_source_category
WHERE external_source = :external_source;
if not tf_check() then return

refresh()

end event

type dw_component_attributes from u_dw_pick_list within w_config_document
integer x = 329
integer y = 1128
integer width = 1029
integer height = 332
integer taborder = 31
boolean bringtotop = true
string dataobject = "dw_external_source_component_att_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;
f_configure_external_source_component(external_source)

refresh()

end event

type st_component_attributes_title from statictext within w_config_document
integer x = 329
integer y = 1060
integer width = 1029
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Component Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_component_attributes_defined from statictext within w_config_document
integer x = 352
integer y = 1252
integer width = 978
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No Component Attributes Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
f_configure_external_source_component(external_source)

refresh()

end event

