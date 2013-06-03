;; Simbolos
;; ---------
(defun infty ()
  (interactive)
  (progn
	  (insert "∞")))
	  
(defun prime ()
  (interactive)
  (progn
	  (insert "'")))

(defun deg ()
  (interactive)
  (progn
	  (insert "℃")))

(defun hbar ()
  (interactive)
  (progn
	  (insert "ℏ")))

(defun hamilton ()
  (interactive)
  (progn
	  (insert "ℋ")))

(defun cross ()
  (interactive)
  (progn
	  (insert "⨯")))

(defun dot ()
  (interactive)
  (progn
	  (insert "⋅")))

(defun leq ()
  (interactive)
  (progn
	  (insert "≤")))

(defun nabla ()
  (interactive)
  (progn
	  (insert "∇")))

(defun int ()
  (interactive)
  (progn
	  (insert "∫")))

(defun sum ()
  (interactive)
  (progn
	  (insert "∑")))

(defun oint ()
  (interactive)
  (progn
	  (insert "∮")))

(defun rarrow ()
  (interactive)
  (progn
	  (insert "→")))

(define-prefix-command 'symbols-keymap)

;; Insert math environment \[ ... \]
;; -----------------------------
(define-skeleton quoted-brackets
  "Insert \\[ ... \\]."
  nil "\\[" _ "\\]")

(define-key symbols-keymap (vector ?\[) 'quoted-brackets)

(define-key symbols-keymap (vector ?1) 'eye)
(define-key symbols-keymap (vector ?8) 'infty)
(define-key symbols-keymap (vector ?') 'prime)
(define-key symbols-keymap (vector ?0) 'deg)
(define-key symbols-keymap (vector ?h) 'hbar)
(define-key symbols-keymap (vector ?H) 'hamilton)
(define-key symbols-keymap (vector ?x) 'cross)
(define-key symbols-keymap (vector ?.) 'dot)
;;(define-key symbols-keymap (vector ?i) 'int)
(define-key symbols-keymap (vector ?c) 'oint)
(define-key symbols-keymap (vector ?s) 'sum)
(define-key symbols-keymap (vector ?n) 'nabla)
(define-key symbols-keymap (vector ?<) 'leq)
(define-key symbols-keymap (vector ?-) 'rarrow)

(global-set-key [(\')] 'symbols-keymap)
