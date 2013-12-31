;; Dired-X
;; --------
(add-hook 'dired-load-hook
 (lambda ()
  (load "dired-x")
 ))

;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))
;; Toggle the view with dired-omit-mode (M-o by default).

(add-to-list 'load-path (expand-file-name "dired-details" site-lisp-dir))
(require 'dired-details+)

;;{{{ Defuns

(defun unmount ()
  "Unmount device in dired"
  (interactive)
  (shell-command 
   (concat "udiskie-umount " (shell-quote-argument (dired-get-filename)))
  )
  (revert-buffer)
)

;; requires pacaur -S trash
(setq delete-by-moving-to-trash t)
(defun empty-trash()
  (interactive)
  (shell-command "trash --empty")
)

(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

(global-set-key (kbd "C-c s") 'sudo-find-file)


(defun truecrypt ()
  (interactive)
  (shell-command "truecrypt --mount /home/marduk/Personal/archivero_fiscal /media/truecrypt1")
  (dired-x-find-file "/media/truecrypt1")
)

(defun unmount-truecrypt ()
  (interactive)
  (shell-command "truecrypt --dismount /media/truecrypt1")
)

;;}}}

;;{{{ File associations
;; ---------------------

;; requires dired-x
;; incompatible with icicles
(setq dired-guess-shell-alist-user
    '(("\\.pdf\\'"  "zathura")
      ("\\.ps\\'"   "zathura")
      ("\\.eps\\'"  "zathura")
      ("\\.djvu\\'" "zathura")
     )
)

;;}}}

;;{{{ Saner defaults

(setq dired-dwim-target t)

;; delete window and kill buffer
(defun really-quit ()
  (interactive)
  (quit-window t)
)

(add-hook 'dired-mode-hook
(lambda()
  (local-set-key (kbd "q") 'really-quit)
))

;; Enable dired-find-alternate-file
(put 'dired-find-alternate-file 'disabled nil)

;; Use enter and delete to visit a directory and its parent
(add-hook 'dired-mode-hook
 (lambda ()
   (define-key dired-mode-map (kbd "<return>") 'dired-find-alternate-file)
   (define-key dired-mode-map (kbd "\d")
     (lambda () (interactive) (find-alternate-file ".."))
   )
 )
)

;;}}}

;;{{{ Async file copying with Rsync
;; source: http://truongtx.me/2013/04/08/emacs-async-file-copying-with-rsync-update/

;; run the input command asynchronously
(defun tmtxt/dired-async (dired-async-command dired-async-command-name)
  "Execute the async shell command in dired.
dired-async-command: the command to execute
dired-async-command-name: just the name for the output buffer

Create a new window at the bottom, execute the dired-async-command and print
the output the that window. After finish execution, print the message to that
window and close it after 3s"
  (let ((dired-async-window-before-sync (selected-window))
		(dired-async-output-buffer
		 (concat "*" dired-async-command-name "*" " at " (current-time-string))))

	;; make a new window
	(tmtxt/dired-async-new-async-window)
	;; not allow popup
	(add-to-list 'same-window-buffer-names dired-async-output-buffer)
	;; run async command
	(async-shell-command dired-async-command dired-async-output-buffer)
	;; set event handler for the async process
	(set-process-sentinel (get-buffer-process dired-async-output-buffer)
						  'tmtxt/dired-async-process-handler)
	;; switch the the previous window
	(select-window dired-async-window-before-sync)))

;; create a new window for async command to display output
(defun tmtxt/dired-async-new-async-window ()
  "Create a new window for displaying tmtxt/dired-async process and switch to that window"
  (let ((dired-async-window-height (- (window-total-height (frame-root-window)) 10)))
	(let ((dired-async-window
		   (split-window (frame-root-window) dired-async-window-height 'below)))
	  (select-window dired-async-window)
	  (set-window-parameter dired-async-window 'no-other-window t))))

;;handle when process finish execution, kill the buffer and the window that hold the process
(defun tmtxt/dired-async-process-handler (process event)
  "Handler for window that displays the async process.

Usage: After start an tmtxt/dired-async, call this function
 (set-process-sentinel process 'tmtxt/dired-async-process-handler)
process: the tmtxt/dired-async process

The function will print the message to notify user that the process is
completed and automatically kill the buffer and window that runs the
process."

  ;; check if the process status is exit, then kill the buffer and the window
  ;; that contain that process after 5 seconds (for the user to see the output)
  (when (equal (process-status process) 'exit)
	;; get the current async buffer and window
	(let ((current-async-buffer (process-buffer process)))
	  (let ((current-async-window (get-buffer-window current-async-buffer)))
		(print "Process completed.\nThe window will be closed automatically in 3s."
			   current-async-buffer)
		(set-window-point current-async-window
						  (buffer-size current-async-buffer))
		;; kill the buffer and window after 3 seconds
		(run-at-time "3 sec" nil 'kill-buffer current-async-buffer)
		(run-at-time "3 sec" nil 'delete-window current-async-window)))))

;; interactive function to execute rsync
(defun tmtxt/dired-async-rsync (dest)
  (interactive
   ;; offer dwim target as the suggestion
   (list (expand-file-name (read-file-name "Rsync to:" (dired-dwim-target-directory)))))

  (let ((files (dired-get-marked-files nil current-prefix-arg))
		dired-async-rsync-command)
	;; the rsync command
	(setq dired-async-rsync-command "rsync -arvz --progress ")
	;; add all selected file names as arguments to the rsync command
	(dolist (file files)
	  (setq dired-async-rsync-command
			(concat dired-async-rsync-command (shell-quote-argument file) " ")))
	;; append the destination to the rsync command
	(setq dired-async-rsync-command
		  (concat dired-async-rsync-command (shell-quote-argument dest)))
	;; execute the command asynchronously
	(tmtxt/dired-async dired-async-rsync-command "rsync")))

(define-key dired-mode-map (kbd "C-c C-r") 'tmtxt/dired-async-rsync)


;; Allow running multiple async commands simultaneously
(defadvice shell-command (after shell-in-new-buffer (command &optional output-buffer error-buffer))
  (when (get-buffer "*Async Shell Command*")
    (with-current-buffer "*Async Shell Command*"
      (rename-uniquely))))
(ad-activate 'shell-command)

;;}}}


(provide 'mb-dired)
