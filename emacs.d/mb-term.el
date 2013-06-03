;; Terminal
;; -----------
;; sources:
;; http://emacs-journey.blogspot.mx/2012/06/improving-ansi-term.html

;; Start bash shell when calling term 
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

;; kill buffer when exiting terminal
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; Easier to add hooks to term-mode
(defun my-term-hook ()
  (define-key term-raw-map "\C-y" 'my-term-paste)
)

;; Make C-y work in ansi-term
(defun my-term-paste (&optional string)
 (interactive)
 (process-send-string
  (get-buffer-process (current-buffer))
  (if string string (current-kill 0))))

(add-hook 'term-mode-hook 'my-term-hook)

;;(global-set-key [f1] 'ansi-term)

(provide 'mb-term)
