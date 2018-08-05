$PBExportHeader$u_richtextedit_tx.sru
forward
global type u_richtextedit_tx from u_ole_tx_textcontrol_v15
end type
end forward

global type u_richtextedit_tx from u_ole_tx_textcontrol_v15
event lbuttondown pbm_renlbuttondown
event field_clicked ( long pl_fieldid,  string ps_field_text,  string ps_field_data )
end type
global u_richtextedit_tx u_richtextedit_tx

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

long fontstate_count
long fontstateposition[]
str_tx_fontstate fontstate[]

boolean displayonly
boolean scrollbars = true


long height_twips
long page_height_twips

long page_width_twips

boolean use_wrap_margin = false

// TX constants
integer txFieldPageNumber = 3
integer txTableCellHorizontalPos = 0
integer txTableCellHorizontalExt = 1
integer txTableCellBorderWidth = 2

long txUseArabicNumerals = 196608


long last_backcolor

// Cache the format settings so we don't have to hit the control if we don't have to
str_tx_fontstate current_fontstate
//private integer tabstop_count
//private long tabstops[]
//private long tabtypes[]
//private boolean is_bold
//private boolean is_italic
//private boolean is_underline
//private integer current_fontsize
//private long current_forecolor
//private long current_textbkcolor
//private long current_indentl
//private long current_indentr
//private long current_indentfl
//private integer current_alignment
//private string current_fontname


// Marks a spot where blank_lines() should not go past
long remove_character_wall = 0

// Page number status
long current_page_field_start
boolean include_total_pages
string page_number_prefix = "Page: "
string total_pages_string = " of "

long ScrollPosY_Hold
time ScrollPosY_Time

long WM_USER = 1024
long TX_GETCHARRECT = 1194 // WM_USER + 170
long TX_GETLINERECT = 1149 // WM_USER + 125

integer view_mode_page_layout = 2
integer view_mode_normal_layout = 3

long current_text_box

private blob tx_state
private boolean fontstate_caching = true

u_file_action file_action

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
public subroutine reset_formatting ()
public subroutine add_rtf (string ps_rtf)
public subroutine goto_end_of_text ()
public subroutine goto_end_of_line ()
public function integer savedocument (string ps_file)
public function integer savedocument (string ps_file, integer pi_format)
public subroutine scroll_down ()
public subroutine scroll_up ()
public subroutine initialize ()
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
public subroutine clear ()
public function long linelength ()
public function long linelength (long pl_line)
public function long selectedline ()
public subroutine selecttextall ()
public subroutine selecttextline ()
public subroutine set_tabstop (integer pi_tab_number, string ps_tab_type, long pl_tab_position)
public subroutine add_text (string ps_text, boolean pb_highlight)
public subroutine set_indents (long pl_indentl, long pl_indentr, long pl_indentfl)
public subroutine set_alignment (integer pi_alignment)
public subroutine set_fontname (string ps_fontname)
public subroutine reset_fontstate ()
public function integer print (string ps_jobname, string ps_printer)
public function integer print (string ps_jobname)
public function integer set_device (string ps_device)
public function long add_field (string ps_display, str_service_info pstr_service)
protected function str_font_settings get_font_settings ()
public subroutine set_font_settings (str_font_settings pstr_font_settings)
public subroutine add_text (string ps_text, str_font_settings pstr_font_settings)
protected function str_font_settings get_empty_font_settings ()
public function long add_field (string ps_display, string ps_data, str_font_settings pstr_font_settings)
public function long add_field (string ps_display, string ps_data, boolean pb_highlight)
public subroutine set_page_width (long pl_page_width)
public subroutine set_page_height (long pl_page_height)
public function long get_scroll_position_y ()
public subroutine set_scroll_position_y (long pl_scroll_position)
private function long grid_column_chars (string ps_string)
public function integer set_background_image (string ps_filename)
public subroutine recalc_fields (boolean pb_for_export)
public subroutine recalc_fields ()
public function integer remove_page_number ()
public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos)
public subroutine set_view_mode (string ps_view_mode)
public function long add_text_box (long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos)
public function integer set_text_box (long pl_textframeid)
public function integer set_text_box_text (long pl_text_box_id, string ps_text)
public function integer replace_image (long pl_objectid, string ps_filename, long pl_width_inches, long pl_height_inches)
public subroutine set_redraw (boolean pb_redraw)
public function str_tx_fontstate get_fontstate ()
public function long add_text_box (long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, boolean pb_lines_visible, string ps_formatting, string ps_text)
public subroutine apply_formatting (string ps_formatting, boolean pb_fontstate_caching)
public function boolean page_mode ()
public function long read_formatting ()
public subroutine set_indents (long pl_indentl, long pl_indentr, long pl_indentfl, boolean pb_set_object)
public function str_charposition charposition ()
public subroutine delete_range (str_charrange pstr_charrange)
public subroutine delete_from_position (str_charposition pstr_position)
public function str_charposition character_at_position (long pl_posx, long pl_posy)
public subroutine select_text (str_charrange pstr_range)
public subroutine select_text (str_charposition pstr_position)
public function integer add_document (blob pbl_document, string ps_extension, str_attributes pstr_attributes)
end prototypes

public subroutine prev_level ();set_level(level - 1)

end subroutine

public function string rich_text ();string ls_rtf

selecttextall()

ls_rtf = object.rtfseltext

goto_end_of_text()

return ls_rtf

end function

public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin);if pl_wrap_margin > 0 and not use_wrap_margin then
	wrap_on()
end if

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

public subroutine clear_rtf ();integer li_viewmode

if len(tx_state) > 0 then
	li_viewmode = object.viewmode
	object.LoadFromMemory(tx_state)
	object.viewmode = li_viewmode
else
	object.resetcontents()
end if

clear_tabs()
set_margins(0, 0, 0)

object.scrollposy = 0
level = 0
left_margin = 0
right_margin = 0
wrap_margin = 0
fontstate_count = 0
use_wrap_margin = false
detail_position = 0
header_position = 0
footer_position = 0

remove_character_wall = 0


end subroutine

public subroutine next_level ();set_level(level + 1)

end subroutine

public subroutine set_underline (boolean pb_underline);integer li_fontunderline

if isnull(pb_underline) then return

if pb_underline then
	li_fontunderline = 1
else
	li_fontunderline = 0
end if

if fontstate_caching then
	if li_fontunderline <> current_fontstate.fontunderline then
		object.fontunderline = li_fontunderline
	end if
else
	object.fontunderline = li_fontunderline
end if

current_fontstate.fontunderline = li_fontunderline




end subroutine

public subroutine top ();goto_top()

end subroutine

public subroutine goto_top ();

object.selstart = 0
object.sellength = 0
object.scrollposy = 0

end subroutine

public subroutine copy_to_clipboard (boolean pb_all);long ll_selstart
long ll_sellength
string ls_text

ll_selstart = object.selstart
ll_sellength = object.sellength

if pb_all then selecttextall()

object.clip(2)

if pb_all then
	object.selstart = ll_selstart
	object.sellength = ll_sellength
end if

end subroutine

public function string get_text ();return object.text

end function

public subroutine add_page_break ();
add_text(char(12))


end subroutine

public subroutine add_tab ();add_text("~t")


end subroutine

public subroutine delete_this_line ();
long ll_line
long ll_pos1
long ll_pos2

ll_line = selectedline()
if ll_line < 0 then return

ll_pos1 = object.GetCharFromLine(ll_line)
if ll_pos1 < 0 then return

ll_pos2 = object.selstart

if ll_pos2 > ll_pos1 then
	delete_range(ll_pos1 + 1, ll_pos2)
end if


end subroutine

public subroutine set_bold (boolean pb_bold);integer li_fontbold

if isnull(pb_bold) then return

if pb_bold then
	li_fontbold = 1
else
	li_fontbold = 0
end if

if fontstate_caching then
	if li_fontbold <> current_fontstate.fontbold then
		object.fontbold = li_fontbold
	end if
else
	object.fontbold = li_fontbold
end if
//object.fontbold = li_fontbold

current_fontstate.fontbold = li_fontbold

end subroutine

public subroutine set_color (long pl_color);if isnull(pl_color) then return

if fontstate_caching then
	if current_fontstate.forecolor <> pl_color then
		object.forecolor = pl_color
	end if
else
	object.forecolor = pl_color
end if

current_fontstate.forecolor = pl_color

end subroutine

public subroutine set_font_size (integer pi_size);if isnull(pi_size) then return

if fontstate_caching then
	if current_fontstate.fontsize <> pi_size then
		object.fontsize = pi_size
	end if
else
	object.fontsize = pi_size
end if

current_fontstate.fontsize = pi_size

end subroutine

public subroutine set_italic (boolean pb_italic);integer li_fontitalic

if isnull(pb_italic) then return

if pb_italic then
	li_fontitalic = 1
else
	li_fontitalic = 0
end if

if fontstate_caching then
	if current_fontstate.fontitalic <> li_fontitalic then
		object.fontitalic = li_fontitalic
	end if
else
	object.fontitalic = li_fontitalic
end if

 current_fontstate.fontitalic = li_fontitalic
 
 
end subroutine

public subroutine set_justify (alignment pe_alignment);if isnull(pe_alignment) then return

CHOOSE CASE pe_alignment
	CASE Left!
		set_alignment(0)
	CASE Right!
		set_alignment(1)
	CASE Center!
		set_alignment(2)
	CASE Justify!
		set_alignment(3)
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

public subroutine delete_last_line ();
long ll_line
long ll_pos1
long ll_pos2

ll_line = selectedline()
if ll_line <= 0 then return

ll_pos1 = object.GetCharFromLine(ll_line - 1)
if ll_pos1 < 0 then return

ll_pos2 = object.GetCharFromLine(ll_line)
if ll_pos2 < 0 then return

delete_range(ll_pos1, ll_pos2)

end subroutine

public subroutine delete_range (long pl_startpos, long pl_endpos);long i
long j
long ll_selstart
long ll_sellength
integer li_table
long ll_del_length

ll_selstart = object.selstart
ll_sellength = object.sellength

ll_del_length = pl_endpos - pl_startpos
if ll_del_length <= 0 then return

// First make sure we don't delete past the wall
if pl_startpos <= remove_character_wall then pl_startpos = remove_character_wall

object.selstart = pl_startpos
object.sellength = ll_del_length
object.seltext = ""

// Remove any formatting structures in the range

for i = fontstate_count to 1 step -1
	if fontstateposition[i] > pl_endpos then
		fontstateposition[i] -= ll_del_length
	elseif fontstateposition[i] > pl_startpos then
		// remove the fontstate
		for j = i + 1 to fontstate_count
			fontstateposition[j - 1] = fontstateposition[j]
		next
		fontstate_count -= 1
	else
		exit
	end if
next

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

reset_formatting()


end subroutine

public subroutine add_text (string ps_text);// Don't do anything if we don't have any text
if isnull(ps_text) or len(ps_text) = 0 then return

// If there are no tabstops and the text contains a tabe then that will cause a problem 
if pos(ps_text, "~t") > 0 and current_fontstate.tabstop_count = 0 then
	apply_formatting("tabs=500/1000/1500/2000/2500/3000/3500/4000/4500/5000/5500/6000/6500/7000")
end if

object.seltext = ps_text

end subroutine

public function long add_cr ();
add_text("~r~n")

//set_indents(current_fontstate.indentl, current_fontstate.indentr, current_fontstate.indentfl, true)

return selectedline()

end function

public subroutine delete_cr ();long ll_pos

ll_pos = object.getcharfromline(selectedline())

delete_range(ll_pos - 1, ll_pos)


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
	set_indents(ll_wrap_twips, ll_right_twips, ll_indent - ll_wrap_twips + ll_left_twips)
else
	set_indents(ll_left_twips, ll_right_twips, ll_left_twips)
end if


read_formatting()

end subroutine

public subroutine set_detail ();if object.viewmode = view_mode_page_layout then
//	object.headerfooteractivate(0)
	object.headerfooterselect(16)
	
	// Reset the fontstate
	reset_fontstate()
end if

end subroutine

public subroutine set_footer ();if object.viewmode = view_mode_page_layout then
	if not f_check_bit(object.headerfooter, 3) then
		object.headerfooter = object.headerfooter + 4
	end if
	
	object.headerfooterselect(4)
	
	// Reset the fontstate
	reset_fontstate()
end if

end subroutine

public subroutine set_header ();if object.viewmode = view_mode_page_layout then
	if not f_check_bit(object.headerfooter, 1) then
		object.headerfooter = object.headerfooter + 1
	end if
	
	object.headerfooterselect(1)
	
	// Reset the fontstate
	reset_fontstate()
end if

end subroutine

public subroutine set_text_back_color (long pl_color);if isnull(pl_color) then return

if fontstate_caching then
	if current_fontstate.textbkcolor <> pl_color then
		last_backcolor = object.textbkcolor
		object.textbkcolor = pl_color
	end if
else
	last_backcolor = object.textbkcolor
	object.textbkcolor = pl_color
end if

current_fontstate.textbkcolor = pl_color

end subroutine

public subroutine set_backcolor (long pl_color);
object.backcolor = pl_color


end subroutine

public subroutine apply_formatting (string ps_formatting);apply_formatting(ps_formatting, true)

end subroutine

public subroutine set_fontstate (str_tx_fontstate pstr_fontstate);integer i
boolean lb_last_fontstate_caching

// Turn off caching to force all the fontstate changes
lb_last_fontstate_caching = fontstate_caching
fontstate_caching = false

set_font_size(pstr_fontstate.fontsize)
set_bold(f_integer_to_boolean(pstr_fontstate.fontbold))
set_underline(f_integer_to_boolean(pstr_fontstate.fontunderline))
set_italic(f_integer_to_boolean(pstr_fontstate.fontitalic))
set_color(pstr_fontstate.forecolor)

set_text_back_color(pstr_fontstate.textbkcolor)

set_alignment(pstr_fontstate.alignment)

current_fontstate.tabstop_count = pstr_fontstate.tabstop_count
current_fontstate.tabstops = pstr_fontstate.tabstops
current_fontstate.tabtypes = pstr_fontstate.tabtypes

//if use_wrap_margin and not pstr_fontstate.use_wrap_margin then
//	wrap_off()
//elseif not use_wrap_margin and pstr_fontstate.use_wrap_margin then
//	wrap_on()
//else
//	for i = current_fontstate.tabstop_count to 1 step -1
//		object.TabCurrent = i
//		object.tabpos = current_fontstate.tabstops[i]
//		object.tabtype = current_fontstate.tabtypes[i]
//	next
//end if

set_indents(pstr_fontstate.indentl, pstr_fontstate.indentr, pstr_fontstate.indentfl)

set_fontname(pstr_fontstate.fontname)

fontstate_caching = lb_last_fontstate_caching


end subroutine

public subroutine reset_formatting ();long ll_pos
long i
boolean lb_found

// See if there's a fontstate associated with this character position
ll_pos = object.selstart

lb_found = false
for i = fontstate_count to 1 step -1
	if fontstateposition[i] > ll_pos then
		fontstate_count -= 1
		continue
	end if
	if fontstateposition[i] = ll_pos then
		lb_found = true
		exit
	end if
	if fontstateposition[i] < ll_pos then
		exit
	end if
next

// If there is one, then reset the font to this state
if lb_found then
	set_fontstate(fontstate[i])
else
	set_fontstate(current_fontstate)
end if


end subroutine

public subroutine add_rtf (string ps_rtf);
object.rtfseltext = ps_rtf


end subroutine

public subroutine goto_end_of_text ();

object.sellength = 0
object.SelStart = -1

end subroutine

public subroutine goto_end_of_line ();
long ll_linelength
long ll_linestart

ll_linelength = linelength(selectedline())
ll_linestart = object.getcharfromline(selectedline())

object.selstart = ll_linestart + ll_linelength
object.sellength = 0

end subroutine

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
//1 - ANSI text			Text in Windows ANSI format (an end of a paragraph is marked with the control characters 13 and 10).
//2 - TX text    			Text in ANSI format (an end of a paragraph is marked only with the control character 10).
//3 - TX    				Text including formatting attributes in the internal Text Control format. Text is stored in ANSI.
//4 - HTML    				HTML format (Hypertext Markup Language).
//5 - RTF    				RTF format (Rich Text Format).
//6 - Unicode text   	Text in Windows Unicode format (an end of a paragraph is marked with the control characters 13 and 10).
//7 - TX text    			Text in Unicode format (an end of a paragraph is marked only with the control character 10).
//8 - TX    				Text including formatting attributes in the internal Text Control format. Text is stored in Unicode.
//9 - Microsoft Word 	Microsoft Word format.
//10 - XML    				XML format (Extensible Markup Language).
//11 - CSS    				CSS format (Cascading Style Sheet).
// 

long ll_sts

recalc_fields(true)

ll_sts = object.save(ps_file, -1, pi_format, false)
if ll_sts <= 0 then return -1

return 1

end function

public subroutine scroll_down ();long ll_scrollposy
long ll_maxy

ll_maxy = object.currentpages * page_height_twips

ll_scrollposy = object.scrollposy

ll_scrollposy += height_twips

// Make sure we don't keep scrolling down when we're already at the bottom
if ll_scrollposy > ll_maxy then ll_scrollposy = ll_maxy

object.scrollposy = ll_scrollposy


end subroutine

public subroutine scroll_up ();long ll_scrollposy

ll_scrollposy = object.scrollposy
if ll_scrollposy > height_twips then
	ll_scrollposy -= height_twips
else
	ll_scrollposy = 0
end if

object.scrollposy = ll_scrollposy


end subroutine

public subroutine initialize ();
string ls_rtf
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

object.fontsize = 9
object.formatselection = true
object.editmode = 1 // read-only with select-text capability
object.borderstyle = 0
object.pageheight = page_height_twips
object.pagewidth = page_width_twips
//object.autoexpand = true
object.fontname = default_rtf_font_name

//////////////////////////////////////////////////////////////
// Msc 12/8/07 commented out because it was causing the text frame insert to take forever
// object.device = 1 // Formatted for screen
//////////////////////////////////////////////////////////////



object.viewmode = view_mode_normal_layout

if scrollbars then
	object.scrollbars = 2  // vertical scroll bar
else
	object.scrollbars = 0  // no scroll bar
end if

current_page_field_start = 0
include_total_pages = false

read_formatting()

current_fontstate = get_fontstate()

// Save the state
tx_state = object.SaveToMemory()


end subroutine

public function integer load_document (string ps_file, integer pi_format);//pi_format values:
//
//1 - ANSI text			Text in Windows ANSI format (an end of a paragraph is marked with the control characters 13 and 10).
//2 - TX text    			Text in ANSI format (an end of a paragraph is marked only with the control character 10).
//3 - TX    				Text including formatting attributes in the internal Text Control format. Text is stored in ANSI.
//4 - HTML    				HTML format (Hypertext Markup Language).
//5 - RTF    				RTF format (Rich Text Format).
//6 - Unicode text   	Text in Windows Unicode format (an end of a paragraph is marked with the control characters 13 and 10).
//7 - TX text    			Text in Unicode format (an end of a paragraph is marked only with the control character 10).
//8 - TX    				Text including formatting attributes in the internal Text Control format. Text is stored in Unicode.
//9 - Microsoft Word 	Microsoft Word format.
//10 - XML    				XML format (Extensible Markup Language).
//11 - CSS    				CSS format (Cascading Style Sheet).
// 

long ll_sts
boolean lb_success

lb_success = object.resetcontents()

ll_sts = object.load(ps_file, 0, pi_format, false)
if ll_sts <= 0 then return -1

return 1

end function

private function integer filetype_to_tx_format (string ps_filetype);
CHOOSE CASE lower(ps_filetype)
	CASE "txt"
		return 1
	CASE "htm", "html"
		return 4
	CASE "rtf"
		return 5
	CASE "doc"
		return 9
	CASE "xml"
		return 10
	CASE "css"
		return 11
	CASE "pdf"
		return 12
	CASE ELSE
		return 5
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

public subroutine add_page_number ();page_number_prefix = ""
current_page_field_start = object.selstart
include_total_pages = false

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

public subroutine add_page_number (string ps_title);// This form of add_page_number adds a prefix to the page number and appends the total
// number of pages

current_page_field_start = object.selstart
page_number_prefix = ps_title
include_total_pages = true

// Add enough spaces to hold the page number
add_text(fill(" ", len(page_number_prefix) + len(total_pages_string) + 6))

// Add a blank to the end of text
object.selstart = -1
add_text(" ")

return

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

public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches);integer li_mode

setnull(li_mode)

return add_image(ps_filename, pl_width_inches, pl_height_inches, "Cursor", true, 0, 0)

//long ll_objectid
//long ll_picture_inches_x
//long ll_picture_inches_y
//long li_scale_x
//long li_scale_y
//
//f_get_picture_dimensions(ps_filename, ll_picture_inches_x, ll_picture_inches_y)
//if ll_picture_inches_x > 0 and ll_picture_inches_y > 0 then
//	li_scale_x = (100 * pl_width_inches) / ll_picture_inches_x
//	li_scale_y = (100 * pl_height_inches) / ll_picture_inches_y
//else
//	li_scale_x = 100
//	li_scale_y = 100
//end if
//
//if isnull(li_scale_x) or li_scale_x <= 0 then li_scale_x = 100
//if li_scale_x < 10 then li_scale_x = 10
//if li_scale_x > 250 then li_scale_x = 250
//
//if isnull(li_scale_y) or li_scale_y <= 0 then li_scale_y = 100
//if li_scale_y < 10 then li_scale_y = 10
//if li_scale_y > 250 then li_scale_y = 250
//
//// We don't want to distort the picture, so make both scales the same as the lowest scale
//if li_scale_x > li_scale_y then
//	li_scale_x = li_scale_y
//else
//	li_scale_y = li_scale_x
//end if
//
//ll_objectid = object.ObjectInsertAsChar(0, ps_filename, -1, li_scale_x, li_scale_y, 0, 1)
//
//if ll_objectid = 0 then
//	return 0
//else
//	return 1
//end if
//
end function

public subroutine add_report_command (str_c_report_command pstr_command);integer li_field
string ls_text

ls_text = pstr_command.context_object + " " + pstr_command.command
object.FieldInsert(ls_text)
li_field = object.FieldCurrent
object.FieldChangeable = false
object.FieldData[li_field] = pstr_command.argument


end subroutine

public subroutine wrap_off ();integer i
use_wrap_margin = false

for i = current_fontstate.tabstop_count to 1 step -1
	object.TabCurrent = i
	object.tabpos = current_fontstate.tabstops[i]
	object.tabtype = current_fontstate.tabtypes[i]
next

set_level(level)

// When the caller turns off the wrapping, set the wall here so no "remove" command
// back up the insertion point past this spot
reset_fontstate()
remove_character_wall = object.selstart


end subroutine

public subroutine wrap_on ();
use_wrap_margin = true

// Set a tab at the wrap margin
clear_tabs()
set_tabstop(1, "left", wrap_margin)

set_level(level)

end subroutine

public function long add_field (string ps_display, string ps_data);return add_field(ps_display, ps_data, true)

end function

public subroutine clear_tabs ();long i

if current_fontstate.tabstop_count > 0 then
	for i = current_fontstate.tabstop_count to 1 step -1
		object.tabcurrent = i
		object.tabpos = 0
	next
else
	for i = 14 to 1 step -1
		object.tabcurrent = i
		object.tabpos = 0
	next
end if

current_fontstate.tabstop_count = 0

end subroutine

public subroutine delete_field (long pl_fieldid, boolean pb_delete_text);
object.FieldCurrent = pl_fieldid

object.selstart = object.fieldstart
if pb_delete_text then
	object.sellength = 0
else
	object.sellength = object.fieldend - object.fieldstart
end if
object.fielddelete(pb_delete_text)

object.fontunderline = 0
object.forecolor = color_black


end subroutine

public subroutine update_field (long pl_fieldid, string ps_fielddata);object.FieldData[pl_fieldid] = ps_fielddata 

end subroutine

public subroutine add_grid (str_grid pstr_grid);integer li_table
integer i
integer j
long ll_viewable
long ll_cell_width[]
object.FormatSelection = True
long ll_total_chars
long ll_column_chars[]
string ls_column
long ll_screen_resolution_x
integer li_heading_count
integer li_column_title_count
long ll_min_twips_per_char = 160
long ll_table_columns
integer li_widest_cell
long ll_cell_growth
long ll_left_margin_twips
long ll_right_margin_twips
long ll_longest_line
str_font_settings lstr_original_font_settings
boolean lb_last_fontstate_caching
long ll_indentl
long ll_indentr
long ll_indentfl

// Turn off caching to force all the fontstate changes
lb_last_fontstate_caching = fontstate_caching
fontstate_caching = false

// Get the original font settings
lstr_original_font_settings = get_font_settings()

set_font_settings(lstr_original_font_settings)

// Save the margins
ll_indentl = current_fontstate.indentl
ll_indentr = current_fontstate.indentr
ll_indentfl = current_fontstate.indentfl

// Wrap margin must be zero for grids
set_margins(left_margin,0,right_margin)

// Make sure nothing is selected
object.sellength = 0

if pstr_grid.table_attributes.suppress_headings then
	li_heading_count = 0
else
	li_heading_count = 1
end if

if pstr_grid.table_attributes.suppress_title_column then
	li_column_title_count = 0
else
	li_column_title_count = 1
end if

// Add a table one column and one row larger than the grid provided
last_table += 1
ll_left_margin_twips = (1440 * left_margin) / 1000
ll_right_margin_twips = (1440 * right_margin) / 1000
set_indents(0, 0, 0)
li_table = object.TableInsert(pstr_grid.row_count + li_heading_count, pstr_grid.column_count + li_column_title_count, -1, last_table)
if li_table <= 0 then return

object.TableCellAttribute[li_table, 0, 1, txTableCellHorizontalPos] = ll_left_margin_twips

add_cr()

if li_heading_count > 0 then
	if li_column_title_count > 0 then
		// Set the heading for the first column
		ls_column = trim(pstr_grid.row_title)
		if isnull(ls_column) then ls_column = ""
		object.TableCellText[li_table, 1, 1] = ls_column
		
		ll_column_chars[1] = grid_column_chars(ls_column)
	end if
	
	// Set the other column headings
	for j = 1 to pstr_grid.column_count
		ls_column = trim(pstr_grid.column_title[j])
		if isnull(ls_column) then ls_column = ""
		
		// Add column heading using bold if necessary
		object.selstart = object.TableCellStart[li_table, 1, j + li_column_title_count] - 1
		if pstr_grid.table_attributes.bold_headings then
			set_bold(true)
		end if
		add_text(ls_column)
		if pstr_grid.table_attributes.bold_headings then
			set_bold(lstr_original_font_settings.bold)
		end if
		
		ll_column_chars[j + li_column_title_count] = grid_column_chars(ls_column)
	next
else
	// We don't have headings so initialize the column counts to zero
	for i = 1 to pstr_grid.column_count + li_column_title_count
		ll_column_chars[i] = 0
	next	
end if

// Then loop through the rows
For i = 1 To pstr_grid.row_count
	if li_column_title_count > 0 then
		ls_column = trim(pstr_grid.grid_row[i].row_title)
		if isnull(ls_column) then ls_column = ""
		object.TableCellText[li_table, i + li_heading_count, 1] = ls_column
		if len(ls_column) > ll_column_chars[1] then
			ll_column_chars[1] = grid_column_chars(ls_column)
		end if
	end if
	
	// Then loop through the columns and set the column text
	for j = 1 to pstr_grid.column_count
		ls_column = trim(pstr_grid.grid_row[i].column[j].column_text)
		if len(ls_column) > 0 then
			object.selstart = object.TableCellStart[li_table, i + li_heading_count, j + li_column_title_count] - 1
			if pstr_grid.grid_row[i].column[j].use_font_settings then
				set_font_settings(pstr_grid.grid_row[i].column[j].font_settings)
			end if
			if len(pstr_grid.grid_row[i].column[j].field_data) > 0 then
				// set the insertion point in the desired cell
				add_field(ls_column, pstr_grid.grid_row[i].column[j].field_data)
			else
				add_text(ls_column)
			end if
			if pstr_grid.grid_row[i].column[j].use_font_settings then
				set_font_settings(lstr_original_font_settings)
			end if
		end if
		ll_longest_line = f_longest_line(ls_column)
		if ll_longest_line > ll_column_chars[j + li_column_title_count] then
			ll_column_chars[j + li_column_title_count] = ll_longest_line
		end if
	next	
Next

// Calculate the viewable width in twips
if pstr_grid.table_attributes.table_width > 0 then
	// If the table width is supplied then convert it from thousandths of an inch to twips
	ll_viewable = (1440 * pstr_grid.table_attributes.table_width) / 1000
else
	// If the table width was not supplied then calculate it based on the screen width or page width
	if object.viewmode = view_mode_normal_layout  then
		ll_screen_resolution_x = common_thread.mm.screen_resolution_x()
		ll_viewable = (1440 * UnitsToPixels(width, XUnitsToPixels!)) / ll_screen_resolution_x
		// Leave room for the scroll bar
		ll_viewable -= 400
		// Leave room for the margins
		ll_viewable -= ll_left_margin_twips
		ll_viewable -= ll_right_margin_twips
	else
		ll_viewable = page_width_twips - object.PageMarginL - object.PageMarginR
		// Leave room for the margins
		ll_viewable -= ll_left_margin_twips
		ll_viewable -= ll_right_margin_twips
	end if
end if

ll_table_columns = pstr_grid.column_count + li_column_title_count

// Give column 1 an automatic bump because if there's a close competition between which column wraps we prefer column 1 to not wrap
ll_column_chars[1] += 1

// Count the total chars
ll_total_chars = 0
for j = 1 to ll_table_columns
	ll_total_chars += ll_column_chars[j]
next

// Calculate the width of each column in twips
for j = 1 to ll_table_columns
	if ll_total_chars > 0 then
		ll_cell_width[j] = long(real(ll_viewable) * (real(ll_column_chars[j]) / real(ll_total_chars)))
	else
		ll_cell_width[j] = ll_viewable / ll_table_columns
	end if
next	

// Find the widest cell
li_widest_cell = 1
for i = 2 to ll_table_columns
	if ll_cell_width[i] > ll_cell_width[li_widest_cell] then li_widest_cell = i
next	

// Scan for columns too narrow and grow them
for j = 1 to ll_table_columns
	if (ll_min_twips_per_char * ll_column_chars[j]) > ll_cell_width[j] &
	 and ll_cell_width[j] < (ll_viewable / ll_table_columns) then
		if (ll_min_twips_per_char * ll_column_chars[j]) < (ll_viewable / ll_table_columns) then
			// If the min width is less than the average width, then grow to the min width
			ll_cell_growth = (ll_min_twips_per_char * ll_column_chars[j]) - ll_cell_width[j]
		else
			// If the min width is greater than the average width, then grow to the average width
			ll_cell_growth =  (ll_viewable / ll_table_columns) - ll_cell_width[j]
		end if
		// Grow cell and reduce the widest cell
		ll_cell_width[j] += ll_cell_growth
		ll_cell_width[li_widest_cell] -= ll_cell_growth
		// Now find the widest cell again
		li_widest_cell = 1
		for i = 2 to ll_table_columns
			if ll_cell_width[i] > ll_cell_width[li_widest_cell] then li_widest_cell = i
		next	
	end if
	
//	if ll_column_chars[j] > (ll_total_chars - ll_column_chars[j]) / 2 then
//		ll_total_chars -= ll_column_chars[j]
//		ll_column_chars[j] = 2 * ll_total_chars / 3
//		ll_total_chars += ll_column_chars[j]
//	end if
next	

// Set the width of each column
for j = 1 to ll_table_columns
	object.TableCellAttribute[li_table, 0, j, txTableCellHorizontalExt] = ll_cell_width[j]
next	

// Set the grid line width
if pstr_grid.table_attributes.suppress_lines then
	object.TableCellAttribute[li_table, 0, 0, txTableCellBorderWidth] = 0
else
	object.TableCellAttribute[li_table, 0, 0, txTableCellBorderWidth] = 1
end if

goto_end_of_text()

add_cr()

remove_character_wall = object.selstart

set_font_settings(lstr_original_font_settings)

// Restore margins
set_indents(ll_indentl, ll_indentr, ll_indentfl)
fontstate_caching = lb_last_fontstate_caching

reset_fontstate()

return

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

ll_currentline = selectedline()

// First find the previous blank line
lb_found = false
for i = ll_currentline to 0 step -1
	ll_linelength = linelength(i)
	if ll_linelength > 0 then
		ll_last_nonempty_line = i
		lb_found = true
		exit
	end if
next

if not lb_found then
	// all the lines are blank
	li_blank_lines = ll_currentline
else
	li_blank_lines = ll_currentline - ll_last_nonempty_line - 1
end if

if li_blank_lines > pi_lines then
	// If we have too many blank lines then remove some
	for i = 1 to (li_blank_lines - pi_lines)
		delete_this_line()
		delete_cr()
	next
	// Now reset the margins cuz they might have been trashed
//	reset_fontstate()
	set_indents(current_fontstate.indentl, current_fontstate.indentr, current_fontstate.indentfl)
elseif li_blank_lines < pi_lines then
	// If we don't have enough blank lines then add some
	for i = 1 to (pi_lines - li_blank_lines)
		add_cr()
	next
end if

li_table = object.tableatinputpos
if li_table > 0 then
	object.selstart = -1
	add_cr()
end if


end subroutine

public subroutine unset_text_back_color ();set_text_back_color(last_backcolor)

end subroutine

public subroutine clear ();object.seltext = ""
remove_character_wall = 0

end subroutine

public function long linelength ();return linelength(selectedline())

end function

public function long linelength (long pl_line);long ll_pos1
long ll_pos2
long ll_maxline

ll_maxline = object.getlinecount() - 1

if pl_line < ll_maxline then
	ll_pos1 = object.getcharfromline(pl_line)
	ll_pos2 = object.getcharfromline(pl_line + 1)
	// assume crlf
	return ll_pos2 - ll_pos1 - 2
elseif pl_line = ll_maxline then
	ll_pos1 = object.getcharfromline(pl_line)
	ll_pos2 = len(string(object.text))
	return ll_pos2 - ll_pos1
else
	return 0
end if

end function

public function long selectedline ();long ll_line
long ll_pos

if object.sellength <= 0 then
	ll_line = object.getlinecount() - 1
else
	ll_pos = object.selstart
	
	ll_line = object.getlinefromchar(ll_pos)
	
	// If the line doesn't exist then assume the last line is selected
	if ll_line < 0 then ll_line = object.getlinecount() - 1
end if

return ll_line



end function

public subroutine selecttextall ();long ll_length

// Set to a value larger than any document
ll_length = 1000000000

object.selstart = 0
object.sellength = ll_length



end subroutine

public subroutine selecttextline ();long ll_linelength
long ll_linestart

ll_linelength = linelength(selectedline())
ll_linestart = object.getcharfromline(selectedline())

object.selstart = ll_linestart
object.sellength = ll_linelength

end subroutine

public subroutine set_tabstop (integer pi_tab_number, string ps_tab_type, long pl_tab_position);long ll_tab_twips
integer li_tabtype
long i


// The pl_tab_position is in 1000th of an inch
ll_tab_twips = (1440 * pl_tab_position) / 1000

CHOOSE CASE lower(ps_tab_type)
	CASE "left"
		li_tabtype = 1
	CASE "right"
		li_tabtype = 2
	CASE "centered"
		li_tabtype = 3
	CASE "decimal"
		li_tabtype = 4
	CASE "rightmargin"
		li_tabtype = 5
	CASE ELSE
		li_tabtype = 1
END CHOOSE

object.tabcurrent = pi_tab_number
object.tabpos = ll_tab_twips
if ll_tab_twips > 0 then
	object.tabtype = li_tabtype
end if

current_fontstate.tabstops[pi_tab_number] = ll_tab_twips
current_fontstate.tabtypes[pi_tab_number] = li_tabtype


end subroutine

public subroutine add_text (string ps_text, boolean pb_highlight);str_font_settings lstr_font_settings

// Don't do anything if we don't have any text
if isnull(ps_text) or len(ps_text) = 0 then return

if pb_highlight then
	lstr_font_settings = abnormal_result_font_settings
	add_text(ps_text, lstr_font_settings)
else
	object.seltext = ps_text
end if


end subroutine

public subroutine set_indents (long pl_indentl, long pl_indentr, long pl_indentfl);long ll_pos
long i
boolean lb_found
boolean lb_changed

if fontstate_caching then
	if pl_indentl <> current_fontstate.indentl then
		lb_changed = true
	end if
	
	if pl_indentr <> current_fontstate.indentr then
		lb_changed = true
	end if
	
	if pl_indentfl <> current_fontstate.indentfl then
		lb_changed = true
	end if
else
	lb_changed = true
end if

set_indents(pl_indentl, pl_indentr, pl_indentfl, lb_changed)

return

end subroutine

public subroutine set_alignment (integer pi_alignment);if isnull(pi_alignment) then return

if fontstate_caching then
	if pi_alignment <> current_fontstate.alignment then
		object.alignment = pi_alignment
	end if
else
	object.alignment = pi_alignment
end if

current_fontstate.alignment = pi_alignment

end subroutine

public subroutine set_fontname (string ps_fontname);if isnull(ps_fontname) then return

if fontstate_caching then
	if ps_fontname <> current_fontstate.fontname then
		object.fontname = ps_fontname
	end if
else
	object.fontname = ps_fontname
end if

current_fontstate.fontname = ps_fontname

end subroutine

public subroutine reset_fontstate ();long ll_indent
long ll_max_indent
long ll_left_twips
long ll_wrap_twips
long ll_right_twips
long ll_left_margin_twips

object.fontsize = current_fontstate.fontsize

object.fontbold = current_fontstate.fontbold
object.fontunderline = current_fontstate.fontunderline
object.fontitalic = current_fontstate.fontitalic


object.forecolor = current_fontstate.forecolor
object.alignment = current_fontstate.alignment
object.fontname = current_fontstate.fontname


object.indentr = current_fontstate.indentr
object.indentfl = current_fontstate.indentfl
object.indentl = current_fontstate.indentl

use_wrap_margin = current_fontstate.use_wrap_margin

wrap_margin = (current_fontstate.indentl * 1000) / 1440
right_margin = (current_fontstate.indentr * 1000) / 1440

ll_max_indent = (2 * wrap_margin) / 3

ll_indent = level * level_indent

if level <= 0 then
	level = 0
	ll_indent = 0
elseif ll_indent > ll_max_indent and wrap_margin > (3 * level_indent) then
	ll_indent = ll_max_indent
end if

if use_wrap_margin then
	ll_left_margin_twips = current_fontstate.indentfl + current_fontstate.indentl
	left_margin = ((ll_left_margin_twips * 1000) / 1440) - ll_indent 
else
	left_margin = wrap_margin
end if

read_formatting()

end subroutine

public function integer print (string ps_jobname, string ps_printer);str_printer lstr_printer
string ls_printer
long ll_page_count
integer li_viewmode

lstr_printer = common_thread.get_printer(ps_printer)

// We need to substitute commas for the tab characters in the windows printer string
ls_printer = f_string_substitute(lstr_printer.printerstring, "~t", ", ")

// We need to set the viewmode to view_mode_page_layout in order for the header/footer to print
li_viewmode = object.viewmode
if li_viewmode <> view_mode_page_layout then
//	object.pagewidth = page_width_twips
	object.viewmode = view_mode_page_layout
end if

set_device(ls_printer)
recalc_fields(false)
object.printdoc(ps_jobname, 1, object.currentpages, 1)

// Set the device back to "screen" and reset the view mode to what it was
set_device("1")
if li_viewmode <> view_mode_page_layout then
	object.viewmode = li_viewmode
//	object.pagewidth = 0
end if

object.refresh()

//integer	li_pages
//long 		ll_hDC
//docinfo	dinfo
//long		ll_Cnt
//long ll_job
//long ll_sts
//constant long ll_WM_USER = 1024
//constant long ll_TX_GETPRINTERDC = ll_WM_USER + 185
//constant long ll_TX_RELEASEPRINTERDC = ll_WM_USER + 186
//
//li_pages = object.CurrentPages
//ll_hDC = Send(object.hWnd, ll_TX_GETPRINTERDC, 0, 0)
//
///* start print job */
//
//dinfo.cbSize = 20
//dinfo.lpszDocName = ps_jobname
//dinfo.l1 = 0
//dinfo.l2 = 0
//dinfo.l3 = 0
//ll_job = StartDoc(ll_hDC, dinfo);
//if ll_job <= 0 then
//	Send(object.hWnd, ll_TX_RELEASEPRINTERDC, ll_hDC, 0)
//	return -1
//end if
//
///* print all pages */
//
//for ll_Cnt = 1 to li_pages
//	StartPage(ll_hDC)
//	object.PrintDevice = ll_hDC
//	object.PrintPage(ll_Cnt)
//	EndPage(ll_hDC)
//next
//
//ll_sts = EndDoc(ll_hDC)
//
//Send(object.hWnd, ll_TX_RELEASEPRINTERDC, ll_hDC, 0)
//
return 1

end function

public function integer print (string ps_jobname);
return print(ps_jobname, common_thread.current_printer())

end function

public function integer set_device (string ps_device);// Whenever the device changes it screws up the current_page marked-text-field.
// Let's go find it and delete it

integer li_sts
long ll_selstart


// First delete the current-page field if it exists
ll_selstart = object.selstart
set_footer()
//li_sts = remove_page_number()
set_detail()
object.selstart = ll_selstart
object.refresh()

// Then change the device
if len(ps_device) > 0 AND ps_device <> "1" then
	object.device = ps_device
else
	object.device = 1
end if

return 1

end function

public function long add_field (string ps_display, str_service_info pstr_service);string ls_field_data

ls_field_data = f_service_to_field_data(pstr_service)

return add_field(ps_display, ls_field_data)


end function

protected function str_font_settings get_font_settings ();str_font_settings lstr_font_settings
integer i

// Get the font_settings from the cached values
lstr_font_settings = f_empty_font_settings()

lstr_font_settings.fontsize = current_fontstate.fontsize
lstr_font_settings.bold = f_number_to_boolean_with_null(current_fontstate.fontbold)
lstr_font_settings.underline = f_number_to_boolean_with_null(current_fontstate.fontunderline)
lstr_font_settings.italic = f_number_to_boolean_with_null(current_fontstate.fontitalic)
lstr_font_settings.forecolor = current_fontstate.forecolor
lstr_font_settings.textbackcolor = current_fontstate.textbkcolor
CHOOSE CASE current_fontstate.alignment
	CASE 0
		lstr_font_settings.alignment = Left!
	CASE 1
		lstr_font_settings.alignment = Right!
	CASE 2
		lstr_font_settings.alignment = Center!
	CASE 3
		lstr_font_settings.alignment = Justify!
END CHOOSE
lstr_font_settings.fontname = current_fontstate.fontname

return lstr_font_settings

end function

public subroutine set_font_settings (str_font_settings pstr_font_settings);set_font_size(pstr_font_settings.fontsize)
set_bold(pstr_font_settings.bold)
set_underline(pstr_font_settings.underline)
set_italic(pstr_font_settings.italic)
set_color(pstr_font_settings.forecolor)

set_text_back_color(pstr_font_settings.textbackcolor)

set_justify(pstr_font_settings.alignment)

set_fontname(pstr_font_settings.fontname)

end subroutine

public subroutine add_text (string ps_text, str_font_settings pstr_font_settings);str_font_settings lstr_font_settings

// Don't do anything if we don't have any text
if isnull(ps_text) or len(ps_text) = 0 then return

// Record the current font_settings
lstr_font_settings = get_font_settings()

// Set the desired font_settings for this text
set_font_settings(pstr_font_settings)

// Add the text
object.seltext = ps_text

// Restore the original font_settings
set_font_settings(lstr_font_settings)

return


end subroutine

protected function str_font_settings get_empty_font_settings ();str_font_settings lstr_font_settings

setnull(lstr_font_settings.fontsize)
setnull(lstr_font_settings.bold)
setnull(lstr_font_settings.underline)
setnull(lstr_font_settings.italic)
setnull(lstr_font_settings.forecolor)
setnull(lstr_font_settings.textbackcolor)
setnull(lstr_font_settings.alignment)
setnull(lstr_font_settings.fontname)

return lstr_font_settings

end function

public function long add_field (string ps_display, string ps_data, str_font_settings pstr_font_settings);integer li_field
long ll_color
long ll_underline
string ls_seltext
str_font_settings lstr_font_settings

if isnull(ps_display) or isnull(ps_data) then return 0

// Record the current font settings
lstr_font_settings = get_font_settings()

// record the current selected text
ls_seltext = object.seltext

set_font_settings(pstr_font_settings)

object.FieldInsert(ps_display)
li_field = object.FieldCurrent
object.FieldData[li_field] = ps_data 

if len(ls_seltext) = 0 then
	// Reset the previous font settings
	set_font_settings(lstr_font_settings)
end if

return li_field

end function

public function long add_field (string ps_display, string ps_data, boolean pb_highlight);// Default font settings for a field is blue text with underline
str_font_settings lstr_font_settings

lstr_font_settings = get_empty_font_settings()

if pb_highlight then
	// Default field highlight is underlined and blue
	lstr_font_settings.underline = true
	lstr_font_settings.forecolor = color_dark_blue
end if

return add_field(ps_display, ps_data, lstr_font_settings)

end function

public subroutine set_page_width (long pl_page_width);
page_width_twips = (1440 * pl_page_width) / 1000

object.pagewidth = page_width_twips

end subroutine

public subroutine set_page_height (long pl_page_height);
page_height_twips = (1440 * pl_page_height) / 1000

object.pageheight = page_height_twips

end subroutine

public function long get_scroll_position_y ();long ll_scrollpos


ll_scrollpos = object.scrollposy

// Convert to 1000th of inch
ll_scrollpos = ll_scrollpos * 1000 / 1440

return ll_scrollpos




end function

public subroutine set_scroll_position_y (long pl_scroll_position);long ll_scrollpos

// Convert from 1000th of inch to twips
ll_scrollpos = ll_scrollpos * 1440 / 1000

scrollposy_hold = ll_scrollpos
scrollposy_time = relativetime(now(), 1)

object.scrollposy = ll_scrollpos


end subroutine

private function long grid_column_chars (string ps_string);long ll_length
long ll_pos

ll_length = len(ps_string)

// Capital "W" counts as two characters
ll_pos = 0
DO
	ll_pos = pos(ps_string, "W", ll_pos + 1)
	if ll_pos <= 0 then exit
	
	ll_length += 1
LOOP WHILE true

// everything is at least 2
if isnull(ll_length) or ll_length < 2 then
	ll_length = 2
end if

return ll_length


end function

public function integer set_background_image (string ps_filename);long ll_objectid
long ll_picture_inches_x
long ll_picture_inches_y
long li_scale_x
long li_scale_y
long ll_width_inches
long ll_height_inches
long ll_page
long ll_text_flow
long ll_imagedisplaymode

ll_width_inches = (1000 * page_width_twips) / 1440
ll_height_inches = (1000 * page_height_twips) / 1440

f_get_picture_dimensions(ps_filename, ll_picture_inches_x, ll_picture_inches_y)
if ll_picture_inches_x > 0 and ll_picture_inches_y > 0 then
	li_scale_x = (100 * ll_width_inches) / ll_picture_inches_x
	li_scale_y = (100 * ll_height_inches) / ll_picture_inches_y
else
	li_scale_x = 100
	li_scale_y = 100
end if

if isnull(li_scale_x) or li_scale_x <= 0 then li_scale_x = 100
if li_scale_x < 10 then li_scale_x = 10
if li_scale_x > 250 then li_scale_x = 250

if isnull(li_scale_y) or li_scale_y <= 0 then li_scale_y = 100
if li_scale_y < 10 then li_scale_y = 10
if li_scale_y > 250 then li_scale_y = 250

// We don't want to distort the picture, so make both scales the same as the lowest scale
if li_scale_x > li_scale_y then
	li_scale_x = li_scale_y
else
	li_scale_y = li_scale_x
end if

if object.viewmode = 1 or object.viewmode = 2 then
	ll_page = 1
else
	ll_page = 0
end if

ll_text_flow = 2

ll_objectid = object.ImageInsertFixed(ps_filename, ll_page, 0, 0, li_scale_x, li_scale_y, ll_text_flow, 0, 0, 0, 0)

//ll_objectid = object.ObjectInsertAsChar(0, ps_filename, 0, li_scale_x, li_scale_y, 2, 0)

if ll_objectid = 0 then
	return 0
else
	ll_imagedisplaymode = object.ImageDisplayMode
//	object.ObjectCurrent = ll_objectid
//	object.ImageDisplayMode = 2
	return 1
end if

end function

public subroutine recalc_fields (boolean pb_for_export);long ll_page_count
integer li_field
boolean lb_success
long ll_selstart
long ll_fieldend
string ls_page_count
string ls_total_pages
integer li_sts

// Set the page count in the footer
if current_page_field_start > 0 then
	ll_selstart = object.selstart
	
	set_footer()
	
	if current_page_field_start > 0 then
		li_sts = remove_page_number()

		//	Then replace the spaces with the prefix
		object.SelStart = current_page_field_start
		object.SelLength = len(page_number_prefix)
		object.SelText = page_number_prefix

		// Then add the marked text field
		object.SelStart = current_page_field_start + len(page_number_prefix)
		object.SelLength = 0
		lb_success = object.FieldInsert("")
		if not lb_success then return
		li_field = object.FieldCurrent
		object.FieldType[li_field] = txFieldPageNumber
	
		if include_total_pages and not pb_for_export then
			// If the recalc is for an export, then just print blank spaces for the total pages.
			// We do this when we because the application importing it probably won't format
			// it the same so the count will likely be wrong.
		
			// Get the page count as a string padded with spaces
			ll_page_count = object.currentpages
			ls_page_count = left(string(ll_page_count) + "     ", 5)
			ls_total_pages = total_pages_string + ls_page_count
			
			object.SelStart = object.FieldEnd
			object.SelLength = len(ls_total_pages)
			object.SelText = ls_total_pages
			
		end if
	
		set_detail()
		
		object.selstart = ll_selstart
		object.SelLength = 0
	end if
end if

// Finally, refresh the control again
object.refresh()

end subroutine

public subroutine recalc_fields ();recalc_fields(false)

end subroutine

public function integer remove_page_number ();integer li_field
boolean lb_success
long ll_linelength

if current_page_field_start <= 0 then return 0

// First delete the marked text field if there is one
li_field = object.FieldNext(0, 2048) // get only txFieldPageNumber fields
if li_field > 0 then
	object.FieldCurrent = li_field
	lb_success = object.FieldDelete(true)
	if not lb_success then return -1
end if

//	Then replace the prefix with spaces
object.SelStart = current_page_field_start
object.SelLength = len(page_number_prefix)
object.SelText = fill(" ", len(page_number_prefix))

// Finally, if we were printing the total pages, replace it with spaces
if include_total_pages then
	object.SelStart = current_page_field_start + len(page_number_prefix)
	object.SelLength = len(total_pages_string) + 5
	object.SelText = fill(" ", len(total_pages_string) + 5)
end if

return 1

end function

public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos);// ps_placement:	"Fixed" = Place the image at the X and Y coordinates specified
//						"Cursor" = Place the image at the cursor

long ll_objectid
long ll_picture_inches_x
long ll_picture_inches_y
long li_scale_x
long li_scale_y
long ll_x_twips
long ll_y_twips
long ll_text_flow
long ll_page
long ll_picture_pixels_x
long ll_picture_pixels_y
long ll_picture_hresolution
long ll_picture_vresolution
long ll_screen_resolution_x
long ll_screen_resolution_y
string ls_drive
string ls_directory
string ls_file
string ls_extension

if pb_text_flow_around then
	ll_text_flow = 3
else
	ll_text_flow = 2
end if

ll_screen_resolution_x = common_thread.mm.screen_resolution_x()
ll_screen_resolution_y = common_thread.mm.screen_resolution_y()

f_get_picture_info(ps_filename, ll_picture_pixels_x, ll_picture_pixels_y, ll_picture_hresolution, ll_picture_vresolution)
ll_picture_inches_x = (1000 * ll_picture_pixels_x) / ll_screen_resolution_x
ll_picture_inches_y = (1000 * ll_picture_pixels_y) / ll_screen_resolution_y

if ll_picture_inches_x > 0 and ll_picture_inches_y > 0 then
	li_scale_x = (100 * pl_width_inches) / ll_picture_inches_x
	li_scale_y = (100 * pl_height_inches) / ll_picture_inches_y
else
	li_scale_x = 100
	li_scale_y = 100
end if

if isnull(li_scale_x) or li_scale_x <= 0 then li_scale_x = 100
if li_scale_x < 10 then li_scale_x = 10
if li_scale_x > 250 then li_scale_x = 250

if isnull(li_scale_y) or li_scale_y <= 0 then li_scale_y = 100
if li_scale_y < 10 then li_scale_y = 10
if li_scale_y > 250 then li_scale_y = 250

// We don't want to distort the picture, so make both scales the same as the lowest scale
if li_scale_x > li_scale_y then
	li_scale_x = li_scale_y
else
	li_scale_y = li_scale_x
end if

// If this is an EMF file and we have a picture resolution, then multiply the scale by the quotient of the picture resolution and the screen reolution
// This is to compensate for a problem with the TX Text control processing EMF files
if lower(right(ps_filename, 3)) = "emf" and ll_picture_hresolution > 0 and ll_picture_vresolution > 0 then
	li_scale_x = li_scale_x * (double(ll_picture_hresolution) / double(ll_screen_resolution_x))
	li_scale_y = li_scale_y * (double(ll_picture_vresolution) / double(ll_screen_resolution_y))
end if

// Convert the x and y position into twips
if isnull(pl_xpos) then
	ll_x_twips = 0
else
	ll_x_twips = (pl_xpos * 1440) / 1000
end if

if isnull(pl_ypos) then
	ll_y_twips = 0
else
	ll_y_twips = (pl_ypos * 1440) / 1000
end if

if object.viewmode = 1 or object.viewmode = 2 then
	ll_page = 1
else
	ll_page = 0
end if

//// for some reason using 100 as a scale factor sometimes results in a slightly distorted image, so if the scale is 100 then pass in nulls instead.
//if li_scale_x = 100 then
//	setnull(li_scale_x)
//	setnull(li_scale_y)
//end if

TRY
	CHOOSE CASE lower(ps_placement)
		CASE "fixed"
			ll_objectid = object.ImageInsertFixed(ps_filename, ll_page, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
	//		ll_objectid = object.ObjectInsertFixed(3, ps_filename, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, 0, 0, ll_text_flow, 100, 100, 100, 100)
		CASE "paragraph"
			ll_objectid = object.ImageInsert(ps_filename, -1, 0, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
	//		ll_objectid = object.ObjectInsert(3, ps_filename, -1, 0, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
		CASE ELSE
			ll_objectid = object.ImageInsertAsChar(ps_filename, -1, li_scale_x, li_scale_y)
			//ll_objectid = object.ObjectInsertAsChar(0, ps_filename, -1, li_scale_x, li_scale_y, 0, 1)
	END CHOOSE
CATCH (oleruntimeerror lt_error)
	log.log(this, "u_richtextedit_tx.add_image:0105", "Error Inserting Image (" + ps_filename + ")~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
END TRY

if ll_objectid = 0 then
	return 0
else
	return ll_objectid
end if

end function

public subroutine set_view_mode (string ps_view_mode);CHOOSE CASE lower(ps_view_mode)
	CASE "page"
		object.viewmode = view_mode_page_layout
	CASE "normal"
		object.viewmode = view_mode_normal_layout
END CHOOSE

end subroutine

public function long add_text_box (long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos);// ps_placement:	"Fixed" = Place the image at the X and Y coordinates specified
//						"Cursor" = Place the image at the cursor

long ll_textframeid
long ll_xpos_twips
long ll_ypos_twips
long ll_width_twips
long ll_height_twips
long ll_text_flow
long ll_page

if pb_text_flow_around then
	ll_text_flow = 3
else
	ll_text_flow = 2
end if

// Convert the x and y position into twips
if isnull(pl_xpos) then
	ll_xpos_twips = 0
else
	ll_xpos_twips = (pl_xpos * 1440) / 1000
end if

if isnull(pl_ypos) then
	ll_ypos_twips = 0
else
	ll_ypos_twips = (pl_ypos * 1440) / 1000
end if

// Convert the width and height into twips
if isnull(pl_width_inches) then
	ll_width_twips = 0
else
	ll_width_twips = (pl_width_inches * 1440) / 1000
end if

if isnull(pl_height_inches) then
	ll_height_twips = 0
else
	ll_height_twips = (pl_height_inches * 1440) / 1000
end if

// Don't allow text box unless widht and height are both positive
if ll_width_twips <= 0 or ll_height_twips <= 0 then return 0

if object.viewmode = 1 or object.viewmode = 2 then
	ll_page = 1
else
	ll_page = 0
end if

CHOOSE CASE lower(ps_placement)
	CASE "fixed"
		ll_textframeid = object.TextFrameInsertFixed(ll_page, ll_xpos_twips, ll_ypos_twips, ll_width_twips, ll_height_twips, ll_text_flow, 100, 100, 100, 100)
	CASE "paragraph"
		ll_textframeid = object.TextFrameInsert(-1, 0, ll_xpos_twips, ll_ypos_twips, ll_width_twips, ll_height_twips, ll_text_flow, 100, 100, 100, 100)
	CASE ELSE
		ll_textframeid = object.TextFrameInsertAsChar(-1, ll_xpos_twips, ll_ypos_twips)
END CHOOSE

if ll_textframeid = 0 then
	return 0
else
	return ll_textframeid
end if

end function

public function integer set_text_box (long pl_textframeid);boolean lb_success

// Set the frame to "main control" if the frame id isn't valid
if isnull(pl_textframeid) or pl_textframeid <= 0 then pl_textframeid = 0

lb_success = object.TextFrameSelect(pl_textframeid)

if lb_success then
	return 1
else
	return -1
end if

end function

public function integer set_text_box_text (long pl_text_box_id, string ps_text);integer li_sts

li_sts = set_text_box(pl_text_box_id)
if li_sts <= 0 then return -1

object.seltext = ps_text

li_sts = set_text_box(0)
if li_sts <= 0 then return -1


return 1


end function

public function integer replace_image (long pl_objectid, string ps_filename, long pl_width_inches, long pl_height_inches);long ll_picture_inches_x
long ll_picture_inches_y
long li_scale_x
long li_scale_y
long ll_x_twips
long ll_y_twips
long ll_text_flow

if isnull(pl_objectid) or pl_objectid <= 0 then
	return 0
end if


f_get_picture_dimensions(ps_filename, ll_picture_inches_x, ll_picture_inches_y)
if ll_picture_inches_x > 0 and ll_picture_inches_y > 0 then
	li_scale_x = (100 * pl_width_inches) / ll_picture_inches_x
	li_scale_y = (100 * pl_height_inches) / ll_picture_inches_y
else
	li_scale_x = 100
	li_scale_y = 100
end if

if isnull(li_scale_x) or li_scale_x <= 0 then li_scale_x = 100
if li_scale_x < 10 then li_scale_x = 10
if li_scale_x > 250 then li_scale_x = 250

if isnull(li_scale_y) or li_scale_y <= 0 then li_scale_y = 100
if li_scale_y < 10 then li_scale_y = 10
if li_scale_y > 250 then li_scale_y = 250

// We don't want to distort the picture, so make both scales the same as the lowest scale
if li_scale_x > li_scale_y then
	li_scale_x = li_scale_y
else
	li_scale_y = li_scale_x
end if

object.objectcurrent = pl_objectid
object.ObjectScaleX = li_scale_x
object.ObjectScaleY = li_scale_y
object.imagefilename = ps_filename

return 1

end function

public subroutine set_redraw (boolean pb_redraw);boolean lb_lock

lb_lock = NOT pb_redraw

object.lockwindowupdate(lb_lock)

end subroutine

public function str_tx_fontstate get_fontstate ();str_tx_fontstate lstr_fontstate
integer i

lstr_fontstate.fontsize = object.fontsize
lstr_fontstate.fontbold = object.fontbold
lstr_fontstate.fontunderline = object.fontunderline
lstr_fontstate.fontitalic = object.fontitalic
lstr_fontstate.forecolor = object.forecolor
lstr_fontstate.textbkcolor = object.textbkcolor
lstr_fontstate.alignment = object.alignment
lstr_fontstate.indentl = object.indentl
lstr_fontstate.indentr = object.indentr
lstr_fontstate.indentfl = object.indentfl
lstr_fontstate.fontname = object.fontname
lstr_fontstate.tabstop_count = current_fontstate.tabstop_count
lstr_fontstate.tabstops = current_fontstate.tabstops
lstr_fontstate.tabtypes = current_fontstate.tabtypes
lstr_fontstate.use_wrap_margin = use_wrap_margin

return lstr_fontstate

end function

public function long add_text_box (long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, boolean pb_lines_visible, string ps_formatting, string ps_text);// ps_placement:	"Fixed" = Place the image at the X and Y coordinates specified
//						"Cursor" = Place the image at the cursor

//long ll_textframeid
long ll_xpos_twips
long ll_ypos_twips
long ll_width_twips
long ll_height_twips
long ll_text_flow
long ll_page
boolean lb_success
integer li_textframeid
integer li_objectcurrent

if pb_text_flow_around then
	ll_text_flow = 3
else
	ll_text_flow = 2
end if

// Convert the x and y position into twips
if isnull(pl_xpos) then
	ll_xpos_twips = 0
else
	ll_xpos_twips = (pl_xpos * 1440) / 1000
end if

if isnull(pl_ypos) then
	ll_ypos_twips = 0
else
	ll_ypos_twips = (pl_ypos * 1440) / 1000
end if

// Convert the width and height into twips
if isnull(pl_width_inches) then
	ll_width_twips = 0
else
	ll_width_twips = (pl_width_inches * 1440) / 1000
end if

if isnull(pl_height_inches) then
	ll_height_twips = 0
else
	ll_height_twips = (pl_height_inches * 1440) / 1000
end if

// Don't allow text box unless widht and height are both positive
if ll_width_twips <= 0 or ll_height_twips <= 0 then return 0

if object.viewmode = 1 or object.viewmode = 2 then
	ll_page = 1
else
	ll_page = 0
end if

object.headerfooterselect(16)
//object.headerfooteractivate(0)

//CHOOSE CASE lower(ps_placement)
//	CASE "fixed"
//		li_textframeid = object.TextFrameInsertFixed(ll_page, ll_xpos_twips, ll_ypos_twips, ll_width_twips, ll_height_twips, ll_text_flow, 100, 100, 100, 100)
//	CASE "paragraph"
//		li_textframeid = object.TextFrameInsert(-1, 0, ll_xpos_twips, ll_ypos_twips, ll_width_twips, ll_height_twips, ll_text_flow, 100, 100, 100, 100)
//	CASE ELSE
//		li_textframeid = object.TextFrameInsertAsChar(-1, ll_xpos_twips, ll_ypos_twips)
//END CHOOSE

li_textframeid = object.TextFrameInsertFixed(ll_page, ll_xpos_twips, ll_ypos_twips, ll_width_twips, ll_height_twips, ll_text_flow, 0, 0, 0, 0)
if li_textframeid = 0 then return 0

if not pb_lines_visible then
	object.TextFrameBorderWidth = 0
	object.TextFrameMarkerLines = false
end if

lb_success = object.TextFrameSelect(li_textframeid)

if len(ps_formatting) > 0 then
	apply_formatting(ps_formatting, false)
end if

if len(ps_text) > 0 then
	object.seltext = ps_text
end if

lb_success = object.TextFrameSelect(0)


return li_textframeid


end function

public subroutine apply_formatting (string ps_formatting, boolean pb_fontstate_caching);string ls_next_command
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
long ll_pagewidth
long ll_pageheight
string lsa_args[]
integer li_arg_count
long ll_margin_thousandths
long ll_margin_twips
boolean lb_prev_fontstate_caching

// Formatting is specified by comma delimited commands:
// fontsize=#			Set the font size
// fn=<fontname>		Set the font
// bold					Set bold on
// italic				Set italics on
// underline			Set underline on
// xbold					Set bold off
// xitalic				Set italics off
// xunderline			Set underline off
// jl						Left Justify
//	jc						Center Justify
//	jr						Right Justify
//	jj						Left and Right Justify
//	fc=#					Foreground Color
//	bc=#					Text Background Color
// margins=#/#/#		Set Margins (Left/Wrap/Right)
// tabs=#/#/#...
// pw=#					Page Width (thousandths of an inch)
// ph=#					Page Height (thousandths of an inch)
// pm=#/#/#/#			Set Page Margins (Left/Right/Top/Bottom)

lb_prev_fontstate_caching = fontstate_caching
fontstate_caching = pb_fontstate_caching

ls_remaining = trim(ps_formatting)

DO WHILE len(ls_remaining) > 0
	f_split_string(ls_remaining, ",", ls_next_command, ls_remaining)
	ls_remaining = trim(ls_remaining)
	
	CHOOSE CASE trim(lower(left(ls_next_command, 2)))
		CASE "pm"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			li_arg_count = f_parse_string(ls_temp2, "/", lsa_args)
			if li_arg_count >= 1 then
				if isnumber(lsa_args[1]) and len(lsa_args[1]) > 0 then
					ll_margin_thousandths = long(lsa_args[1])
					ll_margin_twips = (ll_margin_thousandths * 1440) / 1000
					object.PageMarginL = ll_margin_twips
				end if
			end if
			if li_arg_count >= 2 then
				if isnumber(lsa_args[2]) and len(lsa_args[2]) > 0 then
					ll_margin_thousandths = long(lsa_args[2])
					ll_margin_twips = (ll_margin_thousandths * 1440) / 1000
					object.PageMarginR = ll_margin_twips
				end if
			end if
			if li_arg_count >= 3 then
				if isnumber(lsa_args[3]) and len(lsa_args[3]) > 0 then
					ll_margin_thousandths = long(lsa_args[3])
					ll_margin_twips = (ll_margin_thousandths * 1440) / 1000
					object.PageMarginT = ll_margin_twips
				end if
			end if
			if li_arg_count >= 4 then
				if isnumber(lsa_args[4]) and len(lsa_args[4]) > 0 then
					ll_margin_thousandths = long(lsa_args[4])
					ll_margin_twips = (ll_margin_thousandths * 1440) / 1000
					object.PageMarginB = ll_margin_twips
				end if
			end if
		CASE "pw"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			ll_pagewidth = long(ls_temp2)
			if ll_pagewidth > 0 then
				set_page_width(ll_pagewidth)
			end if
		CASE "ph"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			ll_pageheight = long(ls_temp2)
			if ll_pageheight > 0 then
				set_page_height(ll_pageheight)
			end if
		CASE "fo"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			li_fontsize = integer(ls_temp2)
			if li_fontsize > 0 then
				set_font_size(li_fontsize)
			end if
		CASE "fn"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_fontname(ls_temp2)
		CASE "fc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_color(f_string_to_color(ls_temp2))
		CASE "bc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_text_back_color(f_string_to_color(ls_temp2))
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
			
			// If we've never set any tabs yet, then clear the default tab stops
			if current_fontstate.tabstop_count = 0 then
				clear_tabs()
			else
				// Otherwise clear any excess tabs
				for i = current_fontstate.tabstop_count to li_count + 1 step -1
					object.tabcurrent = i
					object.tabpos = 0
				next
			end if
			
			// Finally, set the desired tab stops
			current_fontstate.tabstop_count = li_count
			for i = 1 to current_fontstate.tabstop_count
				f_split_string(lsa_tabs[i], " ", ls_tabstop, ls_tabtype)
				ll_tabstop = long(ls_tabstop)
				if trim(ls_tabtype) = "" then ls_tabtype = "left"
				set_tabstop(i, "left", ll_tabstop)
			next
	END CHOOSE
LOOP

read_formatting()

if lb_prev_fontstate_caching and not fontstate_caching then
	current_fontstate = get_fontstate()
end if

fontstate_caching = lb_prev_fontstate_caching


end subroutine

public function boolean page_mode ();
if object.viewmode = 1 or object.viewmode = 2 then return true

return false

end function

public function long read_formatting ();long ll_pos
long i
boolean lb_found

ll_pos = object.selstart

lb_found = false
for i = fontstate_count to 1 step -1
	if fontstateposition[i] = ll_pos then
		lb_found = true
		exit
	end if
	if fontstateposition[i] < ll_pos then
		exit
	end if
next

if not lb_found then
	fontstate_count += 1
	i = fontstate_count
	fontstateposition[i] = ll_pos
end if

fontstate[i] = get_fontstate()

return i

end function

public subroutine set_indents (long pl_indentl, long pl_indentr, long pl_indentfl, boolean pb_set_object);long ll_pos
long i
boolean lb_found
long ll_indentfl
long ll_indentl
long ll_indentr

if pb_set_object then
	object.indentfl = pl_indentfl
	object.indentl = pl_indentl
	object.indentfl = pl_indentfl
	object.indentr = pl_indentr
end if

ll_indentfl = object.indentfl
ll_indentl = object.indentl
ll_indentr = object.indentr


current_fontstate.indentl = pl_indentl
current_fontstate.indentr = pl_indentr
current_fontstate.indentfl = pl_indentfl

// now see if this cursor position is saved in the fontstate stack.  If so then update the stack with the current fontstate.
ll_pos = object.selstart

lb_found = false
for i = fontstate_count to 1 step -1
	if fontstateposition[i] = ll_pos then
		lb_found = true
		exit
	end if
	if fontstateposition[i] < ll_pos then
		exit
	end if
next

if lb_found then
	fontstate[i] = current_fontstate
end if


return

end subroutine

public function str_charposition charposition ();str_charposition lstr_charposition

lstr_charposition.line_number = 0
lstr_charposition.char_position = object.selstart

return lstr_charposition



end function

public subroutine delete_range (str_charrange pstr_charrange);long ll_startpos
long ll_endpos

ll_startpos = pstr_charrange.from_position.char_position
ll_endpos = pstr_charrange.to_position.char_position

delete_range(ll_startpos, ll_endpos)

return

end subroutine

public subroutine delete_from_position (str_charposition pstr_position);delete_range(f_charrange(pstr_position, charposition()))

end subroutine

public function str_charposition character_at_position (long pl_posx, long pl_posy);long ll_x
long ll_y
str_charposition lstr_charposition

// What's passed in is thousandths of an inch, but the inputposfrompoint method wants pixels
ll_x = (pl_posx * 1440) / 1000
ll_y = (pl_posy * 1440) / 1000

lstr_charposition.line_number = 0
lstr_charposition.char_position = object.inputposfrompoint(ll_x, ll_y)

return lstr_charposition


end function

public subroutine select_text (str_charrange pstr_range);
object.seltext = pstr_range.from_position.char_position
object.sellength = pstr_range.to_position.char_position - pstr_range.from_position.char_position


return

end subroutine

public subroutine select_text (str_charposition pstr_position);select_text(f_charrange(pstr_position, pstr_position))

end subroutine

public function integer add_document (blob pbl_document, string ps_extension, str_attributes pstr_attributes);string ls_document_file
string ls_rtf
string ls_temp
integer li_sts
string ls_text
string ls_crlf
long ll_pos
long ll_menu_id
integer li_object_id
string ls_rendered_file_type
blob lbl_rendered_file
long ll_desired_width_pixels
long ll_desired_height_pixels

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the display attributes
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
long ll_bitmap_width_inches
long ll_bitmap_height_inches
string ls_placement
boolean lb_text_flow_around
long ll_xpos
long ll_ypos


ll_bitmap_width_inches = long(f_attribute_find_attribute(pstr_attributes, "width"))
ll_bitmap_height_inches = long(f_attribute_find_attribute(pstr_attributes, "height"))
ls_placement = f_attribute_find_attribute(pstr_attributes, "placement")
ls_temp = f_attribute_find_attribute(pstr_attributes, "text_flow_around")
if isnull(ls_temp) then ls_temp = "True"
lb_text_flow_around = f_string_to_boolean(ls_temp)
ll_xpos = long(f_attribute_find_attribute(pstr_attributes, "xposition"))
ll_ypos = long(f_attribute_find_attribute(pstr_attributes, "yposition"))


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Add the document to the rtf control
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CHOOSE CASE lower(ps_extension)
	CASE "rtf", "wri"
		ls_rtf = f_blob_to_string(pbl_document)
		add_rtf(ls_rtf)
		reset_fontstate()
	CASE "txt"
		ls_text = f_blob_to_string(pbl_document)
		// See if there is a crlf
		ls_crlf = "~r~n"
		ll_pos = pos(ls_text, ls_crlf)
		if ll_pos > 0 then
			object.loadfrommemory(pbl_document, 6, true)
		else
			object.loadfrommemory(pbl_document, 7, true)
		end if
	CASE "htm","html"
		object.loadfrommemory(pbl_document, 4, true)
	CASE "css"
		object.loadfrommemory(pbl_document, 11, true)
	CASE "doc"
		object.loadfrommemory(pbl_document, 9, true)
	CASE "docx"
		object.loadfrommemory(pbl_document, 13, true)
	CASE "xml"
		object.loadfrommemory(pbl_document, 10, true)
	CASE "pdf"
		return 0
	CASE "bmp", "png", "wmf", "emf", "tif", "tiff", "jpg", "gif"
		ls_document_file = f_temp_file(ps_extension)
		li_sts = log.file_write(pbl_document, ls_document_file)
		if li_sts > 0 and fileexists(ls_document_file) then
			// Add the bitmap to the rtf control
			li_object_id = add_image(ls_document_file, ll_bitmap_width_inches, ll_bitmap_height_inches, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
			if li_object_id > 0 then
				ll_menu_id = long(f_attribute_find_attribute(pstr_attributes, "menu_id"))
//				add_object_menu(li_object_id, ll_menu_id)
				li_sts = 1
			end if
		else
//			log_error("Error writing image temp file")
		end if
	CASE ELSE
		// If the extension is not recognized then see if we can render it into an image file
		convert_inches_to_pixels(ll_bitmap_width_inches, ll_bitmap_height_inches, ll_desired_width_pixels, ll_desired_height_pixels)
//		li_sts = file_action.render_file(pstr_document, &
//												"png", &
//												ll_desired_width_pixels, &
//												ll_desired_height_pixels, &
//												ls_rendered_file_type, &
//												lbl_rendered_file)
		if li_sts <= 0 then
//			log_error("Error rendering document into image")
			log.log(this, "u_richtextedit_tx.add_document:0092", "Error rendering document into image", 4)
			return -1
		end if
		
		// Save the rendered image
		string ls_temp_file
		ls_temp_file = f_temp_file(ls_rendered_file_type)
		li_sts = log.file_write(lbl_rendered_file, ls_temp_file)
		if li_sts <= 0 then
//			log_error("Error saving rendered document")
			log.log(this, "u_richtextedit_tx.add_document:0102", "Error saving rendered document", 4)
			return -1
		end if
		
		// Add the bitmap to the rtf control
		li_object_id = add_image(ls_temp_file, ll_bitmap_width_inches, ll_bitmap_height_inches, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
		if li_object_id > 0 then
			ll_menu_id = long(f_attribute_find_attribute(pstr_attributes, "menu_id"))
//			add_object_menu(li_object_id, ll_menu_id)
			li_sts = 1
		end if
END CHOOSE



return li_sts


end function

on u_richtextedit_tx.create
call super::create
end on

on u_richtextedit_tx.destroy
call super::destroy
end on

event fieldclicked;call super::fieldclicked;string ls_text
string ls_data
any la_fielddata

la_fielddata = object.fielddata[fieldid]
if lower(classname(la_fielddata)) = "string" then
	ls_text = object.fieldtext
	ls_data = string(la_fielddata)

	object.selstart = object.fieldstart - 1
	object.sellength = object.fieldend - object.fieldstart + 1
	
	object.textbkcolor = color_blue

	this.event POST field_clicked(fieldid, ls_text, ls_data)
end if

end event

