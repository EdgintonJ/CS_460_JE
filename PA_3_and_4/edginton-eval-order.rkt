#lang mystery-languages/eval-order
; Jordan Edginton

; === EXPECTED TEST RESULTS ===
(TEST (begin (deffun (f x) (+ x x)) (f 4)) 8 failure)


; === HOW TO CLASSIFY A VARIANT ===
;L1: The test produces 8

;L2: the test produces a failure



;-- EXPLANATIONS --
;L1: L1 is eager and evaluates the expressions normally.

;L2: L2 is lazy and as such, looks for the values of x when the function f is called, but x wasn't defined yet.
;    This wouldn't be an issue if f wasn't defined within a begin statement; but since it is, the lazy eval will try and
;    evaluate is, causing an error.

