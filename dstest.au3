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


================================
#ce

Local const $nVer = "1"

;===============================================================================
#Region Global Include files
;===============================================================================
;#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;#include <GUIConstants.au3>
;#include <WinAPIShellEx.au3>
;#include <GuiEdit.au3>

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
Global $ctrlFile
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
Local const $guiHeight = 80
Local const $guiLeft = -1
Local const $guiTop = -1



	; Create input
	$gui = GUICreate( "Test DinSide - v." & $nVer & "." &  GetVersion(), $guiWidth, $guiHeight, $guiLeft, $guiTop, $WS_MINIMIZEBOX+$WS_SIZEBOX ) ; & GetVersion(), 500, 200)

	;--- buttons starting from right
	Local const $guiBtnWidth = 50
	Local const $guiBtnHeight = 30
	Local $guiBtnLeft = $guiWidth - $guiMargin - $guiBtnWidth
	Local $guiBtnTop = $guiMargin

	; Label
	$ctrlFile = GUICtrlCreateLabel("File", 10, 16)
	GUICtrlSetData($ctrlFile ,"Logfile")

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



	; set focus
	;GUICtrlSetState($ctrlFile, $GUI_FOCUS)

	; start GUI
	GUISetState() ; will display an empty dialog box

EndFunc


;===============================================================================
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Open_Button_pressed()

	MsgBox( 0, "Button pressed", "Open " )

EndFunc


;===============================================================================
; Function Name:    Open_Button_pressed()
;===============================================================================

Func Take_Button_pressed()

	MsgBox( 0, "Take pressed", "Take snapshot " )

EndFunc
