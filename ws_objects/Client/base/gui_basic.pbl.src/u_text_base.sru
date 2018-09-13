$PBExportHeader$u_text_base.sru
forward
global type u_text_base from nonvisualobject
end type
end forward

global type u_text_base from nonvisualobject
end type
global u_text_base u_text_base

type variables

end variables

forward prototypes
public subroutine add_text (string ps_text)
public subroutine wrap_off ()
public subroutine wrap_on ()
public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin)
public subroutine add_tab ()
public subroutine delete_last_chars (long pl_count)
public subroutine delete_last_line ()
public subroutine set_color (long pl_color)
public subroutine set_bold (boolean pb_bold)
public subroutine set_level (integer pi_level)
public subroutine apply_formatting (string ps_formatting)
public subroutine delete_cr ()
public subroutine delete_from_position (long pl_position)
public subroutine next_level ()
public subroutine prev_level ()
public function long linelength ()
public function long wrap_margin ()
public function long left_margin ()
public function long right_margin ()
public subroutine blank_lines (integer pi_lines)
public subroutine add_grid (str_grid pstr_grid)
public function long add_field (string ps_display, string ps_data)
public function string rich_text ()
public subroutine add_text (string ps_text, boolean pb_highlighted)
public subroutine delete_range (str_charrange pstr_charrange)
public subroutine delete_from_position (str_charposition pstr_charposition)
public function str_charposition charposition ()
public function str_font_settings get_font_settings ()
public subroutine set_font_settings (str_font_settings pstr_font_settings)
public subroutine add_cr ()
end prototypes

public subroutine add_text (string ps_text);
end subroutine

public subroutine wrap_off ();
end subroutine

public subroutine wrap_on ();
end subroutine

public subroutine set_margins (long pl_left_margin, long pl_wrap_margin, long pl_right_margin);
end subroutine

public subroutine add_tab ();add_text("~t")


end subroutine

public subroutine delete_last_chars (long pl_count);
end subroutine

public subroutine delete_last_line ();
end subroutine

public subroutine set_color (long pl_color);
end subroutine

public subroutine set_bold (boolean pb_bold);
end subroutine

public subroutine set_level (integer pi_level);
end subroutine

public subroutine apply_formatting (string ps_formatting);
end subroutine

public subroutine delete_cr ();
end subroutine

public subroutine delete_from_position (long pl_position);
end subroutine

public subroutine next_level ();

end subroutine

public subroutine prev_level ();

end subroutine

public function long linelength ();return 1

end function

public function long wrap_margin ();return 0


end function

public function long left_margin ();return 0

end function

public function long right_margin ();return 0

end function

public subroutine blank_lines (integer pi_lines);
end subroutine

public subroutine add_grid (str_grid pstr_grid);
end subroutine

public function long add_field (string ps_display, string ps_data);return 1

end function

public function string rich_text ();return ""

end function

public subroutine add_text (string ps_text, boolean pb_highlighted);
end subroutine

public subroutine delete_range (str_charrange pstr_charrange);
end subroutine

public subroutine delete_from_position (str_charposition pstr_charposition);
end subroutine

public function str_charposition charposition ();str_charposition lstr_charposition

return lstr_charposition


end function

public function str_font_settings get_font_settings ();str_font_settings lstr_font_settings

lstr_font_settings = f_empty_font_settings()

return lstr_font_settings

end function

public subroutine set_font_settings (str_font_settings pstr_font_settings);

return

end subroutine

public subroutine add_cr ();
end subroutine

on u_text_base.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_text_base.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

