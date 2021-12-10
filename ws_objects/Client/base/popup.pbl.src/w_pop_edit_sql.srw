$PBExportHeader$w_pop_edit_sql.srw
forward
global type w_pop_edit_sql from w_window_base
end type
type st_title from statictext within w_pop_edit_sql
end type
type cb_cancel from commandbutton within w_pop_edit_sql
end type
type cb_ok from commandbutton within w_pop_edit_sql
end type
type cb_load_file from commandbutton within w_pop_edit_sql
end type
type ole_text from u_rich_text_edit within w_pop_edit_sql
end type
type cb_open from commandbutton within w_pop_edit_sql
end type
type cb_reload from commandbutton within w_pop_edit_sql
end type
type cb_execute from commandbutton within w_pop_edit_sql
end type
type cb_select_all from commandbutton within w_pop_edit_sql
end type
end forward

global type w_pop_edit_sql from w_window_base
integer width = 2962
integer height = 1944
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
boolean auto_resize_objects = false
st_title st_title
cb_cancel cb_cancel
cb_ok cb_ok
cb_load_file cb_load_file
ole_text ole_text
cb_open cb_open
cb_reload cb_reload
cb_execute cb_execute
cb_select_all cb_select_all
end type
global w_pop_edit_sql w_pop_edit_sql

type variables
str_sql_context sql_context

string open_file

end variables

event open;call super::open;long n

sql_context = message.powerobjectparm

////////////////////////////////////////////////////////////////////////////////
// Size/Move the controls
////////////////////////////////////////////////////////////////////////////////
st_title.width = width

ole_text.width = width - 70
ole_text.height = height - ole_text.y - 300

cb_execute.x = ole_text.x + ole_text.width - cb_execute.width

cb_cancel.y = height - cb_cancel.height - 130

cb_reload.visible = false
cb_reload.x = (width - cb_reload.width) / 2
cb_reload.y = cb_cancel.y

cb_open.x = cb_reload.x - cb_open.width - 30
cb_open.y = cb_cancel.y

cb_load_file.x = cb_reload.x + cb_reload.width + 30
cb_load_file.y = cb_cancel.y

cb_ok.x = ole_text.x + ole_text.width - cb_ok.width
cb_ok.y = cb_cancel.y

////////////////////////////////////////////////////////////////////////////////
// Initialize text control
////////////////////////////////////////////////////////////////////////////////
ole_text.apply_formatting("fn=Courier New,fontsize=-14,tabs=500/1000/1500/2000/2500/3000/3500/4000/4500/5000/5500/6000/6500/7000")
ole_text.set_edit_mode("Editable")

////////////////////////////////////////////////////////////////////////////////
// Initialize window
////////////////////////////////////////////////////////////////////////////////
if len(sql_context.script_name) > 0 then
	st_title.text = sql_context.script_name
end if

if not isnull(sql_context.sql) and trim(sql_context.sql) <> "" then
	ole_text.add_text(sql_context.sql)
end if

// Clear the Undo Buffer
//ole_text.object.allowundo = false
//ole_text.object.allowundo = true

ole_text.setfocus()


end event

on w_pop_edit_sql.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_load_file=create cb_load_file
this.ole_text=create ole_text
this.cb_open=create cb_open
this.cb_reload=create cb_reload
this.cb_execute=create cb_execute
this.cb_select_all=create cb_select_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_load_file
this.Control[iCurrent+5]=this.ole_text
this.Control[iCurrent+6]=this.cb_open
this.Control[iCurrent+7]=this.cb_reload
this.Control[iCurrent+8]=this.cb_execute
this.Control[iCurrent+9]=this.cb_select_all
end on

on w_pop_edit_sql.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_load_file)
destroy(this.ole_text)
destroy(this.cb_open)
destroy(this.cb_reload)
destroy(this.cb_execute)
destroy(this.cb_select_all)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_edit_sql
integer x = 3072
integer y = 0
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_edit_sql
integer x = 462
integer y = 2552
end type

type st_title from statictext within w_pop_edit_sql
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "SQL Script"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pop_edit_sql
integer x = 18
integer y = 1700
integer width = 402
integer height = 112
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

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_ok from commandbutton within w_pop_edit_sql
integer x = 2496
integer y = 1700
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return popup_return
string ls_text

ls_text = ole_text.get_text()

if len(ls_text) > 0 then
	popup_return.item = ls_text
	popup_return.items[1] = popup_return.item
	popup_return.item_count = 1
else
	setnull(popup_return.item)
	popup_return.item_count = 0
end if

closewithreturn(parent, popup_return)

end event

type cb_load_file from commandbutton within w_pop_edit_sql
integer x = 1659
integer y = 1716
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Load ..."
end type

event clicked;string ls_filter
integer li_sts
long ll_count
long i
string lsa_paths[]
string lsa_files[]
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file

ls_filter = "All Files (*.*), *.*"

li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
															"Select Text File", &
															lsa_paths, &
															lsa_files, &
															ls_filter)
if li_sts < 0 then return

ll_count = upperbound(lsa_paths)

for i = 1 to ll_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue
	
	ll_filebytes = log.file_read2(lsa_paths[i], lbl_file, false)
	if ll_filebytes > 0 then
		ole_text.selecttextall()
		ole_text.clear()
		ole_text.add_text(f_blob_to_string(lbl_file))
		exit
	end if
next

end event

type ole_text from u_rich_text_edit within w_pop_edit_sql
integer x = 23
integer y = 200
integer width = 2866
integer height = 1468
integer taborder = 10
boolean bringtotop = true
end type

type cb_open from commandbutton within w_pop_edit_sql
integer x = 791
integer y = 1704
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open File"
end type

event clicked;integer li_sts
blob lbl_sql

open_file = f_temp_file("sql")

lbl_sql = f_string_to_blob(sql_context.sql, "UTF-8")

li_sts = log.file_write(lbl_sql, open_file)

f_open_file(open_file, false)

cb_reload.visible = true


end event

type cb_reload from commandbutton within w_pop_edit_sql
integer x = 1225
integer y = 1712
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Read File"
end type

event clicked;long ll_filebytes
blob lbl_file

ll_filebytes = log.file_read2(open_file, lbl_file, false)
if ll_filebytes > 0 then
	ole_text.selecttextall()
	ole_text.clear()
	ole_text.add_text(f_blob_to_string(lbl_file))
end if

end event

type cb_execute from commandbutton within w_pop_edit_sql
integer x = 2482
integer y = 112
integer width = 402
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute"
end type

event clicked;long ll_count
string ls_sql
str_sql_context lstr_sql_context
w_window_base lw_window
ls_sql = ole_text.get_text()

lstr_sql_context.script_name = st_title.text
lstr_sql_context.attributes = sql_context.attributes
lstr_sql_context.context = sql_context.context
lstr_sql_context.sql = ls_sql

openwithparm(lw_window, lstr_sql_context, "w_pop_display_sql_results")



end event

type cb_select_all from commandbutton within w_pop_edit_sql
integer x = 23
integer y = 112
integer width = 567
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All/Copy"
end type

event clicked;string ls_sql

ls_sql = ole_text.get_text()

clipboard(ls_sql)

ole_text.selecttextall()

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
00w_pop_edit_sql.bin 
2C00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000e05deff001ca361b0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007dd00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000e05deff001ca361be05deff001ca361b000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d0034003400320037003800340039003500430034005c003a004d004a005c004a00630069006e006f003b00730043003b005c003a004900570000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007ad0000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002f000000120000002f80000012100000300000001220000030800000123000003100000012400000318000001250000032000000126000003280000012700000330000001280000033800000129000003400000012a000003480000012b000003500000012c000003580000012d000003600000012e000003680000012f0000037000000130000003780000013100000380000001320000038c0000013300000394000001340000039c00000000000003a4000000030001000700000003000040cd00000003000025ee00000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b000000000000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff000000080000000c72756f43207265690077654e000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c7409000001
2C690000006e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e6900000000000000000000000000000000000000000000000000000000000000000000000000010007000040cd000025ee000000490000000000ffffff0100010100000100010000000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a000000064006f430b0165697275654e207200000c7700000000ffffff006400000020000000140000000000000000000000000000000001010002ba010104b10000000e00010000000000000000000200000144000000010000000100010000000100000000001f000000010001000000000000000000000000500000000000ff100000000000000190000000006f43310265697275654e207200000077000000000000000000000000000000000001000000010001000000000000000000000000002000640000001401046e014a0108dc11b8010d0116260102011a942370011f0127de01ba012c4c352801300139960100003e04000000000000000000000000004300000075006f0069007200720065004e0020007700650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000002100000374000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e40000000100000209000100000100b7002e000000ffff000000000000000000000000000100000000000000000000000000000000000000000001000000000000000000000000000000000154000000300000000000000000000000000000000005a0ffff05a0000000ff00000000000100000000000000000000000000000124000000010000000000000000ff1000000000000001900000000072412202006c6169000000000000000000000000000000000000000000000000000000000000000000000000000000000041000000690072006c006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000050000000000000000000000000000000002000640000001401046e014a0108dc11b8010d0116260102011a942370011f0127de01ba012c4c352801300139960100013e040209000100000100b7002e000000ffff0000000000000000000000000000000000000012000000000000000000000000000000000000000000000000004e005b0072006f0061006d005d006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10w_pop_edit_sql.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
