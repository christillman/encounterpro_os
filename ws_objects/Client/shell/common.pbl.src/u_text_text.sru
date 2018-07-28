$PBExportHeader$u_text_text.sru
forward
global type u_text_text from u_text_base
end type
end forward

global type u_text_text from u_text_base
end type
global u_text_text u_text_text

type variables
string text

end variables

forward prototypes
public subroutine add_text (string ps_text)
public subroutine add_tab ()
public subroutine delete_cr ()
public subroutine delete_last_chars (long pl_count)
public subroutine delete_last_line ()
public function long linelength ()
public subroutine blank_lines (integer pi_lines)
public function string rich_text ()
public subroutine add_text (string ps_text, boolean pb_highlighted)
public function str_charposition charposition ()
public subroutine delete_range (str_charrange pstr_charrange)
public subroutine delete_from_position (str_charposition pstr_charposition)
public function long add_field (string ps_display, string ps_data)
public subroutine add_cr ()
end prototypes

public subroutine add_text (string ps_text);text += ps_text
end subroutine

public subroutine add_tab ();text += "~t"
end subroutine

public subroutine delete_cr ();string ls_text
long ll_pos

// Find the last "~r~n"
ll_pos = lastpos(text, "~r~n")

if ll_pos > 0 then
	text = left(text, ll_pos - 1)
end if


end subroutine

public subroutine delete_last_chars (long pl_count);text = left(text, len(text) - pl_count)

end subroutine

public subroutine delete_last_line ();delete_cr()

end subroutine

public function long linelength ();string ls_text
long ll_pos

// Find the last "~r~n"
ll_pos = lastpos(text, "~r~n")

if ll_pos > 0 then
	return len(text) - ll_pos - 2
else
	return len(text)
end if


end function

public subroutine blank_lines (integer pi_lines);if right(text, 2) = "~r~n" then return
text += "~r~n"

end subroutine

public function string rich_text ();return text

end function

public subroutine add_text (string ps_text, boolean pb_highlighted);text += ps_text
end subroutine

public function str_charposition charposition ();str_charposition lstr_charposition

lstr_charposition.line_number = 0
lstr_charposition.char_position = len(text)

return lstr_charposition

end function

public subroutine delete_range (str_charrange pstr_charrange);long ll_startpos
long ll_endpos

ll_startpos = pstr_charrange.from_position.char_position
ll_endpos = pstr_charrange.to_position.char_position


text = replace(text, ll_startpos + 1, ll_endpos - ll_startpos, "")

end subroutine

public subroutine delete_from_position (str_charposition pstr_charposition);text = left(text, pstr_charposition.char_position - 1)


end subroutine

public function long add_field (string ps_display, string ps_data);text += ps_display
return 0

end function

public subroutine add_cr ();text += "~r~n"

end subroutine

on u_text_text.create
call super::create
end on

on u_text_text.destroy
call super::destroy
end on

