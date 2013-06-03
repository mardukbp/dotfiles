;;====================
;; LaTeX
;;====================

;;{{{ Compile LaTeX
;; --------------

(setq TeX-PDF-mode t)

;; Ask no questions
(add-hook 'LaTeX-mode-hook (lambda () (setq TeX-command-force "latex")))

;; (defun latex ()
;;   (interactive)
;;   (progn
;; 	  (TeX-command-menu "LaTeX")))

;; (global-set-key (kbd "<f4>") 'latex)

;;}}}

;;(setq TeX-electric-sub-and-superscript t) 

;; enable LaTeX-math-mode by default
;;(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; Activate RefTeX
;;(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;;(setq reftex-plug-into-auctex t)

;; Spellcheck on the fly
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;(add-hook 'tex-mode-hook 'flyspell-mode)
;;(add-hook 'bibtex-mode-hook 'flyspell-mode)

(setq ispell-local-dictionary "castellano")

;;'(LaTeX-math-abbrev-prefix (kbd ":"))

;; Keymaps
;; --------
;; Revisar APL keymap en Xah Lee

;;(load-file (expand-file-name "tex/xetex-symbols-keymap.el" user-emacs-directory))
;;(load-file (expand-file-name "tex/xetex-greek-keymap.el" user-emacs-directory))

;; modify bindings for math mode
;; ------------------------------
;; (eval-after-load "latex"
;;   '(progn
;;        (define-key LaTeX-math-keymap "2" 'LaTeX-math-sqrt)
;;        (define-key LaTeX-math-keymap "!" 'LaTeX-math-not)
;;        (define-key LaTeX-math-keymap "/" 'LaTeX-math-frac)))

;; (setq
;; LaTeX-math-list '(
;; 	   (?6 "partial" nil)
;; 	   (?8 "infty" nil)
;; ))

;; VisibleBookmarks
;; -----------------
;(require 'bm)
;(global-set-key (kbd "<S-f2>") 'bm-toggle)
;(global-set-key (kbd "<f2>") 'bm-next)
;(global-set-key (kbd "<C-f2>") 'bm-previous)
;(global-set-key (kbd "<f3>") 'bm-save)
;(setq bm-highlight-style 'bm-highlight-line-and-fringe)

;; Make buffer persistent by default
;(setq-default bm-buffer-persistence t)

;; Loading the repository from file when on start up.
;(add-hook 'LaTeX-mode-hook 'bm-load-and-restore)

;; Save
;; -----
;; (defun save ()
;;   (interactive)
;;   (progn
;; 	  (save-buffer)))

;; (global-set-key (kbd "<f5>") 'save)

;; Preview LaTeX
;; --------------
;; (defun prev-reg ()
;;   (interactive)
;;   (progn
;; 	  (preview-at-point)))

;; (global-set-key (kbd "<f6>") 'prev-reg)

(provide 'mb-latex)
