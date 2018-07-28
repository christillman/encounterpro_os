HA$PBExportHeader$u_richtextedit_richtextctrl.sru
forward
global type u_richtextedit_richtextctrl from u_ole_richtextctrl
end type
end forward

global type u_richtextedit_richtextctrl from u_ole_richtextctrl
integer width = 901
integer height = 540
event lbuttondown pbm_renlbuttondown
event field_clicked ( long pl_fieldid,  string ps_field_text,  string ps_field_data )
end type
global u_richtextedit_richtextctrl u_richtextedit_richtextctrl

type prototypes
FUNCTION long StartDoc(long hDC, ref docinfo DInfo) LIBRARY "GDI32.DLL"  alias for "StartDocA;Ansi"
FUNCTION long EndDoc(long hDC) LIBRARY "GDI32.DLL"
FUNCTION long StartPage(long hDC) LIBRARY "GDI32.DLL"
FUNCTION long EndPage(long hDC) LIBRARY "GDI32.DLL"

end prototypes

type variables
long level_indent = 300
integer level = 0
integer last_table = 9

long left_margin
long right_margin
long wrap_margin

long	detail_position = 0
long	header_position = 0
long	footer_position = 0

boolean displayonly
boolean scrollbars = true


long height_twips
long page_height_twips

long page_width_twips

boolean header_exists = false
boolean footer_exists = false
boolean first_header_exists = false
boolean first_footer_exists = false

boolean use_wrap_margin = false

// TX constants
integer txFieldPageNumber = 3
integer txTableCellHorizontalPos = 0
integer txTableCellHorizontalExt = 1
integer txTableCellBorderWidth = 2

integer tabstop_count
long tabstops[]
long tabtypes[]

long last_backcolor

end variables

forward prototypes
public subroutine prev_level ()
public function string rich_text ()
public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin)
public subroutine set_margins (long pl_wrap_margin, long pl_right_margin)
public subroutine set_margins ()
public subroutine clear_rtf ()
public subroutine next_level ()
public subroutine set_underline (boolean pb_underline)
public subroutine top ()
public subroutine goto_top ()
public subroutine copy_to_clipboard (boolean pb_all)
public function string get_text ()
public subroutine add_page_break ()
public subroutine add_tab ()
public subroutine delete_this_line ()
public subroutine set_bold (boolean pb_bold)
public subroutine set_color (long pl_color)
public subroutine set_font_size (integer pi_size)
public subroutine set_italic (boolean pb_italic)
public subroutine set_justify (alignment pe_alignment)
public subroutine delete_from_position (long pl_position)
public subroutine delete_last_chars (long pl_count)
public subroutine delete_last_line ()
public subroutine delete_range (long pl_startpos, long pl_endpos)
public subroutine add_text (string ps_text)
public function long add_cr ()
public subroutine delete_cr ()
public subroutine set_level (integer pi_level)
public subroutine set_detail ()
public subroutine set_footer ()
public subroutine set_header ()
public subroutine set_text_back_color (long pl_color)
public subroutine set_backcolor (long pl_color)
public subroutine apply_formatting (string ps_formatting)
public subroutine set_fontstate (str_tx_fontstate pstr_fontstate)
protected function str_tx_fontstate get_fontstate ()
public subroutine read_formatting ()
public subroutine reset_formatting ()
public subroutine add_rtf (string ps_rtf)
public subroutine goto_end_of_text ()
public subroutine goto_end_of_line ()
public function integer print (string ps_jobname)
public function integer savedocument (string ps_file)
public function integer savedocument (string ps_file, integer pi_format)
public subroutine scroll_down ()
public subroutine scroll_up ()
public subroutine initialize ()
public subroutine set_tab (integer pi_tab_number, string ps_tab_type, long pl_tab_position)
public function integer load_document (string ps_file, integer pi_format)
private function integer filetype_to_tx_format (string ps_filetype)
public function integer load_document (string ps_file)
public subroutine refresh ()
public subroutine add_page_number ()
public subroutine add_date ()
public subroutine add_time ()
public subroutine add_date_time ()
public subroutine add_page_number (string ps_title)
public function integer add_image (string ps_filename)
public subroutine convert_inches_to_pixels (long pl_inches_x, long pl_inches_y, ref long pl_pixels_x, ref long pl_pixels_y)
public subroutine convert_pixels_to_inches (long pl_pixels_x, long pl_pixels_y, ref long pl_inches_x, ref long pl_inches_y)
public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches)
public subroutine add_report_command (str_c_report_command pstr_command)
public subroutine wrap_off ()
public subroutine wrap_on ()
public function long add_field (string ps_display, string ps_data)
public subroutine clear_tabs ()
public subroutine delete_field (long pl_fieldid, boolean pb_delete_text)
public subroutine update_field (long pl_fieldid, string ps_fielddata)
public subroutine add_grid (str_grid pstr_grid)
public subroutine blank_lines (integer pi_lines)
public subroutine unset_text_back_color ()
public subroutine set_default_tabs ()
public function long charposition ()
public subroutine clear ()
public function long linelength ()
public function long linelength (long pl_line)
public function long selectedline ()
public subroutine selecttextall ()
public subroutine selecttextline ()
end prototypes

public subroutine prev_level ();set_level(level - 1)

end subroutine

public function string rich_text ();
string ls_rtf

if object.sellength > 0 then
	ls_rtf = object.selrtf
else
	ls_rtf = object.textrtf
end if

return ls_rtf

end function

public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin);
left_margin = pl_left_margin
wrap_margin = pl_wrap_margin
right_margin = pl_right_margin

//setparagraphsetting(leftmargin!, wrap_margin)
//setparagraphsetting(rightmargin!, right_margin)

set_level(level)

end subroutine

public subroutine set_margins (long pl_wrap_margin, long pl_right_margin);set_margins(0, pl_wrap_margin, pl_right_margin)

end subroutine

public subroutine set_margins ();
if left_margin <> 0 or right_margin <> 0 or wrap_margin <> 0 then
	set_margins(left_margin, wrap_margin, right_margin)
end if

end subroutine

public subroutine clear_rtf ();

object.textrtf = ""
level = 0
left_margin = 0
right_margin = 0
wrap_margin = 0
//fontstate_count = 0
use_wrap_margin = false
detail_position = 0
header_position = 0
footer_position = 0
header_exists = false
footer_exists = false
first_header_exists = false
first_footer_exists = false

end subroutine

public subroutine next_level ();set_level(level + 1)

end subroutine

public subroutine set_underline (boolean pb_underline);
if pb_underline then
	object.selunderline = 1
else
	object.selunderline = 0
end if


end subroutine

public subroutine top ();goto_top()

end subroutine

public subroutine goto_top ();

object.selstart = 0

end subroutine

public subroutine copy_to_clipboard (boolean pb_all);if pb_all then
	clipboard(object.text)
else
	clipboard(object.seltext)
end if

end subroutine

public function string get_text ();return object.text

end function

public subroutine add_page_break ();
add_text(char(12))


end subroutine

public subroutine add_tab ();add_text("~t")


end subroutine

public subroutine delete_this_line ();long ll_pos

ll_pos = object.find("~r~n", object.selstart, 1, 8)
if ll_pos <= 1 then return

delete_range(ll_pos, object.selstart)


end subroutine

public subroutine set_bold (boolean pb_bold);
if pb_bold then
	object.selbold = 1
else
	object.selbold = 0
end if


end subroutine

public subroutine set_color (long pl_color);object.selcolor = pl_color

end subroutine

public subroutine set_font_size (integer pi_size);object.selfontsize = pi_size
		
end subroutine

public subroutine set_italic (boolean pb_italic);
if pb_italic then
	object.selitalic = 1
else
	object.selitalic = 0
end if


end subroutine

public subroutine set_justify (alignment pe_alignment);
CHOOSE CASE pe_alignment
	CASE Left!
		object.selalignment = 0
	CASE Right!
		object.selalignment = 1
	CASE Center!
		object.selalignment = 2
	CASE Justify!
		object.selalignment = 0 // justify isn't supported with this control
END CHOOSE


end subroutine

public subroutine delete_from_position (long pl_position);long ll_currentpos

ll_currentpos = object.selstart

if ll_currentpos < pl_position then
	delete_range(ll_currentpos, pl_position)
else
	delete_range(pl_position, ll_currentpos)
end if


end subroutine

public subroutine delete_last_chars (long pl_count);long ll_pos

ll_pos = object.selstart

delete_range(ll_pos - pl_count, ll_pos)

end subroutine

public subroutine delete_last_line ();long ll_pos1
long ll_pos2

ll_pos1 = object.find("~r~n", object.selstart, 1, 8)
if ll_pos1 <= 1 then return

ll_pos2 = object.find("~r~n", ll_pos1, 1, 8)
if ll_pos2 <= 1 then return

delete_range(ll_pos1, ll_pos1 - 1)


end subroutine

public subroutine delete_range (long pl_startpos, long pl_endpos);long i
long j
long ll_selstart
long ll_sellength
integer li_table

ll_selstart = object.selstart
ll_sellength = object.sellength

object.selstart = pl_startpos
object.sellength = pl_endpos - pl_startpos
object.seltext = ""

if pl_endpos <= ll_selstart then
	// The entire deleted range is before the current selection
	object.selstart = ll_selstart - (pl_endpos - pl_startpos)
	object.sellength = ll_sellength
elseif pl_startpos >= (ll_selstart + ll_sellength) then
	// The entire deleted range is after the current selection
	object.selstart = ll_selstart
	object.sellength = ll_sellength
else
	// The deleted range contains the current selection
	object.selstart = pl_startpos
	object.sellength = 0
end if

end subroutine

public subroutine add_text (string ps_text);
if not isnull(ps_text) then object.seltext = ps_text


end subroutine

public function long add_cr ();add_text("~r~n")
return 1

end function

public subroutine delete_cr ();long ll_pos

ll_pos = object.find("~r~n", object.selstart, 1, 8)

if ll_pos > 1 then delete_range(ll_pos, ll_pos + 1)



end subroutine

public subroutine set_level (integer pi_level);long ll_indent
long ll_max_indent
long ll_left_twips
long ll_wrap_twips
long ll_right_twips

level = pi_level

ll_max_indent = (2 * wrap_margin) / 3

ll_indent = pi_level * level_indent

if level <= 0 then
	level = 0
	ll_indent = 0
elseif ll_indent > ll_max_indent and wrap_margin > (3 * level_indent) then
	ll_indent = ll_max_indent
end if

// Since the indent is relative to the left margin and we want the indentation to
// extend out to the left of the left margin, the indent value must be negative

ll_wrap_twips = (1440 * wrap_margin) / 1000
ll_right_twips = (1440 * right_margin) / 1000
ll_left_twips = (1440 * left_margin) / 1000

if use_wrap_margin then
	object.selindent = ll_wrap_twips
	object.selrightindent = ll_right_twips
	object.selhangingindent = ll_indent - ll_wrap_twips + ll_left_twips
	
	// Set a tab at the wrap margin
	clear_tabs()
	set_tab(1, "left", wrap_margin)
else
	object.selindent = ll_left_twips
	object.selrightindent = ll_right_twips
	object.selhangingindent = ll_left_twips
end if


read_formatting()

end subroutine

public subroutine set_detail ();return

end subroutine

public subroutine set_footer ();return

end subroutine

public subroutine set_header ();return

end subroutine

public subroutine set_text_back_color (long pl_color);return

end subroutine

public subroutine set_backcolor (long pl_color);object.backcolor = pl_color

end subroutine

public subroutine apply_formatting (string ps_formatting);string ls_next_command
string ls_remaining
string ls_temp1
string ls_temp2
integer li_fontsize
long ll_left_margin
long ll_wrap_margin
long ll_right_margin
string lsa_tabs[]
integer li_count
integer i
long ll_tabstop
string ls_tabstop
string ls_tabtype

// Formatting is specified by comma delimited commands:
// fontsize=#			Set the font size
// fn=<fontname>		Set the font
// bold					Set bold on
// italic				Set italics on
// underline			Set underline on
// xbold					Set bold off
// xitalic				Set italics on
// xunderline			Set underline on
// jl						Left Justify
//	jc						Center Justify
//	jr						Right Justify
//	jj						Left and Right Justify
//	fc=#					Foreground Color
//	bc=#					Text Background Color
// margins=#/#/#		Set Margins (Left/Wrap/Right)
// tabs=#/#/#...

ls_remaining = trim(ps_formatting)

DO WHILE len(ls_remaining) > 0
	f_split_string(ls_remaining, ",", ls_next_command, ls_remaining)
	ls_remaining = trim(ls_remaining)
	
	CHOOSE CASE trim(lower(left(ls_next_command, 2)))
		CASE "fo"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			li_fontsize = integer(ls_temp2)
			if li_fontsize > 0 then
				set_font_size(li_fontsize)
			end if
		CASE "fn"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			object.font.name = ls_temp2
		CASE "fc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_color(long(ls_temp2))
		CASE "bc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_text_back_color(long(ls_temp2))
		CASE "bo"
			set_bold(true)
		CASE "it"
			set_italic(true)
		CASE "un"
			set_underline(true)
		CASE "xb"
			set_bold(false)
		CASE "xi"
			set_italic(false)
		CASE "xu"
			set_underline(false)
		CASE "le"
			set_justify(left!)
		CASE "ce"
			set_justify(center!)
		CASE "ri"
			set_justify(right!)
		CASE "ju"
			set_justify(justify!)
		CASE "ma"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			f_split_string(ls_temp2, "/", ls_temp1, ls_temp2)
			ll_left_margin = long(ls_temp1)
			f_split_string(ls_temp2, "/", ls_temp1, ls_temp2)
			ll_wrap_margin = long(ls_temp1)
			ll_right_margin = long(ls_temp2)
			// If we actually got 3 params then set the margins
			if len(ls_temp2) > 0 then
				set_margins(ll_left_margin, ll_wrap_margin, ll_right_margin)
			end if
		CASE "ta"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			li_count = f_parse_string(ls_temp2, "/", lsa_tabs)
			if li_count > 14 then li_count = 14
			// First clear the tab stops
			clear_tabs()
			
			for i = 1 to li_count
				f_split_string(lsa_tabs[i], " ", ls_tabstop, ls_tabtype)
				ll_tabstop = long(ls_tabstop)
				if trim(ls_tabtype) = "" then ls_tabtype = "left"
				set_tab(i, "left", ll_tabstop)
			next
	END CHOOSE
LOOP

read_formatting()


	
end subroutine

public subroutine set_fontstate (str_tx_fontstate pstr_fontstate);return

end subroutine

protected function str_tx_fontstate get_fontstate ();str_tx_fontstate lstr_fontstate
integer i


return lstr_fontstate

end function

public subroutine read_formatting ();return

end subroutine

public subroutine reset_formatting ();return

end subroutine

public subroutine add_rtf (string ps_rtf);
object.selrtf = ps_rtf


end subroutine

public subroutine goto_end_of_text ();object.SelStart = len(string(object.text))

end subroutine

public subroutine goto_end_of_line ();long ll_pos
long ll_len

ll_len = len(string(object.text))

ll_pos = object.find("~r~n", object.selstart, ll_len, 8)

if ll_pos > 1 then
	object.selstart = ll_pos
else
	object.selstart = ll_len
end if


end subroutine

public function integer print (string ps_jobname);return 0

end function

public function integer savedocument (string ps_file);string ls_drive
string ls_directory
string ls_file
string ls_extension
integer li_tx_format

f_parse_filepath(ps_file, ls_drive, ls_directory, ls_file, ls_extension)

li_tx_format = filetype_to_tx_format(ls_extension)

return savedocument(ps_file, li_tx_format)

end function

public function integer savedocument (string ps_file, integer pi_format);//pi_format values:
//
//0 - RTF    				RTF format (Rich Text Format).
//1 - ANSI text			Text in Windows ANSI format (an end of a paragraph is marked with the control characters 13 and 10).
// 

long ll_sts

object.save(ps_file, pi_format)

return 1

end function

public subroutine scroll_down ();return

end subroutine

public subroutine scroll_up ();return

end subroutine

public subroutine initialize ();string ls_rtf
long ll_screen_resolution_y
integer i

//	\paperwN Paper width in twips (the default is 12,240). 
//	\paperhN Paper height in twips (the default is 15,840). 
//	\marglN Left margin in twips (the default is 1800). 
//	\margrN Right margin in twips (the default is 1800). 
//	\margtN Top margin in twips (the default is 1440). 
//	\margbN Bottom margin in twips (the default is 1440). 
// 1 twip = 1/1440 inch


// Set the page height/width in twips
page_height_twips = 15840 // 11 inches
page_width_twips = 12240 // 8.5 inches

// Get the height of the control in twips
ll_screen_resolution_y = common_thread.mm.screen_resolution_y()
height_twips = (1440 * UnitsToPixels(height, YUnitsToPixels!)) / ll_screen_resolution_y

// Set the right margin, assuming a page width of 8.5 inches
//rightmargin = 8500 - ll_width

object.selfontsize = 9
//object.formatselection = true
object.locked = true // read-only
object.borderstyle = 0
//object.pageheight = page_height_twips
//object.pagewidth = 0
//object.autoexpand = true
object.selfontname = "Times New Roman"

if scrollbars then
	object.scrollbars = 2  // vertical scroll bar
else
	object.scrollbars = 0  // no scroll bar
end if

clear_tabs()

set_default_tabs()

read_formatting()

end subroutine

public subroutine set_tab (integer pi_tab_number, string ps_tab_type, long pl_tab_position);long ll_tab_twips
integer li_tabtype
long i
integer li_tabcount

// ps_tab_type is ignored because only left tabs are supported with this control

// The pl_tab_position is in 1000th of an inch
ll_tab_twips = (1440 * pl_tab_position) / 1000

li_tabcount = object.seltabcount

if li_tabcount < pi_tab_number then
	object.seltabcount = pi_tab_number
end if

object.seltabs[pi_tab_number - 1] = ll_tab_twips

end subroutine

public function integer load_document (string ps_file, integer pi_format);//pi_format values:
//
//0 - RTF    				RTF format (Rich Text Format).
//1 - ANSI text			Text in Windows ANSI format (an end of a paragraph is marked with the control characters 13 and 10).
// 

long ll_sts

object.loadfile(ps_file, pi_format)

return 1

end function

private function integer filetype_to_tx_format (string ps_filetype);
CHOOSE CASE lower(ps_filetype)
	CASE "rtf"
		return 0
	CASE ELSE
		return 1
END CHOOSE

end function

public function integer load_document (string ps_file);string ls_drive
string ls_directory
string ls_file
string ls_extension
integer li_tx_format

f_parse_filepath(ps_file, ls_drive, ls_directory, ls_file, ls_extension)

li_tx_format = filetype_to_tx_format(ls_extension)

return load_document(ps_file, li_tx_format)

end function

public subroutine refresh ();object.refresh()

end subroutine

public subroutine add_page_number ();return

end subroutine

public subroutine add_date ();string ls_text

ls_text = string(today())

add_text(ls_text)

end subroutine

public subroutine add_time ();string ls_text

ls_text = string(now())

add_text(ls_text)

end subroutine

public subroutine add_date_time ();add_date()
add_text(" ")
add_time()


end subroutine

public subroutine add_page_number (string ps_title);return

end subroutine

public function integer add_image (string ps_filename);long ll_width_inches
long ll_height_inches

setnull(ll_width_inches)
setnull(ll_height_inches)

return add_image(ps_filename, ll_width_inches, ll_height_inches)

end function

public subroutine convert_inches_to_pixels (long pl_inches_x, long pl_inches_y, ref long pl_pixels_x, ref long pl_pixels_y);long ll_screen_resolution_x
long ll_screen_resolution_y

ll_screen_resolution_x = common_thread.mm.screen_resolution_x()
ll_screen_resolution_y = common_thread.mm.screen_resolution_y()

// pl_inches_x and pl_inches_y are in thousandths of an inch.  Screen resolution is in pixels per inch.

pl_pixels_x = ll_screen_resolution_x * pl_inches_x / 1000
pl_pixels_y = ll_screen_resolution_y * pl_inches_y / 1000


end subroutine

public subroutine convert_pixels_to_inches (long pl_pixels_x, long pl_pixels_y, ref long pl_inches_x, ref long pl_inches_y);long ll_screen_resolution_x
long ll_screen_resolution_y

ll_screen_resolution_x = common_thread.mm.screen_resolution_x()
ll_screen_resolution_y = common_thread.mm.screen_resolution_y()

pl_inches_x = (1000 * pl_pixels_x) / ll_screen_resolution_x
pl_inches_y = (1000 * pl_pixels_y) / ll_screen_resolution_y


end subroutine

public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches);return 0

end function

public subroutine add_report_command (str_c_report_command pstr_command);return

end subroutine

public subroutine wrap_off ();use_wrap_margin = false
set_level(level)
set_default_tabs()

end subroutine

public subroutine wrap_on ();use_wrap_margin = true
set_level(level)

end subroutine

public function long add_field (string ps_display, string ps_data);return 0

end function

public subroutine clear_tabs ();object.seltabcount = 0
tabstop_count = 0

end subroutine

public subroutine delete_field (long pl_fieldid, boolean pb_delete_text);return

end subroutine

public subroutine update_field (long pl_fieldid, string ps_fielddata);return

end subroutine

public subroutine add_grid (str_grid pstr_grid);return

end subroutine

public subroutine blank_lines (integer pi_lines);long ll_currentline
boolean lb_found
integer i
long ll_linelength
long ll_last_nonempty_line
long li_blank_lines
integer li_table

if isnull(pi_lines) or pi_lines <= 0 then pi_lines = 0
if pi_lines > 50 then pi_lines = 50

long ll_pos1
long ll_pos2
long ll_len

li_blank_lines = 0
ll_len = len(string(object.text))
ll_pos1 = object.selstart

DO WHILE true
	ll_pos2 = ll_pos1
	ll_pos1 = object.find("~r~n", ll_pos1, 0, 8)
	if ll_pos1 <= 1 then EXIT
	if ll_pos1 = ll_pos2 - 2 then
		li_blank_lines += 1
	else
		EXIT
	end if
LOOP

if li_blank_lines > pi_lines then
	// If we have too many blank lines then remove some
	delete_range(object.selstart - (2 * (li_blank_lines - pi_lines)), object.selstart)
elseif li_blank_lines < pi_lines then
	// If we don't have enough blank lines then add some
	for i = 1 to (pi_lines - li_blank_lines)
		add_cr()
	next
end if


end subroutine

public subroutine unset_text_back_color ();return


end subroutine

public subroutine set_default_tabs ();integer i

for i = 1 to 14
	set_tab(i, "left", i * 720)
next

end subroutine

public function long charposition ();return long(object.selstart)


end function

public subroutine clear ();object.seltext = ""

end subroutine

public function long linelength ();long ll_pos1
long ll_pos2
long ll_len

ll_len = len(string(object.text))

ll_pos1 = object.find("~r~n", object.selstart, 1, 8)
if ll_pos1 <= 1 then
	ll_pos1 = 0
else
	ll_pos1 += 2
end if

ll_pos2 = object.find("~r~n", object.selstart, ll_len, 8)
if ll_pos2 <= 1 then ll_pos2 = ll_len

return ll_pos2 - ll_pos1

end function

public function long linelength (long pl_line);long ll_pos1
long ll_pos2
long ll_len
long i

ll_len = len(string(object.text))
ll_pos1 = 0

for i = 2 to pl_line
	ll_pos1 = object.find("~r~n", ll_pos1, ll_len, 8)
	if ll_pos1 <= 1 then return 0
	ll_pos1 += 2
next

ll_pos2 = object.find("~r~n", ll_pos1, ll_len, 8)
if ll_pos2 <= 1 then ll_pos2 = ll_len

return ll_pos2 - ll_pos1

end function

public function long selectedline ();long ll_line
long ll_pos

ll_pos = object.selstart

ll_line = object.getlinefromchar(ll_pos)
	
return ll_line + 1




end function

public subroutine selecttextall ();long ll_length

ll_length = len(string(object.text))

object.selstart = 0
object.sellength = ll_length



end subroutine

public subroutine selecttextline ();long ll_pos1
long ll_pos2
long ll_len

ll_len = len(string(object.text))

ll_pos1 = object.find("~r~n", object.selstart, 1, 8)
if ll_pos1 <= 1 then
	ll_pos1 = 0
else
	ll_pos1 += 2
end if

ll_pos2 = object.find("~r~n", object.selstart, ll_len, 8)
if ll_pos2 <= 1 then ll_pos2 = ll_len

object.selstart = ll_pos1
object.sellength = ll_pos2 - ll_pos1

end subroutine

on u_richtextedit_richtextctrl.create
end on

on u_richtextedit_richtextctrl.destroy
end on

