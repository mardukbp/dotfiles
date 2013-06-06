;; Sources
;; ----------
;; http://www.djcbsoftware.nl/code/mu/mu4e/
;; http://ionrock.org/emacs-email-and-mu.html
;; http://zmalltalker.com/linux/mu.html
;; http://wenshanren.org/?p=111
;; http://www.brool.com/index.php/using-mu4e

(require 'mu4e)

;;{{{ Org mode (experimental as of 0.9.9.5)

;; (require 'org-mu4e)
;; (defalias 'org-mail 'org-mu4e-compose-org-mode)

;; convert org mode to HTML automatically
;; (setq org-mu4e-convert-to-html t)

;;}}}

;;{{{ Key bindings

(global-set-key [f2] 'mu4e)

;; Get mail but do not sync maildirs
(global-set-key (kbd "<f12>")
		(lambda ()
		  (interactive)
		  (save-window-excursion
		    (shell-command "offlineimap -qf INBOX &"))))


;; Shortcuts
(setq mu4e-maildir-shortcuts
      '(("/iCloud/INBOX" . ?1)
	("/FCiencias/INBOX" . ?2)
	("/Gmail/INBOX" . ?3)
	("/ICN/INBOX" . ?4)
       )
)

;;}}}

;;{{{ Variables
(setq 
  mu4e-mu-home "/media/Archivos/mail/mu" ;; Where is the index?
  mu4e-maildir "/media/Archivos/mail/Maildirs" 
  mu4e-get-mail-command "offlineimap" ;; Get mail with S-u
  ;;mu4e-update-interval 300 ;; update every 5 mins
  
  ;; don't keep message buffers around
  message-kill-buffer-on-exit t
  
  ;mu4e-debug t

  mu4e-confirm-quit nil
  mu4e-use-fancy-chars t

)

;;}}}

;;{{{ Bookmarks in main view
;; ----------------------------

(setq mu4e-bookmarks
       '( ("flag:unread AND NOT flag:trashed" "Unread messages"      ?u)
          ("date:today..now"                  "Today's messages"     ?t)
          ("date:1d..now"                     "Last 2 days"          ?r)
	)
)

;;}}}

;;{{{ Attachments

;; Attaching files with dired
;; mark the file(s) in dired you would like to attach and press C-c RET C-a, and you'll be asked whether to attach them to an existing message, or create a new one.
(require 'gnus-dired)
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
   (set-buffer buffer)
   (when (and (derived-mode-p 'message-mode)
	   (null message-sent-message-via))
     (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

;;}}}

;;{{{ Headers list

(setq
  mu4e-headers-seen-mark nil
  mu4e-headers-flagged-mark nil
)

(setq mu4e-headers-skip-duplicates t)

 ;; the headers to show in the headers list -- a pair of a field
(setq mu4e-headers-fields
    '( (:date          .  20)
       (:flags         .  6)
       (:from-or-to    .  40)
       (:subject       .  nil)))

;;}}}

;;{{{ Reading messages

(setq
  mu4e-headers-date-format "%d/%b/%Y %H:%M"
  mu4e-attachment-dir "/media/Archivos/temp"
)

;; fields to show in message view
(setq mu4e-view-fields '(:from :to :cc :subject :date :attachments))

(setq mu4e-view-show-images t)

(setq
  ;;mu4e-html2text-command "pandoc -f html -t org"
  ;;mu4e-html2text-command "html2text -width 72"
  mu4e-html2text-command "w3m -dump -T text/html"
)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
   (imagemagick-register-types))

;;(add-hook 'mu4e-view-mode-hook 'mu4e-view-hide-cited)

;; Type aV to open message in browser
(add-to-list 'mu4e-view-actions
	     '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;;}}}

;;{{{ Sending mail
(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/bin/msmtp"
      user-full-name "Marduk Bolaños"
)

;;}}}

;;{{{ Accounts and folders

;; In some cases, you may want to have a bit more flexibility – for example, have a separate trash-folder (or sent-folder, drafts-folder, refile-folder) for private mail and work mail. You can now do something like:

;; (setq mu4e-trash-folder
;;   (lambda (msg)
;;     (if (and msg ;; msg may be nil
;;           (mu4e-message-contact-field-matches msg :to "me@work.com"))
;;       "/trash-work"
;;       "/trash")))

;;}}}

;;{{{ Composing messages

(setq default-input-method 'latin-1-prefix)
(add-hook 'mu4e-compose-mode-hook 'toggle-input-method)

(setq
  ;; limit address autocompletion to messages received since given date
  mu4e-compose-complete-only-after "2013-01-01"
  ;; limit address autocompletion to messages addressed only to me
  mu4e-compose-complete-only-personal t
)

;; select an account and set the variables in my-mu4e-account-alist to the correct values
(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
	  (if mu4e-compose-parent-message
	      (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
		(string-match "/\\(.*?\\)/" maildir)
		(match-string 1 maildir))
	    (completing-read (format "Compose with account: (%s) "
				     (mapconcat #'(lambda (var) (car var)) my-mu4e-account-alist "/"))
			     (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
			     nil t nil nil (caar my-mu4e-account-alist))))
	 (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
	(mapc #'(lambda (var)
		  (set (car var) (cadr var)))
	      account-vars)
      (error "No email account found"))))


(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; Expand BBDB aliases with SPC
(add-hook 'mu4e-compose-mode-hook 'bbdb-define-all-aliases)

(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
	   (setq ispell-local-dictionary "castellano")
           (set-fill-column 72)
           (flyspell-mode)))


;;}}}

;;{{{ Private info

(add-to-list 'load-path "~/private")

(require 'mu4e-private)

;;}}}

(provide 'mb-mu4e)