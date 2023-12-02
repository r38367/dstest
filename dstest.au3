#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\..\..\Program Files (x86)\AutoIt3\Icons\MyAutoIt3_Green.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_ProductName=Anton's tool
#AutoIt3Wrapper_Res_Field=Timestamp|%date%.%time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs
================================

Simple module to get create xml file from the name and fnr

Versions:
v1
30/11/23
	- add #1 - initial prototype
v2
01/12/23
	- add #3 - save screnshot to file <timestamp>_screen.jpg
	- add #6 - save screenshots to Word
	- add #4 - always on top
v3
01/12/23
	- add #7 split front-end from and back-end

================================
#ce

Local const $nVer = "3"

;===============================================================================
#Region Global Include files
;===============================================================================
;#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;#include <GUIConstants.au3>
;#include <GuiEdit.au3>
#include <Date.au3>
#include <String.au3>
#EndRegion Global Include files

;===============================================================================
#Region Lib files
;===============================================================================
#include "dstestlib.au3"
#EndRegion LIB files


;===============================================================================
#Region Global Frontend Variables
;===============================================================================
Global $gui
Global $idButtonTake
Global $idButtonOpen
Global $idInput
Global $idLabel

Global	$hInput, $pInputProc ; to control Paste into Input control

Global	$userinput, $policy, $test, $logfile, $bValidName = False

#EndRegion Global GUI Variables


Opt('MustDeclareVars', 1)

Main()

;===============================================================================
; Main Loop
;===============================================================================
Func	Main()

	Local $msg

	_GUI_Create()

	Do

		$msg = GUIGetMsg()

		if $msg = $idButtonTake then

			_Take_Button_pressed()

		ElseIf $msg = $idButtonOpen then

			_Open_Button_pressed()

		ElseIf $msg = $idInput then

			_Input_pressed()

		EndIf

	Until $msg = $GUI_EVENT_CLOSE

	GUIDelete()

	exit


EndFunc

; -----------------------------------------------------------------------------
; Create GUI
;
; All controls to create a form
; -----------------------------------------------------------------------------
Func _GUI_Create()

;--- space between elements
Local const $guiMargin = 10

;--- GUI
Local const $guiWidth = 500
Local const $guiHeight = 100
Local const $guiLeft = -1
Local const $guiTop = -1



	; Create input
	$gui = GUICreate( "Test DinSide - v." & $nVer & "." &  _GetVersion(), $guiWidth, $guiHeight, $guiLeft, $guiTop, $WS_MINIMIZEBOX+$WS_SIZEBOX ) ; & GetVersion(), 500, 200)

	;--- buttons starting from right
	Local const $guiBtnWidth = 50
	Local const $guiBtnHeight = 30
	Local $guiBtnLeft = $guiWidth - $guiMargin - $guiBtnWidth
	Local $guiBtnTop = $guiMargin

	; Button
	; ----- 1st from right button
	$guiBtnLeft = $guiWidth - $guiMargin - $guiBtnWidth
	$guiBtnTop = $guiMargin

	$idButtonOpen = GUICtrlCreateButton("Open", $guiBtnLeft, $guiBtnTop, $guiBtnWidth, $guiBtnHeight)
	GUIctrlsetfont(-1, 9, 0, 0, "Lucida Console" )
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	; ----- 2nd button from right <<<--
	$guiBtnLeft = $guiBtnLeft - $guiMargin - $guiBtnWidth

	$idButtonTake = GUICtrlCreateButton("Take", $guiBtnLeft, $guiBtnTop, $guiBtnWidth, $guiBtnHeight)
	GUIctrlsetfont(-1, 9, 0, 0, "Lucida Console" )
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	; ----- input from left <<<--
	Local $guiInputHeight = 20
	$guiBtnLeft = $guiBtnLeft - $guiMargin	; length to buttons

	$idInput = GUICtrlCreateInput("", $guiMargin, $guiBtnTop, $guiBtnLeft - $guiMargin, $guiInputHeight )
	GUIctrlsetfont(-1, 10, 0, 0, "Lucida Console" )
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetTip(-1, "tc policy text")

	; Register callback function to subclass Input control (to intercept WM_PASTE)
	$hInput = GUICtrlGetHandle( $idInput )
	$pInputProc = DllCallbackGetPtr( DllCallbackRegister( "_StripClip", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr" ) )
	_WinAPI_SetWindowSubclass( $hInput, $pInputProc, 9999, 0 ) ; SubclassId = 9999, $pData = 0


	; ----- Label
	Local const $guiLabelLeft = $guiMargin
	Local const $guiLabelTop = $guiBtnTop + $guiInputHeight + $guiMargin
	Local const $guiLabelWidth = $guiBtnLeft - $guiMargin
	Local const $guiLabelHeight = $guiInputHeight

	$idLabel = GUICtrlCreateLabel(	"", $guiLabelLeft, $guiLabelTop, $guiLabelWidth, $guiLabelHeight)
	GUIctrlsetfont(-1, 10, 0, 0, "Lucida Console" )
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT )

	; set focus
	GUICtrlSetState($idInput, $GUI_FOCUS)

	; start GUI
	GUISetState() ; will display an empty dialog box

	; Always on top
	WinSetOnTop($gui, "", $WINDOWS_ONTOP)

EndFunc

;===============================================================================
; Callback functions
;===============================================================================

Func _Take_Button_pressed()
	Take_Button_pressed()
EndFunc

Func _Open_Button_pressed()
	Open_Button_pressed()
EndFunc

Func _Input_pressed()

	$userinput = StringStripWS( _Get_Input(), 7 )
	_Set_Label( Process_input( $userinput ) )

Endfunc

;===============================================================================
; _StripClip() - call back for paste into input control
;===============================================================================

#include <WinAPIShellEx.au3>
; InputProc callback function
Func _StripClip( $hWnd, $iMsg, $wParam, $lParam, $iSubclassId, $pData )
  Switch $iMsg
 	case $WM_PASTE
		ClipPut( StringStripWS(StringReplace( ClipGet(), @CRLF, " "),7) )
		;;GUICtrlSetData( $ctrlName, StringStripWS(StringReplace( ClipGet(), @CRLF, " "),7) )
		;ConsoleWrite( "Paste:"& GUICtrlRead( $ctrlName ) & @CRLF )
		;return 0
  EndSwitch
  ; Call next function in subclass chain
  Return DllCall( "comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam )[0] ; _WinAPI_DefSubclassProc
EndFunc

;===============================================================================
; Function: GetVersion
;
; Return: String yyyymmddhhmm
;
;===============================================================================

Func _GetVersion()

	Local $ver
	If @Compiled Then

		$ver = FileGetVersion(@ScriptFullPath, "Timestamp")

		; dd/mm/yyyy.hh.mm.ss -> dd.mm.yy.hhmm
		$ver = StringRegExpReplace( $ver, "(\d+)[/\-\.](\d+)[/\-\.]\d*(\d\d).(\d+):(\d+):\d+" , "$1.$2.$3.$4$5" )

	Else
		$ver = "Not compiled"
	EndIf

	Return $ver

EndFunc


Func	_Get_Input()
	Return GUICtrlRead($idInput)
EndFunc

Func	_Set_Label( $text )
	GUICtrlSetData($idLabel, $text )
EndFunc
