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


	; Check policy number
	; has to be 7 digit number d00dddd


; sunny case
UTAssertEqual( GetPolicy( "") , 0)
UTAssertEqual( GetPolicy( "6000445") , 6000445)
UTAssertEqual( GetPolicy( "6000315 ny IPS") , 6000315)
UTAssertEqual( GetPolicy( "2345 6000135") , 6000135)
UTAssertEqual( GetPolicy( "6000135 2345") , 6000135)

; error case
UTAssertEqual( GetPolicy( "50001") , 0)
UTAssertEqual( GetPolicy( "5012135") , 0)
UTAssertEqual( GetPolicy( "50001234") , 0)

; corny case
UTAssertEqual( GetPolicy( " 6000135 1111 is it true ") , 6000135)
UTAssertEqual( GetPolicy( " 1234 6000135 is it true ") , 6000135)



