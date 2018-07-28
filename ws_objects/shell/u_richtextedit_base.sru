HA$PBExportHeader$u_richtextedit_base.sru
forward
global type u_richtextedit_base from richtextedit
end type
end forward

global type u_richtextedit_base from richtextedit
integer width = 494
integer height = 360
integer taborder = 10
integer textsize = -12
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean init_hscrollbar = true
boolean init_pictureframe = true
borderstyle borderstyle = stylelowered!
boolean resizable = true
event ue_postconstructor ( )
end type
global u_richtextedit_base u_richtextedit_base

type prototypes
protected:
// these become obsolete pb 10.5
//function integer GETCOLORLOGFONT( ulong hwnd, ulong msg, ulong wparm, &
//	ref s_colorlogfont clf ) library 'user32.dll' alias for "SendMessageW"
//function integer SETCOLORLOGFONT( ulong hwnd, ulong msg, ulong wparm, &
//	s_colorlogfont clf ) library 'user32.dll' alias for "SendMessageW"
function ulong FindWindow ( ref string lpClassName, ref string lpWindowName ) &
	library "user32.dll" alias for "FindWindowW"
function ulong FindWindow ( ref string lpClassName, long lpWindowName ) &
	library "user32.dll" alias for "FindWindowW"
function ulong GetWindow ( ulong handle, uint uCmd ) library "USER32.DLL"
FUNCTION int GetClassNameA(ulong hwnd, ref string  lpClassName, int length)  Library "user32.dll" alias for "GetClassNameW"

function long GetDC (long hWnd) LIBRARY "USER32.DLL"
function ulong GetDeviceCaps(ulong hDC, ulong nIndex) LIBRARY "GDI32.DLL"
/***************************************************************
* By			: mjw
* Date		: 2007
* Purpose	: new api functions for unicode
* CR#			: 
***************************************************************/
function long ReleaseDC (long hWnd, long hDC) LIBRARY "USER32.DLL"
function long ColorLogFont105 ( long hWnd, ulong Msg, ulong wParam, ref s_logfont clf )  Library "user32.dll" Alias For "SendMessageW"
function long GetLogFont105( uLong hFont, int cbBuffer, Ref s_logfont clf ) Library "gdi32.dll" Alias For "GetObjectW"
function long GetLogFont1052( uLong hWin, ulong Msg, ulong wParam, Ref s_colorlogfont clf ) Library "user32.dll" Alias For "SendMessageW"
function long GetCurrentObject (uLong hDC, uint ObjectType) Library "gdi32.dll" Alias for "GetCurrentObject;Ansi"
end prototypes

type variables
/***************************************************************
* By			: mjw
* Date		: 2007
* Purpose	: setlogfontmsg changed, control name changed, constants for getcurrentobject
* CR#			: 
**************************************************************/
public:

//protectedwrite	
string	is_font

protected:

//constant	ulong	getlogfontmsg = 1024 + 296
constant	ulong	getlogfontmsg= 4240	

//constant	ulong	setlogfontmsg = 1024 + 298
constant ulong setlogfontmsg = 3092 

constant	ulong	setfont = 64
constant ulong setfontsize = 128
//constant	string	classname =  "PB100RichTextEdit" obsolete 10.5
constant string   classname = "PBTxTextControl"
s_colorlogfont	is_colorlogfont 
s_logfont is_logfont
ulong		iul_handle

constant	integer LOGPIXELSY = 90

constant	integer FONT_DISPLAY	= 0
constant	integer FONT_PRINTER = 1
constant	integer FONT_LOGICAL = 2

constant	integer FONT_TYP		= 15
constant	integer FONT_SET     = 240


//constants for getcurrentobject from wingdi.h
constant uint OBJ_PEN = 1
constant uint OBJ_BRUSH = 2
constant uint OBJ_DC = 3
constant uint OBJ_METADC = 4
constant uint OBJ_PAL = 5
constant uint OBJ_FONT = 6
constant uint OBJ_BITMAP = 7
constant uint OBJ_REGION  = 8
constant uint OBJ_METAFILE = 9
constant uint OBJ_MEMDC = 10
constant uint OBJ_EXTPEN = 11
constant uint OBJ_ENHMETADC = 12
constant uint OBJ_ENHMETAFILE = 13


constant byte DEFAULT_PITCH =  0
constant byte FIXED_PITCH  =  1
constant byte VARIABLE_PITCH  =  2


/* Font Families */
constant uint FF_DONTCARE   =  0 //  (0<<4)  /* Don't care or don't know. */
constant uint FF_ROMAN     =  16 // (1<<4) 0001 0000  /* Variable stroke width, serifed. */
                                    /* Times Roman, Century Schoolbook, etc. */
constant uint FF_SWISS   =  32 //(2<<4) 0010 0000  /* Variable stroke width, sans-serifed. */
                                    /* Helvetica, Swiss, etc. */
constant uint FF_MODERN  = 48  // (3<<4) 0011 0000 /* Constant stroke width, serifed or sans-serifed. */
                                    /* Pica, Elite, Courier, etc. */
constant uint FF_SCRIPT  =  64  // (4<<4) 0100 000 /* Cursive, etc. */
constant uint FF_DECORATIVE = 80  //0101 0000 (5<<4)  /* Old English, etc. */

/* Font Weights */
constant long FW_DONTCARE   =      0
constant long FW_THIN       =      100
constant long FW_EXTRALIGHT =      200
constant long FW_LIGHT      =      300
constant long FW_NORMAL     =      400
constant long FW_MEDIUM     =      500
constant long FW_SEMIBOLD   =      600
constant long FW_BOLD       =      700
constant long FW_EXTRABOLD  =      800
constant long FW_HEAVY      =      900

constant long FW_ULTRALIGHT  =     FW_EXTRALIGHT
constant long FW_REGULAR     =     FW_NORMAL
constant long FW_DEMIBOLD    =     FW_SEMIBOLD
constant long FW_ULTRABOLD   =     FW_EXTRABOLD
constant long FW_BLACK       =     FW_HEAVY

end variables

forward prototypes
public function integer of_setfont (string as_fontname)
protected function unsignedlong of_findrte ()
protected function integer of_getfont ()
public function integer of_getfontsize (integer ai_points)
public function integer of_setfontsize (integer ai_points)
public function integer of_underline (integer ai_onoff)
public function integer of_italics (integer ai_onoff)
public function integer of_strikeout (integer ai_onoff)
public function integer of_orientation (integer ai_angle)
public function integer of_escapement (integer ai_angle)
public function integer of_weight (integer ai_weight)
public function integer of_pitchandfamily ()
public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit)
public function long of_bitwiseor (long al_value1, long al_value2)
end prototypes

event ue_postconstructor;iul_handle = of_findrte()
of_getfont()


end event

public function integer of_setfont (string as_fontname);/***************************************************************
* By			: mjw
* Date		: 2007
* Purpose	: changed call to new format removed select all
* CR#			: 
***************************************************************/
integer				li_rc

IF as_fontname = '' THEN Return 0

//Set the new font
//this.setredraw ( FALSE )

//this.SelectTextAll ( Detail! )  // removed this to only change the selected text
//is_colorlogfont.lf.lffacename[] = as_fontname
//li_rc = SetColorLogFont ( iul_handle, setlogfontmsg, setfont, is_colorlogfont )

of_getfont() // get the current font info
is_logfont.lffacename = as_fontname + char(0)
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 

//this.setredraw ( TRUE )


//Make sure it took 
of_getfont()

Return li_rc
end function

protected function unsignedlong of_findrte ();ulong		lul_hndl
string	ls_class
integer	li_classlen = 40, li_rc

// Get a handle to the first child
lul_hndl = GetWindow ( Handle (this), 5 )
ls_class = Space ( li_classlen )
                     
DO WHILE lul_hndl <> 0
	li_rc = GetClassNameA ( lul_hndl, ls_class, li_classlen )
	IF ls_class = classname THEN Return lul_hndl
   lul_hndl = GetWindow (lul_hndl, 2 )
LOOP

MessageBox ( "Error", classname + " not found." )

Return lul_hndl
end function

protected function integer of_getfont ();
/***************************************************************
* Project Name   : D&L rtf field
* Author         : mjw
* Return Values  : the current font - 1 if it fails     
* Description    : Gets the font for this rtf object
* Request No     :
***************************************************************/
/***************************************************************
* By			: mjw
* Date		: 2007
* Purpose	: new format for getfont that return the current font.
              there can be some issues if the selected text 
				  ie two different fonts it return blank for the font name
				  ie a mixture of bold and Italics returns a what ever the first
				  character was. when setting it may cause all of the field to become
				  italic or bold or both.
				  When doing something like that where you have a mixture it maybe
				  desireable to do it as a character at a time.
* CR#			: 
***************************************************************/
integer	li_rc
ulong	ll_dchandle 
ulong ll_fonthandle
ulong lul_hndl
String    ls_data, ls_ansi, ls_ansi2
Blob      lb_data
long     ll_len 
uint    lu_asc


lul_hndl = handle(this)
li_rc = GetLogFont1052(lul_hndl, getlogfontmsg,0,is_colorlogfont)
is_logfont = is_colorlogfont.lf
Return li_rc
 

 
// these return the system information not the current font info
//ll_DCHandle = GetDC ( handle(this))
//ll_fonthandle = GetCurrentObject(ll_DCHandle,OBJ_FONT) 
//li_rc = GetLogFont105( ll_fonthandle, 60, is_logfont)
//ReleaseDc(handle(this),ll_DCHandle) 


//ll_DCHandle = GetDC ( lul_hndl)
//ll_fonthandle = GetCurrentObject(ll_DCHandle,OBJ_FONT) 
//li_rc = GetLogFont105( ll_fonthandle, 60, is_logfont)
//ReleaseDc(lul_hndl,ll_DCHandle) 



//is_logfont.lffacename = this.facename  // gets the current/default font
//is_logfont.lfheight = this.textsize  //  get the current/defualt text size

//pre 10

//integer		li_rc
//
//li_rc = GetColorLogFont ( iul_handle, getlogfontmsg, -1, is_colorlogfont )
//IF li_rc = 0 THEN Return -1
//
//is_font = is_colorlogfont.lf.lffacename
//
//Return 1



end function

public function integer of_getfontsize (integer ai_points);/***************************************************************
* Description   : Determines the font height in pixels based upon the device caps
* Request No    : 
***************************************************************/

integer	li_pixels
long		ll_dchandle, ll_pixelsPerInchY

ll_DCHandle = GetDC ( Handle ( this ) )
ll_pixelsPerInchY = GetDeviceCaps ( ll_DCHandle, LOGPIXELSY )
li_pixels = - ( ai_points * ll_pixelsPerInchY ) / 72

Return li_pixels
end function

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
integer	li_pixels

IF ai_points <= 0 THEN Return 0

//Set the new font
//this.setredraw ( FALSE )
li_pixels = of_getfontsize( ai_points )
of_getfont()
is_logfont.lfheight = li_pixels
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 

//this.setredraw ( TRUE )

//Make sure it took
of_getfont()

Return li_rc
end function

public function integer of_underline (integer ai_onoff);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : ai_onoff = 1 = on 0 = off 
* Return Values  : outcome of api call          
* Description    : underlines the selected text
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont()
is_logfont.lfunderline = byte(ai_onoff)
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
of_getfont()
//this.setredraw ( TRUE )
Return li_rc


end function

public function integer of_italics (integer ai_onoff);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : ai_on off 1 = on, 0 = off
* Return Values  : outcome of api call          
* Description    : underlines the selected text
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont()
is_logfont.ifitalic = byte(ai_onoff)
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
//this.setredraw ( TRUE )
of_getfont()


Return li_rc


end function

public function integer of_strikeout (integer ai_onoff);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : none
* Return Values  : outcome of api call          
* Description    : sets strikeout for the selected text
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont()
is_logfont.lfstrikeout = byte(ai_onoff)
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
of_getfont()
//this.setredraw ( TRUE )


Return li_rc


end function

public function integer of_orientation (integer ai_angle);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : none
* Return Values  : return of the api call         
* Description    : is supposed to set the orientation of the selected text
                   but haven't gotten it working as of yet may be
						 for pictures
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont( )
is_logfont.lforientation = ai_angle
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
//this.setredraw ( TRUE )
of_getfont()

Return li_rc


end function

public function integer of_escapement (integer ai_angle);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : none
* Return Values  : outcome of api call          
* Description    : is supposed to set the escapement for the selected text
                   but doesn't seem to be implemented at this may need to be a picture
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont()
is_logfont.lforientation = ai_angle
is_logfont.lfescapement  = ai_angle
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
//this.setredraw ( TRUE )


Return li_rc


end function

public function integer of_weight (integer ai_weight);/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : ai wieght 
* Return Values  :  Font Weights  - used in display at other end

* Description    : sets the weight for the selected text.
                   not all fonts support all weights
						 700 is bold
***************************************************************/
integer				li_rc

//this.setredraw ( FALSE )
of_getfont()
is_logfont.lfweight = truncate(ai_weight/100,0) * 100
//is_logfont.lfweight = 700
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
//this.setredraw ( TRUE )


Return is_logfont.lfweight


end function

public function integer of_pitchandfamily ();
/***************************************************************
* Project Name   : rtf demo
* Author         : mjw
* Date           : 2007
* Arguments      : none
* Return Values  : return of api call
* Description    : sets the font to fixed with.  only works with certain font types
***************************************************************/
integer				li_rc
long ll_or
//this.setredraw ( FALSE )
of_getfont()
ll_or = of_bitwiseor(long(FIXED_PITCH),long(FF_MODERN))
is_logfont.lfPitchandfamily = byte(ll_or)
li_rc = ColorLogFont105(handle(this) ,setlogfontmsg,0,is_logfont) 
of_getfont()
//this.setredraw ( TRUE )
Return li_rc

 

end function

public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit);
//	Function:  		of_GetBit
//
//	Access: 			public
//
//	Arguments:
//	al_decimal		Decimal value whose on/off value needs to be determined (e.g. 47).
//	ai_bit			Position bit from right to left on the Decimal value.
//
//	Returns: 		boolean
//						True if the value is On.
//						False if the value is Off.
//						If any argument's value is NULL, function returns NULL.
//
//	Description:   Determines if the nth binary bit of a decimal number is 
//						1 or 0.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.03	Fixed problem when dealing with large numbers (>32k)
//				from "mod int" to "int mod"
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

Boolean lb_null

//Check parameters
If IsNull(al_decimal) or IsNull(ai_bit) then
	SetNull(lb_null)
	Return lb_null
End If

//Assumption ai_bit is the nth bit counting right to left with
//the leftmost bit being bit one.
//al_decimal is a binary number as a base 10 long.
If Int(Mod(al_decimal / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False
end function

public function long of_bitwiseor (long al_value1, long al_value2);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_BitwiseOr
//
//	Access: 			public
//
//	Arguments:
//	al_Value1		The first value to be used in the operation (e.g. 55).
//	al_Value2		The second value to be used in the operation (e.g. 44).
//
//	Returns: 		Long
//						The result of the OR operation (e.g. 63).
//						If either argument's value is NULL, function returns NULL.
//
//	Description:   Performs a bitwise OR operation (al_Value1 || al_Value2),
//						which ORs each bit of the values.
//						(55 || 44) = 63
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

Integer		li_Cnt
Long			ll_Result
Boolean		lb_Value1[32], lb_Value2[32]

// Check for nulls
If IsNull(al_Value1) Or IsNull(al_Value2) Then
	SetNull(ll_Result)
	Return ll_Result
End If

// Get all bits for both values
For li_Cnt = 1 To 32
	lb_Value1[li_Cnt] = of_getbit(al_Value1, li_Cnt)
	lb_Value2[li_Cnt] = of_getbit(al_Value2, li_Cnt)
Next

// Or them together
For li_Cnt = 1 To 32
	If lb_Value1[li_Cnt] Or lb_Value2[li_Cnt] Then
		ll_Result = ll_Result + (2^(li_Cnt - 1))
	End If
Next

Return ll_Result

end function

event constructor;this.event post ue_postconstructor()



end event

on u_richtextedit_base.create
end on

on u_richtextedit_base.destroy
end on

