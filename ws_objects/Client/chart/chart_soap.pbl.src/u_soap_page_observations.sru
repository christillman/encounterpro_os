$PBExportHeader$u_soap_page_observations.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_observations from u_soap_page_base_large
end type
type rte_observations from u_rich_text_edit within u_soap_page_observations
end type
type st_format_1 from statictext within u_soap_page_observations
end type
type st_format_2 from statictext within u_soap_page_observations
end type
type st_format_3 from statictext within u_soap_page_observations
end type
type st_format_4 from statictext within u_soap_page_observations
end type
type pb_down from picturebutton within u_soap_page_observations
end type
type pb_up from picturebutton within u_soap_page_observations
end type
end forward

global type u_soap_page_observations from u_soap_page_base_large
rte_observations rte_observations
st_format_1 st_format_1
st_format_2 st_format_2
st_format_3 st_format_3
st_format_4 st_format_4
pb_down pb_down
pb_up pb_up
end type
global u_soap_page_observations u_soap_page_observations

type variables

long display_script_id_1
long display_script_id_2
long display_script_id_3
long display_script_id_4

long current_display_script_id

end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_initialize ()
public subroutine prev_encounter ()
public subroutine next_encounter ()
public subroutine key_down (keycode key, unsignedlong keyflags)
end prototypes

public subroutine xx_refresh ();rte_observations.setredraw(false)

rte_observations.clear_rtf()
rte_observations.display_encounter(current_display_encounter.encounter_id, current_display_script_id)
rte_observations.goto_top()

rte_observations.setredraw(true)

end subroutine

public subroutine xx_initialize ();integer i
string ls_temp

pb_up.visible = false
pb_down.visible = false

this_section.load_params(this_section.page[this_page].page_id)

st_format_1.backcolor = color_object
st_format_2.backcolor = color_object
st_format_3.backcolor = color_object
st_format_4.backcolor = color_object

setnull(current_display_script_id)
	
display_script_id_1 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_1"))
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_1")
if isnull(display_script_id_1) then
	st_format_1.visible = false
else
	st_format_1.visible = true
	if not isnull(ls_temp) then st_format_1.text = left(ls_temp, 3)
	if isnull(current_display_script_id) then
		st_format_1.backcolor = color_object_selected
		current_display_script_id = display_script_id_1
	end if
end if

display_script_id_2 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_2"))
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_2")
if isnull(display_script_id_2) then
	st_format_2.visible = false
else
	st_format_2.visible = true
	if not isnull(ls_temp) then st_format_2.text = left(ls_temp, 3)
	if isnull(current_display_script_id) then
		st_format_2.backcolor = color_object_selected
		current_display_script_id = display_script_id_2
	end if
end if

display_script_id_3 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_3"))
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_3")
if isnull(display_script_id_3) then
	st_format_3.visible = false
else
	st_format_3.visible = true
	if not isnull(ls_temp) then st_format_3.text = left(ls_temp, 3)
	if isnull(current_display_script_id) then
		st_format_3.backcolor = color_object_selected
		current_display_script_id = display_script_id_3
	end if
end if

display_script_id_4 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_4"))
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_4")
if isnull(display_script_id_4) then
	st_format_4.visible = false
else
	st_format_4.visible = true
	if not isnull(ls_temp) then st_format_4.text = left(ls_temp, 3)
	if isnull(current_display_script_id) then
		st_format_4.backcolor = color_object_selected
		current_display_script_id = display_script_id_4
	end if
end if

if dw_encounters.visible then
	pb_up.visible = true
	pb_down.visible = true
	rte_observations.visible = true

	pb_down.x = content_right_edge - pb_down.width
	pb_up.x = pb_down.x - pb_up.width - 12
	
	pb_up.y = content_bottom_edge - pb_up.height
	pb_down.y = content_bottom_edge - pb_down.height
	
	st_format_2.x = content_left_edge + (content_width / 2) - st_format_2.width - 8
	st_format_1.x = st_format_2.x - st_format_1.width - 16
	st_format_3.x = st_format_2.x + st_format_2.width + 16
	st_format_4.x = st_format_3.x + st_format_3.width + 16
	
	st_format_1.y = content_bottom_edge - st_format_1.height
	st_format_2.y = content_bottom_edge - st_format_2.height
	st_format_3.y = content_bottom_edge - st_format_3.height
	st_format_4.y = content_bottom_edge - st_format_4.height

	rte_observations.x = content_left_edge
	rte_observations.y = content_top_edge
	rte_observations.width = content_width
	rte_observations.height = st_format_1.y - rte_observations.y - 20

	rte_observations.initialize()
else
	pb_up.visible = false
	pb_down.visible = false
	rte_observations.visible = false
	st_format_1.visible = false
	st_format_2.visible = false
	st_format_3.visible = false
	st_format_4.visible = false
end if


end subroutine

public subroutine prev_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait

if isnull(current_display_encounter) then return

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 1  then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row - 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)

end subroutine

public subroutine next_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait


if isnull(current_display_encounter) then return

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 0 and ll_row < ll_count then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row + 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)
end subroutine

public subroutine key_down (keycode key, unsignedlong keyflags);

CHOOSE CASE key
	CASE keyuparrow!
		prev_encounter()
	CASE keydownarrow!
		next_encounter()
	CASE keypageup!
		pb_up.event post clicked()
	CASE keypagedown!
		pb_down.event post clicked()
END CHOOSE

return

end subroutine

on u_soap_page_observations.create
int iCurrent
call super::create
this.rte_observations=create rte_observations
this.st_format_1=create st_format_1
this.st_format_2=create st_format_2
this.st_format_3=create st_format_3
this.st_format_4=create st_format_4
this.pb_down=create pb_down
this.pb_up=create pb_up
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rte_observations
this.Control[iCurrent+2]=this.st_format_1
this.Control[iCurrent+3]=this.st_format_2
this.Control[iCurrent+4]=this.st_format_3
this.Control[iCurrent+5]=this.st_format_4
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.pb_up
end on

on u_soap_page_observations.destroy
call super::destroy
destroy(this.rte_observations)
destroy(this.st_format_1)
destroy(this.st_format_2)
destroy(this.st_format_3)
destroy(this.st_format_4)
destroy(this.pb_down)
destroy(this.pb_up)
end on

type cb_configure_tab from u_soap_page_base_large`cb_configure_tab within u_soap_page_observations
end type

type st_coding_title from u_soap_page_base_large`st_coding_title within u_soap_page_observations
end type

type st_all from u_soap_page_base_large`st_all within u_soap_page_observations
end type

type st_indirect from u_soap_page_base_large`st_indirect within u_soap_page_observations
end type

type st_direct from u_soap_page_base_large`st_direct within u_soap_page_observations
end type

type st_button_12 from u_soap_page_base_large`st_button_12 within u_soap_page_observations
end type

type st_button_9 from u_soap_page_base_large`st_button_9 within u_soap_page_observations
end type

type st_button_7 from u_soap_page_base_large`st_button_7 within u_soap_page_observations
end type

type st_button_11 from u_soap_page_base_large`st_button_11 within u_soap_page_observations
end type

type st_button_10 from u_soap_page_base_large`st_button_10 within u_soap_page_observations
end type

type st_button_8 from u_soap_page_base_large`st_button_8 within u_soap_page_observations
end type

type pb_12 from u_soap_page_base_large`pb_12 within u_soap_page_observations
end type

type pb_11 from u_soap_page_base_large`pb_11 within u_soap_page_observations
end type

type pb_10 from u_soap_page_base_large`pb_10 within u_soap_page_observations
end type

type pb_9 from u_soap_page_base_large`pb_9 within u_soap_page_observations
end type

type pb_8 from u_soap_page_base_large`pb_8 within u_soap_page_observations
end type

type pb_7 from u_soap_page_base_large`pb_7 within u_soap_page_observations
end type

type dw_encounters from u_soap_page_base_large`dw_encounters within u_soap_page_observations
end type

type cb_coding from u_soap_page_base_large`cb_coding within u_soap_page_observations
end type

type pb_4 from u_soap_page_base_large`pb_4 within u_soap_page_observations
end type

type cb_current from u_soap_page_base_large`cb_current within u_soap_page_observations
end type

type pb_1 from u_soap_page_base_large`pb_1 within u_soap_page_observations
end type

type pb_5 from u_soap_page_base_large`pb_5 within u_soap_page_observations
end type

type pb_2 from u_soap_page_base_large`pb_2 within u_soap_page_observations
end type

type pb_3 from u_soap_page_base_large`pb_3 within u_soap_page_observations
end type

type pb_6 from u_soap_page_base_large`pb_6 within u_soap_page_observations
end type

type st_button_1 from u_soap_page_base_large`st_button_1 within u_soap_page_observations
end type

type st_button_2 from u_soap_page_base_large`st_button_2 within u_soap_page_observations
end type

type st_button_3 from u_soap_page_base_large`st_button_3 within u_soap_page_observations
end type

type st_button_4 from u_soap_page_base_large`st_button_4 within u_soap_page_observations
end type

type st_button_5 from u_soap_page_base_large`st_button_5 within u_soap_page_observations
end type

type st_button_6 from u_soap_page_base_large`st_button_6 within u_soap_page_observations
end type

type st_config_mode_menu from u_soap_page_base_large`st_config_mode_menu within u_soap_page_observations
end type

type st_encounter_count from u_soap_page_base_large`st_encounter_count within u_soap_page_observations
end type

type st_7 from u_soap_page_base_large`st_7 within u_soap_page_observations
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_soap_page_observations
end type

type rte_observations from u_rich_text_edit within u_soap_page_observations
integer x = 1143
integer y = 144
integer width = 1989
integer height = 1844
integer taborder = 50
boolean bringtotop = true
borderstyle borderstyle = styleraised!
end type

event field_clicked;call super::field_clicked;parent.postevent("refresh")
end event

type st_format_1 from statictext within u_soap_page_observations
integer x = 1842
integer y = 2008
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "1"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_3.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_1

refresh()

end event

type st_format_2 from statictext within u_soap_page_observations
integer x = 2002
integer y = 2008
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_1.backcolor = color_object
st_format_3.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_2

refresh()

end event

type st_format_3 from statictext within u_soap_page_observations
integer x = 2162
integer y = 2008
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "3"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_1.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_3

refresh()

end event

type st_format_4 from statictext within u_soap_page_observations
integer x = 2322
integer y = 2008
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "4"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_3.backcolor = color_object
st_format_1.backcolor = color_object

current_display_script_id = display_script_id_4

refresh()

end event

type pb_down from picturebutton within u_soap_page_observations
integer x = 2994
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;rte_observations.Scroll_down()

end event

type pb_up from picturebutton within u_soap_page_observations
integer x = 2834
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;rte_observations.Scroll_up()

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
08u_soap_page_observations.bin 
2700001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000c7cc31b001caa9a00000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000c7cc31b001caa9a0c7cc31b001caa9a0000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d00340034003200370038003400390035006900340063006e006f006800500020006f00720048002000400000006f004b0075007a0061006b0000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a000000003000100070000000300002cf50000000300002fa500000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
216e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e69006100000073006e00490020004300540047000000720061006d0061006e006f00000064006f004d0001000700002cf500002fa5000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d000000000000000000000000005b0000006f004e006d0072006c00610000005d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18u_soap_page_observations.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
