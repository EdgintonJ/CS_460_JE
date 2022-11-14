#lang mystery-languages/fields
; Jordan Edginton

; === EXPECTED TEST RESULTS ===
(TEST (defvar w (object ["x" 1] [2 1])) failure failure void)

; === EXTRA TESTS ===
(TEST (oget w 2) failure failure 1)
(TEST (defvar y (object ["x" 1])) failure void void)
(TEST (oget y "x") failure 1 1)

; === HOW TO CLASSIFY A VARIANT ===
;L1: The test produces a failure.

;L2: The test produces a failure.

;L3: The test produces a successful variable creation (hence why it resturns a void).



;-- EXPLANATIONS --
;L1: The test fails for L1 because "x" (a string) cannot be used as an identifier. 

;L2: The test fails for L2 because 2 (a number) cannot be used as an identifier. It is ok with "x" though.

;L3: The test is successful for L3 and can use both strings and numbers as identifiers. 

