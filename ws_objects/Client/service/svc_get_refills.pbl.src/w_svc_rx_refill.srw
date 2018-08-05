$PBExportHeader$w_svc_rx_refill.srw
forward
global type w_svc_rx_refill from w_window_base
end type
type cb_be_back from commandbutton within w_svc_rx_refill
end type
type cb_done from commandbutton within w_svc_rx_refill
end type
type st_title from statictext within w_svc_rx_refill
end type
type st_date_title from statictext within w_svc_rx_refill
end type
type st_refill_date from statictext within w_svc_rx_refill
end type
type st_print_now from statictext within w_svc_rx_refill
end type
type st_2 from statictext within w_svc_rx_refill
end type
type st_print_checkout from statictext within w_svc_rx_refill
end type
type st_dont_print from statictext within w_svc_rx_refill
end type
type ole_refill_history from u_rich_text_edit within w_svc_rx_refill
end type
type st_1 from statictext within w_svc_rx_refill
end type
type st_3 from statictext within w_svc_rx_refill
end type
type mle_refill_comment from multilineedit within w_svc_rx_refill
end type
type cb_pick_comment from commandbutton within w_svc_rx_refill
end type
type pb_up from u_picture_button within w_svc_rx_refill
end type
type pb_down from u_picture_button within w_svc_rx_refill
end type
type cb_cancel from commandbutton within w_svc_rx_refill
end type
type cb_1 from commandbutton within w_svc_rx_refill
end type
type st_checking_contraindications from statictext within w_svc_rx_refill
end type
end forward

global type w_svc_rx_refill from w_window_base
string title = "Retry Posting"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_be_back cb_be_back
cb_done cb_done
st_title st_title
st_date_title st_date_title
st_refill_date st_refill_date
st_print_now st_print_now
st_2 st_2
st_print_checkout st_print_checkout
st_dont_print st_dont_print
ole_refill_history ole_refill_history
st_1 st_1
st_3 st_3
mle_refill_comment mle_refill_comment
cb_pick_comment cb_pick_comment
pb_up pb_up
pb_down pb_down
cb_cancel cb_cancel
cb_1 cb_1
st_checking_contraindications st_checking_contraindications
end type
global w_svc_rx_refill w_svc_rx_refill

type variables
u_component_service service

string print_when
date refill_date

string progress_type

string signature_service

string report_service
string report_id


end variables

forward prototypes
public function integer check_contraindications ()
end prototypes

public function integer check_contraindications ();integer li_sts
string ls_assessment_id
str_attributes lstr_attributes
st_checking_contraindications.visible = true

ls_assessment_id = service.treatment.assessment.assessment_id

lstr_attributes = service.get_attributes()

li_sts = f_check_contraindications(service.cpr_id, ls_assessment_id, service.treatment.treatment_type, service.treatment.treatment_key, service.treatment.treatment_description, lstr_attributes)


st_checking_contraindications.visible = false


return li_sts


end function

on w_svc_rx_refill.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.st_title=create st_title
this.st_date_title=create st_date_title
this.st_refill_date=create st_refill_date
this.st_print_now=create st_print_now
this.st_2=create st_2
this.st_print_checkout=create st_print_checkout
this.st_dont_print=create st_dont_print
this.ole_refill_history=create ole_refill_history
this.st_1=create st_1
this.st_3=create st_3
this.mle_refill_comment=create mle_refill_comment
this.cb_pick_comment=create cb_pick_comment
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.st_checking_contraindications=create st_checking_contraindications
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_date_title
this.Control[iCurrent+5]=this.st_refill_date
this.Control[iCurrent+6]=this.st_print_now
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_print_checkout
this.Control[iCurrent+9]=this.st_dont_print
this.Control[iCurrent+10]=this.ole_refill_history
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.mle_refill_comment
this.Control[iCurrent+14]=this.cb_pick_comment
this.Control[iCurrent+15]=this.pb_up
this.Control[iCurrent+16]=this.pb_down
this.Control[iCurrent+17]=this.cb_cancel
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.st_checking_contraindications
end on

on w_svc_rx_refill.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.st_title)
destroy(this.st_date_title)
destroy(this.st_refill_date)
destroy(this.st_print_now)
destroy(this.st_2)
destroy(this.st_print_checkout)
destroy(this.st_dont_print)
destroy(this.ole_refill_history)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.mle_refill_comment)
destroy(this.cb_pick_comment)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_cancel)
destroy(this.cb_1)
destroy(this.st_checking_contraindications)
end on

event post_open;call super::post_open;integer li_sts
str_popup_return popup_return


li_sts = check_contraindications()
if li_sts <= 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "CANCEL"
	closewithreturn(this, popup_return)
end if

return

end event

event open;call super::open;str_popup_return popup_return
long ll_menu_id
integer li_sts
string ls_refill_comment
string ls_progress_key
long ll_null

setnull(ll_null)

popup_return.item_count = 0

service = message.powerobjectparm


if isnull(service.treatment) then
	log.log(this, "w_svc_rx_refill:open", "Null treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

st_title.text = service.treatment.treatment_description

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 2
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 3
end if

refill_date = today()
st_refill_date.text = string(refill_date, date_format_string)


print_when = service.get_attribute("print_when")
if isnull(print_when) then print_when = "NOW"

if not service.is_encounter_open() then
	// If the encounter isn't open then we can't print at checkout
	st_print_checkout.visible = false
	// If we're supposed to print at checkout then change it to "now"
	if upper(left(print_when, 1)) = "C" then
		print_when = "NOW"
	end if
end if

CHOOSE CASE upper(left(print_when, 1))
	CASE "N"
		// Now
		print_when = "NOW"
		st_print_now.backcolor = color_object_selected
	CASE "C"
		// Checkout
		print_when = "CHECKOUT"
		st_print_checkout.backcolor = color_object_selected
	CASE "D"
		// Don't Print
		print_when = "DONT"
		st_dont_print.backcolor = color_object_selected
END CHOOSE

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

signature_service = service.get_attribute("signature_service")
if isnull(signature_service) then signature_service = "EXTERNAL_SOURCE"

report_service = service.get_attribute("report_service")
if isnull(report_service) then report_service = "REPORT"

report_id = service.get_attribute("report_id")
if isnull(report_id) then report_id = datalist.get_preference( "PREFERENCES", "rx_prescription_report", "{ED21F61C-D7A2-40EF-9022-2FE20658839D}")  // PB Prescription Report

progress_type = service.get_attribute("progress_type")
if isnull(progress_type) then progress_type = "Refill"

setnull(ls_progress_key)

ole_refill_history.initialize()
li_sts = ole_refill_history.display_progress("Treatment", service.treatment.treatment_id, progress_type, ls_progress_key, "Dates", false, ll_null)
if li_sts <= 0 then
	ole_refill_history.add_text("No Previous Refills")
end if

ls_refill_comment = service.get_attribute("refill_comment")
if isnull(ls_refill_comment) then ls_refill_comment = "Normal Refill"
mle_refill_comment.text = ls_refill_comment

mle_refill_comment.setfocus()

postevent("post_open")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_rx_refill
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_rx_refill
end type

type cb_be_back from commandbutton within w_svc_rx_refill
integer x = 1454
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_svc_rx_refill
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 80
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
integer li_sts
string ls_progress
str_attributes lstr_attributes
datetime ldt_progress_date_time
string ls_progress_key
long ll_risk_level

ls_progress_key = "Ordered"
setnull(ll_risk_level)

ls_progress = trim(mle_refill_comment.text)
if ls_progress = "" or isnull(ls_progress) then
	openwithparm(w_pop_message, "You must provide a comment")
	return
end if

if refill_date = today() then
	ldt_progress_date_time = datetime(today(), now())
else
	ldt_progress_date_time = datetime(refill_date, time(""))
end if

current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, &
																	progress_type, &
																	ls_progress_key, &
																	ls_progress, &
																	ldt_progress_date_time, &
																	ll_risk_level)

lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "report_id", report_id)
f_attribute_add_attribute(lstr_attributes, "prescription_date", string(refill_date, date_format_string))

if print_when = "NOW" then
	service_list.do_service(service.cpr_id, service.encounter_id, report_service, lstr_attributes)
elseif print_when = "CHECKOUT" then
	service_list.order_service_at_checkout(service.cpr_id, service.encounter_id, report_service, "Print Refill", lstr_attributes)
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_svc_rx_refill
integer width = 2921
integer height = 172
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Treatment Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_date_title from statictext within w_svc_rx_refill
integer x = 224
integer y = 196
integer width = 361
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_refill_date from statictext within w_svc_rx_refill
integer x = 603
integer y = 180
integer width = 576
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12/12/2000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_date
string ls_text

ld_date = refill_date

ls_text = f_select_date(ld_date, "Refill Date")
if isnull(ls_text) then return

refill_date = ld_date
text = ls_text

end event

type st_print_now from statictext within w_svc_rx_refill
integer x = 2080
integer y = 744
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Print Now"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_print_checkout.backcolor = color_object
st_dont_print.backcolor = color_object

print_when = "NOW"

end event

type st_2 from statictext within w_svc_rx_refill
integer x = 2121
integer y = 632
integer width = 507
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Print When"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_print_checkout from statictext within w_svc_rx_refill
integer x = 2080
integer y = 900
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Print at Checkout"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_print_now.backcolor = color_object
st_dont_print.backcolor = color_object

print_when = "CHECKOUT"

end event

type st_dont_print from statictext within w_svc_rx_refill
integer x = 2080
integer y = 1056
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Don~'t Print"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_print_checkout.backcolor = color_object
st_print_now.backcolor = color_object

print_when = "DONT"

end event

type ole_refill_history from u_rich_text_edit within w_svc_rx_refill
integer x = 137
integer y = 668
integer width = 1669
integer height = 824
integer taborder = 10
boolean bringtotop = true
boolean scrollbars = false
end type

type st_1 from statictext within w_svc_rx_refill
integer x = 142
integer y = 600
integer width = 507
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill History"
boolean focusrectangle = false
end type

type st_3 from statictext within w_svc_rx_refill
integer x = 101
integer y = 356
integer width = 480
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill Comment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_refill_comment from multilineedit within w_svc_rx_refill
integer x = 603
integer y = 352
integer width = 1934
integer height = 172
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_pick_comment from commandbutton within w_svc_rx_refill
integer x = 2555
integer y = 428
integer width = 128
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Refill Comment"
popup.data_row_count = 2
popup.items[1] = "Refill Comment"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

mle_refill_comment.replacetext(popup_return.items[1])

mle_refill_comment.setfocus()

end event

type pb_up from u_picture_button within w_svc_rx_refill
integer x = 1819
integer y = 668
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;ole_refill_history.Scroll_up()
end event

type pb_down from u_picture_button within w_svc_rx_refill
integer x = 1819
integer y = 792
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;ole_refill_history.Scroll_down()
end event

type cb_cancel from commandbutton within w_svc_rx_refill
integer x = 1934
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_1 from commandbutton within w_svc_rx_refill
integer x = 2080
integer y = 1300
integer width = 603
integer height = 144
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sign for Refill"
end type

event clicked;str_attributes lstr_attributes

lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "object_context", "treatment")
f_attribute_add_attribute(lstr_attributes, "external_source_type", "Signature")

service_list.do_service(service.cpr_id, service.encounter_id, signature_service, lstr_attributes)

end event

type st_checking_contraindications from statictext within w_svc_rx_refill
boolean visible = false
integer x = 983
integer y = 100
integer width = 955
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 31385327
string text = "<  Checking Contraindications  >"
alignment alignment = center!
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Fw_svc_rx_refill.bin 
2400001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000002ed68fe001ca361f0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba905000000002ed68fe001ca361f2ed68fe001ca361f000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
24ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d003400340032003700380034003900350065003400420072006900750064006c0072006500310020002e0031003b0030003a00430050005c0000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a0000000030001000700000003000025b9000000030000154a00000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
216e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e69006100000073006e00490020004300540041000000690072006c0061004e002000720061006f007200010007000025b90000154a000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d0000000000000000000000000000004000000050080076640000000020006400201fff1e000000240000001d0000000700000004000000010000000e0000003400000190000000000000006000000060fffc002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Fw_svc_rx_refill.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
