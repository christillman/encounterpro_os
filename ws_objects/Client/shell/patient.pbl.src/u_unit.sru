$PBExportHeader$u_unit.sru
forward
global type u_unit from nonvisualobject
end type
end forward

global type u_unit from nonvisualobject
end type
global u_unit u_unit

type prototypes
FUNCTION long GetForegroundWindow() library "user32.dll"

end prototypes

type variables
string unit_id
string description
string unit_type
string plural_flag
string print_unit
string abbreviation
string display_mask
string prefix

boolean display_minor_units
string major_unit_display_suffix
string minor_unit_display_suffix
string major_unit_input_suffixes
string minor_unit_input_suffixes
long multiplier

string this_unit_preference

string metric_unit
string english_unit
real conversion_factor
real conversion_difference

end variables
forward prototypes
public subroutine convert_to_metric (real pr_amount, ref real pr_metric_amount, ref string ps_metric_unit)
public subroutine convert_from_metric (real pr_metric_amount, ref real pr_amount)
public function string plural_description ()
public subroutine convert_from_english (real pr_english_amount, ref real pr_amount)
public function string pretty_unit (string ps_unit_preference, ref string ps_pretty_unit_id)
public subroutine convert_to_english (real pr_amount, ref real pr_english_amount, ref string ps_english_unit)
public function integer load_metric_conversion ()
public function string get_value (string ps_value)
public function string convert (string ps_to_unit_id, string ps_value)
public function string get_value (string ps_value, string ps_specific, string ps_generic)
public function str_amount_unit get_value_and_unit (string ps_value, string ps_specific, string ps_generic, boolean pb_unit_editable)
public function string pretty_number (real pr_amount, string ps_display_mask)
public function string pretty_amount_unit (real pr_amount, string ps_unit_preference, string ps_display_mask)
public function string pretty_amount (real pr_amount, string ps_unit_preference, string ps_display_mask)
public function string pretty_amount_unit (real pr_amount)
public function string pretty_date (string ps_date, string ps_display_mask)
public function string pretty_unit (long pl_amount)
public function string pretty_unit (real pr_amount)
public function string pretty_unit (string ps_amount)
public function string pretty_amount (real pr_amount)
public function string pretty_amount (string ps_amount)
public function string pretty_amount (string ps_amount, string ps_unit_preference, string ps_display_mask)
public function string pretty_amount_unit (string ps_amount)
public function string pretty_amount_unit (string ps_amount, string ps_unit_preference, string ps_display_mask)
public function string pretty_amount (real pr_amount, string ps_unit_preference)
public function string pretty_amount_unit (real pr_amount, string ps_unit_preference)
public function string convert (string ps_to_unit_id, string ps_value, string ps_display_mask)
public function str_amount_unit get_value_and_unit (string ps_value, string ps_specific, string ps_generic, boolean pb_unit_editable, string ps_prompt)
public function integer check_value (ref string ps_value)
public function string interpret_compound_number (string ps_value, string ps_major_suffixes, string ps_minor_suffixes, long pl_multiplier)
public subroutine split_numbers (string ps_value, ref long pl_left_number, ref string ps_left_suffix, ref decimal pdc_right_number, ref string ps_right_suffix)
public function string pretty_number (real pr_amount, string ps_display_mask, boolean pb_use_minor_units)
public function string convert (string ps_to_unit_id, string ps_value, string ps_display_mask, boolean pb_use_minor_units)
end prototypes

public subroutine convert_to_metric (real pr_amount, ref real pr_metric_amount, ref string ps_metric_unit);real lr_temp

ps_metric_unit = metric_unit

if isnull(pr_amount) then
	setnull(lr_temp)
elseif isnull(metric_unit) then
	lr_temp = pr_amount
elseif unit_id = english_unit then
	if conversion_factor > 0 then
		lr_temp = (pr_amount - conversion_difference) / conversion_factor
	else
		lr_temp = 0
	end if
else
	lr_temp = pr_amount
end if

pr_metric_amount = lr_temp
end subroutine

public subroutine convert_from_metric (real pr_metric_amount, ref real pr_amount);real lr_temp

if isnull(metric_unit) then
	lr_temp = pr_metric_amount
elseif isnull(pr_metric_amount) then
	setnull(lr_temp)
elseif unit_id = english_unit then
	lr_temp = (pr_metric_amount * conversion_factor) + conversion_difference
else
	lr_temp = pr_metric_amount
end if

pr_amount = lr_temp

end subroutine

public function string plural_description ();string ls_s
string ls_description

ls_description = description

CHOOSE CASE plural_flag
	CASE "Y"
		ls_description += "s"
	CASE "I"
		// Change ending "y" to "ies", maintianing case
		if right(ls_description, 1) = "y" then
			ls_description = left(ls_description, len(ls_description) - 1) + "ies"
		elseif right(ls_description, 1) = "Y" then
			ls_description = left(ls_description, len(ls_description) - 1) + "IES"
		else
			ls_description += "s"
		end if
	CASE "E"
		ls_description += "es"
END CHOOSE

return ls_description


end function

public subroutine convert_from_english (real pr_english_amount, ref real pr_amount);real lr_temp

if isnull(metric_unit) then
	lr_temp = pr_english_amount
elseif isnull(pr_english_amount) then
	setnull(lr_temp)
elseif unit_id = metric_unit then
	if conversion_factor > 0 then
		lr_temp = (pr_english_amount - conversion_difference) / conversion_factor
	else
		lr_temp = 0
	end if
else
	lr_temp = pr_english_amount
end if

pr_amount = lr_temp

end subroutine

public function string pretty_unit (string ps_unit_preference, ref string ps_pretty_unit_id);string ls_value
u_unit luo_unit

if isnull(ps_unit_preference) then ps_unit_preference = unit_preference

if upper(ps_unit_preference) = "ENGLISH" and this_unit_preference = "METRIC" then
	luo_unit = unit_list.find_unit(english_unit)
	if isnull(luo_unit) then
		log.log(this, "u_unit.pretty_unit:0009", "Unable to find english unit (" + english_unit + ")", 4)
		return ""
	end if
elseif upper(ps_unit_preference) = "METRIC" and this_unit_preference = "ENGLISH" then
	luo_unit = unit_list.find_unit(metric_unit)
	if isnull(luo_unit) then
		log.log(this, "u_unit.pretty_unit:0015", "Unable to find english unit (" + metric_unit + ")", 4)
		return ""
	end if
else
	luo_unit = this
end if

ps_pretty_unit_id = luo_unit.unit_id
ls_value = ""

return luo_unit.pretty_unit(ls_value)


end function

public subroutine convert_to_english (real pr_amount, ref real pr_english_amount, ref string ps_english_unit);real lr_temp

ps_english_unit = english_unit
if isnull(pr_amount) then
	setnull(lr_temp)
elseif isnull(metric_unit) then
	lr_temp = pr_amount
elseif unit_id = metric_unit then
	lr_temp = (pr_amount * conversion_factor) + conversion_difference
else
	lr_temp = pr_amount
end if

pr_english_amount = lr_temp

end subroutine

public function integer load_metric_conversion ();real lr_conversion_factor
real lr_conversion_difference
integer li_sts
string ls_unit_from_metric_flag
string ls_unit_from
string ls_unit_to

  SELECT unit_from,
  			unit_to,
  			conversion_factor,
			conversion_difference,
			unit_from_metric_flag
    INTO :ls_unit_from,
	 		:ls_unit_to,
	 		:lr_conversion_factor,
			:lr_conversion_difference,
			:ls_unit_from_metric_flag
    FROM c_unit_conversion (NOLOCK)
   WHERE unit_from_metric_flag = 'Y'
	AND	( c_unit_conversion.unit_from = :unit_id  
          OR c_unit_conversion.unit_to = :unit_id )   ;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then
	setnull(metric_unit)
	setnull(english_unit)
	setnull(conversion_factor)
	setnull(conversion_difference)
	li_sts = 0
else
	metric_unit = ls_unit_from
	english_unit = ls_unit_to
	conversion_factor = lr_conversion_factor
	conversion_difference = lr_conversion_difference
	li_sts = 1
end if

if metric_unit = unit_id then
	this_unit_preference = "METRIC"
elseif english_unit = unit_id then
	this_unit_preference = "ENGLISH"
else
	setnull(this_unit_preference)
end if

return li_sts

end function

public function string get_value (string ps_value);string ls_generic
string ls_specific

setnull(ls_generic)
setnull(ls_specific)

return get_value(ps_value, ls_generic, ls_specific)


end function

public function string convert (string ps_to_unit_id, string ps_value);u_unit luo_unit

luo_unit = unit_list.find_unit(ps_to_unit_id)
if isnull(luo_unit) then
	log.log(this, "u_unit.convert:0005", "Error finding unit (" + ps_to_unit_id + ")", 4)
	return ps_value
end if

return convert(ps_to_unit_id, ps_value, luo_unit.display_mask)

end function

public function string get_value (string ps_value, string ps_specific, string ps_generic);str_amount_unit lstr_amount_unit

lstr_amount_unit = get_value_and_unit(ps_value, ps_specific, ps_generic, false)

return lstr_amount_unit.amount

end function

public function str_amount_unit get_value_and_unit (string ps_value, string ps_specific, string ps_generic, boolean pb_unit_editable);return get_value_and_unit(ps_value, ps_specific, ps_generic, pb_unit_editable, "")

end function

public function string pretty_number (real pr_amount, string ps_display_mask);return pretty_number(pr_amount, ps_display_mask, true)

end function

public function string pretty_amount_unit (real pr_amount, string ps_unit_preference, string ps_display_mask);string ls_s
string ls_amount
real lr_amount
string ls_unit
u_unit luo_unit

if isnull(ps_unit_preference) then ps_unit_preference = unit_preference

// First convert to the desired unit preference
if upper(ps_unit_preference) = "ENGLISH" and this_unit_preference = "METRIC" then
	convert_to_english(pr_amount, lr_amount, ls_unit)
elseif upper(ps_unit_preference) = "METRIC" and this_unit_preference = "ENGLISH" then
	convert_to_metric(pr_amount, lr_amount, ls_unit)
else
	lr_amount = pr_amount
	ls_unit = unit_id
end if

// Find the desired unit object and get the pretty string
if ls_unit = unit_id then
	luo_unit = this
else
	luo_unit = unit_list.find_unit(ls_unit)
	if isnull(luo_unit) then luo_unit = this
end if

ls_amount = luo_unit.pretty_number(lr_amount, ps_display_mask)

if isnull(ls_amount) then return ls_amount

if print_unit = "Y" then
	ls_unit = luo_unit.pretty_unit(ls_amount)
	if ls_unit <> "" then ls_amount += " " + ls_unit
end if

if not isnull(prefix) then ls_amount = prefix + ls_amount

return ls_amount

end function

public function string pretty_amount (real pr_amount, string ps_unit_preference, string ps_display_mask);string ls_s
string ls_amount
real lr_amount
string ls_unit
u_unit luo_unit

if isnull(ps_unit_preference) then ps_unit_preference = unit_preference

// First convert to the desired unit preference
if upper(ps_unit_preference) = "ENGLISH" and this_unit_preference = "METRIC" then
	convert_to_english(pr_amount, lr_amount, ls_unit)
elseif upper(ps_unit_preference) = "METRIC" and this_unit_preference = "ENGLISH" then
	convert_to_metric(pr_amount, lr_amount, ls_unit)
else
	lr_amount = pr_amount
	ls_unit = unit_id
end if

// Find the desired unit object and get the pretty string
if ls_unit = unit_id then
	luo_unit = this
else
	luo_unit = unit_list.find_unit(ls_unit)
	if isnull(luo_unit) then luo_unit = this
end if

ls_amount = luo_unit.pretty_number(lr_amount, ps_display_mask)

return ls_amount

end function

public function string pretty_amount_unit (real pr_amount);return pretty_amount_unit(pr_amount, this_unit_preference, display_mask)

end function

public function string pretty_date (string ps_date, string ps_display_mask);string ls_null
date ld_date
string ls_date

setnull(ls_null)

// If the amount to print is null then the result is null
if isnull(ps_date) then return ls_null

// Make sure it's a date
if not isdate(ps_date) then return ls_null

ld_date = date(ps_date)

// If a display_mask isn't passed in, then use the default mask for this unit
if isnull(ps_display_mask) then ps_display_mask = display_mask

if isnull(ps_display_mask) then
	ls_date = string(ld_date)
else
	ls_date = string(ld_date, ps_display_mask)
end if

if not isnull(prefix) then ls_date = prefix + ls_date

return ls_date

end function

public function string pretty_unit (long pl_amount);string ls_amount

ls_amount = string(pl_amount)

return pretty_unit(ls_amount)

end function

public function string pretty_unit (real pr_amount);string ls_amount

ls_amount = pretty_number(pr_amount, display_mask)

return pretty_unit(ls_amount)

end function

public function string pretty_unit (string ps_amount);string ls_s
string ls_description

ls_description = description

if isnull(ps_amount) then return ls_description

if integer(ps_amount) <> 1 then
	CHOOSE CASE plural_flag
		CASE "Y"
			ls_description += "s"
		CASE "I"
			// Change ending "y" to "ies", maintianing case
			if right(ls_description, 1) = "y" then
				ls_description = left(ls_description, len(ls_description) - 1) + "ies"
			elseif right(ls_description, 1) = "Y" then
				ls_description = left(ls_description, len(ls_description) - 1) + "IES"
			else
				ls_description += "s"
			end if
		CASE "E"
			ls_description += "es"
	END CHOOSE
end if

return ls_description

end function

public function string pretty_amount (real pr_amount);
return pretty_amount(pr_amount, this_unit_preference, display_mask)

end function

public function string pretty_amount (string ps_amount);
return pretty_amount(ps_amount, this_unit_preference, display_mask)

end function

public function string pretty_amount (string ps_amount, string ps_unit_preference, string ps_display_mask);real lr_amount
long ll_amount
string ls_amount

if isnull(ps_amount) then return ps_amount

if isnull(ps_unit_preference) then ps_unit_preference = unit_preference

CHOOSE CASE upper(unit_type)
	CASE "NUMBER"
		lr_amount = real(ps_amount)
		ls_amount = pretty_amount(lr_amount, ps_unit_preference, ps_display_mask)
		if isnull(ls_amount) then return ls_amount
	CASE "DATE"
		ls_amount = pretty_date(ps_amount, ps_display_mask)
	CASE ELSE
		ls_amount = trim(ps_amount)
END CHOOSE

return ls_amount

end function

public function string pretty_amount_unit (string ps_amount);
return pretty_amount_unit(ps_amount, this_unit_preference, display_mask)

end function

public function string pretty_amount_unit (string ps_amount, string ps_unit_preference, string ps_display_mask);real lr_amount
long ll_amount
string ls_amount
string ls_unit

if isnull(ps_amount) then return ps_amount

if isnull(ps_unit_preference) then ps_unit_preference = unit_preference

CHOOSE CASE upper(unit_type)
	CASE "NUMBER"
		lr_amount = real(ps_amount)
		return pretty_amount_unit(lr_amount, ps_unit_preference, ps_display_mask)
	CASE "DATE"
		ls_amount = pretty_date(ps_amount, ps_display_mask)
	CASE ELSE
		ls_amount = trim(ps_amount)
END CHOOSE

if ls_unit <> "" and print_unit = "Y" then ls_amount += " " + ls_unit

return ls_amount

end function

public function string pretty_amount (real pr_amount, string ps_unit_preference);
return pretty_amount(pr_amount, ps_unit_preference, display_mask)

end function

public function string pretty_amount_unit (real pr_amount, string ps_unit_preference);return pretty_amount_unit(pr_amount, ps_unit_preference, display_mask)

end function

public function string convert (string ps_to_unit_id, string ps_value, string ps_display_mask);return convert(ps_to_unit_id, ps_value, ps_display_mask, true)

end function

public function str_amount_unit get_value_and_unit (string ps_value, string ps_specific, string ps_generic, boolean pb_unit_editable, string ps_prompt);integer li_sts
date ld_date
real lr_amount
long ll_amount
string ls_amount
str_popup popup
str_popup_return popup_return
u_unit luo_unit
str_amount_unit lstr_amount_unit
w_window_base lw_window
long ll_whandle
boolean lb_IsWindowEnabled
string ls_value

ll_whandle = getforegroundwindow()
lb_IsWindowEnabled = IsWindowEnabled(ll_whandle)

lstr_amount_unit.amount = ps_value
lstr_amount_unit.unit = unit_id

if pb_unit_editable then popup.item = "EDITUNIT"

setnull(luo_unit)

popup.argument_count = 0

if not isnull(ps_specific) then
	popup.argument_count += 1
	popup.argument[popup.argument_count] = ps_specific
end if

if not isnull(ps_generic) then
	popup.argument_count += 1
	popup.argument[popup.argument_count] = ps_generic
end if

if not isnull(prefix) then
	if left(ps_value, len(prefix)) = prefix then
		ps_value = mid(ps_value, len(prefix) + 1)
	end if
end if

CHOOSE CASE unit_type
	CASE "NUMBER"
		ls_value = ps_value
		li_sts = check_value(ls_value)
		if li_sts < 0 then
			setnull(ls_value)
		end if
		popup.realitem = real(ls_value)
		popup.objectparm = this
		popup.title = ps_prompt

		openwithparm(w_number, popup)
		popup_return = message.powerobjectparm
		if popup_return.item = "CANCEL" then return lstr_amount_unit
		
//		lr_amount = popup_return.realitem
//		ls_amount = pretty_number(lr_amount, display_mask)
		// preserve the original data entry
		ls_amount = popup_return.rawdata
		luo_unit = popup_return.returnobject
	CASE "DATE"
		if isnull(ps_value) or trim(ps_value) = "" then
			ld_date = today()
		else
			ld_date = date(ps_value)
			if ld_date < date("1/1/1910") then ld_date = today()
		end if
		if isnull(ps_prompt) or trim(ps_prompt) = "" then ps_prompt = "Select Date"
		ls_amount = f_select_date(ld_date, ps_prompt)
	CASE "STRING"
		if isnull(ps_prompt) or trim(ps_prompt) = "" then
			popup.title = description
		else
			popup.title = ps_prompt
		end if
		popup.objectparm = this
		popup.item = ps_value
		popup.displaycolumn = 40 // 40 characters max
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return lstr_amount_unit

		ls_amount = trim(popup_return.items[1])
	CASE ELSE
		ls_amount = trim(ps_value)
END CHOOSE

lstr_amount_unit.amount = ls_amount

if isnull(luo_unit) then
	lstr_amount_unit.unit = unit_id
else
	lstr_amount_unit.unit = luo_unit.unit_id
end if

if lb_IsWindowEnabled then EnableWindow(ll_whandle, true)

return lstr_amount_unit

end function

public function integer check_value (ref string ps_value);string ls_value

// Work with a local copy for now
ls_value = ps_value

// If there's a prefix and it matches the beginning of the value, then remove it
if not isnull(prefix) then
	if left(ls_value, len(prefix)) = prefix then
		ls_value = mid(ls_value, len(prefix) + 1)
	end if
end if

CHOOSE CASE unit_type
	CASE "NUMBER"
		if not isnumber(ls_value) and multiplier > 0 then
			// If the value doesn't look like a number, then try to interpret
			// it as a compound number
			ls_value = interpret_compound_number(ls_value, major_unit_input_suffixes, minor_unit_input_suffixes, multiplier)
		end if
		ps_value = ls_value
	CASE "DATE"
		if not isdate(ls_value) then
		end if
		ps_value = ls_value
	CASE "STRING"
		return 1
	CASE ELSE
		return 1
END CHOOSE

return 1

end function

public function string interpret_compound_number (string ps_value, string ps_major_suffixes, string ps_minor_suffixes, long pl_multiplier);long ll_left_number
string ls_left_suffix
decimal{1} ldc_right_number
string ls_right_suffix
long ll_major = 0
decimal{1} ldc_minor = 0
string lsa_major_suffixes[]
integer li_major_count
string lsa_minor_suffixes[]
integer li_minor_count
long i
string ls_value
boolean lb_found
long ll_sign
decimal{3} ldc_amount

split_numbers(ps_value, ll_left_number, ls_left_suffix, ldc_right_number, ls_right_suffix)

ls_left_suffix = lower(ls_left_suffix)
ls_right_suffix = lower(ls_right_suffix)

li_major_count = f_parse_string(ps_major_suffixes, ",", lsa_major_suffixes)
li_minor_count = f_parse_string(ps_major_suffixes, ",", lsa_minor_suffixes)


// Process the left number
lb_found = false
for i = 1 to li_major_count
	if lower(lsa_major_suffixes[i]) = left(ls_left_suffix, len(lsa_major_suffixes[i])) then
		ll_major = ll_left_number
		lb_found = true
	end if
next

if not lb_found then
	for i = 1 to li_minor_count
		if lower(lsa_minor_suffixes[i]) = left(ls_left_suffix, len(lsa_minor_suffixes[i])) then
			ldc_minor = ll_left_number
			lb_found = true
		end if
	next
end if

// If we didn't match any suffixes then assume the left number is the major number
if not isnull(ll_left_number) and not lb_found then ll_major = ll_left_number


// Process the right number
lb_found = false
for i = 1 to li_major_count
	if lower(lsa_major_suffixes[i]) = left(ls_right_suffix, len(lsa_major_suffixes[i])) then
		ll_major = long(ldc_right_number)
		lb_found = true
	end if
next

if not lb_found then
	for i = 1 to li_minor_count
		if lower(lsa_minor_suffixes[i]) = left(ls_right_suffix, len(lsa_minor_suffixes[i])) then
			ldc_minor = ldc_right_number
			lb_found = true
		end if
	next
end if

// If we didn't match any suffixes then assume the right number is the minor number
if not isnull(ldc_right_number) and not lb_found then ldc_minor = ldc_right_number

// get the sign from the major
if ll_major <> 0 then
	ll_sign = sign(ll_major)
else
	ll_sign = sign(ldc_minor)
end if

ldc_amount = ll_sign * (abs(ll_major) + (abs(ldc_minor) / pl_multiplier))

ls_value = string(ldc_amount)

return ls_value


end function

public subroutine split_numbers (string ps_value, ref long pl_left_number, ref string ps_left_suffix, ref decimal pdc_right_number, ref string ps_right_suffix);integer i

ps_value = trim(ps_value)

setnull(pl_left_number)
setnull(ps_left_suffix)
setnull(pdc_right_number)
setnull(ps_right_suffix)

for i = 1 to len(ps_value)
	if not isnumber(left(ps_value, i)) then
		// Remove the number found
		pl_left_number = long(left(ps_value, i - 1))
		ps_value = mid(ps_value, i)
		exit
	end if
next

// If we got through without setting the left number, then the entire
// string must be a number
if isnull(pl_left_number) then
	pl_left_number = long(ps_value)
end if

// Pick off the left "suffix" by finding the next number
for i = 1 to len(ps_value)
	if isnumber(mid(ps_value, i, 1)) then
		ps_left_suffix = left(ps_value, i - 1)
		ps_value = mid(ps_value, i)
		exit
	end if
next

// If we got through without setting the left suffix, then the entire
// string must be the left suffix
if isnull(ps_left_suffix) then
	ps_left_suffix = ps_value
	return
end if

for i = 1 to len(ps_value)
	if not isnumber(left(ps_value, i)) then
		// Remove the number found
		pdc_right_number = dec(left(ps_value, i - 1))
		ps_right_suffix = mid(ps_value, i)
		return
	end if
next

// If we got through without finding the end of the right number, then
// the entire string must be the right number
pdc_right_number = dec(ps_value)
setnull(ps_right_suffix)

end subroutine

public function string pretty_number (real pr_amount, string ps_display_mask, boolean pb_use_minor_units);integer li_integer, li_pos, li_sts
real lr_fraction
string ls_plural_flag
string ls_fraction, ls_amount, ls_unit, ls_null
real lr_half_unit
integer i
decimal{1} ldc_minor

setnull(ls_null)

// If the amount to print is null then the result is null
if isnull(pr_amount) then return ls_null

// If a display_mask isn't passed in, then use the default mask for this unit
if isnull(ps_display_mask) then ps_display_mask = display_mask

if display_minor_units and pb_use_minor_units then
	li_integer = int(pr_amount)
	lr_fraction = abs(pr_amount) - abs(li_integer)
	if lr_fraction = 0 then
		ls_fraction = ""
	else
		ldc_minor = lr_fraction * multiplier
		ls_fraction = string(ldc_minor, "##.#")
		if right(ls_fraction, 1) = "." then ls_fraction = left(ls_fraction, len(ls_fraction) - 1)
	end if
	
	ls_amount = ""
	if li_integer <> 0 then
		ls_amount = string(li_integer) + major_unit_display_suffix
	end if
	if len(ls_fraction) > 0 then
		if len(ls_amount) > 0 then ls_amount += " "
		ls_amount += ls_fraction + minor_unit_display_suffix
	end if
else
	CHOOSE CASE ps_display_mask
		CASE "QUARTER"
			li_integer = int(pr_amount)
			lr_fraction = pr_amount - li_integer
			if lr_fraction <= (1 / 8) then
				ls_fraction = ""
				pr_amount = li_integer
			elseif lr_fraction <= (3 / 8) then
				ls_fraction = "1/4"
				pr_amount = li_integer + (1 / 4)
			elseif lr_fraction <= (5 / 8) then
				ls_fraction = "1/2"
				pr_amount = li_integer + (1 / 2)
			elseif lr_fraction <= (7 / 8) then
				ls_fraction = "3/4"
				pr_amount = li_integer + (3 / 4)
			else
				ls_fraction = ""
				li_integer = li_integer + 1
				pr_amount = li_integer
			end if
	
			if li_integer > 0 then
				if ls_fraction = "" then
					ls_amount = string(li_integer)
				else
					ls_amount = string(li_integer) + " " + ls_fraction
				end if
			else
				ls_amount = ls_fraction
			end if
		CASE "HALF"
			li_integer = int(pr_amount)
			lr_fraction = pr_amount - li_integer
			if lr_fraction <= (1 / 4) then
				ls_fraction = ""
				pr_amount = li_integer
			elseif lr_fraction <= (3 / 4) then
				ls_fraction = "1/2"
				pr_amount = li_integer + (1 / 2)
			else
				ls_fraction = ""
				li_integer = li_integer + 1
				pr_amount = li_integer
			end if
	
			if li_integer > 0 then
				if ls_fraction = "" then
					ls_amount = string(li_integer)
				else
					ls_amount = string(li_integer) + " " + ls_fraction
				end if
			else
				ls_amount = ls_fraction
			end if
		CASE ELSE
			if isnull(ps_display_mask) then
				ls_amount = string(pr_amount)
			else
				ls_amount = string(pr_amount, ps_display_mask)
			end if
	END CHOOSE
end if

// Suppress a decimal point if it's at the end
if right(ls_amount, 1) = "." then
	ls_amount = left(ls_amount, len(ls_amount) - 1)
end if

return ls_amount

end function

public function string convert (string ps_to_unit_id, string ps_value, string ps_display_mask, boolean pb_use_minor_units);real lr_conversion_factor
real lr_conversion_difference
integer li_sts
real lr_from_value
real lr_to_value
string ls_value
u_unit luo_unit

// If this unit isn't numeric then we don't convert it, we just return the value
if lower(unit_type) <> "number" then
	return ps_value
end if

luo_unit = unit_list.find_unit(ps_to_unit_id)
if isnull(luo_unit) then
	log.log(this, "u_unit.convert:0016", "Error finding unit (" + ps_to_unit_id + ")", 4)
	return ps_value
end if

// Check the value before converting it to a real
ls_value = ps_value
li_sts = check_value(ls_value)
if li_sts < 0 then
	setnull(ls_value)
end if
lr_from_value = real(ls_value)

if unit_id = ps_to_unit_id then
	return pretty_number(lr_from_value, ps_display_mask, pb_use_minor_units)
end if

if ps_to_unit_id = english_unit then
	convert_to_english(lr_from_value, lr_to_value, ps_to_unit_id)
	ls_value = luo_unit.pretty_number(lr_to_value, ps_display_mask, pb_use_minor_units)
	return ls_value
end if

if ps_to_unit_id = metric_unit then
	convert_to_metric(lr_from_value, lr_to_value, ps_to_unit_id)
	ls_value = luo_unit.pretty_number(lr_to_value, ps_display_mask, pb_use_minor_units)
	return ls_value
end if

// If it's not an english or metric conversion, then look up the conversion factor
li_sts = tf_get_conversion(unit_id, ps_to_unit_id, lr_conversion_factor, lr_conversion_difference)

if li_sts > 0 then
	lr_to_value = (lr_from_value * lr_conversion_factor) + lr_conversion_difference
	ls_value = luo_unit.pretty_number(lr_to_value, ps_display_mask, pb_use_minor_units)
	return ls_value
elseif li_sts = 0 then
	li_sts = tf_get_conversion(ps_to_unit_id, unit_id, lr_conversion_factor, lr_conversion_difference)
	if li_sts > 0 then
		if lr_conversion_factor > 0 then
			lr_to_value = (lr_from_value - lr_conversion_difference) / lr_conversion_factor
		else
			lr_to_value = 0
		end if
		
		ls_value = luo_unit.pretty_number(lr_to_value, ps_display_mask, pb_use_minor_units)
		return ls_value
	end if
end if

return ps_value

end function

on u_unit.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_unit.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

