;; C Mode
;; --------

(setq-default c-basic-offset 4)

;; Line numbers, vim style
;; ------------------------
(require 'linum)
(add-hook 'c-mode-hook 'linum-mode)

;;{{{ Key bindings
;; ----------------

(defun en-us-keymap ()
  (local-set-key (kbd "9") '(lambda () (interactive) (insert "(")))
  (local-set-key (kbd "0") '(lambda () (interactive) (insert ")")))
  (local-set-key (kbd "[") '(lambda () (interactive) (insert "{")))
  (local-set-key (kbd "]") '(lambda () (interactive) (insert "}")))

  (local-set-key (kbd "(") '(lambda () (interactive) (insert "9")))
  (local-set-key (kbd ")") '(lambda () (interactive) (insert "0")))
  (local-set-key (kbd "{") '(lambda () (interactive) (insert "[")))
  (local-set-key (kbd "}") '(lambda () (interactive) (insert "]")))

  ;; automatic indentation
  (local-set-key (kbd "RET") 'newline-and-indent)
)

(defun es-latam-keymap ()
  (local-set-key (kbd "8") '(lambda () (interactive) (insert "(")))
  (local-set-key (kbd "9") '(lambda () (interactive) (insert ")")))
  
  (local-set-key (kbd "(") '(lambda () (interactive) (insert "8")))
  (local-set-key (kbd ")") '(lambda () (interactive) (insert "9")))
  
  ;; automatic indentation
  (local-set-key (kbd "RET") 'newline-and-indent)
)

(add-hook 'c-mode-hook 'es-latam-keymap)

;;}}}


;; Include header
;; ---------------
;; (defun pointed-bracket ()
;; 	(local-set-key "<" 'skeleton-pair-insert-maybe)
;; )
;; (add-hook 'c-mode-common-hook 'pointed-bracket)

;; Load CEDET
;; -----------

;; (global-ede-mode 'nil)                  ; do NOT use project manager

;; (semantic-load-enable-excessive-code-helpers)

;; (require 'semantic-ia)          ; names completion and display of tags
;; (require 'semantic-gcc)         ; auto locate system include files

;; ;;(semantic-add-system-include "~/3rd-party/boost-1.43.0/include/" 'c++-mode)
;; ;;(semantic-add-system-include "~/3rd-party/protobuf-2.3.0/include" 'c++-mode)

;; (require 'semanticdb)
;; (global-semanticdb-minor-mode 1)

;; (defun my-cedet-hook ()
;;   (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;;   (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
;;   (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;;   (local-set-key "\C-c=" 'semantic-decoration-include-visit)
;;   (local-set-key "\C-cj" 'semantic-ia-fast-jump)
;;   (local-set-key "\C-cq" 'semantic-ia-show-doc)
;;   (local-set-key [(super w)] 'semantic-symref)
;;   (local-set-key "\C-cs" 'semantic-ia-show-summary)
;;   (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
;;   (local-set-key "\C-c+" 'semantic-tag-folding-show-block)
;;   (local-set-key "\C-c-" 'semantic-tag-folding-fold-block)
;;   (local-set-key "\C-c\C-c+" 'semantic-tag-folding-show-all)
;;   (local-set-key "\C-c\C-c-" 'semantic-tag-folding-fold-all)
;;   )
;; (add-hook 'c-mode-common-hook 'my-cedet-hook)

;; (global-srecode-minor-mode 1)    ; Enable template insertion menu
;; (global-semantic-tag-folding-mode 1)
;; '(semantic-completion-displayor-format-tag-function (quote semantic-format-tag-summarize))
;; (global-semantic-idle-summary-mode 1)
;; (global-semantic-idle-scheduler-mode 1)
;; (global-semantic-idle-completions-mode 1)
;; (global-semantic-decoration-mode 1)
;; (global-semantic-highlight-func-mode 1)
;; (global-semantic-stickyfunc-mode 1)

;; (require 'eassist)

;; ;(concat essist-header-switches ("hh" "cc"))
;; (defun alexott/c-mode-cedet-hook ()
;;   (local-set-key "\C-ct" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-xt" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-ce" 'eassist-list-methods)
;;   (local-set-key "\C-c\C-r" 'semantic-symref)
;;   )
;; (add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)

;; ;; gnu global support
;; (require 'semanticdb-global)
;; (semanticdb-enable-gnu-global-databases 'c-mode)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)

;; ;; ctags
;; (require 'semanticdb-ectag)
;; (semantic-load-enable-primary-exuberent-ctags-support)

;;(global-semantic-idle-tag-highlight-mode 1)

;; Load ECB
;; ---------

;; (require 'ecb)
;; (require 'ecb-autoloads)

;; Load doxymacs
;; --------------

;; (require 'doxymacs)
;; (add-hook 'c-mode-common-hook 'doxymacs-mode)

;; (defun my-doxymacs-font-lock-hook ()
;;      (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
;;          (doxymacs-font-lock)))
;;    (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

(provide 'mb-c)
