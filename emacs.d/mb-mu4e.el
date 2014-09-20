;; Sources
;; ----------
;; http://www.djcbsoftware.nl/code/mu/mu4e/
;; http://ionrock.org/emacs-email-and-mu.html
;; http://zmalltalker.com/linux/mu.html
;; http://wenshanren.org/?p=111
;; http://www.brool.com/index.php/using-mu4e

(require 'mu4e)

;;{{{ Org mode (experimental as of 0.9.9.5)

(require 'org-mu4e)
;; (defalias 'org-mail 'org-mu4e-compose-org-mode)

;; convert org mode to HTML automatically
;; (setq org-mu4e-convert-to-html t)

;;}}}

;;{{{ Key bindings

(global-set-key [f2] 'mu4e)

;; Get mail but do not sync maildirs
;; (global-set-key (kbd "<f12>")
;; 		(lambda ()
;; 		  (interactive)
;; 		  (save-window-excursion
;; 		    (shell-command "offlineimap -qf INBOX &"))))


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
  mu4e-mu-home "~/Personal/mail/mu" ;; Where is the index?
  mu4e-maildir "~/Personal/mail/Maildirs" 
  mu4e-get-mail-command "offlineimap" ;; Get mail with S-u
  ;;mu4e-update-interval 300 ;; update every 5 mins
  
  ;; don't keep message buffers around
  message-kill-buffer-on-exit t
  
  ;mu4e-debug t

  mu4e-confirm-quit nil
  mu4e-use-fancy-chars t

  mu4e-compose-signature-auto-include nil
  mu4e-completing-read-function 'completing-read
)

;;}}}

;;{{{ bookmarks in main view

;; ----------------------------

(setq mu4e-bookmarks
      '( ("flag:unread AND NOT flag:trashed" "Unread messages"      ?u)
          ("date:today..now"                  "Today's messages"     ?t)
          ("date:2d..now"                     "Last 2 days"          ?r)
	  ("flag:flagged"                     "Flagged messages"     ?f)
	  ("from:kurzweilai"                  "Kurzweil"             ?k)
	  ("from:phys"                        "Phys.org"             ?o)
	  ("from:science"                     "Science"              ?s)
	  ("subject:this week in physics AND NOT science" "APS Physics" ?p)
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
  mu4e-attachment-dir "~/"
)

;; fields to show in message view
(setq mu4e-view-fields '(:from :to :cc :subject :date :attachments))

(setq mu4e-view-show-images nil)

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


;; Add sender to bbdb
(defun mu4e-add-sender-bbdb ()
  (interactive)
  (let ((from (mu4e-field-at-point :from)))  
    (bbdb-create-internal (car (car from)) nil (cdr (car from)) nil nil nil))
)

;;}}}

;;{{{ Sending mail

;; while mu4e doesn't have this feature, from
;; https://groups.google.com/group/mu-discuss/browse_thread/thread/551b7a6487a0aeb3
(defun jmg/ido-select-recipient ()
  "Inserts a contact from the mu cache.
Uses ido to select the contact from all those present in the database."
  (interactive)
  (insert
   (ido-completing-read
    "Recipient: "
    (mapcar
     (lambda (contact-string)
       (let* ((data (split-string contact-string ","))
              (name (when (> (length (car data)) 0)
                      (car data)))
              (address (cadr data)))
         (if name
             (format "%s <%s>" name address)
           address)))
     (remove-if (lambda (string) (= 0 (length string)))
                (split-string (shell-command-to-string "mu cfind --muhome ~/Personal/mail/mu --format=csv")
                              "\n"))))))

;;(define-key message-mode-map (kbd "TAB") 'jmg/ido-select-recipient)

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
  mu4e-compose-complete-only-after nil
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
	    ;;(setq ispell-local-dictionary "castellano")
	    (set-fill-column 72)
	    (flyspell-mode)
	    ;; http://ertius.org/blog/stop-flyspell-claiming-m-tab/
	    (eval-after-load "flyspell"
	      '(progn
		 (define-key flyspell-mode-map (kbd "M-TAB") nil)))
	    ))


;; BBDB + ido-mode address completion
;; http://bigwalter.net/daniel/elisp/snippets.html
(defun bbdb-record-address-combinations (record)
  (let ((names (cons (let ((first (aref record 0))
                           (last (aref record 1)))
                       (cond ((and first last) (format "\"%s %s\"" first last))
                             (first first)
                             (last last)))
                     (aref record 2)))
        (adds (aref record 6))
        (comb nil))
    (dolist (name names)
      (dolist (add adds)
        (push (format "%s <%s>" name add) comb)))
    comb))

(defun ido-complete-bbdb-address ()
  (interactive)
  (let* ((end (point))
         (beg (save-excursion
                (re-search-backward "\\(\\`\\|[\n:,]\\)[ \t]*")
                (goto-char (match-end 0))
                (point)))
         (orig (buffer-substring beg end))
         (typed (downcase orig))
         (pattern (bbdb-string-trim typed)))
    (delete-region beg end)
    (insert
     (ido-completing-read "Record: "
                          (let (result)
                            (dolist (rec (bbdb-records))
                              (setq result
                                    (nconc (bbdb-record-address-combinations rec)
                                           result)))
                            result)
                          nil nil pattern))))

(add-hook 'mu4e-compose-mode-hook
 	  '(lambda () (local-set-key (kbd "M-TAB") 'ido-complete-bbdb-address)))

;;}}}

;;{{{ Private info

(add-to-list 'load-path "~/Personal/private")

(require 'mu4e-private)

;;}}}

(provide 'mb-mu4e)
