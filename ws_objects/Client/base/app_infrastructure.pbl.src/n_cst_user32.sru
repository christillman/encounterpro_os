$PBExportHeader$n_cst_user32.sru
forward
global type n_cst_user32 from nonvisualobject
end type
type tagpoint from structure within n_cst_user32
end type
type tagscrollinfo from structure within n_cst_user32
end type
type tagrect from structure within n_cst_user32
end type
type access_mask from structure within n_cst_user32
end type
type flashwinfo from structure within n_cst_user32
end type
type menuiteminfoa from structure within n_cst_user32
end type
type trackmouseevent from structure within n_cst_user32
end type
end forward

type tagPOINT from structure
	long		x
	long		y
end type

type tagSCROLLINFO from structure
	uint		cbSize
	uint		fMask
	integer		nMin
	integer		nMax
	uint		nPage
	integer		nPos
	integer		nTrackPos
end type

type tagRECT from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type ACCESS_MASK from structure
	long		SpecificRights
	character		StandardRights
	character		AccessSystemAcl
	character		Reserved[3]
	character		GenericAll
	character		GenericExecute
	character		GenericWrite
	character		GenericRead
end type

type FLASHWINFO from structure
	uint		cbSize
	ulong		hWnd
	ulong		dwFlags
	uint		uCount
	ulong		dwTimeout
end type

type MENUITEMINFOA from structure
	uint		cbSize
	uint		fMask
	uint		fType
	uint		fState
	uint		wID
	ulong		hSubMenu
	ulong		hbmpChecked
	ulong		hbmpUnchecked
	ulong		dwItemData
	ulong		dwTypeData
	uint		cch
end type

type trackmouseevent from structure
	unsignedlong		cbSize
	unsignedlong		dwFlags
	unsignedlong		hwndTrack
	unsignedlong		dwHoverTime
end type

global type n_cst_user32 from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean PostMessage (ulong hWnd, uint Msg, ulong wParam, ulong lParam) Library "USER32.DLL" Alias for "PostMessageA"
Function ulong SendMessage (ulong hWnd, uint Msg, ulong wParam, ulong lParam) Library "USER32.DLL" Alias for "SendMessageA"
Function ulong SendMessageTimeout (ulong hWnd, uint Msg, ulong wParam, ulong lParam, uint fuFlags, uint uTimeout, ref uint lpdwResult) Library "USER32.DLL" Alias for "SendMessageTimeoutA"

end prototypes

type variables
public:
/*
 * Color Types
 */
constant int CTLCOLOR_MSGBOX         = 0
constant int CTLCOLOR_EDIT           = 1
constant int CTLCOLOR_LISTBOX        = 2
constant int CTLCOLOR_BTN            = 3
constant int CTLCOLOR_DLG            = 4
constant int CTLCOLOR_SCROLLBAR      = 5
constant int CTLCOLOR_STATIC         = 6
constant int CTLCOLOR_MAX            = 7
constant int COLOR_SCROLLBAR         = 0
constant int iCOLOR_BACKGROUND        = 1
constant int COLOR_ACTIVECAPTION     = 2
constant int COLOR_INACTIVECAPTION   = 3
constant int COLOR_MENU              = 4
constant int COLOR_WINDOW            = 5
constant int COLOR_WINDOWFRAME       = 6
constant int COLOR_MENUTEXT          = 7
constant int COLOR_WINDOWTEXT        = 8
constant int COLOR_CAPTIONTEXT       = 9
constant int COLOR_ACTIVEBORDER      = 10
constant int COLOR_INACTIVEBORDER    = 11
constant int COLOR_APPWORKSPACE      = 12
constant int COLOR_HIGHLIGHT         = 13
constant int COLOR_HIGHLIGHTTEXT     = 14
constant int COLOR_BTNFACE           = 15
constant int COLOR_BTNSHADOW         = 16
constant int COLOR_GRAYTEXT          = 17
constant int COLOR_BTNTEXT           = 18
constant int COLOR_INACTIVECAPTIONTEXT = 19
constant int COLOR_BTNHIGHLIGHT      = 20
constant int COLOR_3DDKSHADOW        = 21
constant int COLOR_3DLIGHT           = 22
constant int COLOR_INFOTEXT          = 23
constant int COLOR_INFOBK            = 24
constant int COLOR_DESKTOP           = iCOLOR_BACKGROUND
constant int COLOR_3DFACE            = COLOR_BTNFACE
constant int COLOR_3DSHADOW          = COLOR_BTNSHADOW
constant int COLOR_3DHIGHLIGHT       = COLOR_BTNHIGHLIGHT
constant int COLOR_3DHILIGHT         = COLOR_BTNHIGHLIGHT
constant int COLOR_BTNHILIGHT        = COLOR_BTNHIGHLIGHT

/*
 * GetSystemMetrics() codes
 */

constant int SM_CXSCREEN             = 0
constant int SM_CYSCREEN             = 1
constant int SM_CXVSCROLL            = 2
constant int SM_CYHSCROLL            = 3
constant int SM_CYCAPTION            = 4
constant int SM_CXBORDER             = 5
constant int SM_CYBORDER             = 6
constant int SM_CXDLGFRAME           = 7
constant int SM_CYDLGFRAME           = 8
constant int SM_CYVTHUMB             = 9
constant int SM_CXHTHUMB             = 10
constant int SM_CXICON               = 11
constant int SM_CYICON               = 12
constant int SM_CXCURSOR             = 13
constant int SM_CYCURSOR             = 14
constant int SM_CYMENU               = 15
constant int SM_CXFULLSCREEN         = 16
constant int SM_CYFULLSCREEN         = 17
constant int SM_CYKANJIWINDOW        = 18
constant int SM_MOUSEPRESENT         = 19
constant int SM_CYVSCROLL            = 20
constant int SM_CXHSCROLL            = 21
constant int SM_DEBUG                = 22
constant int SM_SWAPBUTTON           = 23
constant int SM_RESERVED1            = 24
constant int SM_RESERVED2            = 25
constant int SM_RESERVED3            = 26
constant int SM_RESERVED4            = 27
constant int SM_CXMIN                = 28
constant int SM_CYMIN                = 29
constant int SM_CXSIZE               = 30
constant int SM_CYSIZE               = 31
constant int SM_CXFRAME              = 32
constant int SM_CYFRAME              = 33
constant int SM_CXMINTRACK           = 34
constant int SM_CYMINTRACK           = 35
constant int SM_CXDOUBLECLK          = 36
constant int SM_CYDOUBLECLK          = 37
constant int SM_CXICONSPACING        = 38
constant int SM_CYICONSPACING        = 39
constant int SM_MENUDROPALIGNMENT    = 40
constant int SM_PENWINDOWS           = 41
constant int SM_DBCSENABLED          = 42
constant int SM_CMOUSEBUTTONS        = 43

constant int SM_CXFIXEDFRAME           = SM_CXDLGFRAME  /* ;win40 name change */
constant int SM_CYFIXEDFRAME           = SM_CYDLGFRAME  /* ;win40 name change */
constant int SM_CXSIZEFRAME            = SM_CXFRAME     /* ;win40 name change */
constant int SM_CYSIZEFRAME            = SM_CYFRAME     /* ;win40 name change */

constant int SM_SECURE               = 44
constant int SM_CXEDGE               = 45
constant int SM_CYEDGE               = 46
constant int SM_CXMINSPACING         = 47
constant int SM_CYMINSPACING         = 48
constant int SM_CXSMICON             = 49
constant int SM_CYSMICON             = 50
constant int SM_CYSMCAPTION          = 51
constant int SM_CXSMSIZE             = 52
constant int SM_CYSMSIZE             = 53
constant int SM_CXMENUSIZE           = 54
constant int SM_CYMENUSIZE           = 55
constant int SM_ARRANGE              = 56
constant int SM_CXMINIMIZED          = 57
constant int SM_CYMINIMIZED          = 58
constant int SM_CXMAXTRACK           = 59
constant int SM_CYMAXTRACK           = 60
constant int SM_CXMAXIMIZED          = 61
constant int SM_CYMAXIMIZED          = 62
constant int SM_NETWORK              = 63
constant int SM_CLEANBOOT            = 67
constant int SM_CXDRAG               = 68
constant int SM_CYDRAG               = 69
constant int SM_SHOWSOUNDS           = 70
constant int SM_CXMENUCHECK          = 71   /* Use instead of GetMenuCheckMarkDimensions()! */
constant int SM_CYMENUCHECK          = 72
constant int SM_SLOWMACHINE          = 73
constant int SM_MIDEASTENABLED       = 74
constant int SM_CMETRICS             = 76

/*
 * Window Messages
 */
constant ulong WM_MOUSEMOVE                    = 512 //0x0200
constant ulong WM_LBUTTONDOWN                 = 513 // 0x0201
constant ulong WM_LBUTTONUP                    = 514 //0x0202
constant ulong WM_LBUTTONDBLCLK                = 515 //0x0203
constant ulong WM_RBUTTONDOWN                  = 516 //0x0204
constant ulong WM_RBUTTONUP                    =  517 //0x0205
constant ulong WM_RBUTTONDBLCLK                = 518 //0x0206
constant ulong WM_MOUSEHOVER                   = 673 //0x02A1
constant ulong WM_MOUSELEAVE                   = 675 //0x02A3

// SendMessageTimeout flags
constant uint SMTO_NORMAL             = 0 // 0x0000
constant uint SMTO_BLOCK              = 1 // 0x0001
constant uint SMTO_ABORTIFHUNG        = 2 // 0x0002
constant uint SMTO_NOTIMEOUTIFNOTHUNG = 8 // 0x0008

// Windows messages
constant uint WM_CLOSE               = 16    // 0x0010
constant uint WM_QUERYENDSESSION     = 17    // 0x0011

end variables
on n_cst_user32.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_user32.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

