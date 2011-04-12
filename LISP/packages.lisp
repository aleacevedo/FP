;----------------------------------------------------
(defpackage :com.facorro.debug
	(:use 
		:common-lisp)
	(:export
		:debugging?
		:start-debug
		:stop-debug))
;----------------------------------------------------
(defpackage :com.facorro.tree
	(:use 
		:common-lisp)
	(:export
		:make-node
		:children
		:datum
		:add-child))
;----------------------------------------------------
(defpackage :com.facorro.string
	(:use 
		:common-lisp)
	(:export 
		:string-split
		:string-explode))
;----------------------------------------------------
(defpackage :com.facorro.parser
	(:use 
		:common-lisp)
	(:export 
		:*rules*
		:add-rule
		:parse
		:apply-rule
		:defrule))
;----------------------------------------------------
(defpackage :com.facorro.fp.functions
	(:use :common-lisp)
	(:export 
		:get-function
		:operand?
		:precedence
		:num-params
		:*functions*))
;----------------------------------------------------
(defpackage :com.facorro.fp.parser
	(:use 
		:common-lisp
		:com.facorro.parser
		:com.facorro.string
		:com.facorro.fp.functions
		:com.facorro.tree
		:com.facorro.debug))
;----------------------------------------------------
(defpackage :com.facorro.fp.evaluator
	(:use 
		:common-lisp
		:com.facorro.fp.functions)
	(:export
		:evaluate))
;----------------------------------------------------
(defpackage :com.facorro.test
	(:use :common-lisp)
	(:export :test))
;----------------------------------------------------
(defpackage :com.facorro.fp.interpreter
	(:use 
		:common-lisp 
		:com.facorro.fp.functions
		:com.facorro.parser
		:com.facorro.test
		:com.facorro.fp.evaluator)
	(:export
		:interpret))
;----------------------------------------------------
(defpackage :com.facorro.fp.repl
	(:use
		:common-lisp
		:com.facorro.fp.interpreter)
	(:export
		:fp-repl))
;----------------------------------------------------