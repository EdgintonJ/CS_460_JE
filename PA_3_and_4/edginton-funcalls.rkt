#lang mystery-languages/fun-calls
; Jordan Edginton

; === EXPECTED TEST RESULTS ===
(deffun (f) 4)
(deffun (g x) (+ x x))
(TEST (g ((g (f)))) failure 4 8)



; === HOW TO CLASSIFY A VARIANT ===
;L1: test 1 produces a failure.

;L2: test 1 produces 4.

;L3: test 1 produces 8.



;-- EXPLANATIONS --
;L1: L1 fails because the language cannot use a procedure as an argument for a function

;L2: L2 returns our argument used for the outer function [(g (f))] and doesn't apply it to the outer g function call

;L3: L3 correctly returns applies the result of the inner g function as an arguemtent for the outer g function.
