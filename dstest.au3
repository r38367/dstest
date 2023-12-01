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

================================
#ce

Local const $nVer = "2"

;===============================================================================
#Region Global Include files
;===============================================================================
;#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;#include <GUIConstants.au3>
;#include <GuiEdit.au3>
#include <Date.au3>
#include <ScreenCapture.au3>
#include <Word.au3>
#include <String.au3>
#EndRegion Global Include files

;===============================================================================
#Region Lib files
;===============================================================================
#EndRegion LIB files


;===============================================================================
#Region Global Variables
;===============================================================================
Global $gui
Global $idButtonTake
Global $idButtonOpen
Global $idInput
Global $idLabel

Global	$hInput, $pInputProc ; to control Paste into Input control

Global	$policy, $test, $logfile, $bValidName = False

#EndRegion Global Variables


;OnAutoItExitRegister("MyExitFunc")
Opt('MustDeclareVars', 1)

Main()

;===============================================================================
; Function Name:  Main
;===============================================================================
Func	Main()

	Local $msg

	GUI_Create()

	Do

		$msg = GUIGetMsg()

		if $msg = $idButtonTake then

			Take_Button_pressed()

		ElseIf $msg = $idButtonOpen then

			Open_Button_pressed()

		ElseIf $msg = $idInput then

			Input_pressed()

		EndIf

	Until $msg = $GUI_EVENT_CLOSE

	GUIDelete()

	exit


EndFunc

; -----------------------------------------------------------------------------
; Function: GetVersion
;
; Return: String yyyymmddhhmm
;
; -----------------------------------------------------------------------------

Func GetVersion()

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

; -----------------------------------------------------------------------------
; Function: Process input
; Input: String
;
; -----------------------------------------------------------------------------
Func GUI_Create()

;--- space between elements
Local const $guiMargin = 10

;--- GUI
Local const $guiWidth = 500
Local const $guiHeight = 100
Local const $guiLeft = -1
Local const $guiTop = -1



	; Create input
	$gui = GUICreate( "Test DinSide - v." & $nVer & "." &  GetVersion(), $guiWidth, $guiHeight, $guiLeft, $guiTop, $WS_MINIMIZEBOX+$WS_SIZEBOX ) ; & GetVersion(), 500, 200)

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

	$idInput = GUICtrlCreateInput(" ", $guiMargin, $guiBtnTop, $guiBtnLeft - $guiMargin, $guiInputHeight )
	GUIctrlsetfont(-1, 10, 0, 0, "Lucida Console" )
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetTip(-1, "tc [policy]")

	; Register callback function to subclass Input control (to intercept WM_PASTE)
	$hInput = GUICtrlGetHandle( $idInput )
	$pInputProc = DllCallbackGetPtr( DllCallbackRegister( "_StripClip", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr" ) )
	_WinAPI_SetWindowSubclass( $hInput, $pInputProc, 9999, 0 ) ; SubclassId = 9999, $pData = 0


	; ----- Label
	Local const $guiLabelLeft = $guiMargin
	Local const $guiLabelTop = $guiBtnTop + $guiInputHeight + $guiMargin
	Local const $guiLabelWidth = $guiBtnLeft - $guiMargin
	Local const $guiLabelHeight = $guiInputHeight

	$idLabel = GUICtrlCreateLabel(	"this is a file name that will be posted", $guiLabelLeft, $guiLabelTop, $guiLabelWidth, $guiLabelHeight)
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
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Open_Button_pressed()

	;MsgBox( 0, "Button pressed", "Open " )

EndFunc


;===============================================================================
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Take_Button_pressed()

	;MsgBox( 0, "Take pressed", "Take snapshot " )
	Local $name = ScreenshotFileName()
	ScreenShotToJpg( $name )
	if $bValidName then _SavePicToWord( createLogFile(), $name, false )


EndFunc

;===============================================================================
; Function Name:    Input_pressed()
;===============================================================================
Func Input_pressed()
	Local $err, $input
	Local $sText = "Test:{test}, Policy:{policy}"

	; Strip of white space and place into array
	$input = StringStripWS( GUICtrlRead($idInput), 7 )


	; Get name and surname
	setLogFile( GetFields( $input ) & ".docx" )

	GUICtrlSetData($idLabel, "Test:"&getTest()&", Policy:"&getPolicy()& _StringRepeat(" ", 10) )
	;MSgBox( 0, "Input", "Input pressed!" & @CRLF & $input )

EndFunc


Func	GetFields( $input )

	; acceptable format:
	; 	dddd ddddddd
	;	ddddddd dddd
ConsoleWrite( $input & @CRLF )
	; if test+policy
	If StringRegExp( $input, "^(\d{4,5}) +(\d{7})$" ) then
ConsoleWrite( "1" & @CRLF )
		setTest( StringRegExpReplace( $input, "^(\d+) (\d+)$", "$1" ) )
		setPolicy( StringRegExpReplace( $input, "^(\d+) (\d+)$", "$2" ) )
$bValidName = true
	; if policy + test
	elseif  StringRegExp( $input, "^(\d{7}) (\d{4,5})$" ) then
ConsoleWrite( "2" & @CRLF )
		setTest( StringRegExpReplace( $input, "^(\d+) (\d+)$", "$1" ) )
		setPolicy( StringRegExpReplace( $input, "^(\d+) (\d+)$", "$2" ) )
$bValidName = true

	; if policy
	elseif  StringRegExp( $input, "^(\d{7})$" ) then
ConsoleWrite( "3" & @CRLF )
		setPolicy( StringRegExpReplace( $input, "^(\d+)$", "$1" ) )
		setTest( "XXXX" )

$bValidName = false

	; if test
	elseif  StringRegExp( $input, "^(\d{4,5})$" ) then
ConsoleWrite( "4" & @CRLF )
		setTest( StringRegExpReplace( $input, "^(\d+)$", "$1" ) )
		setPolicy( "0000000" )

$bValidName = false

; if wrong format
	Else
ConsoleWrite( "5" & @CRLF )
	$bValidName = false
	setTest( "XXXX" )
	setPolicy( "0000000" )

	Return "error"

	EndIf

		;$test   = StringRegExpReplace( $input, "^(\d{4}\d?\d?) (\d{7})$", "$1" )
		;$policy = StringRegExpReplace( $input, "^(\d+) (\d+)$", "$2" )

	return getTest() & "_Anton_" & getPolicy()

EndFunc



;===============================================================================
; Function Name:    _StripClip() - call abck for paste into input control
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
; Function Name:    Make name for screenshot
;===============================================================================

Func	ScreenshotFileName()

	Local $title = StringStripWS( GUICtrlRead($idInput), 7) ; get input
	Local $name = StringRegExpReplace( _NowCalc(), "(\d\d\d\d).(\d\d).(\d\d) (\d\d):(\d\d):(\d\d)", '$3-$2-$1-$4$5$6_screen.jpg')
	if $title <> "" then $name=StringReplace( $name, "screen", $title )

	; check if input is not empty
	ConsoleWrite( $name & @CRLF )
	return @ScriptDir & "\" & $name

EndFunc ;==> ScreenshotFileName

;===============================================================================
; Function Name:    Take screenshot and save to file
;===============================================================================
Func ScreenShotToJpg( $name )


	; Capture full screen
    _ScreenCapture_Capture( $name )
	if @error then
		MsgBox( 0, "Error", "Screen capture failed" )
	EndIf

EndFunc   ;==>ScreenShotToJpg


;===============================================================================
; Function Name:    Take screenshot and save to file
;===============================================================================
Func ScreenShotToWord( $name )

; get name for word file

	if $bValidName then

		_SavePicToWord( createLogFile(), $name  )

	EndIf

	; Do not save if not valif policy or test

EndFunc   ;==>ScreenShotToWord


;===============================================================================
; class to work with global variables
;===============================================================================

Func	getPolicy()
	return $policy
EndFunc

Func	setPolicy($p)
	$policy = $p
EndFunc

Func	getTest()
	return $test
EndFunc

Func	setTest($t)
	$test = $t
EndFunc

Func	getLogFile()
	return $logfile
EndFunc

Func	setLogFile($f)
	$logfile = $f
EndFunc

Func	createLogFile()

	Local	$test = getTest()
	Local	$policy = getPolicy()

	setLogFile( @ScriptDir & "\" & $test & "_Anton_" & $policy & ".docx" )
	return  getLogFile()

EndFunc


Func _SavePicToWord( $sWord, $sPicName, $bVisible=false )
	Local 	$oDoc

ConsoleWrite( "-"& $sWord & "-" & @CRLF & $sPicName & @CRLF )

	; Create application object
	Local $oWord = _Word_Create( $bVisible )
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_Create", _
					"Error creating a new Word application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

	; Open the test document
	if not FileExists( $sWord ) then
		; create file

		$oDoc = _Word_DocAdd($oWord)
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocAdd", _
					 "@error = " & @error & ", @extended = " & @extended)

		_Word_DocSaveAs($oDoc, $sWord, 16)
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocSaveAs", _
					 "@error = " & @error & ", @extended = " & @extended)
	EndIf

	; open file
	Local $oDoc = _Word_DocOpen( $oWord, $sWord, Default, Default, False, False, True )
		; set to end

	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocOpen", _
					 "@error = " & @error & ", @extended = " & @extended)

	; Insert a picture after the fourth word of the document
	; Set the range as insert marker after the 4th word
	Local $oRange = _Word_DocRangeSet($oDoc, -2 )
	$oRange.insertAfter(@CRLF & _NowCalc() )
	$oRange = _Word_DocRangeSet($oDoc, -2 )
	_Word_DocPictureAdd($oDoc, $sPicName, Default, Default, $oRange)
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocPictureAdd", _
					" @error = " & @error & ", @extended = " & @extended)
	$oRange = _Word_DocRangeSet($oDoc, -2 )
	;$oRange.Select

	; Close document
	_Word_DocSave($oDoc)
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocSave", _
					" @error = " & @error & ", @extended = " & @extended)
	;if not $bVisible then
		_Word_Quit($oWord, $WdSaveChanges )
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocClose", _
					" @error = " & @error & ", @extended = " & @extended)
	;EndIf

EndFunc