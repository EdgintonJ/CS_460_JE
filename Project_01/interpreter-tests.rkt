#lang racket
;; Author: Jordan Edginton
(require "interpreter.rkt"
         "support.rkt"
         "test-support.rkt")

(define/provide-test-suite student-tests ;; DO NOT EDIT THIS LINE ==========
  ; My basic tests
  (test-equal? "Works with Num primitive"
               (eval `2) (v-num 2))
  (test-equal? "Works with Str primitive"
               (eval `"test") (v-str "test"))
  (test-equal? "Works with Bool primitive"
               (eval `true) (v-bool #t))
  (test-equal? "Works with addition"
               (eval `(+ 1 (+ 1 2))) (v-num 4))
  (test-equal? "Works with string append"
               (eval `(++ "f" "or")) (v-str "for"))
  (test-equal? "Test number comparison"
               (eval `{num= 1 1}) (v-bool #t))
  (test-equal? "Test string comparison"
               (eval `{str= "abc" "abc"}) (v-bool #t))

  ;--- Guy's tests
  (test-equal? "Test if case for numbers"
               (eval `{if (num= 1 1) true false}) (v-bool #t))

  (test-equal? "Test if case for strings"
               (eval `{if (str= "abc" "abc") true false}) (v-bool #t))

  (test-equal? "Test if case for number addition"
               (eval `{if (num= (+ 1 1) 2) true false}) (v-bool #t))

  (test-equal? "Test if case for string appending"
               (eval `{if (str= (++ "Appending" "This") "AppendingThis") true false}) (v-bool #t))

 (test-raises-interp-error? "Passing Str to + results in err-bad-arg-to-op"
                             (eval `{+ "bad" 1})
                             (err-bad-arg-to-op (op-plus) (v-str "bad")))
     
  (test-raises-interp-error? "1Passing Boolean to + results in err-bad-arg-to-op"
                             (eval `{+ false true})
                             (err-bad-arg-to-op (op-plus) (v-bool #f)))

  (test-raises-interp-error? "2Passing Boolean to + results in err-bad-arg-to-op"
                             (eval `{+ true 1})
                             (err-bad-arg-to-op (op-plus) (v-bool #t)))
  
  (test-raises-interp-error? "Passing Str to + results in err-bad-arg-to-op"
                             (eval `{+ 1 "nope"})
                             (err-bad-arg-to-op (op-plus) (v-str "nope")))
  
  (test-raises-interp-error? "Passing Num to string append results in err-bad-arg-to-op"
                             (eval `{++ 1 "nope"})
                             (err-bad-arg-to-op (op-append) (v-num 1)))
  
  (test-raises-interp-error? "Passing Boolean and String to string append results in err-bad-arg-to-op"
                             (eval `{++ true "nope"})
                             (err-bad-arg-to-op (op-append) (v-bool #t)))
    
  (test-raises-interp-error? "Test string append Bool results in err-bad-arg-to-op"
               (eval `{++ "append" true})
               (err-bad-arg-to-op (op-append) (v-bool #t)))
  
  (test-raises-interp-error? "Passing string to num equality results in err-bad-arg-to-op"
                             (eval `{num= 1 "nope"})
                             (err-bad-arg-to-op (op-num-eq) (v-str "nope")))
  
  (test-raises-interp-error? "Passing num to string equality results in err-bad-arg-to-op"
                             (eval `{str= "nope" 1})
                             (err-bad-arg-to-op (op-str-eq) (v-num 1)))
  
  (test-raises-interp-error? "Passing non-bool to if clause"
                             (eval `{if (++ "append" "boolFailure") true false})
                             (err-if-got-non-boolean (v-str "appendboolFailure")))
  ;--- end Guy's tests
  

  ;--- crazy tests for grading
  (test-equal? "Test crazy addition"
               (eval `(+ 1 (+ (+ (+ (+ (+ (+ 1 2) 2) 2) 2) 2) (+ (+ (+ 1 2) 2) (+ (+ 1 2) (+ 1 2)))))) (v-num 23))
  
  (test-equal? "Test crazy number comparison"
               (eval `{num= (+ 1 (+ (+ (+ 1 2) 2) 2)) (+ (+ (+ 1 2) 2) (+ 1 2))}) (v-bool #t))
  
  (test-equal? "Test crazy string append"
               (eval `(++ (++ (++ "a" (++ "z" "u")) (++ (++ "r" " ") (++ "l" (++ "a" "n")))) "e")) (v-str "azur lane"))
  
  (test-equal? "Test crazy string comparison"
               (eval `{str= (++ (++ (++ "l" "ol") (++ "l" "ol")) "ol") (++ (++ "l" "ol") (++ (++ "l" "ol") "ol"))}) (v-bool #t))
  
  (test-equal? "Test crazy if case"
               (eval `{if (num= 1 1) {if (num= 1 1) {if (num= 1 1) {if (num= 1 1) {if (num= 1 1) true false} false} false} false} false}) (v-bool #t))

  (test-equal? "Test crazy multi case"
               (eval `{if (num= (+ 1 (+ 1 2)) (+ 1 (+ 1 2))) {if (str= (++ (++ "l" "ol") "ol") (++ (++ "l" "ol") "ol")) true false} false}) (v-bool #t))

  (test-raises-interp-error? "Test crazy multi error"
                             (eval `{if (num= (+ 1 (+ 1 2)) (+ 1 (+ 1 2))) {if (++ (++ (++ "l" "ol") "ol") (++ (++ "l" "ol") "ol")) true false} false})
                             (err-if-got-non-boolean (v-str "lolollolol")))

  ;--- PA 2 tests from Piazza
  (test-equal? "Testing and"
               (eval `(and (num= 1 1) (num= 1 1))) (v-bool #t))
  (test-equal? "Testing or"
               (eval `(or (num= 1 1) (num= 2 1))) (v-bool #t))
  (test-equal? "Testing or right"
               (eval `(or (num= 1 2) (num= 1 1))) (v-bool #t))
  (test-equal? "Test if with and"
               (eval `{if (and (num= 1 1) (num= 1 1)) true false}) (v-bool #t))
  (test-equal? "Test if with or"
               (eval `{if (or (num= 1 2) (num= 1 1)) true false}) (v-bool #t))

  (test-equal? "NESTED TEST: desugar AND - should return true"
               (eval `{if (and (and (and (and true true) (and true true)) (and (and true true) (and true true))) (and (and true true) (and true true))) true false}) (v-bool #t)
  )
  (test-equal? "NESTED TEST: desugar OR - should return true"
               (eval `{if (or (or (or (or false true) (or false true)) (or (or false true) (or false true))) (or (or false true) (or false true))) true false}) (v-bool #t)
  ) 
  
  (test-equal? "NESTED TEST: desugar AND - should return false"
               (eval `{if (and (and (and (and (and true false) (and true false)) (and (and true false) (and true false))) (and (and (and true false) (and true false)) (and (and true false) (and true false)))) (and (and (and true false) (and true false)) (and (and true false) (and true false)))) true false}) (v-bool #f)
  )


  (test-equal? "NESTED TEST: desugar OR - should return false"
               (eval `{if (or (or (or (or false false) (or false false)) (or (or false false) (or false false))) (or (or (or false false) (or false false)) (or (or false false) (or false false)))) true false}) (v-bool #f)
  )

  (test-equal? "Test grammar rule: (<expr> or <expr>) - simple short circuit"
               (eval `{or true 1})(v-bool #t))
  (test-raises-interp-error? "Trying to interpret a never-defined variable throws an error"
                             (eval `{+ a 8000})
                             (err-unbound-var 'a)
                             )
(test-raises-interp-error? "Using a non-function as a function throws an error"
                             (eval `{"xerophytic" 5})
                             (err-not-a-function (v-str "xerophytic")))

    (test-equal? "meaning of variables changes depending on scope"
               (eval `(
                       (lam x ( (lam x (+ x 3)) x))
                       2))
               (v-num 5)
               )
  
  (test-equal? "Ackermannesqe lambda hell"
               (eval `(
                       ((lam y ((lam x (x x)) (y y)))
                        (lam x x))
                       56))
               (v-num 56)
               )
  
  (test-raises-interp-error? "Using a non-function as a function throws an error"
                             (eval `{"xerophytic" 5})
                             (err-not-a-function (v-str "xerophytic")))

(test-raises-interp-error? "Trying to interpret a never-defined variable throws an error"
                             (eval `{+ a 8000})
                             (err-unbound-var 'a)
                             )
(test-raises-interp-error? "Trying to interpret an out-of scope variable throws an error"
                             (eval `{ (lam x (+ x 5)) x})
                             (err-unbound-var 'x)
                             )

(test-equal? "Lambda Test: If with param in true block"
               (eval `((lam x (if true (+ x x) 10)) 3)) (v-num 6))

(test-equal? "Lambda Test: If with param in false block"
               (eval `((lam x (if false (+ 20 20) x)) 3)) (v-num 3))

(test-equal? "Lambda Test: If with param in condition"
               (eval `((lam x (if (num= x 3) (+ 20 20) x)) 3)) (v-num 40))

(test-equal? "Lambda Test: If with var in condition"
               (eval `((lam x (if (num= x 3) (+ 20 20) x)) 3)) (v-num 40))

(test-equal? "Lambda Test: Lambda function call within true block of if"
               (eval `(if true ((lam x (+ x 5)) 2) (v-num 10))) (v-num 7))

(test-equal? "Lambda Test: Lambda funcation call within false block of if"
               (eval `(if false (v-num 10) ((lam x (+ x 5)) 2))) (v-num 7))

(test-equal? "Lambda Test: Lambda function call within condition using num="
               (eval `(if (num= 99 ((lam x (+ x 90)) 9)) ((lam x (+ x 5)) 2) (v-num 10))) (v-num 7))

(test-equal? "Lambda Test: Lambda call as left expression in plus operation"
               (eval `(+ ((lam x (+ x 5)) 2) 9)) (v-num 16))

(test-equal? "Lambda Test: Lambda call as right expression in plus operation"
               (eval `(+ 9 ((lam x (+ x 5)) 2))) (v-num 16))

  (test-equal? "Test LET using string"
               (eval `{let (x "this") x}) (v-str "this"))
  
  (test-equal? "Test LET using strings/append"
               (eval `{let (x "te") (++ x "st")}) (v-str "test"))

  (test-equal? "Test LET using strings/append - nested"
               (eval `{let (a "some") (let (b "thing") (++ a b))}) (v-str "something"))

  (test-equal? "Test LET using strings/append - nested part 2"
               (eval `{let (a "another") (let (b " ") (let (c "test") (++ a (++ b c))))}) (v-str "another test"))

  (test-equal? "Test LET using strings/append - deeply nested (idea borrowed and adapted from Evan's post as the credit goes to him, thanks Evan)"
               (eval `{let (a "how") (let (b " far ") (let (c "can ") (let (d "we") (let (e " go") (let (f "?") (++ a (++ b (++ c (++ d (++ e f))))))))))}) (v-str "how far can we go?"))

  (test-equal? "Test LET using bool"
               (eval `{let (x true) x}) (v-bool #t))

  (test-equal? "Test LET with AND using boolean"
               (eval `{let (x true) (and (num= (+ 2 0) (+ 1 1)) x)}) (v-bool #t))

  (test-equal? "Test LET with AND using boolean part 2"
               (eval `{let (x true) (let (y false) (and (and (num= (+ 1 18) (+ 9 10)) x) y))}) (v-bool #f))

  (test-equal? "Test LET with AND using addition and boolean"
               (eval `{let (x true) (and (num= (+ 2 1) (+ 0 3)) x)}) (v-bool #t))

  (test-equal? "Test LET with OR using boolean"
               (eval `{let (x true) (let (y false)(or x y))}) (v-bool #t))

  (test-equal? "Test LET with OR using boolean part 2"
               (eval `{let (x false) (let (y false) (or x y))}) (v-bool #f))

  (test-equal? "Test LET with AND/OR using addition and boolean"
               (eval `{let (x true) (let (y false) (and x (or (num= (+ 5 5) (+ 7 3)) y)))}) (v-bool #t))

  (test-equal? "Test LET with AND/OR using addition and boolean part 2"
               (eval `{let (x true) (let (y false) (or (and (num= (+ 67 33) (+ 25 75)) x) y))}) (v-bool #t))
   (test-equal? "Testing lambdas in lambdas in lambdas"
               (eval `((lam x (+ ((lam x (+ ((lam x (+ x x)) ((lam x (+ x x)) ((lam x (+ x x))x))) ((lam x (+ x x))x))) ((lam x (+ x x))x))
                                 ((lam x (+ ((lam x (+ x x)) ((lam x (+ x x)) ((lam x (+ x x))x))) ((lam x (+ x x))x))) ((lam x (+ x x))x)))) 2))
               (v-num 80))

  (test-equal? "Testing lambda (updating value of x)"
               (eval `((lam x ((lam x (+ x 1))x))2)) (v-num 3))

  (test-equal? "Test Homework 7 #3"
               (eval `((lam x ((lam f (f (+ x (+ x 1)))) (lam y (+ x y)))) 3))(v-num 10))
  (test-equal? "Test LET with sugar in variable assignment"
               (eval `{let (x (and true false)) x}) (v-bool #f)
  )

  (test-equal? "Test LET with sugar in the body"
               (eval `{let (x true) (and x x)}) (v-bool #t)
  )

  (test-equal? "Test LET with sugar in variable assignment and the body"
               (eval `{let (x (and true false)) (and x x)}) (v-bool #f)
  )
)
;; DO NOT EDIT BELOW THIS LINE =================================================

(module+ main (run-tests student-tests))
