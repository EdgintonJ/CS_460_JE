#lang plait
;; Author: Jordan Edginton

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================
; (define (funct_name [para_name1 : para_type] [para_name2 : para_type]): return_type

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (desugar (parse str))))

(define env-ht (hash (list)))

; Here is where we "desugar" for Expr. we turn and/or into if statements, let into app/lambda expressions,
; and we check if to see if there isn't an and/or within it
(define (desugar [expr : Expr]): Expr
  (type-case Expr expr
    [(sugar-and left right) (e-if (desugar left) (e-if (desugar right) (e-bool #t) (e-bool #f)) (e-bool #f))]
    [(sugar-or left right) (e-if (desugar left) (e-bool #t) (e-if (desugar right) (e-bool #t) (e-bool #f)))]
    [(sugar-let var value body) (e-app (e-lam var (desugar body)) value)]
    [(e-if cond consq altern) (e-if (desugar cond) (desugar consq) (desugar altern))]
    [else expr])  
  )

; here we check if the Value is a v-fun. if so, we interp the function while updating it's enviornment
(define (check_fun [val : Value] [arg : Value]): Value
  (type-case Value val
    [(v-fun param body env) (interp_env (desugar body) (add_env env param arg))]
    [else (raise-error(err-not-a-function val))]
    )
  )

;check if Value is a v-num in a + operation
(define (check_num [val : Value]): Value
  (type-case Value val
    [(v-num value) val]
    [else (raise-error(err-bad-arg-to-op (op-plus) val))]
    )
  )

;check if Value is a v-str in a ++ operation
(define (check_str [val : Value]): Value
  (type-case Value val
    [(v-str value) val]
    [else (raise-error(err-bad-arg-to-op (op-append) val))]
    )
  )

;check if Value is a v-num in a num= operation
(define (check_num_eq [val : Value]): Value
  (type-case Value val
    [(v-num value) val]
    [else (raise-error(err-bad-arg-to-op (op-num-eq) val))]
    )
  )

;check if Value is a v-str in a str= operation
(define (check_str_eq [val : Value]): Value
  (type-case Value val
    [(v-str value) val]
    [else (raise-error(err-bad-arg-to-op (op-str-eq) val))]
    )
  )

;check if Value is a v-bool in an if statement
(define (check_bool_if [val : Value]): Value
  (type-case Value val
    [(v-bool value) val]
    [else (raise-error(err-if-got-non-boolean val))]
    )
  )


; lookup item in env and return it's contents if found
(define (look_up [env : Env] [id : Symbol]): Value
  (type-case (Optionof Value) (hash-ref env id)
    [(some v) v]
    [(none) (raise-error (err-unbound-var id))]
    )
 )


; take an env, add item to a copy it, and return the new env
(define (add_env [env : Env] [id : Symbol] [val : Value]): Env
  (hash-set env id val)
  )


; This is our new interp function with the env parameter.
(define (interp_env [expr : Expr] [env : Env]): Value
  (type-case Expr expr
    [(e-num value) (v-num value)]
    [(e-str value) (v-str value)]
    [(e-bool value) (v-bool value)]
    [(e-var symbol) (look_up env symbol)]
    
    [(e-op op left right)
     (type-case Operator op
       [(op-plus) (v-num (+ (v-num-value (check_num (interp_env left env))) (v-num-value (check_num (interp_env right env)))))]       
       [(op-append) (v-str (string-append (v-str-value (check_str (interp_env left env))) (v-str-value (check_str (interp_env right env)))))]       
       [(op-str-eq) (v-bool (string=? (v-str-value (check_str_eq (interp_env left env))) (v-str-value (check_str_eq (interp_env right env)))))]       
       [(op-num-eq) (v-bool (= (v-num-value (check_num_eq (interp_env left env))) (v-num-value (check_num_eq (interp_env right env)))))]
             )]
    
    [(e-if cond consq altern) (if (v-bool-value (check_bool_if (interp_env cond env))) (interp_env consq env) (interp_env altern env))]
    
    [(e-app func arg) (check_fun (interp_env func env) (interp_env arg env))]
    [(e-lam param body) (v-fun param body env)]
    
    [else (v-bool #f)] ;else returns false, should never get here since all that's not implemented in interp are the sugars
    )
  )

; our old interp function that is called at the start. It now just calls our new interp using an empty enviornment.
(define (interp [expr : Expr]): Value
  (interp_env expr env-ht)
  )


