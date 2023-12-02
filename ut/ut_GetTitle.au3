#include-once

#include "unittest.au3"
#include "../dstestlib.au3"

; ==============================
; Unis tests template
;
; 1. Change <include> to filename with function under test
; 2. Use function under test in Assert section
;
; ==============================


	; Check optional text
	; Terxt has to be at the end of input


; sunny case
UTAssertEqual( GetTitle( "") , "")
UTAssertEqual( GetTitle( "6000135 2345") , "")
UTAssertEqual( GetTitle( "6000135 text is 12") , "text is 12")
UTAssertEqual( GetTitle( "New case ") , "New case")
UTAssertEqual( GetTitle( "6000315 ny IPS") , "ny IPS")
UTAssertEqual( GetTitle( "2345 6000135 updated after 2 times") , "updated after 2 times")
UTAssertEqual( GetTitle( "6000135 i mellom 2345") , "i mellom 2345")
UTAssertEqual( GetTitle( " 6000135 1111 is it true ") , "is it true")

; error case



