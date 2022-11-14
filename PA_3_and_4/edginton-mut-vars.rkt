#lang mystery-languages/mut-vars
; Jordan Edginton

; === EXPECTED TEST RESULTS ===
(defvar w 3)
(deffun (g v) (set! v (+ v 12)))
(g w)
(TEST w 3 15 15)

(deffun (t) (set! t 4))
(t)
(TEST t 4 failure 4)

; === FAILED TESTS ===
(TEST (defvar w (deffun (x) 2)) failure failure failure)



; === HOW TO CLASSIFY A VARIANT ===
;L1: test 1 produces 3, test 2 is a 4, test 3 is a failure

;L2: test 1 produces 15, test 2 is a failure, test 3 is a failure

;L3: test 1 produces 15, test 2 is a 4, test 3 is a failure



;-- EXPLANATIONS --
;L1: L1 will not allow you do change a variable within a function

;I could not figure out L2 and L3, but I got a test that gave me difefrent errors for all 3 languages.

;L2:
;    from the failed test, L2 had a "box" funciton only within the "defvar" function. I imagine this box causes an
;    error within defvar, but I couldn't figure out how to trigger it.

;L3: The closest i could get is the deffun (t) test. From the failed test,
;    L3 had a "thunk" function within deffun, and I'm assuming the same thing happens here like in L2.
;    I again though couldn't figure out how to trigger it.

