#lang mystery-languages/mut-structs
; Jordan Edginton

; === EXPECTED TEST RESULTS ===
(defvar o (object [a 43] [c (object [m 24])]))
(deffun (m x) (oset (oget x c) m 6) (oset x a 12))
(m o)
(TEST (oget (oget o c) m) 6 6 24)
(TEST (oget o a) 12 43 43)


; === HOW TO CLASSIFY A VARIANT ===
;L1: Test 1 produces 6, test 2 produces 12

;L2: Test 1 produces 6, test 2 produces 43

;L3: Test 1 produces 24, test 2 produces 43



;-- EXPLANATIONS --
;L1: L1 can modify an item within an object, as well as a nested object's item, using a function and keep the changes after the function returns.
;    L1 is directly modifying the object and so all changes affect the original.

;L2: L2 can only modify a nested object's item using a function and keep the changes after the function returns.
;    L2 is modifying a copy when modifying an item, but the nested object is not a copy and therefore L2 is modifying the actual item.

;L3: L3 can't modify an item within an object and keep the changes after the function returns.
;    L3 is only modifying a copy of the object, so the original object remains the same.
