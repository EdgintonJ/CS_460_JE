#lang mystery-languages/conditionals
; Jordan Edginton

; === MAIN TEST ===

(TEST (or 0 #f) failure 0 #f)


; === EXTRA TESTS ===

(TEST (if (not 0) 3 4) failure 4 3)
(TEST (and #t 123) failure 123 #t)



; === HOW TO CLASSIFY A VARIANT ===
;L1: Test 1 produces an error

;L2: Test 1 produces: 0 

;L3: Test 1 produces: #f 



;-- EXPLANATIONS --
;L1: The error for the test is caused by the fact that 0 is not a boolean and it requires all statements to be booleans.   

;L2: L2 returns the first item in the statement if it is not a boolean.    

;L3: L3 translates 0 as false, which then checks the next item (#f) and returns false.    

