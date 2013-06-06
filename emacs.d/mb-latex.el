;;====================
;; LaTeX
;;====================

;; Preview LaTeX
(load "preview-latex.el" nil t t)

;; Fold mode
(add-hook 'LaTeX-mode-hook 'TeX-fold-mode)

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

;;{{{ RefTeX

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(setq reftex-plug-into-auctex t)

;; source: http://ergoemacs.org/emacs/modernization_mark-word.html
(defun select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters are paired characters:
 () [] {} «» ‹› “” 〖〗 【】 「」 『』 （） 〈〉 《》 〔〕 ⦗⦘ 〘〙 ⦅⦆ 〚〛 ⦃⦄
 For practical purposes, also: \"\", but not single quotes."
 (interactive)
 (let (start end)
   (skip-chars-backward "^<>([{“「『‹«（〈《〔【〖⦗〘⦅〚⦃\"")
   (setq start (point))
   (skip-chars-forward "^<>)]}”」』›»）〉》〕】〗⦘〙⦆〛⦄\"")
   (setq end (point))
   (buffer-substring-no-properties start end)
   )
 )

;; Source: http://permalink.gmane.org/gmane.emacs.auctex.devel/2757

;; given a key and a field name return the value of that entry's field.
(defun reftex-get-data (key data)
  (let* ((files (reftex-get-bibfile-list))
	 (entry (condition-case nil
		    (save-excursion
		      (reftex-pop-to-bibtex-entry key files nil nil nil t))
		  (error
		   (if files
		       (message "cite: no such database entry: %s" key)
		     (message "%s" (substitute-command-keys
				    (format reftex-no-info-message "cite"))))
		   nil))))
    (when entry
      (cdr (assoc data (reftex-parse-bibtex-entry entry))))))

;; Open file at point in \cite{...}
(defun reftex-open-file ()
  (interactive)
  (let ((file (reftex-get-data (select-text-in-quote) "file")))
    (when file
      (let ((name (concat "" (save-match-data
				(string-match ":\\(.*\\):" file)
				(match-string 1 file)))))
	(call-process-shell-command "zathura" nil nil nil (concat "\"" name "\"" ))))))

;;}}}

;; Auto-reload document in order get support for packages
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;;(setq TeX-electric-sub-and-superscript t) 

;; enable LaTeX-math-mode by default
;;(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)



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

(add-hook 'LaTeX-mode-hook
          (lambda () 
	    (local-set-key (kbd "4") '(lambda () (interactive) (insert "$")))
	    (local-set-key (kbd "5") '(lambda () (interactive) (insert "%")))
	    (local-set-key (kbd "6") '(lambda () (interactive) (insert "^")))
	    (local-set-key (kbd "7") '(lambda () (interactive) (insert "&")))
	    (local-set-key (kbd "9") '(lambda () (interactive) (insert "(")))
	    (local-set-key (kbd "0") '(lambda () (interactive) (insert ")")))
	    (local-set-key (kbd "=") '(lambda () (interactive) (insert "+")))

	    (local-set-key (kbd "$") '(lambda () (interactive) (insert "4")))
	    (local-set-key (kbd "%") '(lambda () (interactive) (insert "5")))
	    (local-set-key (kbd "^") '(lambda () (interactive) (insert "6")))
	    (local-set-key (kbd "&") '(lambda () (interactive) (insert "7")))
	    (local-set-key (kbd "(") '(lambda () (interactive) (insert "9")))
	    (local-set-key (kbd ")") '(lambda () (interactive) (insert "0")))
	    (local-set-key (kbd "+") '(lambda () (interactive) (insert "=")))

))

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