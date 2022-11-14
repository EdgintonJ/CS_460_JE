#lang mystery-languages/arithmetic
; Jordan Edginton
; === EXPECTED TEST RESULTS ===
(TEST (+ 4 5) 9 9.0 9)

(TEST (+ 1 0.8) 9/5 1.8 9/5)

(TEST (/ 10 8) 5/4 1.25 1)


; === HOW TO CLASSIFY A VARIANT ===
;L1: test 1 produces 9, test 2 produces 9/5, test 3 produces 5/4

;L2: test 1 produces 9.0, test 2 produces 1.8, test 3 produces 1.25

;L3: test 1 produces 9, test 2 produces 9/5, test 3 produces 1



;-- EXPLANATIONS --
;L1: will turn the output into the lowest fraction possible
;    in the second and third test the number returned was a fraction that was reduced from 10/8 to 5/4.

;L2: Will convert the number into a float/double
;    in the first test the number returned has 1 decimal point of precision, even though it's an integer

;L3: will turn the output into the lowest fraction possible AND rounds down when doing division
;    Test 2 has the same result as L1; but in the third test, instead of returning 5/4 it rounded down the result to 1. 
