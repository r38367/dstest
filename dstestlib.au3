#include-once

#include "constants.au3"
#include <ScreenCapture.au3>
#include <Word.au3>
#include <Date.au3>


;===============================================================================
#Region Global Backend Variables
;===============================================================================
Global	$test = ""
Global	$policy = ""
Global	$title = ""

#EndRegion Global backend Variables


Opt('MustDeclareVars', 1)

#cs
================================

Back-end for

Versions:
v1
01/12/23
	- add #7 - split from and back end

================================
#ce

;===============================================================================
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Open_Button_pressed()

	;MsgBox( 0, "Button pressed", "Open " )

EndFunc


;===============================================================================
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Take_Button_pressed( )

	;MsgBox( 0, "Take pressed", "Take snapshot " )
	Local $jpgFile

	$jpgFile = ScreenshotFileName()
	ScreenshotToFile( $jpgFile )
	if $test <> 0 or $policy <> 0 or $title <> "" then
		_SavePicToWord( WordFileName(), $jpgFile )
	endif

EndFunc

;===============================================================================
; Function Name:    Process input parameters()
; Sets global variables based on input text:
;	- $test
;	- $policy
;	- $jpg file name
;	- $word file name
; Returns:
;	- text for label
;===============================================================================
Func Process_input( $input )

	Local $ret = "Test:{t}, Policy:{p}, Text:{x}"

	; Strip of white space and place into array
	$input = StringStripWS( $input, 7 )

	; Parse input to get $test and $policy
	 $test = GetTest( $input )
	 $policy = GetPolicy( $input )
	 $title = GetTitle( $input )

	 ;MSgBox( 0, "Input", "Input pressed!" & @CRLF & $input )
	 $ret = StringReplace( StringReplace( StringReplace( $ret, "{t}", $test ), "{p}", $policy ), "{x}", $title )
	return $ret

EndFunc

;---- TODO HERE

;===============================================================================
; Function:  Get comment
; Returns:
;	- text
;	- "" if no text
;===============================================================================
Func	GetTitle( $text )
	$text = StringStripWS( $text, 7 )

	Local $a = StringRegExp( $text, "[\d ]*(.*)", 1)
	;ConsoleWrite( "error " & @error & ", ext. " & @extended & "" & $a[0] & @CRLF )
	if @error then
		ConsoleWrite( "error " & @error & ", ext. " & @extended & @CRLF )
		return ""
	endif

	Return $a[0]

EndFunc

;===============================================================================
; Function:  Get test
; Returns:
;	- test number
;	- 0 if no test in text
;===============================================================================
Func	GetTest( $text )

	Local $a
	$a = StringRegExp( $text, "(?<!\d)\d{4}(?!\d)", 1)
	if @error then return ""

	Return $a[0]

EndFunc

;===============================================================================
; Function:  Get policy
; Returns:
;	- policy number
;	- 0 if no test in text
;===============================================================================
Func	GetPolicy( $text )

	Local $a
	$a = StringRegExp( $text, "(?<!\d)\d00\d{4}(?!\d)", 1)
	if @error then return ""

	Return $a[0]

EndFunc


;===============================================================================
; Function Name:    Make name for screenshot
;===============================================================================

Func	ScreenshotFileName()

	;Local $title = StringStripWS( GUICtrlRead($text), 7) ; get input
	Local $name = StringRegExpReplace( _NowCalc(), "(\d\d\d\d).(\d\d).(\d\d) (\d\d):(\d\d):(\d\d)", '$3-$2-$1-$4$5$6_screen.jpg')
	if $title <> "" then $name=StringReplace( $name, "screen", $title )
	$name = @ScriptDir & "\" &  $name

	; check if input is not empty
	ConsoleWrite( $name & @CRLF )
	return $name

EndFunc ;==> ScreenshotFileName

;===============================================================================
; Function Name:    Take screenshot and save to file
;===============================================================================
Func ScreenshotToFile( $file )

	; Capture full screen
    _ScreenCapture_Capture( $file )
	if @error then
		MsgBox( 0, "Error", "Screen capture failed" )
	EndIf

EndFunc   ;==>ScreenShotToJpg


;===============================================================================
; Save jpg to word file
;===============================================================================

Func _SavePicToWord( $sWord, $sPicName, $bVisible=false )
	Local 	$oDoc

ConsoleWrite( "-"& $sWord & "-" & @CRLF & $sPicName & @CRLF )

	; Create application object
	Local $oWord = _Word_Create( $bVisible )
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_Create", _
					"Error creating a new Word application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_Create" )

	; Open the test document
	if not FileExists( $sWord ) then
		; create file

		$oDoc = _Word_DocAdd($oWord)
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocAdd", _
					 "@error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_DocAdd" )

		_Word_DocSaveAs($oDoc, $sWord, $wdFormatDocumentDefault)
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocSaveAs", _
					 "@error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_DocSaveAs" )
	Else
		; open file
		$oDoc = _Word_DocOpen( $oWord, $sWord, false, Default, False, False, True )
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocOpen", _
					 "@error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_DocOpen" )

	EndIf


	; Insert a picture after the fourth word of the document
	; Set the range as insert marker after the 4th word
	Local $oRange = _Word_DocRangeSet($oDoc, -2 )
;MsgBox( 0, "", "_Word_DocRangeSet 1" )
	$oRange.insertAfter(_NowCalc() )
;MsgBox( 0, "", "_Word_DocRangeSet 2" )
	$oRange = _Word_DocRangeSet($oDoc, -2 )
;MsgBox( 0, "", "_Word_DocRangeSet 3" )
	_Word_DocPictureAdd($oDoc, $sPicName, Default, Default, $oRange)
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocPictureAdd", _
					" @error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_DocPictureAdd" )
	$oRange = _Word_DocRangeSet($oDoc, -2 )
	$oRange.insertAfter(@CRLF)
;MsgBox( 0, "", "_Word_DocRangeSet 4" )
	;$oRange.Select

	; Close document
	_Word_DocSave($oDoc)
	If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocSave", _
					" @error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_DocSave" )
	;if not $bVisible then
		_Word_Quit($oWord, $WdSaveChanges, Default, true )
		If @error Then Exit MsgBox($MB_SYSTEMMODAL, "_Word_DocClose", _
					" @error = " & @error & ", @extended = " & @extended)
;MsgBox( 0, "", "_Word_Quit" )
	;EndIf

EndFunc

Func	WordFileName()

	;if $test <> "" or $policy <> ""  then
		return  @ScriptDir & "\" & $test & "_Anton_" & $policy & ".docx"
	;EndIf
	;return 0

EndFunc

