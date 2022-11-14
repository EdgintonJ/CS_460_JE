#lang mystery-languages/scope
; Jordan Edginton

; === EXPECTED TEST RESULTS ===

(TEST ((lambda (x) (+ x 2)) 5) 7 7)

(TEST ((lambda (x) (+ x 5)) x) failure 10)


; === HOW TO CLASSIFY A VARIANT ===
;L1: test 1 produces a 7, while test 2 produces an error since x is not defined

;L2: test 1 produces a 7, and test 2 produces a 10



;-- EXPLANATIONS --
;L1: L1 uses static scoping and while it's fine for the first test (since we difined x), it doesn't
;    work for tthe second test since x (as the argument) is no longer defined.

;L2: L2 uses dynamic scoping. It's the same for the first test, but x is still defined and can be used again for
;    the second test as an argument.
