$PBExportHeader$u_assessment_overview.sru
forward
global type u_assessment_overview from userobject
end type
type rtf from u_rich_text_edit within u_assessment_overview
end type
type dw_properties from u_dw_pick_list within u_assessment_overview
end type
type st_begin_date_changed from statictext within u_assessment_overview
end type
end forward

global type u_assessment_overview from userobject
integer width = 2912
integer height = 1164
long backcolor = 33538240
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
rtf rtf
dw_properties dw_properties
st_begin_date_changed st_begin_date_changed
end type
global u_assessment_overview u_assessment_overview

type variables
u_str_assessment		assessment
long display_script_id

end variables

forward prototypes
public function integer initialize (u_str_assessment puo_assessment)
public function integer assessment_overview ()
public function integer display_assessment_properties (str_assessment_description pstr_assessment)
end prototypes

public function integer initialize (u_str_assessment puo_assessment);long ll_backcolor
integer li_sts
str_assessment_description lstr_assessment

ll_backcolor = datalist.get_preference_int("SYSTEM", "assessment_review_background_color")
if not isnull(ll_backcolor) then rtf.set_background_color(ll_backcolor)

assessment = puo_assessment

li_sts = current_patient.assessments.assessment(lstr_assessment, assessment.problem_id)
if li_sts <= 0 then return -1

dw_properties.width = 1029
dw_properties.height = height - 100
dw_properties.x = width - dw_properties.width - 20
dw_properties.y = 20

//rtf.width = dw_properties.x - 20
//rtf.height = this.height

//st_begin_date.x = width - st_begin_date.width - 20
//st_end_date.x = st_begin_date.x
//st_created.x = st_begin_date.x
//st_ordered_by.x = st_begin_date.x
//st_closed_by.x = st_begin_date.x
//st_created_by.x = st_begin_date.x
//st_status.x = st_begin_date.x
//st_acuteness.x = st_begin_date.x
//
//st_begin_date_title.x = st_begin_date.x - st_begin_date_title.width - 8
//st_end_date_title.x = st_begin_date_title.x
//st_created_title.x = st_begin_date_title.x
//st_ordered_by_title.x = st_begin_date_title.x
//st_closed_by_title.x = st_begin_date_title.x
//st_created_by_title.x = st_begin_date_title.x
//st_status_title.x = st_begin_date_title.x
//st_acuteness_title.x = st_begin_date_title.x
//
return 1

end function

public function integer assessment_overview ();integer li_sts
str_assessment_description lstr_assessment

li_sts = current_patient.assessments.assessment(lstr_assessment, assessment.problem_id)
if li_sts <= 0 then return -1

//rtf.setredraw(false)

//rtf.width = dw_properties.x - 20
rtf.width = width
rtf.height = height

rtf.clear_rtf()

rtf.display_assessment(lstr_assessment, display_script_id)
rtf.top()

display_assessment_properties(lstr_assessment)

//rtf.setredraw(true)

return 1

end function

public function integer display_assessment_properties (str_assessment_description pstr_assessment);Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
integer li_sts

setnull(ls_null)

dw_properties.reset()

dw_properties.object.title[1] = "Begin Date"
dw_properties.object.attribute[1] = "begin_date"
dw_properties.object.value[1] = string(pstr_assessment.begin_date)
dw_properties.object.clickable[1] = 1

dw_properties.object.title[2] = "End Date"
dw_properties.object.attribute[2] = "end_date"
dw_properties.object.value[2] = string(pstr_assessment.end_date)
// Don't let the user change the end_date if the assessment is still open
if isnull(pstr_assessment.assessment_status) then
	dw_properties.object.clickable[2] = 0
else
	dw_properties.object.clickable[2] = 1
end if

dw_properties.object.title[3] = "Created"
dw_properties.object.attribute[3] = "created"
dw_properties.object.value[3] = string(pstr_assessment.created)

dw_properties.object.title[4] = "Ordered By"
dw_properties.object.attribute[4] = "ordered_by"
dw_properties.object.value[4] = user_list.user_full_name(pstr_assessment.diagnosed_by)
dw_properties.object.color[4] = user_list.user_color(pstr_assessment.diagnosed_by)

SELECT max(assessment_progress_sequence)
INTO :ll_progress_sequence
FROM p_assessment_Progress
WHERE cpr_id = :current_patient.cpr_id
AND problem_id = :pstr_assessment.problem_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_assessment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND problem_id = :pstr_assessment.problem_id
	AND assessment_progress_sequence = :ll_progress_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_user_id)
end if

dw_properties.object.title[5] = "Closed By"
dw_properties.object.attribute[5] = "closed_by"
dw_properties.object.value[5] = user_list.user_full_name(ls_user_id)
dw_properties.object.color[5] = user_list.user_color(ls_user_id)

dw_properties.object.title[6] = "Created By"
dw_properties.object.attribute[6] = "created_by"
dw_properties.object.value[6] = user_list.user_full_name(pstr_assessment.created_by)
dw_properties.object.color[6] = user_list.user_color(pstr_assessment.created_by)



dw_properties.object.title[7] = "Status"
dw_properties.object.attribute[7] = "assessment_status"
if isnull(pstr_assessment.assessment_status) OR upper(pstr_assessment.assessment_status) = "OPEN" then
	dw_properties.object.value[7] = "Open"
else
	dw_properties.object.value[7] = wordcap(pstr_assessment.assessment_status)
end if
if upper(pstr_assessment.assessment_status) = "CANCELLED" then
	dw_properties.object.clickable[7] = 1
else
	dw_properties.object.clickable[7] = 0
end if


dw_properties.object.title[8] = "Acuteness"
dw_properties.object.attribute[8] = "acuteness"
dw_properties.object.value[8] = wordcap(pstr_assessment.acuteness)
dw_properties.object.clickable[8] = 1
	
return 1


end function

on u_assessment_overview.create
this.rtf=create rtf
this.dw_properties=create dw_properties
this.st_begin_date_changed=create st_begin_date_changed
this.Control[]={this.rtf,&
this.dw_properties,&
this.st_begin_date_changed}
end on

on u_assessment_overview.destroy
destroy(this.rtf)
destroy(this.dw_properties)
destroy(this.st_begin_date_changed)
end on

type rtf from u_rich_text_edit within u_assessment_overview
integer width = 1883
integer height = 1164
integer taborder = 30
end type

type dw_properties from u_dw_pick_list within u_assessment_overview
integer x = 1874
integer y = 16
integer width = 1029
integer height = 928
integer taborder = 20
string dataobject = "dw_attribute_value_display_list"
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
datetime ldt_begin_date
integer li_sts
string ls_attribute
integer li_clickable
string ls_old_value
string ls_new_value
string ls_null

setnull(ls_null)

if isnull(row) or row <= 0 then return

ls_attribute = object.attribute[row]
li_clickable = object.clickable[row]
ls_old_value = object.value[row]

if isnull(li_clickable) or li_clickable <= 0 then return

CHOOSE CASE lower(ls_attribute)
	CASE "begin_date"
		popup.title = "Begin Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date, db_datetime_format)
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
	CASE "end_date"
		popup.title = "End Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date, db_datetime_format)
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
	CASE "assessment_status"
		if ls_old_value = "Cancelled" then
			openwithparm(w_pop_yes_no, "Do you wish to un-cancel this assessment?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
			
			current_patient.assessments.set_progress(assessment.problem_id, 'UNCancelled', ls_null, ls_null)
			
			assessment_overview()
			return
		end if
	CASE "acuteness"
		popup.dataobject = "dw_domain_notranslate_list"
		popup.datacolumn = 2
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = "Acuteness"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		ls_new_value = popup_return.items[1]
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
		
END CHOOSE



end event

type st_begin_date_changed from statictext within u_assessment_overview
integer x = 3127
integer y = 24
integer width = 50
integer height = 64
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
07u_assessment_overview.bin 
2E00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000175701d001ca361d0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000175701d001ca361d175701d001ca361d000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
21ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d00340034003200370038003400390035000000340000000000000000000000000000000000000000000000000000000000000000000000000000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a000000003000100070000000300002a950000000300001e1300000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
2D6e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e69000000000000000000000000000000000000000000000000000000000000000000000000000000000001000700002a9500001e13000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17u_assessment_overview.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
