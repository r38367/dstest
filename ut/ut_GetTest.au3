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


	; Check test case number
	; has to be 4 digit number


; sunny case
UTAssertEqual( GetTest( "2524") , 2524)
UTAssertEqual( GetTest( "1234 ny IPS") , 1234)
UTAssertEqual( GetTest( "2345 6000135") , 2345)
UTAssertEqual( GetTest( "6000135 2345") , 2345)

; error case
UTAssertEqual( GetTest( "") , 0)
UTAssertEqual( GetTest( "123") , 0)
UTAssertEqual( GetTest( "12345") , 0)
UTAssertEqual( GetTest( "6000135") , 0)
UTAssertEqual( GetTest( "12345 6000135") , 0)

; corny case
UTAssertEqual( GetTest( " 6000135 1111 is it true ") , 1111)
UTAssertEqual( GetTest( " 1234 6000135 is it true ") , 1234)



