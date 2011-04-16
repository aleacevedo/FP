(in-package :com.facorro.fp.functions)
;;------------------------------
;; Constante FP values
;;------------------------------
(defconstant *false-value* "F")
(defconstant *true-value* "T")
(defconstant *empty-list-value* "<>")
;;------------------------------
;; id
;;------------------------------
(defun id ()	
	(lambda (arg)
		(debug-msg :com.facorro.fp.functions "(id) arg: ~a~%" arg)
		arg))
;;------------------------------
;; selector
;;------------------------------
(defun selector (n)
	(lambda (arg)
		(cond 
			((> n 1) (funcall (selector (- n 1)) (cdr arg)))
			(t (car arg)))))
;;------------------------------
; selector-right
;;------------------------------
(defun selector-right (n)
  (lambda (arg)
    (cond 
		((> (length arg) 0)
           (cond 
				((= n (length arg)) (car arg))
				(t (funcall (selector-right n) (cdr arg)))))
		(t nil))))
;;------------------------------
; tl (tail)
;;------------------------------
(defun tl ()
	(lambda (arg) (cdr arg)))
;;------------------------------
; tlr (tail right)
;;------------------------------
(defun tlr ()
	(lambda (arg)
		(cond 
			((<= (length arg) 1) nil)
			(t (append (list (car arg)) (funcall (tlr) (cdr arg)))))))
;;------------------------------
; atom
;;------------------------------
(defun fp-atom ()
	(lambda (arg) (get-truth-value (atom arg))))
;;------------------------------
; eq
;;------------------------------
(defun fp-eq ()
	(lambda (arg) (get-truth-value (equal (car arg) (cadr arg)))))
;;------------------------------
; fp-null
;;------------------------------
(defun fp-null ()
	(lambda (arg) (get-truth-value (null arg))))
;;------------------------------
; fp-reverse
;;------------------------------
(defun fp-reverse ()
  (lambda (arg) (reverse arg)))
;;------------------------------
; fp-iota
;;------------------------------
(defun iota ()
  (lambda (n)
    (cond ((< n 2) (list 1))
          (t (append (funcall (iota) (- n 1)) (list n))))))
;;------------------------------
; fp-distl
;;------------------------------
(defun distl ()
	(lambda (arg)
		(let ((l (cadr arg))
             (a (car arg)))
			(cond 
				((funcall (fp-null) l) nil)
				(t
					(append (list (list a (car l))) (funcall (distl) (list a (cdr l)))))))))
;;------------------------------
; fp-distr
;;------------------------------
(defun distr ()
  (lambda (arg)
    (let ((l (car arg))
          (a (cadr arg)))
      (cond ((funcall (fp-null) l) nil)
            (t
             (append (list (list (car l) a)) (funcall (distr) (list (cdr l) a))))))))
;;------------------------------
; fp-length
;;------------------------------
(defun fp-length ()
  (lambda (arg) (length arg)))
;;------------------------------
; Binary operators
; + - * / < >
;;------------------------------
(defun make-fp-operator (op)
  (lambda (arg) (funcall op (car arg) (cadr arg))))
;;------------------------------
; -
;;------------------------------
(defun fp-- ()
  (make-fp-operator #'-))
;;------------------------------
; +
;;------------------------------
(defun fp-+ ()
  (make-fp-operator #'+))
;;------------------------------
; *
;;------------------------------
(defun fp-* ()
  (make-fp-operator #'*))
;;------------------------------
; % Division
;;------------------------------
(defun fp-% ()
  (make-fp-operator #'/))
;;------------------------------
; <
;;------------------------------
(defun fp-< ()
	(lambda (arg)
		(get-truth-value (< (first arg) (second arg)))))
	;(make-fp-operator #'<))
;;------------------------------
; >
;;------------------------------
(defun fp-> ()
	(lambda (arg)
		(get-truth-value (> (first arg) (second arg)))))
;;------------------------------
; trans
;;------------------------------
(defun trans ()
  (lambda (arg)
    (cond ((funcall (fp-null) (car arg)) nil)
          (t
           (append (list (mapcar #'car arg)) (funcall (trans) (mapcar #'cdr arg)))))))
;;------------------------------
; and
;;------------------------------
(defun fp-and ()
	(lambda (arg)
		(get-truth-value (eval (append '(and) (map-truth-values arg))))))
;;------------------------------
;; or
;;------------------------------
(defun fp-or ()
	(lambda (arg)
		(get-truth-value (eval (append '(or) (map-truth-values arg))))))
;;------------------------------
;; map-truth-values
;;------------------------------
(defun map-truth-values (arg)
	(mapcar (lambda (val) (equal val *true-value*)) arg))
;;------------------------------
;; get-truth-value
;;------------------------------
(defun get-truth-value (data)
	(if data *true-value* *false-value*))
;;------------------------------
;; not
;;------------------------------
(defun fp-not ()
	(lambda (arg) (if (not arg) *true-value* *false-value*)))
;;------------------------------
; fp-appendl
;;------------------------------
(defun appendl ()
  (lambda (arg)
    (let ((a (car arg))
          (l (cadr arg)))
      (cons a l))))
;;------------------------------
; fp-appendr
;;------------------------------
(defun appendr ()
  (lambda (arg)
    (let ((l (first arg))
          (a (second arg)))
      (append l (list a)))))
;;------------------------------
; rot
;;------------------------------
(defun rot ()
  (lambda (arg)
    (funcall (appendr) 
             (list (cdr arg) (car arg)))))
;;------------------------------
; rotr
;;------------------------------
(defun rotr ()
  (lambda (arg)
    (funcall (appendl) 
             (list (funcall (selector-right 1) arg) 
                   (funcall (tlr) arg)))))
;;------------------------------
; fp-compose
;;------------------------------
(defun compose (f1 f2)
  (lambda (l) (funcall f1 (funcall f2 l))))
;;------------------------------
; fp-construct
;;------------------------------
(defun construct (&rest args)
	(lambda (arg) (mapcar (lambda (f) (funcall f arg)) args)))
;;------------------------------
; fp-const
;;------------------------------
(defun const (const)
  (lambda (arg) 
	arg ; To avoid compiler warning and mantain homogeinity
	const))
;;------------------------------
; fp-cond
;;------------------------------
(defun fp-cond (a b c)
  (lambda (arg) (if (funcall a arg) (funcall b arg) (funcall c arg))))
;;------------------------------
; fp-insert
;;------------------------------
(defun insert (f)
  (lambda (arg) (cond
                  ((funcall (fp-null) arg) nil)
                  ((= (length arg) 1) (car arg))
                  ((= (length arg) 2) (funcall f (list (car arg) (cadr arg))))
                  (t
                   (funcall f (list (car arg) (funcall (insert f) (cdr arg))))))))
;;------------------------------
; alpha
;;------------------------------
(defun alpha (f)
  (lambda (l) (mapcar f l)))
;;------------------------------
; def
;;------------------------------
(defun def (name fn)
	"Creates a user defined function"
	(lambda ()
		(add-function (def-fp-function name (lambda () fn)))
		(concatenate 'string "FUNCTION " name " DEFINED")))