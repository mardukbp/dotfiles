;; Python config
;; --------------

;; ; python-mode
;; (setq pymode-dir (expand-file-name "python-mode" site-lisp-dir))
;; (add-to-list 'load-path pymode-dir)
;; (require 'python-mode)

;; ; use IPython
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
(setq py-python-command-args '("-colors" "Linux"))
;; (setq py-force-py-shell-name-p t)

;; ; switch to the interpreter after executing code
;; (setq py-shell-switch-buffers-on-execute-p t)
;; (setq py-switch-buffers-on-execute-p t)

;; ; don't split windows
;; ;(setq py-split-windows-on-execute-p nil)

;; ; try to automagically figure out indentation
;; (setq py-smart-indentation t)

;; ; pymacs
;; (setq pymacs-dir (expand-file-name "Pymacs" site-lisp-dir))
;; (add-to-list 'load-path pymacs-dir)
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")
;; (require 'pymacs)

;; ; ropemacs
;; (setq pymacs-load-path '("~/emacs.d/site-lisp/ropemacs"))

;; (pymacs-load "ropemacs" "rope-")

(provide 'mb-python)
