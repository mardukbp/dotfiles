;; Emacs iPython Notebook
;; ------------------------
;;(require 'ein)

(defun run-python2 () (interactive) (run-python "/usr/bin/python2")) ;; necessary for auto-completion

(defun pynb-tesis ()
  (interactive)
  (run-python2)
  (async-shell-command "ipython notebook --pylab inline --profile=tesis")
  (delete-other-windows)
)

(defun pynb-default ()
  (interactive)
  (run-python2)
  (async-shell-command "ipython notebook --pylab inline --profile=default")
  (delete-other-windows)
)

;; open notebook list with a separate function because waiting time for the server is variable
(defun ein ()
  (interactive)
  (ein:notebooklist-open nil)
)

;; pydoc-info
;; (require 'pydoc-info)

;; Maxima mode
;; -------------
(defvar maxima-version
  (substring ;; removes the trailing \n
   (shell-command-to-string "maxima --version | sed 's/Maxima //'")
   0 -1)
"Maxima version")

(add-to-list 'load-path (concat "/usr/share/maxima/" maxima-version "/emacs/"))
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)
(setq imaxima-use-maxima-mode-flag t)

(provide 'mb-scicomp)
