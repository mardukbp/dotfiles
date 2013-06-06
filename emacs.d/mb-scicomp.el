;; Emacs iPython Notebook
;; ------------------------
(require 'ein)

(defun run-python2 () (interactive) (run-python "/usr/bin/python2"));; necessary for auto-completion

(defun run-ipython () (interactive) (async-shell-command "ipython notebook --pylab inline --notebook-dir=/media/Archivos/Documents/pynb"))
(defun pynb ()
  (interactive)
  (run-python2)
  (run-ipython)
  (delete-other-windows)
)

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
