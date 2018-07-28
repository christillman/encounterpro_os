$PBExportHeader$u_text_rtf.sru
forward
global type u_text_rtf from u_text_base
end type
end forward

global type u_text_rtf from u_text_base
end type
global u_text_rtf u_text_rtf

type variables
u_rich_text_edit rtf

end variables

forward prototypes
public subroutine add_text (string ps_text)
public subroutine add_tab ()
public subroutine apply_formatting (string ps_formatting)
public subroutine delete_cr ()
public subroutine delete_last_chars (long pl_count)
public subroutine delete_last_line ()
public subroutine next_level ()
public subroutine prev_level ()
public subroutine set_bold (boolean pb_bold)
public subroutine set_color (long pl_color)
public subroutine set_level (integer pi_level)
public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin)
public subroutine wrap_off ()
public subroutine wrap_on ()
public function long linelength ()
public function long wrap_margin ()
public function long left_margin ()
public function long right_margin ()
public subroutine add_grid (str_grid pstr_grid)
public subroutine blank_lines (integer pi_lines)
public function long add_field (string ps_display, string ps_data)
public function string rich_text ()
public subroutine add_text (string ps_text, boolean pb_highlighted)
public function str_charposition charposition ()
public subroutine delete_range (str_charrange pstr_charrange)
public subroutine delete_from_position (str_charposition pstr_charposition)
public function str_font_settings get_font_settings ()
public subroutine set_font_settings (str_font_settings pstr_font_settings)
public subroutine add_cr ()
end prototypes

public subroutine add_text (string ps_text);rtf.add_text(ps_text)

end subroutine

public subroutine add_tab ();rtf.add_tab()

end subroutine

public subroutine apply_formatting (string ps_formatting);rtf.apply_formatting(ps_formatting)

end subroutine

public subroutine delete_cr ();rtf.delete_cr()

end subroutine

public subroutine delete_last_chars (long pl_count);rtf.delete_last_chars(pl_count)

end subroutine

public subroutine delete_last_line ();rtf.delete_last_line()

end subroutine

public subroutine next_level ();rtf.next_level()

end subroutine

public subroutine prev_level ();rtf.prev_level()

end subroutine

public subroutine set_bold (boolean pb_bold);rtf.set_bold(pb_bold)

end subroutine

public subroutine set_color (long pl_color);rtf.set_color(pl_color)

end subroutine

public subroutine set_level (integer pi_level);rtf.set_level(pi_level)

end subroutine

public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin);rtf.set_margins(pl_left_margin, pl_wrap_margin, pl_right_margin)

end subroutine

public subroutine wrap_off ();rtf.wrap_off()

end subroutine

public subroutine wrap_on ();rtf.wrap_on()

end subroutine

public function long linelength ();return rtf.linelength()

end function

public function long wrap_margin ();return rtf.wrap_margin

end function

public function long left_margin ();return rtf.left_margin

end function

public function long right_margin ();return rtf.right_margin

end function

public subroutine add_grid (str_grid pstr_grid);rtf.add_grid(pstr_grid)

end subroutine

public subroutine blank_lines (integer pi_lines);rtf.blank_lines(pi_lines)

end subroutine

public function long add_field (string ps_display, string ps_data);return rtf.add_field(ps_display, ps_data)

end function

public function string rich_text ();return rtf.rich_text()

end function

public subroutine add_text (string ps_text, boolean pb_highlighted);rtf.add_text(ps_text, pb_highlighted)

end subroutine

public function str_charposition charposition ();return rtf.charposition()

end function

public subroutine delete_range (str_charrange pstr_charrange);rtf.delete_range(pstr_charrange)

end subroutine

public subroutine delete_from_position (str_charposition pstr_charposition);rtf.delete_from_position(pstr_charposition)

end subroutine

public function str_font_settings get_font_settings ();return rtf.get_font_settings()

end function

public subroutine set_font_settings (str_font_settings pstr_font_settings);rtf.set_font_settings(pstr_font_settings)

end subroutine

public subroutine add_cr ();rtf.add_cr()
end subroutine

on u_text_rtf.create
call super::create
end on

on u_text_rtf.destroy
call super::destroy
end on

