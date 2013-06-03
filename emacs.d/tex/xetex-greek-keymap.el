;; Letras griegas
;; ---------------
(defun ga ()
  (interactive)
  (progn
	  (insert "α")))

(defun gA ()
  (interactive)
  (progn
	  (insert "𝛢")))

(defun gb ()
  (interactive)
  (progn
	  (insert "𝛽")))

(defun gB ()
  (interactive)
  (progn
	  (insert "𝛣")))

(defun gg ()
  (interactive)
  (progn
	  (insert "𝛾")))

(defun gG ()
  (interactive)
  (progn
	  (insert "𝛤")))

(defun gd ()
  (interactive)
  (progn
	  (insert "𝛿")))

(defun gD ()
  (interactive)
  (progn
	  (insert "𝛥")))

(defun ge ()
  (interactive)
  (progn
	  (insert "𝜀")))

(defun gE ()
  (interactive)
  (progn
	  (insert "𝛦")))

(defun gz ()
  (interactive)
  (progn
	  (insert "𝜁")))

(defun gZ ()
  (interactive)
  (progn
	  (insert "𝛧")))

(defun gh ()
  (interactive)
  (progn
	  (insert "𝜂")))

(defun gH ()
  (interactive)
  (progn
	  (insert "𝛨")))

(defun gq ()
  (interactive)
  (progn
	  (insert "𝜃")))

(defun gQ ()
  (interactive)
  (progn
	  (insert "𝛩")))

(defun gk ()
  (interactive)
  (progn
	  (insert "𝜅")))

(defun gK ()
  (interactive)
  (progn
	  (insert "𝛫")))

(defun gl ()
  (interactive)
  (progn
	  (insert "𝜆")))

(defun gL ()
  (interactive)
  (progn
	  (insert "𝛬")))

(defun gm ()
  (interactive)
  (progn
	  (insert "𝜇")))

(defun gM ()
  (interactive)
  (progn
	  (insert "𝛭")))

(defun gn ()
  (interactive)
  (progn
	  (insert "𝜈")))

(defun gN ()
  (interactive)
  (progn
	  (insert "𝛮")))

(defun gj ()
  (interactive)
  (progn
	  (insert "𝜉")))

(defun gJ ()
  (interactive)
  (progn
	  (insert "𝛯")))

(defun gp ()
  (interactive)
  (progn
	  (insert "𝜋")))

(defun gP ()
  (interactive)
  (progn
	  (insert "𝛱")))

(defun gr ()
  (interactive)
  (progn
	  (insert "𝜌")))

(defun gs ()
  (interactive)
  (progn
	  (insert "𝜎")))

(defun gS ()
  (interactive)
  (progn
	  (insert "𝛴")))

(defun gt ()
  (interactive)
  (progn
	  (insert "𝜏")))

(defun gf ()
  (interactive)
  (progn
	  (insert "𝜑")))

(defun gF ()
  (interactive)
  (progn
	  (insert "𝛷")))

(defun gx ()
  (interactive)
  (progn
	  (insert "𝜒")))

(defun gy ()
  (interactive)
  (progn
	  (insert "𝜓")))

(defun gY ()
  (interactive)
  (progn
	  (insert "𝛹")))

(defun gw ()
  (interactive)
  (progn
	  (insert "𝜔")))

(defun gW ()
  (interactive)
  (progn
	  (insert "𝛺")))

(define-prefix-command 'greek-keymap)
(define-key greek-keymap (vector ?a) 'ga)
(define-key greek-keymap (vector ?A) 'gA)
(define-key greek-keymap (vector ?b) 'gb)
(define-key greek-keymap (vector ?B) 'gB)
(define-key greek-keymap (vector ?g) 'gg)
(define-key greek-keymap (vector ?G) 'gG)
(define-key greek-keymap (vector ?d) 'gd)
(define-key greek-keymap (vector ?D) 'gD)
(define-key greek-keymap (vector ?e) 'ge)
(define-key greek-keymap (vector ?E) 'gE)
(define-key greek-keymap (vector ?z) 'gz)
(define-key greek-keymap (vector ?h) 'gh)
(define-key greek-keymap (vector ?q) 'gq)
(define-key greek-keymap (vector ?Q) 'gQ)
(define-key greek-keymap (vector ?k) 'gk)
(define-key greek-keymap (vector ?l) 'gl)
(define-key greek-keymap (vector ?L) 'gL)
(define-key greek-keymap (vector ?m) 'gm)
(define-key greek-keymap (vector ?n) 'gn)
(define-key greek-keymap (vector ?j) 'gj)
(define-key greek-keymap (vector ?J) 'gJ)
(define-key greek-keymap (vector ?p) 'gp)
(define-key greek-keymap (vector ?P) 'gP)
(define-key greek-keymap (vector ?r) 'gr)
(define-key greek-keymap (vector ?s) 'gs)
(define-key greek-keymap (vector ?S) 'gS)
(define-key greek-keymap (vector ?t) 'gt)
(define-key greek-keymap (vector ?f) 'gf)
(define-key greek-keymap (vector ?F) 'gF)
(define-key greek-keymap (vector ?x) 'gx)
(define-key greek-keymap (vector ?y) 'gy)
(define-key greek-keymap (vector ?Y) 'gY)
(define-key greek-keymap (vector ?w) 'gw)
(define-key greek-keymap (vector ?W) 'gW)

(global-set-key [(\;)] 'greek-keymap)
