$PBExportHeader$u_richtextedit.sru
forward
global type u_richtextedit from u_richtextedit_base
end type
type str_rtf_input_field from structure within u_richtextedit
end type
end forward

type str_rtf_input_field from structure
	string		field_name
	string		field_data
end type

global type u_richtextedit from u_richtextedit_base
integer width = 901
integer height = 540
integer textsize = -10
string facename = "Arial"
boolean init_wordwrap = true
long init_inputfieldbackcolor = 15780518
boolean init_headerfooter = true
event lbuttondown pbm_renlbuttondown
event field_clicked ( long pl_fieldid,  string ps_field_text,  string ps_field_data )
end type
global u_richtextedit u_richtextedit

type variables
long level_indent = 200
integer level = 0

long left_margin
long right_margin
long wrap_margin

long	detail_fromline=1,detail_fromchar=1,detail_toline=0,detail_tochar=0
long	header_fromline=1,header_fromchar=1,header_toline=0,header_tochar=0
long	footer_fromline=1,footer_fromchar=1,footer_toline=0,footer_tochar=0

private str_rtf_input_field input_fields[]
private long input_field_count

private boolean font_settings_caching = false
private long last_backcolor
private long field_backcolor
private str_font_settings current_font_settings

end variables

forward prototypes
public subroutine prev_level ()
public subroutine delete_last_line ()
public subroutine delete_this_line ()
public subroutine set_bold (boolean pb_bold)
public function string rich_text ()
public subroutine set_footer ()
public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin)
public subroutine set_margins (long pl_wrap_margin, long pl_right_margin)
public subroutine set_italic (boolean pb_italic)
public subroutine set_margins ()
public subroutine add_tab ()
public subroutine add_text (string ps_text)
public subroutine set_detail ()
public subroutine set_header ()
public subroutine set_position ()
public subroutine delete_last_chars (integer pi_count)
public subroutine set_page_width (long pl_width)
public subroutine clear_rtf ()
public subroutine next_level ()
public subroutine set_level (integer pi_level)
public subroutine set_underline (boolean pb_underline)
public subroutine set_justify (alignment pe_alignment)
public subroutine set_insertion_point_end ()
public subroutine add_page_break ()
public subroutine top ()
public subroutine goto_end_of_line ()
public subroutine goto_end_of_text ()
public subroutine goto_top ()
public subroutine delete_range (long pl_startline, long pl_startchar, long pl_endline, long pl_endchar)
public function string get_text ()
public subroutine initialize_margins ()
public function str_charposition charposition ()
public subroutine delete_range (str_charrange pstr_charrange)
public subroutine select_text (str_charrange pstr_charrange)
public subroutine delete_from_position (str_charposition pstr_position)
public function str_charposition character_at_position (long pl_posx, long pl_posy)
public subroutine select_text (str_charposition pstr_position)
public subroutine add_text (string ps_text, str_font_settings pstr_font_settings)
public subroutine add_text (string ps_text, boolean pb_highlight)
public subroutine set_font_settings (str_font_settings pstr_font_settings)
public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos)
public function integer add_image (string ps_filename, long pl_width_inches, long pl_height_inches)
public function integer add_image (string ps_filename)
public subroutine set_redraw (boolean pb_redraw)
public subroutine blank_lines (integer pi_lines)
public function long add_field (string ps_display, string ps_data, str_font_settings pstr_font_settings)
public function long add_field (string ps_display, string ps_data, boolean pb_highlight)
protected function str_font_settings get_empty_font_settings ()
public function long add_field (string ps_display, string ps_data)
public function long add_field (string ps_display, str_service_info pstr_service)
public function integer set_background_image (string ps_filename)
public function long get_scroll_position_y ()
public subroutine add_grid (str_grid pstr_grid)
public subroutine unset_text_back_color ()
public subroutine convert_inches_to_pixels (long pl_inches_x, long pl_inches_y, ref long pl_pixels_x, ref long pl_pixels_y)
public subroutine convert_pixels_to_inches (long pl_pixels_x, long pl_pixels_y, ref long pl_inches_x, ref long pl_inches_y)
public subroutine reset_fontstate ()
public function boolean page_mode ()
public subroutine add_date_time ()
public subroutine add_time ()
public subroutine add_date ()
public subroutine add_page_number (string ps_title)
public subroutine add_page_number ()
public subroutine add_rtf (string ps_rtf)
public function integer add_document (blob pbl_document, string ps_extension, str_attributes pstr_attributes)
public subroutine initialize ()
public function integer replace_image (long pl_objectid, string ps_filename, long pl_width_inches, long pl_height_inches)
public subroutine set_edit_mode (string ps_edit_mode)
public subroutine set_undoable (boolean pb_undoable)
public function string get_selected_text ()
public subroutine wrap_off ()
public subroutine wrap_on ()
public function str_font_settings get_font_settings ()
public subroutine update_field (long pl_fieldid, string ps_fielddata)
public subroutine delete_field (long pl_fieldid, boolean pb_delete_text)
public function integer load_document (string ps_file, filetype pe_filetype)
public function integer load_document (string ps_file)
private function filetype filetype_from_extension (string ps_extension)
public subroutine scroll_down ()
public subroutine scroll_up ()
public subroutine set_background_color (long pl_color)
public subroutine set_page_height (long pl_height)
public subroutine recalc_fields ()
public subroutine recalc_fields (boolean pb_for_export)
public subroutine set_view_mode (string ps_view_mode)
public subroutine copy_to_clipboard (boolean pb_all)
public function str_font_settings get_font_settings (boolean pb_use_caching)
public subroutine set_font_settings (str_font_settings pstr_font_settings, boolean pb_use_caching)
public subroutine apply_formatting (string ps_formatting, boolean pb_use_caching)
public subroutine set_fontname (string ps_fontname)
public subroutine set_strikeout (boolean pb_strikeout)
public subroutine set_subscript (boolean pb_subscript)
public subroutine set_superscript (boolean pb_superscript)
public subroutine set_font_size (integer pi_fontsize)
public subroutine set_color (long pl_forecolor)
public subroutine set_text_back_color (long pl_textbackcolor)
public subroutine apply_formatting (string ps_formatting)
public subroutine delete_line (long pl_line)
public subroutine set_position (str_charposition pstr_charposition)
public subroutine delete_cr ()
public subroutine add_cr ()
private subroutine add_chunk_old (string ps_text)
public function integer of_setfontsize (integer ai_points)
end prototypes

public subroutine prev_level ();set_level(level - 1)

end subroutine

public subroutine delete_last_line ();delete_line(selectedline() - 1)

end subroutine

public subroutine delete_this_line ();delete_line(selectedline())

end subroutine

public subroutine set_bold (boolean pb_bold);if font_settings_caching then
	if pb_bold = current_font_settings.bold then return
	
	SetTextStyle ( pb_bold,  current_font_settings.underline,  current_font_settings.subscript,  current_font_settings.superscript,  current_font_settings.italic,  current_font_settings.strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( pb_bold, lb_underline, lb_subscript, lb_superscript, lb_italic, lb_strikeout )

return

end subroutine

public function string rich_text ();return copyrtf(false)

end function

public subroutine set_footer ();set_position()
SelectText(footer_fromline, footer_fromchar, footer_toline, footer_tochar, Footer!)

end subroutine

public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin);
left_margin = pl_left_margin
wrap_margin = pl_wrap_margin
right_margin = pl_right_margin

setparagraphsetting(Indent!, left_margin)

//setparagraphsetting(leftmargin!, wrap_margin)
//setparagraphsetting(rightmargin!, right_margin)

//set_level(level)

end subroutine

public subroutine set_margins (long pl_wrap_margin, long pl_right_margin);set_margins(0, pl_wrap_margin, pl_right_margin)

end subroutine

public subroutine set_italic (boolean pb_italic);if font_settings_caching then
	if pb_italic = current_font_settings.italic then return
	
	SetTextStyle ( current_font_settings.bold,  current_font_settings.underline,  current_font_settings.subscript,  current_font_settings.superscript,  pb_italic,  current_font_settings.strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( lb_bold, lb_underline, lb_subscript, lb_superscript, pb_italic, lb_strikeout )

return


end subroutine

public subroutine set_margins ();
if left_margin <> 0 or right_margin <> 0 or wrap_margin <> 0 then
	set_margins(left_margin, wrap_margin, right_margin)
end if

end subroutine

public subroutine add_tab ();replacetext("~t")

end subroutine

public subroutine add_text (string ps_text);string ls_cr
string ls_nl
string ls_chunk
long ll_pos
long ll_pos2
boolean lb_found_cr
string ls_whats_left

if isnull(ps_text) then return

replacetext(ps_text)
return
//lb_found_cr = false
//ls_cr = "~r"
//ls_nl = "~n"
//ls_whats_left = ps_text
//
//DO
//	// Trim off any leading CRs or NLs
//	DO
//		if (asc(ls_whats_left) = asc(ls_cr)) or (asc(ls_whats_left) = asc(ls_nl)) then
//			ls_whats_left = mid(ls_whats_left, 2)
//		end if
//	LOOP WHILE (asc(ls_whats_left) = asc(ls_cr)) or (asc(ls_whats_left) = asc(ls_nl))
//	
//	// Find the first CR or NL
//	ll_pos = pos(ls_whats_left, ls_cr)
//	ll_pos2 = pos(ls_whats_left, ls_nl)
//	if ll_pos2 < ll_pos and ll_pos2 > 0 then ll_pos = ll_pos2
//	
//	if ll_pos = 1 then
//		ls_whats_left = mid(ls_whats_left, 2)
//	elseif ll_pos > 1 then
//		ls_chunk = left(ls_whats_left, ll_pos - 1)
//		add_chunk(ls_chunk)
//		add_cr()
//		// Temporarily set the indent to 0 so newlines within an add_text() call wrap to the left
//		// margin instead of the left edge
//		setparagraphsetting(Indent!, 0)
//		lb_found_cr = true
//		ls_whats_left = mid(ls_whats_left, ll_pos + 1)
//	else
//		add_chunk(ls_whats_left)
//		ls_whats_left = ""
//	end if
//LOOP WHILE ls_whats_left <> ""
//
////if lb_found_cr then
////	add_cr()
////	set_level(level)
////end if
////
////
end subroutine

public subroutine set_detail ();set_position()
SelectText(detail_fromline, detail_fromchar, detail_toline, detail_tochar, detail!)
end subroutine

public subroutine set_header ();set_position()
SelectText(header_fromline, header_fromchar, header_toline, header_tochar, header!)
end subroutine

public subroutine set_position ();long ll_startline, ll_startchar
long ll_endline, ll_endchar
band l_band

// Get the band and start and end of the selection

l_band = Position(ll_startline, ll_startchar,&
		ll_endline, ll_endchar)

CHOOSE CASE l_band

CASE Detail!
		detail_fromline = ll_startline
		detail_fromchar = ll_startchar
		detail_toline = ll_endline
		detail_tochar = ll_endchar
CASE Header!
		header_fromline = ll_startline
		header_fromchar = ll_startchar
		header_toline = ll_endline
		header_tochar = ll_endchar
CASE Footer!
		footer_fromline = ll_startline
		footer_fromchar = ll_startchar
		footer_toline = ll_endline
		footer_tochar = ll_endchar
END CHOOSE
end subroutine

public subroutine delete_last_chars (integer pi_count);boolean lb_displayonly
long ll_startline, ll_startchar
long ll_endline, ll_endchar
band l_band


lb_displayonly = displayonly

displayonly = false

// Get the band and start and end of the selection

l_band = Position(ll_startline, ll_startchar,&
		ll_endline, ll_endchar)

// Calculate the range
ll_endline = ll_startline
ll_endchar = ll_startchar - 1
ll_startchar -= pi_count

// If we're already at the beginning of the line then we're done
if ll_endchar < 1 then return

// Don't remove past the beginning of the line
if ll_startchar < 1 then ll_startchar = 1

// Select the text and clear it
SelectText(ll_startline, ll_startchar, ll_endline, ll_endchar)
clear()

// Restore the previous displayonly setting
displayonly = lb_displayonly


end subroutine

public subroutine set_page_width (long pl_width);paperwidth = pl_width

end subroutine

public subroutine clear_rtf ();boolean lb_displayonly

lb_displayonly = displayonly

displayonly = false
selecttextall()
// clear()  // Wasn't working for some reason
replacetext("")
set_margins()
set_color(color_text_normal)
set_bold(false)
set_italic(false)
set_underline(false)
set_strikeout(false)
set_subscript(false)
set_superscript(false)
set_level(0)
set_justify(left!)
input_field_count = 0
inputfieldsvisible = true
inputfieldbackcolor = color_light_blue

displayonly = lb_displayonly

end subroutine

public subroutine next_level ();set_level(level + 1)

end subroutine

public subroutine set_level (integer pi_level);long ll_indent
long ll_max_indent

return

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
setparagraphsetting(LeftMargin!, wrap_margin)
setparagraphsetting(RightMargin!, right_margin)
setparagraphsetting(Indent!, ll_indent - wrap_margin + left_margin)

end subroutine

public subroutine set_underline (boolean pb_underline);if font_settings_caching then
	if pb_underline = current_font_settings.underline then return
	
	SetTextStyle ( current_font_settings.bold,  pb_underline,  current_font_settings.subscript,  current_font_settings.superscript,  current_font_settings.italic,  current_font_settings.strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( lb_bold, pb_underline, lb_subscript, lb_superscript, lb_italic, lb_strikeout )

return


end subroutine

public subroutine set_justify (alignment pe_alignment);if font_settings_caching then
	if pe_alignment = current_font_settings.alignment then return
end if

setalignment(pe_alignment)
current_font_settings.alignment = pe_alignment

return


end subroutine

public subroutine set_insertion_point_end ();long ll_linecount
long ll_charcount

ll_linecount = linecount()

selecttext(ll_linecount, 1, 0, 0)

ll_charcount = linelength()

selecttext(ll_linecount, ll_charcount + 1, 0, 0)

end subroutine

public subroutine add_page_break ();string ls_page_break

ls_page_break = "{\rtf1\ansi\deff0{\par\page }}"

PasteRTF(ls_page_break)

goto_end_of_text()

end subroutine

public subroutine top ();goto_top()

end subroutine

public subroutine goto_end_of_line ();long ll_line
long ll_linelength

ll_line = selectedline()
ll_linelength = linelength()

selecttext(ll_line, ll_linelength + 1, 0, 0)

end subroutine

public subroutine goto_end_of_text ();long ll_linecount

ll_linecount = linecount()

selecttext(ll_linecount, 1, 0, 0)

goto_end_of_line()


end subroutine

public subroutine goto_top ();long ll_line

// Scroll back to the top
ll_line = selectedline()
scroll(-ll_line)

selecttext(1, 1, 0, 0)

end subroutine

public subroutine delete_range (long pl_startline, long pl_startchar, long pl_endline, long pl_endchar);long ll_line
long ll_length
boolean lb_displayonly

lb_displayonly = displayonly

displayonly = false

selecttext(pl_startline, pl_startchar, pl_endline, pl_endchar)

clear()

set_margins()

displayonly = lb_displayonly


end subroutine

public function string get_text ();long ll_linecount
long i
string ls_line
string ls_text

ll_linecount = linecount()

ls_text = ""

for i = 1 to ll_linecount
	selecttext(i, 1, 0, 0)
	selecttextline()
	ls_line = trim(selectedtext())
	if ls_text = "" then
		ls_text = ls_line
	else
		ls_text += " " + ls_line
	end if
next

goto_end_of_text()

return ls_text


end function

public subroutine initialize_margins ();string ls_rtf
long ll_width
long ll_screen_resolution

//	\paperwN Paper width in twips (the default is 12,240). 
//	\paperhN Paper height in twips (the default is 15,840). 
//	\marglN Left margin in twips (the default is 1800). 
//	\margrN Right margin in twips (the default is 1800). 
//	\margtN Top margin in twips (the default is 1440). 
//	\margbN Bottom margin in twips (the default is 1440). 
// 1 twip = 1/1440 inch

ll_screen_resolution = common_thread.mm.screen_resolution_x()

// Get the width of the control in inches
ll_width = (1000 * UnitsToPixels(width, XUnitsToPixels!)) / ll_screen_resolution

// Set the right margin, assuming a page width of 8.5 inches
rightmargin = 8500 - ll_width


end subroutine

public function str_charposition charposition ();str_charposition lstr_charposition
long ll_startline, ll_startchar
long ll_endline, ll_endchar
band l_band

// Get the band and start and end of the selection

l_band = Position(ll_startline, ll_startchar,&
		ll_endline, ll_endchar)

lstr_charposition.line_number = ll_startline
lstr_charposition.char_position = ll_startchar

return lstr_charposition
end function

public subroutine delete_range (str_charrange pstr_charrange);long ll_line
long ll_length
boolean lb_displayonly

lb_displayonly = displayonly

displayonly = false

select_text(pstr_charrange)

clear()

set_margins()

displayonly = lb_displayonly


end subroutine

public subroutine select_text (str_charrange pstr_charrange);selecttext(pstr_charrange.from_position.line_number, pstr_charrange.from_position.char_position, pstr_charrange.to_position.line_number, pstr_charrange.to_position.char_position)

end subroutine

public subroutine delete_from_position (str_charposition pstr_position);
delete_range(f_charrange(pstr_position, charposition()))

return

end subroutine

public function str_charposition character_at_position (long pl_posx, long pl_posy);str_charposition lstr_charposition
long ll_startline, ll_startchar
long ll_endline, ll_endchar
band l_band

// Get the band and start and end of the selection

l_band = Position(ll_startline, ll_startchar,&
		ll_endline, ll_endchar)

lstr_charposition.line_number = ll_startline
lstr_charposition.char_position = ll_startchar

return lstr_charposition
end function

public subroutine select_text (str_charposition pstr_position);selecttext(pstr_position.line_number, pstr_position.char_position, 0, 0)

end subroutine

public subroutine add_text (string ps_text, str_font_settings pstr_font_settings);str_font_settings lstr_font_settings

// Don't do anything if we don't have any text
if isnull(ps_text) or len(ps_text) = 0 then return

// Record the current font_settings
lstr_font_settings = get_font_settings()

// Set the desired font_settings for this text
set_font_settings(pstr_font_settings)

// Add the text
//add_chunk(ps_text)
replacetext(ps_text)

// Restore the original font_settings
set_font_settings(lstr_font_settings)

return


end subroutine

public subroutine add_text (string ps_text, boolean pb_highlight);str_font_settings lstr_font_settings

// Don't do anything if we don't have any text
if isnull(ps_text) or len(ps_text) = 0 then return

if pb_highlight then
	lstr_font_settings = abnormal_result_font_settings
	add_text(ps_text, lstr_font_settings)
else
	add_text(ps_text)
end if


end subroutine

public subroutine set_font_settings (str_font_settings pstr_font_settings);set_font_size(pstr_font_settings.fontsize)
set_bold(pstr_font_settings.bold)
set_underline(pstr_font_settings.underline)
set_italic(pstr_font_settings.italic)
set_color(pstr_font_settings.forecolor)

//set_text_back_color(pstr_font_settings.textbackcolor)

set_justify(pstr_font_settings.alignment)

//set_fontname(pstr_font_settings.fontname)

end subroutine

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

//if object.viewmode = 1 or object.viewmode = 2 then
//	ll_page = 1
//else
//	ll_page = 0
//end if
//
////// for some reason using 100 as a scale factor sometimes results in a slightly distorted image, so if the scale is 100 then pass in nulls instead.
////if li_scale_x = 100 then
////	setnull(li_scale_x)
////	setnull(li_scale_y)
////end if
//
//TRY
//	CHOOSE CASE lower(ps_placement)
//		CASE "fixed"
//			ll_objectid = object.ImageInsertFixed(ps_filename, ll_page, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
//	//		ll_objectid = object.ObjectInsertFixed(3, ps_filename, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, 0, 0, ll_text_flow, 100, 100, 100, 100)
//		CASE "paragraph"
//			ll_objectid = object.ImageInsert(ps_filename, -1, 0, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
//	//		ll_objectid = object.ObjectInsert(3, ps_filename, -1, 0, ll_x_twips, ll_y_twips, li_scale_x, li_scale_y, ll_text_flow, 100, 100, 100, 100)
//		CASE ELSE
//			ll_objectid = object.ImageInsertAsChar(ps_filename, -1, li_scale_x, li_scale_y)
//			//ll_objectid = object.ObjectInsertAsChar(0, ps_filename, -1, li_scale_x, li_scale_y, 0, 1)
//	END CHOOSE
//CATCH (oleruntimeerror lt_error)
//	log.log(this, "add_image()", "Error Inserting Image (" + ps_filename + ")~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
//END TRY

if ll_objectid = 0 then
	return 0
else
	return ll_objectid
end if

end function

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

public function integer add_image (string ps_filename);long ll_width_inches
long ll_height_inches

setnull(ll_width_inches)
setnull(ll_height_inches)

return add_image(ps_filename, ll_width_inches, ll_height_inches)

end function

public subroutine set_redraw (boolean pb_redraw);//boolean lb_lock

//lb_lock = NOT pb_redraw

//object.lockwindowupdate(lb_lock)

setredraw(pb_redraw)

end subroutine

public subroutine blank_lines (integer pi_lines);long ll_currentline
long ll_startingline
integer i
long ll_linelength
long ll_blank_lines
integer li_table
str_charposition lstr_charposition
string ls_temp

if isnull(pi_lines) then pi_lines = 0

/////////////////////////////////////////////////////////////////////////////////////////////
// The logic that deletes lines was causing crashes so for now
// I simplified the blank_lines command to never delete and
// only count the current line as blank or not
/////////////////////////////////////////////////////////////////////////////////////////////
if linelength() > 0 then
	ll_blank_lines = 0
else
	ll_blank_lines = 1
end if

for i = 1 to (pi_lines - ll_blank_lines + 1)
	add_cr()
next
return
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

if isnull(pi_lines) or pi_lines <= 0 then pi_lines = 0
if pi_lines > 50 then pi_lines = 50

lstr_charposition = charposition()

ll_blank_lines = 0
ll_currentline = selectedline()
DO WHILE ll_currentline > 0
	SelectText (ll_currentline, 1, 0, 0)
	ls_temp = TextLine()
	ll_linelength = len(ls_temp)
	if ll_linelength > 0 then
		exit
	else
		ll_blank_lines++
	end if
	ll_currentline  -= 1
LOOP

set_position(lstr_charposition)

// This calculation included the current line, which doesn't count, so subtract one leaving blank_lines = -1 if there aren't any blank lines
ll_blank_lines -= 1

if ll_blank_lines > pi_lines then
	// If we have too many blank lines then remove some
	for i = ll_startingline to ll_startingline - ll_blank_lines + pi_lines + 1 step -1
		delete_line(i)
	next
	// Now reset the margins cuz they might have been trashed
//	reset_fontstate()
//	set_indents(current_fontstate.indentl, current_fontstate.indentr, current_fontstate.indentfl)
elseif ll_blank_lines < pi_lines then
	// If we don't have enough blank lines then add some
	for i = 1 to (pi_lines - ll_blank_lines)
		add_cr()
	next
end if

//li_table = object.tableatinputpos
//if li_table > 0 then
//	object.selstart = -1
//	add_cr()
//end if


end subroutine

public function long add_field (string ps_display, string ps_data, str_font_settings pstr_font_settings);integer li_sts
str_font_settings lstr_font_settings
string ls_fieldname
string ls_selectedtext
str_charposition lstr_charposition

if isnull(ps_display) or isnull(ps_data) then return 0

// Record the current font settings
lstr_font_settings = get_font_settings()

// record the current selected text
ls_selectedtext = selectedtext()

set_font_settings(pstr_font_settings)

// If the insertion point is at the end of a line then add a space because we have trouble
// if the InputField is at the end of a line
lstr_charposition = charposition()
if selectedcolumn() > linelength() then
	replacetext(" ")
	select_text(lstr_charposition)
end if
	

ls_fieldname = "field" + right("0000" + string(input_field_count), 4)
li_sts = InputFieldInsert(ls_fieldname)
if li_sts <= 0 then return -1

input_field_count++
input_fields[input_field_count].field_name = ls_fieldname
input_fields[input_field_count].field_data = ps_data
li_sts = InputFieldChangeData(ls_fieldname, ps_display)

inputfieldbackcolor = field_backcolor

// Now move the insertion point outside the field
lstr_charposition.line_number = selectedline()
lstr_charposition.char_position = linelength() + 1
select_text(lstr_charposition)

if len(ls_selectedtext) = 0 then
	// Reset the previous font settings
	set_font_settings(lstr_font_settings)
end if

return input_field_count

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

public function long add_field (string ps_display, string ps_data);return add_field(ps_display, ps_data, true)

end function

public function long add_field (string ps_display, str_service_info pstr_service);string ls_field_data

ls_field_data = f_service_to_field_data(pstr_service)

return add_field(ps_display, ls_field_data)


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

//ll_width_inches = (1000 * page_width_twips) / 1440
//ll_height_inches = (1000 * page_height_twips) / 1440
//
//f_get_picture_dimensions(ps_filename, ll_picture_inches_x, ll_picture_inches_y)
//if ll_picture_inches_x > 0 and ll_picture_inches_y > 0 then
//	li_scale_x = (100 * ll_width_inches) / ll_picture_inches_x
//	li_scale_y = (100 * ll_height_inches) / ll_picture_inches_y
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
//if object.viewmode = 1 or object.viewmode = 2 then
//	ll_page = 1
//else
//	ll_page = 0
//end if
//
//ll_text_flow = 2
//
//ll_objectid = object.ImageInsertFixed(ps_filename, ll_page, 0, 0, li_scale_x, li_scale_y, ll_text_flow, 0, 0, 0, 0)
//
////ll_objectid = object.ObjectInsertAsChar(0, ps_filename, 0, li_scale_x, li_scale_y, 2, 0)
//
//if ll_objectid = 0 then
//	return 0
//else
//	ll_imagedisplaymode = object.ImageDisplayMode
////	object.ObjectCurrent = ll_objectid
////	object.ImageDisplayMode = 2
//	return 1
//end if
//
return 0

end function

public function long get_scroll_position_y ();long ll_scrollpos


//ll_scrollpos = object.scrollposy

// Convert to 1000th of inch
ll_scrollpos = ll_scrollpos * 1000 / 1440

return ll_scrollpos




end function

public subroutine add_grid (str_grid pstr_grid);integer li_table
integer i
integer j
long ll_viewable
//long ll_cell_width[]
//object.FormatSelection = True
long ll_total_chars
//long ll_column_chars[]
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
long ll_wrap_margin
long ll_right_margin
long ll_left_margin

// Turn off caching to force all the fontstate changes
lb_last_fontstate_caching = font_settings_caching
font_settings_caching = false

// Get the original font settings
lstr_original_font_settings = get_font_settings()

set_font_settings(lstr_original_font_settings)

// Save the margins
ll_wrap_margin = wrap_margin
ll_right_margin = right_margin
ll_left_margin = left_margin

// Wrap margin must be zero for grids
set_margins(left_margin,0,right_margin)

// Make sure nothing is selected
//object.sellength = 0

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
//last_table += 1
//ll_left_margin_twips = (1440 * left_margin) / 1000
//ll_right_margin_twips = (1440 * right_margin) / 1000
//set_indents(0, 0, 0)
//li_table = object.TableInsert(pstr_grid.row_count + li_heading_count, pstr_grid.column_count + li_column_title_count, -1, last_table)
//if li_table <= 0 then return
//
//object.TableCellAttribute[li_table, 0, 1, txTableCellHorizontalPos] = ll_left_margin_twips

add_cr()

if li_heading_count > 0 then
	if pstr_grid.table_attributes.bold_headings then
		set_bold(true)
	end if
	if li_column_title_count > 0 then
		// Set the heading for the first column
		ls_column = trim(pstr_grid.row_title)
		if isnull(ls_column) then ls_column = ""
		//object.TableCellText[li_table, 1, 1] = ls_column
		add_text(ls_column)
		
//		ll_column_chars[1] = grid_column_chars(ls_column)
	end if
	
	// Set the other column headings
	for j = 1 to pstr_grid.column_count
		ls_column = trim(pstr_grid.column_title[j])
		if isnull(ls_column) then ls_column = ""
		
		// Add column heading using bold if necessary
		add_tab()
		add_text(ls_column)
		
//		ll_column_chars[j + li_column_title_count] = grid_column_chars(ls_column)
	next
	
	// Set the bold back
	if pstr_grid.table_attributes.bold_headings then
		set_bold(lstr_original_font_settings.bold)
	end if
//else
//	// We don't have headings so initialize the column counts to zero
//	for i = 1 to pstr_grid.column_count + li_column_title_count
//		ll_column_chars[i] = 0
//	next	

	add_cr()
end if

// Then loop through the rows
For i = 1 To pstr_grid.row_count
	if li_column_title_count > 0 then
		ls_column = trim(pstr_grid.grid_row[i].row_title)
		if isnull(ls_column) then ls_column = ""
		
		add_text(ls_column)
//		object.TableCellText[li_table, i + li_heading_count, 1] = ls_column
//		if len(ls_column) > ll_column_chars[1] then
//			ll_column_chars[1] = grid_column_chars(ls_column)
//		end if
	end if
	
	// Then loop through the columns and set the column text
	for j = 1 to pstr_grid.column_count
		ls_column = trim(pstr_grid.grid_row[i].column[j].column_text)
		if isnull(ls_column) then ls_column = ""
		add_tab()
		if pstr_grid.grid_row[i].column[j].use_font_settings then
			set_font_settings(pstr_grid.grid_row[i].column[j].font_settings)
		end if
		add_text(ls_column)
		if pstr_grid.grid_row[i].column[j].use_font_settings then
			set_font_settings(lstr_original_font_settings)
		end if
		
//		if len(ls_column) > 0 then
//			object.selstart = object.TableCellStart[li_table, i + li_heading_count, j + li_column_title_count] - 1
//			if pstr_grid.grid_row[i].column[j].use_font_settings then
//				set_font_settings(pstr_grid.grid_row[i].column[j].font_settings)
//			end if
//			if len(pstr_grid.grid_row[i].column[j].field_data) > 0 then
//				// set the insertion point in the desired cell
//				add_field(ls_column, pstr_grid.grid_row[i].column[j].field_data)
//			else
//				add_text(ls_column)
//			end if
//			if pstr_grid.grid_row[i].column[j].use_font_settings then
//				set_font_settings(lstr_original_font_settings)
//			end if
//		end if
//		ll_longest_line = f_longest_line(ls_column)
//		if ll_longest_line > ll_column_chars[j + li_column_title_count] then
//			ll_column_chars[j + li_column_title_count] = ll_longest_line
//		end if
	next	
	add_cr()
Next

//// Calculate the viewable width in twips
//if pstr_grid.table_attributes.table_width > 0 then
//	// If the table width is supplied then convert it from thousandths of an inch to twips
//	ll_viewable = (1440 * pstr_grid.table_attributes.table_width) / 1000
//else
//	// If the table width was not supplied then calculate it based on the screen width or page width
//	if object.viewmode = view_mode_normal_layout  then
//		ll_screen_resolution_x = common_thread.mm.screen_resolution_x()
//		ll_viewable = (1440 * UnitsToPixels(width, XUnitsToPixels!)) / ll_screen_resolution_x
//		// Leave room for the scroll bar
//		ll_viewable -= 400
//		// Leave room for the margins
//		ll_viewable -= ll_left_margin_twips
//		ll_viewable -= ll_right_margin_twips
//	else
//		ll_viewable = page_width_twips - object.PageMarginL - object.PageMarginR
//		// Leave room for the margins
//		ll_viewable -= ll_left_margin_twips
//		ll_viewable -= ll_right_margin_twips
//	end if
//end if
//
//ll_table_columns = pstr_grid.column_count + li_column_title_count
//
//// Give column 1 an automatic bump because if there's a close competition between which column wraps we prefer column 1 to not wrap
//ll_column_chars[1] += 1
//
//// Count the total chars
//ll_total_chars = 0
//for j = 1 to ll_table_columns
//	ll_total_chars += ll_column_chars[j]
//next
//
//// Calculate the width of each column in twips
//for j = 1 to ll_table_columns
//	if ll_total_chars > 0 then
//		ll_cell_width[j] = long(real(ll_viewable) * (real(ll_column_chars[j]) / real(ll_total_chars)))
//	else
//		ll_cell_width[j] = ll_viewable / ll_table_columns
//	end if
//next	
//
//// Find the widest cell
//li_widest_cell = 1
//for i = 2 to ll_table_columns
//	if ll_cell_width[i] > ll_cell_width[li_widest_cell] then li_widest_cell = i
//next	
//
//// Scan for columns too narrow and grow them
//for j = 1 to ll_table_columns
//	if (ll_min_twips_per_char * ll_column_chars[j]) > ll_cell_width[j] &
//	 and ll_cell_width[j] < (ll_viewable / ll_table_columns) then
//		if (ll_min_twips_per_char * ll_column_chars[j]) < (ll_viewable / ll_table_columns) then
//			// If the min width is less than the average width, then grow to the min width
//			ll_cell_growth = (ll_min_twips_per_char * ll_column_chars[j]) - ll_cell_width[j]
//		else
//			// If the min width is greater than the average width, then grow to the average width
//			ll_cell_growth =  (ll_viewable / ll_table_columns) - ll_cell_width[j]
//		end if
//		// Grow cell and reduce the widest cell
//		ll_cell_width[j] += ll_cell_growth
//		ll_cell_width[li_widest_cell] -= ll_cell_growth
//		// Now find the widest cell again
//		li_widest_cell = 1
//		for i = 2 to ll_table_columns
//			if ll_cell_width[i] > ll_cell_width[li_widest_cell] then li_widest_cell = i
//		next	
//	end if
//	
////	if ll_column_chars[j] > (ll_total_chars - ll_column_chars[j]) / 2 then
////		ll_total_chars -= ll_column_chars[j]
////		ll_column_chars[j] = 2 * ll_total_chars / 3
////		ll_total_chars += ll_column_chars[j]
////	end if
//next	
//
//// Set the width of each column
//for j = 1 to ll_table_columns
//	object.TableCellAttribute[li_table, 0, j, txTableCellHorizontalExt] = ll_cell_width[j]
//next	
//
//// Set the grid line width
//if pstr_grid.table_attributes.suppress_lines then
//	object.TableCellAttribute[li_table, 0, 0, txTableCellBorderWidth] = 0
//else
//	object.TableCellAttribute[li_table, 0, 0, txTableCellBorderWidth] = 1
//end if
//
//goto_end_of_text()
//
//add_cr()
//
//remove_character_wall = object.selstart
//
set_font_settings(lstr_original_font_settings)

// Restore margins
//set_indents(ll_wrap_margin, ll_right_margin, ll_left_margin)
font_settings_caching = lb_last_fontstate_caching

reset_fontstate()

return

end subroutine

public subroutine unset_text_back_color ();set_text_back_color(last_backcolor)

end subroutine

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

public subroutine reset_fontstate ();long ll_indent
long ll_max_indent
long ll_left_twips
long ll_wrap_twips
long ll_right_twips
long ll_left_margin_twips

//object.fontsize = current_fontstate.fontsize
//
//object.fontbold = current_fontstate.fontbold
//object.fontunderline = current_fontstate.fontunderline
//object.fontitalic = current_fontstate.fontitalic
//
//
//object.forecolor = current_fontstate.forecolor
//object.alignment = current_fontstate.alignment
//object.fontname = current_fontstate.fontname
//
//
//object.indentr = current_fontstate.indentr
//object.indentfl = current_fontstate.indentfl
//object.indentl = current_fontstate.indentl
//
//use_wrap_margin = current_fontstate.use_wrap_margin
//
//wrap_margin = (current_fontstate.indentl * 1000) / 1440
//right_margin = (current_fontstate.indentr * 1000) / 1440
//
//ll_max_indent = (2 * wrap_margin) / 3
//
//ll_indent = level * level_indent
//
//if level <= 0 then
//	level = 0
//	ll_indent = 0
//elseif ll_indent > ll_max_indent and wrap_margin > (3 * level_indent) then
//	ll_indent = ll_max_indent
//end if
//
//if use_wrap_margin then
//	ll_left_margin_twips = current_fontstate.indentfl + current_fontstate.indentl
//	left_margin = ((ll_left_margin_twips * 1000) / 1440) - ll_indent 
//else
//	left_margin = wrap_margin
//end if
//
//read_formatting()
//
end subroutine

public function boolean page_mode ();
//if object.viewmode = 1 or object.viewmode = 2 then return true

return false

end function

public subroutine add_date_time ();add_date()
add_text(" ")
add_time()


end subroutine

public subroutine add_time ();string ls_text

ls_text = string(now())

add_text(ls_text)

end subroutine

public subroutine add_date ();string ls_text

ls_text = string(today())

add_text(ls_text)

end subroutine

public subroutine add_page_number (string ps_title);//// This form of add_page_number adds a prefix to the page number and appends the total
//// number of pages
//
//current_page_field_start = object.selstart
//page_number_prefix = ps_title
//include_total_pages = true
//
//// Add enough spaces to hold the page number
//add_text(fill(" ", len(page_number_prefix) + len(total_pages_string) + 6))
//
//// Add a blank to the end of text
//object.selstart = -1
//add_text(" ")

return

end subroutine

public subroutine add_page_number ();//page_number_prefix = ""
//current_page_field_start = object.selstart
//include_total_pages = false

end subroutine

public subroutine add_rtf (string ps_rtf);
//object.rtfseltext = ps_rtf


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

//CHOOSE CASE lower(ps_extension)
//	CASE "rtf", "wri"
//		ls_rtf = f_blob_to_string(pbl_document)
//		add_rtf(ls_rtf)
//		reset_fontstate()
//	CASE "txt"
//		ls_text = f_blob_to_string(pbl_document)
//		// See if there is a crlf
//		ls_crlf = "~r~n"
//		ll_pos = pos(ls_text, ls_crlf)
//		if ll_pos > 0 then
//			object.loadfrommemory(pbl_document, 6, true)
//		else
//			object.loadfrommemory(pbl_document, 7, true)
//		end if
//	CASE "htm","html"
//		object.loadfrommemory(pbl_document, 4, true)
//	CASE "css"
//		object.loadfrommemory(pbl_document, 11, true)
//	CASE "doc"
//		object.loadfrommemory(pbl_document, 9, true)
//	CASE "docx"
//		object.loadfrommemory(pbl_document, 13, true)
//	CASE "xml"
//		object.loadfrommemory(pbl_document, 10, true)
//	CASE "pdf"
//		return 0
//	CASE "bmp", "png", "wmf", "emf", "tif", "tiff", "jpg", "gif"
//		ls_document_file = f_temp_file(ps_extension)
//		li_sts = log.file_write(pbl_document, ls_document_file)
//		if li_sts > 0 and fileexists(ls_document_file) then
//			// Add the bitmap to the rtf control
//			li_object_id = add_image(ls_document_file, ll_bitmap_width_inches, ll_bitmap_height_inches, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
//			if li_object_id > 0 then
//				ll_menu_id = long(f_attribute_find_attribute(pstr_attributes, "menu_id"))
////				add_object_menu(li_object_id, ll_menu_id)
//				li_sts = 1
//			end if
//		else
////			log_error("Error writing image temp file")
//		end if
//	CASE ELSE
//		// If the extension is not recognized then see if we can render it into an image file
//		convert_inches_to_pixels(ll_bitmap_width_inches, ll_bitmap_height_inches, ll_desired_width_pixels, ll_desired_height_pixels)
////		li_sts = file_action.render_file(pstr_document, &
////												"png", &
////												ll_desired_width_pixels, &
////												ll_desired_height_pixels, &
////												ls_rendered_file_type, &
////												lbl_rendered_file)
//		if li_sts <= 0 then
////			log_error("Error rendering document into image")
//			log.log(this, "display_document()", "Error rendering document into image", 4)
//			return -1
//		end if
//		
//		// Save the rendered image
//		string ls_temp_file
//		ls_temp_file = f_temp_file(ls_rendered_file_type)
//		li_sts = log.file_write(lbl_rendered_file, ls_temp_file)
//		if li_sts <= 0 then
////			log_error("Error saving rendered document")
//			log.log(this, "display_document()", "Error saving rendered document", 4)
//			return -1
//		end if
//		
//		// Add the bitmap to the rtf control
//		li_object_id = add_image(ls_temp_file, ll_bitmap_width_inches, ll_bitmap_height_inches, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
//		if li_object_id > 0 then
//			ll_menu_id = long(f_attribute_find_attribute(pstr_attributes, "menu_id"))
////			add_object_menu(li_object_id, ll_menu_id)
//			li_sts = 1
//		end if
//END CHOOSE



return li_sts


end function

public subroutine initialize ();//
//string ls_rtf
//long ll_screen_resolution_y
//integer i
//
////	\paperwN Paper width in twips (the default is 12,240). 
////	\paperhN Paper height in twips (the default is 15,840). 
////	\marglN Left margin in twips (the default is 1800). 
////	\margrN Right margin in twips (the default is 1800). 
////	\margtN Top margin in twips (the default is 1440). 
////	\margbN Bottom margin in twips (the default is 1440). 
//// 1 twip = 1/1440 inch
//
//
// Set the page height/width in twips
paperheight = 11000 // 11 inches
paperwidth = 8500 // 8.5 inches
//
//// Get the height of the control in twips
//ll_screen_resolution_y = common_thread.mm.screen_resolution_y()
//height_twips = (1440 * UnitsToPixels(height, YUnitsToPixels!)) / ll_screen_resolution_y
//
//// Set the right margin, assuming a page width of 8.5 inches
////rightmargin = 8500 - ll_width
//

leftmargin = 500
rightmargin = 500

DisplayOnly = false
facename = default_rtf_font_name
textsize = 9

//object.fontsize = 9
//object.formatselection = true
//object.editmode = 1 // read-only with select-text capability
//object.borderstyle = 0
//object.pageheight = page_height_twips
//object.pagewidth = page_width_twips
////object.autoexpand = true
//object.fontname = default_rtf_font_name
//
////////////////////////////////////////////////////////////////
//// Msc 12/8/07 commented out because it was causing the text frame insert to take forever
//// object.device = 1 // Formatted for screen
////////////////////////////////////////////////////////////////
//
//
//
//object.viewmode = view_mode_normal_layout
//
//if scrollbars then
//	VScrollBar = true
//else
//	VScrollBar = false
//end if
//
//current_page_field_start = 0
//include_total_pages = false
//
//read_formatting()
//
current_font_settings = get_font_settings()
//
//// Save the state
//tx_state = object.SaveToMemory()
//
//
if isvalid(datalist) and not isnull(datalist) then
	field_backcolor = datalist.get_preference_int("COLOR", "RTF Field Backcolor", rgb(216,216,216))
end if

end subroutine

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

//object.objectcurrent = pl_objectid
//object.ObjectScaleX = li_scale_x
//object.ObjectScaleY = li_scale_y
//object.imagefilename = ps_filename

return 1

end function

public subroutine set_edit_mode (string ps_edit_mode);// "Editable"
// "Read and Select"
// "Read Only"


CHOOSE CASE lower(ps_edit_mode)
	CASE "editable"
		displayonly = false
	CASE "read and select"
		displayonly = true
	CASE "read only"
		displayonly = true
END CHOOSE
end subroutine

public subroutine set_undoable (boolean pb_undoable);


return

end subroutine

public function string get_selected_text ();return selectedtext()

end function

public subroutine wrap_off ();
return

end subroutine

public subroutine wrap_on ();
return

end subroutine

public function str_font_settings get_font_settings ();return get_font_settings(font_settings_caching)

end function

public subroutine update_field (long pl_fieldid, string ps_fielddata);//object.FieldData[pl_fieldid] = ps_fielddata 

end subroutine

public subroutine delete_field (long pl_fieldid, boolean pb_delete_text);//
//object.FieldCurrent = pl_fieldid
//
//object.selstart = object.fieldstart
//if pb_delete_text then
//	object.sellength = 0
//else
//	object.sellength = object.fieldend - object.fieldstart
//end if
//object.fielddelete(pb_delete_text)
//
//object.fontunderline = 0
//object.forecolor = color_black
//
//
end subroutine

public function integer load_document (string ps_file, filetype pe_filetype);//pi_format values:
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
//	FileTypeRichText! - (Default) The file being opened is in rich text format (RTF)
//	FileTypeText! - The file being opened is plain ASCII text (TXT)
//	FileTypeHTML! - The file being opened is in HTML format (HTM or HTML)
//	FileTypeDoc! - The file being opened is in Microsoft Word format (DOC)
//

return insertdocument(ps_file, true, pe_filetype)

end function

public function integer load_document (string ps_file);string ls_drive
string ls_directory
string ls_file
string ls_extension
FileType le_filetype


f_parse_filepath(ps_file, ls_drive, ls_directory, ls_file, ls_extension)

le_filetype = filetype_from_extension(ls_extension)

return load_document(ps_file, le_filetype)

end function

private function filetype filetype_from_extension (string ps_extension);//	FileTypeRichText! - (Default) The file being opened is in rich text format (RTF)
//	FileTypeText! - The file being opened is plain ASCII text (TXT)
//	FileTypeHTML! - The file being opened is in HTML format (HTM or HTML)
//	FileTypeDoc! - The file being opened is in Microsoft Word format (DOC)

CHOOSE CASE lower(ps_extension)
	CASE "txt"
		return FileTypeText! 
	CASE "htm", "html"
		return FileTypeHTML!
	CASE "rtf"
		return FileTypeRichText!
	CASE "doc"
		return FileTypeDoc!
	CASE "xml"
		return FileTypeText!
	CASE "css"
		return FileTypeText!
//	CASE "pdf"
//		return 12
	CASE ELSE
		return FileTypeText! 
END CHOOSE

return FileTypeText! 

end function

public subroutine scroll_down ();scrollnextpage()
end subroutine

public subroutine scroll_up ();scrollpriorpage()
end subroutine

public subroutine set_background_color (long pl_color);
backcolor = pl_color


end subroutine

public subroutine set_page_height (long pl_height);PaperHeight = pl_height

end subroutine

public subroutine recalc_fields ();recalc_fields(false)

end subroutine

public subroutine recalc_fields (boolean pb_for_export);long ll_page_count
integer li_field
boolean lb_success
long ll_selstart
long ll_fieldend
string ls_page_count
string ls_total_pages
integer li_sts

// Set the page count in the footer
//if current_page_field_start > 0 then
//	ll_selstart = object.selstart
//	
//	set_footer()
//	
//	if current_page_field_start > 0 then
//		li_sts = remove_page_number()
//
//		//	Then replace the spaces with the prefix
//		object.SelStart = current_page_field_start
//		object.SelLength = len(page_number_prefix)
//		object.SelText = page_number_prefix
//
//		// Then add the marked text field
//		object.SelStart = current_page_field_start + len(page_number_prefix)
//		object.SelLength = 0
//		lb_success = object.FieldInsert("")
//		if not lb_success then return
//		li_field = object.FieldCurrent
//		object.FieldType[li_field] = txFieldPageNumber
//	
//		if include_total_pages and not pb_for_export then
//			// If the recalc is for an export, then just print blank spaces for the total pages.
//			// We do this when we because the application importing it probably won't format
//			// it the same so the count will likely be wrong.
//		
//			// Get the page count as a string padded with spaces
//			ll_page_count = object.currentpages
//			ls_page_count = left(string(ll_page_count) + "     ", 5)
//			ls_total_pages = total_pages_string + ls_page_count
//			
//			object.SelStart = object.FieldEnd
//			object.SelLength = len(ls_total_pages)
//			object.SelText = ls_total_pages
//			
//		end if
//	
//		set_detail()
//		
//		object.selstart = ll_selstart
//		object.SelLength = 0
//	end if
//end if
//
//// Finally, refresh the control again
//object.refresh()
//
end subroutine

public subroutine set_view_mode (string ps_view_mode);CHOOSE CASE lower(ps_view_mode)
	CASE "page"
		preview(true)
//		object.viewmode = view_mode_page_layout
	CASE "normal"
		preview(false)
//		object.viewmode = view_mode_normal_layout
END CHOOSE

end subroutine

public subroutine copy_to_clipboard (boolean pb_all);
if pb_all then selecttextall()

copy()

end subroutine

public function str_font_settings get_font_settings (boolean pb_use_caching);str_font_settings lstr_font_settings

if pb_use_caching then
	return current_font_settings
end if

lstr_font_settings.alignment = getalignment()
lstr_font_settings.bold = gettextstyle(bold!)
lstr_font_settings.italic = gettextstyle(italic!)
lstr_font_settings.subscript = gettextstyle(subscript!)
lstr_font_settings.superscript = gettextstyle(superscript!)
lstr_font_settings.underline = gettextstyle(underlined!)
lstr_font_settings.strikeout = gettextstyle(strikeout!)
lstr_font_settings.fontsize = textsize
lstr_font_settings.forecolor = gettextcolor()
//lstr_font_settings.textbackcolor = textsize
lstr_font_settings.fontname = facename

return lstr_font_settings


end function

public subroutine set_font_settings (str_font_settings pstr_font_settings, boolean pb_use_caching);str_font_settings lstr_font_settings
boolean lb_font_settings_caching


lb_font_settings_caching = font_settings_caching
font_settings_caching = pb_use_caching

setalignment(lstr_font_settings.alignment)

// Since the boolean settings get set as a group, add the logic here to set them all with a single call to SetTextStyle
if  NOT font_settings_caching &
	OR (pstr_font_settings.bold <> current_font_settings.bold) &
	OR (pstr_font_settings.underline <> current_font_settings.underline) &
	OR (pstr_font_settings.subscript <> current_font_settings.subscript) &
	OR (pstr_font_settings.superscript <> current_font_settings.superscript) &
	OR (pstr_font_settings.italic <> current_font_settings.italic) &
	OR (pstr_font_settings.strikeout <> current_font_settings.strikeout) then
		SetTextStyle ( pstr_font_settings.bold, pstr_font_settings.underline, pstr_font_settings.subscript, pstr_font_settings.superscript, pstr_font_settings.italic, pstr_font_settings.strikeout )
end if

set_font_size(pstr_font_settings.fontsize)
set_color(pstr_font_settings.forecolor)
set_text_back_color(pstr_font_settings.textbackcolor)
set_fontname(pstr_font_settings.fontname)

font_settings_caching = lb_font_settings_caching
current_font_settings = pstr_font_settings

return


end subroutine

public subroutine apply_formatting (string ps_formatting, boolean pb_use_caching);string ls_next_command
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
boolean lb_font_settings_caching

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
// margins=#/#/#		Set Margins (Left/Wrap/Right)
//	fc=#					Foreground Color
//	bc=#					Text Background Color
// tabs=#/#/#...
// pw=#					Page Width (thousandths of an inch)
// ph=#					Page Height (thousandths of an inch)
// pm=#/#/#/#			Set Page Margins (Left/Right/Top/Bottom)

lb_font_settings_caching = font_settings_caching
font_settings_caching = pb_use_caching


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
		CASE "bo"
			set_bold(true)
		CASE "it"
			set_italic(true)
		CASE "un"
			set_underline(true)
		CASE "so"
			set_strikeout(true)
		CASE "sb"
			set_subscript(true)
		CASE "sp"
			set_superscript(true)
		CASE "xb"
			set_bold(false)
		CASE "xi"
			set_italic(false)
		CASE "xu"
			set_underline(false)
		CASE "xo"
			set_strikeout(false)
		CASE "xs"
			set_subscript(false)
		CASE "xp"
			set_superscript(false)
		CASE "le"
			set_justify(left!)
		CASE "ce"
			set_justify(center!)
		CASE "ri"
			set_justify(right!)
		CASE "ju", "jj"
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
		CASE "fn"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_fontname(ls_temp2)
		CASE "fc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_color(f_string_to_color(ls_temp2))
		CASE "bc"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			set_text_back_color(f_string_to_color(ls_temp2))
		CASE "pm"
			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
			li_arg_count = f_parse_string(ls_temp2, "/", lsa_args)
			if li_arg_count >= 1 then
				if isnumber(lsa_args[1]) and len(lsa_args[1]) > 0 then
					ll_margin_thousandths = long(lsa_args[1])
					LeftMargin = ll_margin_thousandths/1000
				end if
			end if
			if li_arg_count >= 2 then
				if isnumber(lsa_args[2]) and len(lsa_args[2]) > 0 then
					ll_margin_thousandths = long(lsa_args[2])
					RightMargin = ll_margin_thousandths/1000
				end if
			end if
			if li_arg_count >= 3 then
				if isnumber(lsa_args[3]) and len(lsa_args[3]) > 0 then
					ll_margin_thousandths = long(lsa_args[3])
					TopMargin = ll_margin_thousandths/1000
				end if
			end if
			if li_arg_count >= 4 then
				if isnumber(lsa_args[4]) and len(lsa_args[4]) > 0 then
					ll_margin_thousandths = long(lsa_args[4])
					BottomMargin = ll_margin_thousandths/1000
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
		CASE "ta"
//			f_split_string(ls_next_command, "=", ls_temp1, ls_temp2)
//			li_count = f_parse_string(ls_temp2, "/", lsa_tabs)
//			if li_count > 14 then li_count = 14
//			
//			// If we've never set any tabs yet, then clear the default tab stops
//			if current_fontstate.tabstop_count = 0 then
//				clear_tabs()
//			else
//				// Otherwise clear any excess tabs
//				for i = current_fontstate.tabstop_count to li_count + 1 step -1
//					object.tabcurrent = i
//					object.tabpos = 0
//				next
//			end if
//			
//			// Finally, set the desired tab stops
//			current_fontstate.tabstop_count = li_count
//			for i = 1 to current_fontstate.tabstop_count
//				f_split_string(lsa_tabs[i], " ", ls_tabstop, ls_tabtype)
//				ll_tabstop = long(ls_tabstop)
//				if trim(ls_tabtype) = "" then ls_tabtype = "left"
//				set_tabstop(i, "left", ll_tabstop)
//			next
	END CHOOSE
LOOP


//read_formatting()

// If the saved lb_font_settings_caching is TRUE but the passed in font_settings_caching is false, then the cache may be stale so refresh it
if lb_font_settings_caching and not font_settings_caching then
	current_font_settings = get_font_settings()
end if

font_settings_caching = lb_font_settings_caching



	
	
	
end subroutine

public subroutine set_fontname (string ps_fontname);if font_settings_caching then
	if lower(ps_fontname) = lower(current_font_settings.fontname) then return
end if

facename = ps_fontname
of_setfont(ps_fontname)
current_font_settings.fontname = ps_fontname

return

end subroutine

public subroutine set_strikeout (boolean pb_strikeout);if font_settings_caching then
	if pb_strikeout = current_font_settings.strikeout then return
	
	SetTextStyle ( current_font_settings.bold,  current_font_settings.underline,  current_font_settings.subscript,  current_font_settings.superscript,  current_font_settings.italic,  pb_strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( lb_bold, lb_underline, lb_subscript, lb_superscript, lb_italic, pb_strikeout )

return


end subroutine

public subroutine set_subscript (boolean pb_subscript);if font_settings_caching then
	if pb_subscript = current_font_settings.subscript then return
	
	SetTextStyle ( current_font_settings.bold,  current_font_settings.underline,  pb_subscript,  current_font_settings.superscript,  current_font_settings.italic,  current_font_settings.strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( lb_bold, lb_underline, pb_subscript, lb_superscript, lb_italic, lb_strikeout )

return


end subroutine

public subroutine set_superscript (boolean pb_superscript);if font_settings_caching then
	if pb_superscript = current_font_settings.superscript then return
	
	SetTextStyle ( current_font_settings.bold,  current_font_settings.underline,  current_font_settings.subscript,  pb_superscript,  current_font_settings.italic,  current_font_settings.strikeout )
	return
end if

boolean lb_bold
boolean lb_underline
boolean lb_subscript
boolean lb_superscript
boolean lb_italic
boolean lb_strikeout

lb_bold = gettextstyle(bold!)
lb_underline = gettextstyle(underlined!)
lb_subscript = gettextstyle(subscript!)
lb_superscript = gettextstyle(superscript!)
lb_italic = gettextstyle(italic!)
lb_strikeout = gettextstyle(strikeout!)

SetTextStyle ( lb_bold, lb_underline, lb_subscript, pb_superscript, lb_italic, lb_strikeout )

return


end subroutine

public subroutine set_font_size (integer pi_fontsize);if font_settings_caching then
	if pi_fontsize = current_font_settings.fontsize then return
end if

textsize = pi_fontsize
of_setfontsize(pi_fontsize)
current_font_settings.fontsize = pi_fontsize

return


end subroutine

public subroutine set_color (long pl_forecolor);if font_settings_caching then
	if pl_forecolor = current_font_settings.forecolor then return
end if

settextcolor(pl_forecolor)
current_font_settings.forecolor = pl_forecolor

return


end subroutine

public subroutine set_text_back_color (long pl_textbackcolor);if font_settings_caching then
	if pl_textbackcolor = current_font_settings.textbackcolor then return
end if

// Don't know how to set the text-backcolor (as opposed to the control's backcolor) for this control.
//settextbackcolor(pl_textbackcolor)
current_font_settings.textbackcolor = pl_textbackcolor

return


end subroutine

public subroutine apply_formatting (string ps_formatting);apply_formatting(ps_formatting, font_settings_caching)

	
end subroutine

public subroutine delete_line (long pl_line);boolean lb_displayonly
long ll_linecount
long ll_length
long ll_prev_length

if isnull(pl_line) or pl_line <= 0 then return

lb_displayonly = displayonly

displayonly = false

ll_linecount = linecount()
if pl_line > ll_linecount then
	return
elseif pl_line < ll_linecount then
	// We're deleting a line before the last line
	selecttext(pl_line, 1, pl_line + 1, 1)
	replacetext("")
	// Leave the insertion point at the beginning of the deleted line (which used to be the line after the deleted line)
	selecttext(pl_line, 1, 0, 0)
elseif pl_line > 1 then
	// For deleting the last line, delete from the end of the previous line
	// First see how long the current line is line is
	selecttext(pl_line, 1, 0, 0)
	ll_length = len(textline())
	// Then see how long the previous line is
	selecttext(pl_line - 1, 1, 0, 0)
	ll_prev_length = len(textline())
	// Now select everthing from the end of the previous line to the end of the specified line
	selecttext(pl_line - 1, ll_prev_length + 1, pl_line, ll_length + 1)
	replacetext("")
	// Leave the insertion point at the end of the line before the deleted line
	selecttext(pl_line - 1, ll_prev_length + 1, 0, 0)
else
	// There's only 1 line!
	selecttextall()
	replacetext("")
end if

set_margins()

displayonly = lb_displayonly


end subroutine

public subroutine set_position (str_charposition pstr_charposition);
selecttext(pstr_charposition.line_number, pstr_charposition.char_position, 0, 0)

end subroutine

public subroutine delete_cr ();long ll_line
long ll_prev_length
boolean lb_displayonly

lb_displayonly = displayonly

displayonly = false

ll_line = selectedline()
selecttext(ll_line - 1, 1, 0, 0)
ll_prev_length = len(textline())

// Now select everthing from the end of the previous line to the end of the specified line
selecttext(ll_line - 1, ll_prev_length + 1, ll_line, 1)
replacetext("")

set_margins()

displayonly = lb_displayonly


end subroutine

public subroutine add_cr ();
replacetext("~r~n")

//set_margins()

//set_color(color_text_normal)
//set_bold(false)
//set_italic(false)
//set_underline(false)


return

end subroutine

private subroutine add_chunk_old (string ps_text);string ls_whats_left
string ls_chunk
integer li_chunk_size = 5

ls_whats_left = ps_text

DO
	if len(ls_whats_left) > li_chunk_size then
		ls_chunk = left(ls_whats_left, li_chunk_size)
		ls_whats_left = mid(ls_whats_left, li_chunk_size + 1)
	else
		ls_chunk = ls_whats_left
		ls_whats_left = ""
	end if
	
	replacetext(ls_chunk)
LOOP WHILE ls_whats_left <> ""



end subroutine

public function integer of_setfontsize (integer ai_points);/***************************************************************
* Arguments     : ai_points = new font size in point
* Return Values :          
* Description   : converts the passed point size to pixels and 
                  set the selected text to the desired point size
* Request No    : 
***************************************************************/
/***************************************************************
* By			: mjw
* Date		: 2007
* Purpose	: changed to api call to new format
* CR#			: 
***************************************************************/

integer	li_rc
//integer	li_pixels

IF ai_points <= 0 THEN Return 0

//Set the new font
//this.setredraw ( FALSE )
//li_pixels = of_getfontsize( ai_points )
of_getfont()
//is_logfont.lfheight = li_pixels
is_logfont.lfheight = -ai_points
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 

//this.setredraw ( TRUE )

//Make sure it took
of_getfont()

Return li_rc
end function

on u_richtextedit.create
call super::create
end on

on u_richtextedit.destroy
call super::destroy
end on

event constructor;initialize()
initialize_margins()

end event

event inputfieldselected;long i
string ls_text

for i = 1 to input_field_count
	if input_fields[i].field_name = fieldname then
		ls_text = inputfieldgetdata(fieldname)
		this.event POST field_clicked(i, ls_text, input_fields[i].field_data)
		return
	end if
next

end event

