;;{{{ Auto Complete

(require 'auto-complete)
(add-hook 'emacs-lisp-mode-hook 'auto-complete-mode)
(add-hook 'markdown-mode-hook 'auto-complete-mode)

;;}}}

;;{{{ BBDB

(require 'bbdb)
(setq bbdb-file "~/Personal/mail/bbdb")
(bbdb-initialize)
(setq bbdb-north-american-phone-numbers-p nil)
;; Don't show an annoying window when completing aliases
(setq bbdb-use-pop-up nil)

;; import vCards
(add-to-list 'load-path (expand-file-name "bbdb-vcard" site-lisp-dir))
(require 'bbdb-vcard)

;;}}}

;;{{{ bibretrieve

;; https://github.com/pzorin/bibretrieve

(add-to-list 'load-path (expand-file-name "bibretrieve" site-lisp-dir))

(load "bibretrieve")

(defun bibretrieve-amazon-create-url (author title)
  (concat "http://lead.to/amazon/en/?key="(mm-url-form-encode-xwfu title) "&si=ble&op=bt&bn=&so=sa&ht=us"))

(defun bibretrieve-phys-create-url (author title)
  (concat "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?db_key=PHY&"
	  "&aut_req=YES&aut_logic=AND&author=" (mm-url-form-encode-xwfu author)
	  "&ttl_req=YES&ttl_logic=AND&title=" (mm-url-form-encode-xwfu title)
	  "&data_type=BIBTEX"))

(defun bibretrieve-phys ()
  (interactive)
  (setq bibretrieve-backends '(("phys" . 5)))
  (bibretrieve)
)

(defun bibretrieve-arxiv ()
  (interactive)
  (setq bibretrieve-backends '(("arxiv" . 5)))
  (bibretrieve)
)

(defun bibretrieve-amazon ()
  (interactive)
  (setq mm-url-use-external t)
  (setq mm-url-program "w3m")
  (setq mm-url-arguments (list "-dump"))
  (setq bibretrieve-backends '(("amazon" . 5)))
  (bibretrieve)
  (setq mm-url-use-external nil)
)

(defun bibretrieve-calibre-create-url (author title)

  (let ((tempfile (make-temp-file "calibre" nil ".bib")))

    (call-process-shell-command "calibredb" nil nil nil 
				"catalog" tempfile "-s"
				(if (> (length author) 0) (concat "authors:" "\"" author "\""))
				(if (> (length title) 0)  (concat "title:" "\"" title "\"")))
    (concat "file://" tempfile)
))

(defun bibretrieve-calibre ()
  (interactive)
  (setq mm-url-use-external t)
  (setq bibretrieve-backends '(("calibre" . 5)))
  (bibretrieve)
  (setq mm-url-use-external nil)
)

(defun bibretrieve-scholar-create-url (author title)

  (let ((tempfile (make-temp-file "scholar" nil ".bib")))

    (call-process-shell-command "gscholar.py" nil nil nil 
				(if (> (length author) 0) (concat "\"" author "\""))
				(if (> (length title) 0)  (concat "\"" title "\""))
				(concat " > " tempfile))
    (concat "file://" tempfile)
))

(defun bibretrieve-scholar ()
  (interactive)
  (setq mm-url-use-external t)
  (setq bibretrieve-backends '(("scholar" . 5)))
  (bibretrieve)
  (setq mm-url-use-external nil)
)

;;}}}

;;{{{ ebib
;; https://github.com/joostkremers/ebib

(autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)

(global-set-key [f3] 'ebib)

;;{{{ Add keyword to entries

(require 'ebib)
(ebib-key index "y" ebib-add-keyword-entries t)

(defun ebib-add-keyword-entries ()
  "Add keyword to marked entries"
  (interactive)
  (if (ebib-called-with-prefix)
      (ebib-execute-when
        ((marked-entries)
         (let ((minibuffer-local-completion-map `(keymap (keymap (32)) ,@minibuffer-local-completion-map))
	       (collection (ebib-keywords-for-database ebib-cur-db))
	       (keywords))
	   
	   (setq collections (cons "" collection))
	   (loop for keyword = (completing-read "Select or enter keyword: " collections nil nil nil 'ebib-keyword-history)
		 until (string= keyword "")
		 do (let ((curr-keywords keywords))
		      (setq keywords (if curr-keywords (concat curr-keywords ebib-keywords-separator keyword) keyword))
		      (unless (member keyword collection)
			(ebib-keywords-add-keyword keyword ebib-cur-db))
		      ))

	   (mapc #'(lambda (entry)
	   	     (setq ebib-cur-entry-hash (ebib-retrieve-entry entry ebib-cur-db))
	   	     (ebib-add-keyword-entry keywords))
	   	  (edb-marked-entries ebib-cur-db))
	   
           (message "Keyword added to marked entries.")
           (ebib-set-modified t)
	   (setf (edb-marked-entries ebib-cur-db) nil)
           (ebib-fill-entry-buffer)
           (ebib-fill-index-buffer)))
        ((default)
         (beep)))))

(defun ebib-add-keyword-entry (keyword)
  (let* ((conts (to-raw (gethash 'keywords ebib-cur-entry-hash)))
	 (new-conts (if conts
			(concat conts ebib-keywords-separator keyword)
		      keyword)))
    (puthash 'keywords (from-raw (if ebib-keywords-field-keep-sorted
				     (ebib-sort-keywords new-conts)
				   new-conts))
	     ebib-cur-entry-hash)))
;;}}}

;;{{{ Attach PDF to email
(defun ebib-attach-file ()
  "Attach file to gnus/mu4e composition buffer"
  (interactive)

  (ebib-execute-when
    ((entries)
     (let ((filename (to-raw (car (ebib-get-field-value ebib-standard-file-field
                                                        (edb-cur-entry ebib-cur-db))))))
       (if filename
           (ebib-dired-attach filename)
         (error "Field `%s' is empty" ebib-standard-file-field))))
    ((default)
     (beep))))

(defun ebib-dired-attach (file)
  "Attach FILENAME using gnus-dired-attach."
  (let ((file-full-path
            (or (locate-file file ebib-file-search-dirs)
                (locate-file (file-name-nondirectory file) ebib-file-search-dirs)
                (expand-file-name file))))
    (if (file-exists-p file-full-path)
	(progn
	  (gnus-dired-attach (cons file-full-path '()))
	  (ebib-lower))
      (error "File not found: `%s'" file-full-path))))

;;}}}

;;{{{ Export file
(defun ebib-export-file (dest)
  "Export file to a given directory"
  (interactive (list (read-directory-name "Destination:")))

  (ebib-execute-when
    ((entries)
     (let ((filename (to-raw (car (ebib-get-field-value ebib-standard-file-field
                                                        (edb-cur-entry ebib-cur-db))))))
       (if filename
           (ebib-copy-file filename dest)
         (error "Field `%s' is empty" ebib-standard-file-field))))
    ((default)
     (beep))))

(defun ebib-copy-file (file destdir)
  "Copy FILE to DESTDIR"
  (let ((file-full-path
            (or (locate-file file ebib-file-search-dirs)
                (locate-file (file-name-nondirectory file) ebib-file-search-dirs)
                (expand-file-name file))))
    (if (file-exists-p file-full-path)
	(progn
	  (shell-command (concat "cp " file-full-path " " "\"" destdir "\""))
	  )
      (error "File not found: `%s'" file-full-path))))
;;}}}

;;{{{ Config

(setq ebib-multiline-major-mode 'markdown-mode)

(add-to-list 'Info-default-directory-list (expand-file-name site-lisp-dir "ebib"))

(add-hook 'Info-mode-hook
	  (lambda () (setq Info-additional-directory-list Info-default-directory-list)))

(setq papers-dir "~/Library/Artículos")

(setq thesis-dir "~/Library/Tesis")

(add-to-list 'ebib-file-search-dirs (expand-file-name "arXiv" papers-dir))

(add-to-list 'ebib-file-search-dirs (expand-file-name "pdf" papers-dir))

(add-to-list 'ebib-file-search-dirs thesis-dir)

(setq ebib-file-associations '(("pdf" . "zathura") ("djvu" . "zathura")))

(setq ebib-preload-bib-files '("~/Library/Artículos/articulos.bib"))

(add-to-list 'ebib-preload-bib-files "~/Library/Tesis/tesis.bib")

;;(setq ebib-keywords-files-alist '())

(setq ebib-keywords-file "keywords")

(setq ebib-autogenerate-keys t)

(setq bibtex-autokey-name-case-convert-function (quote identity))

(setq bibtex-autokey-year-length 4)

(setq bibtex-autokey-titleword-ignore '(".*"))

(setq ebib-uniquify-keys t)

(setq ebib-use-timestamp t)

(setq ebib-timestamp-format "%a %b %e %Y %jd")

(setq ebib-index-window-size 20)

;;}}}

;;{{{ Filter recently added entries

(defun ebib-filter-n-days (n)
  "Filter entries added in the last n days"
  
  (let* ((field (intern-soft "timestamp"))
	 (day-of-year (string-to-number (format-time-string "%j")))
	 (n-days-ago (- day-of-year (- n 1)))
	 (days-between (number-sequence n-days-ago day-of-year))
	 (regexp-days-between (mapconcat #'(lambda (x)
					     (concat "\\(" (number-to-string x) "d\\)"))
					  days-between "\\|")))

    (ebib-execute-when
      ((real-db)
       (setf (edb-filter ebib-cur-db) `(contains ,field ,regexp-days-between))
       (ebib-redisplay)))
))

(defun ebib-filter-added-nth (key)
  (interactive (list (if (featurep 'xemacs)
                         (event-key last-command-event)
                       last-command-event)))
  (ebib-filter-n-days (- (if (featurep 'xemacs)
			     (char-to-int key)
			   key) 48)))

(mapc #'(lambda (key)
          (define-key ebib-filters-map (format "%d" key)
            'ebib-filter-added-nth))
       '(1 2 3 4 5 6 7 8 9))

;;}}}

;;{{{ Filters

;; Pretty printing lib
(require 'pp)

;; Associative list for filters
(defvar filters-alist())

(defvar filters-already-loaded nil)

(setq filter-ignore-case t)

(setq filter-default-file "~/Library/Artículos/filters")

;;{{{ Load filters

;; Get filters list from buffer
(defun filters-alist-from-buffer ()
  "Return a `filters-alist' from the current buffer.
The buffer must of course contain filter format information.
Does not care from where in the buffer it is called, and does not
affect point."
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "(" nil t)
	(progn
	  (forward-char -1)
          (read (current-buffer)))
      ;; Else no hope of getting information here.
      (error "Not filter format"))))


;; Load filters-alist
(defun filter-load (file &optional overwrite no-msg)
  "Load filters from FILE (which must be in filters format).
Appends loaded filters to the front of the list of filters.  If
optional second argument OVERWRITE is non-nil, existing filters
are destroyed. Optional third arg NO-MSG means don't display any
messages while loading."

  (setq file (abbreviate-file-name (expand-file-name file)))
  (if (not (file-readable-p file))
      (error "Cannot read filters file %s" file)
    (if (null no-msg)
        (message "Loading filters from %s..." file))
    
    (with-current-buffer (let ((enable-local-variables nil))
                           (find-file-noselect file))
      (goto-char (point-min))

      (let ((flist (filters-alist-from-buffer)))
        (if (listp flist)
            (progn
              (if overwrite
                  (progn
                    (setq filters-alist flist))
            ))

          (error "Invalid filter list in %s" file))
      (kill-buffer (current-buffer)))
      (if (null no-msg)
         (message "Loading filters from %s...done" file))
    )))


;; Load filters file
(defun filter-maybe-load-default-file ()
  "If filters have not been loaded from the default place, load them."
  (interactive)
  (and (not filters-already-loaded)
       (null filters-alist)
       (file-readable-p filter-default-file)

       (filter-load filter-default-file t nil)
       (setq filters-already-loaded t)))

;;}}}

;;{{{ Get filter

(defun filter-get-filter (filter-name &optional noerror)
  "Return the filter record corresponding to FILTER-NAME.
If FILTER-NAME is a string, look for the corresponding
filter record in `filters-alist'; return it if found, otherwise
error."
  (cond
   ((stringp filter-name)
    (or (assoc-string filter-name filters-alist
                      filter-ignore-case)
        (unless noerror (error "Invalid filter %s" filter-name))))))

;; Sort filters
(defun filter-sort-alist ()
  "Return `filters-alist' for display."
  (interactive)
  (progn
    (sort (copy-alist filters-alist)
	  (function
	   (lambda (x y) (string-lessp (car x) (car y))))) 
    ))

;;}}}

;;{{{ Rename filter
(defun filter-set-name (filter-name newname)
  "Set filter's name to NEWNAME."
  (setcar (filter-get-filter filter-name) newname))

;; (defun ebib-rename-filter ()
;;   (interactive)
;;   (let ((old-name (completing-read (format "Choose a saved filter: ")
;; 				 (mapcar #'(lambda(x)
;; 					     (cons x 0))
;; 					  (filter-all-names))
			       
;;                                 nil t)))
;;     (let ((new-name (read-from-minibuffer "Enter new name: ")))
;;       (if (filter-get-filter new-name 'noerror)
;; 	  (error "There is already a filter with that name. Better overwrite that filter instead.")
;; 	(progn
;; 	  (filter-set-name old-name new-name)
;; 	  (filter-write-file)
;; 	  (setq filters-alist nil)
;; 	  (setq filters-already-loaded nil)))
;; )))

;;}}}

;;{{{ Delete filter

;; (defun ebib-delete-filter ()
;;   (interactive)
  
;;   (let ((filter-name (completing-read (format "Choose a saved filter: ")
;; 				 (mapcar #'(lambda(x)
;; 					     (cons x 0))
;; 					  (filter-all-names))
			       
;;                                 nil t)))
    
;;     (setq filters-alist (delq (filter-get-filter filter-name) filters-alist))
;;     (filter-write-file)
;;     (message "Filter %s deleted" filter-name)
;;     (setq filters-alist nil)
;;     (setq filters-already-loaded nil)))

;;}}}

;;{{{ Add filter to alist

;; Check for dups and store filter
(defun filter-store (name alist no-overwrite)
  "Store the filter NAME with data ALIST.
If NO-OVERWRITE is non-nil and another filter of the same name
already exists in `filter-alist', record the new filter without
throwing away the old one."
  (interactive)
  (filter-maybe-load-default-file)
    (if (and (not no-overwrite)
           (filter-get-filter name 'noerror))
      ;; already existing filter under that name and
      ;; no prefix arg means just overwrite old filter
      ;; Use the new (NAME . ALIST) format.
      (setcdr (filter-get-filter name) (cons alist '()))

    ;; otherwise just cons it onto the front (either the filter
    ;; doesn't exist already, or there is no prefix arg.  In either
    ;; case, we want the new filter consed onto the alist...)
    (push (cons name (cons alist '())) filters-alist))
)

;;}}}

;;{{{ Save filters

(defun filter-write-file ()
  "Write `filters-alist' to FILTER-DEFAULT-FILE."
  (interactive)
  (message "Saving filters to file %s..." filter-default-file)
  (with-current-buffer (get-buffer-create " *Filters*")
    (goto-char (point-min))
    (delete-region (point-min) (point-max))
    (let ((print-length nil)
          (print-level nil)
          (print-circle t))
      ;;(filter-insert-header)
      
      (insert "(")
      (dolist (i filters-alist) (pp i (current-buffer)))
      (insert ")")

      (condition-case nil
	  (write-region (point-min) (point-max) filter-default-file)
	(file-error (message "Can't write %s" filter-default-file)))
      
      (kill-buffer (current-buffer))
      (message "Saving filters to file %s...done" filter-default-file)
)))

;;}}}

;;{{{ Save ebib filter

;;{{{ virtual-db
;; (defun ebib-save-filter ()
;;   (interactive)

;;   (setq filter (edb-virtual ebib-cur-db))

;;   (let ((ebib-filter-name (read-from-minibuffer "Enter filter name: ")))
;;     (filter-store ebib-filter-name filter nil)
;;     (filter-write-file)
;;     (setq filters-alist nil)
;;     (setq filters-already-loaded nil)
;; ))

;;}}}

;; filtered-db
;; (defun ebib-save-filter ()
;;   (interactive)

;;   (setq filter (edb-filter ebib-cur-db))

;;   (let ((ebib-filter-name (read-from-minibuffer "Enter filter name: ")))
;;     (filter-store ebib-filter-name filter nil)
;;     (filter-write-file)
;;     (setq filters-alist nil)
;;     (setq filters-already-loaded nil)
;; ))


;;}}}

;;{{{ Show saved filters
(defun filter-name-from-full-record (filter-record)
  "Return the name of FILTER-RECORD. FILTER-RECORD is, e.g.,
one element from `filters-alist'."
  (car filter-record))

(defun filter-all-names ()
  "Return a list of all current filter names."
  (filter-maybe-load-default-file)
  (mapcar 'filter-name-from-full-record (filter-sort-alist)))

;;}}}

;;{{{ Load ebib filter

;;{{{ virtual-db

;; ;; Create virtual database with saved filter
;; (defun filter-create-virtual-db (filter)
;;   "Creates a virtual database based on saved filter."
;;   (let ((new-db (ebib-create-new-database ebib-cur-db)))
;;     (setf (edb-virtual new-db) filter)
;;     (setf (edb-filename new-db) nil)
;;     (setf (edb-name new-db) (concat "V:" (edb-name new-db)))
;;     (setf (edb-modified new-db) nil)
;;     (setf (edb-make-backup new-db) nil)
;;     new-db))

;; ;; Load saved filter
;; (defun ebib-load-filter ()
;;   (interactive)

;;   (ebib-execute-when
;;     ((virtual-db)
;;      (error "A saved filter can only be applied to a real database")
;;     ))

;;   (ebib-execute-when
;;     ((real-db)
;;      (let ((filter (completing-read (format "Choose a saved filter: ")
;;                                (mapcar #'(lambda(x)
;; 					(cons x 0))
;; 					(filter-all-names))
			       
;;                                 nil t)))
;;        (setq filter-record (car (cdr (filter-get-filter filter))))
   

;;        (setq ebib-cur-db (filter-create-virtual-db filter-record))

;;        (ebib-run-filter (edb-virtual ebib-cur-db) ebib-cur-db)
;;        (ebib-fill-entry-buffer)
;;        (ebib-fill-index-buffer)))
;; ))

;;}}}

;; filtered-db

;; Load saved filter
;; (defun ebib-load-filter ()
;;   (interactive)

;;   (ebib-execute-when
;;     ((filtered-db)
;;      (error "A saved filter can only be applied to a real database")
;;     ))

;;   (ebib-execute-when
;;     ((real-db)
;;      (let ((filter (completing-read (format "Choose a saved filter: ")
;;                                (mapcar #'(lambda(x)
;; 					(cons x 0))
;; 					(filter-all-names))
			       
;;                                 nil t)))
;;        (setq filter-record (car (cdr (filter-get-filter filter))))
       
;;        (setf (edb-filter ebib-cur-db) filter-record)

;;        (ebib-run-filter ebib-cur-db)
;;        (ebib-fill-entry-buffer)
;;        (ebib-fill-index-buffer)))
;; ))

;;}}}

;;}}}

;;{{{ Import bibtex entry from conkeror

(setq arxiv-dir "~/Library/Artículos/arXiv/")

(defun ebib-import-arxiv (arxiv-url)
  (interactive)

  (let ((tempbuff (get-buffer-create "*arxiv*"))
	(arxiv-id (car (cdr (split-string arxiv-url "abs/"))))
	(arxiv-pdf-url (concat (replace-regexp-in-string "abs" "pdf" arxiv-url) ".pdf")))
  
    (call-process-shell-command "arxiv2bib.py" nil tempbuff nil arxiv-id)

    (setq arxiv-id (replace-regexp-in-string "/" "_" arxiv-id))

    (call-process-shell-command "links" nil nil nil
				"-source" arxiv-pdf-url "> " (concat arxiv-dir arxiv-id ".pdf"))

    (with-current-buffer tempbuff
      (ebib-import)
      ;;(kill-buffer (current-buffer))
)))

(require 'mm-url)

(defun ebib-import-bibtex (url filename)
  (interactive)

  (let ((tempbuff (get-buffer-create "*bibtex*")))  
    (with-current-buffer tempbuff
      (mm-url-insert-file-contents url)
      
      ;; Fix syntactically incorrect BibTeX entry
      ;; ==========================================
      
      ;; from EJPD
      (setq bibtex-key filename)

      (while (search-forward "@article{\n" nil t)
	(replace-match (concat "@article{" bibtex-key ",\n") nil t))

      ;; from AIP
      (while (search-forward "eid = ," nil t)
	(replace-match "eid = \"\"," nil t))

      ;; Add file field
      ;; ===============

      (while (search-forward "\n}" nil t)
	(replace-match (concat ",\n  file = {" filename ".pdf}\n}") nil t))
      
      (ebib-import)
      (kill-buffer (current-buffer))
    ) 
))

;;}}}

;;{{{ Insert current entry key as filename
(defun fileaskey()
(concat (ebib-cur-entry-key) ".pdf"))

;; Insert current entry key as file name
(global-set-key (kbd "C-c v") 
		(lambda () 
		  (interactive) 
		  (insert (concat (ebib-cur-entry-key) ".pdf"))))

;;}}}

;;}}}

;;{{{ Expand region
;; https://github.com/magnars/expand-region.el

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;}}}

;;{{{ Folding Mode

;; http://git.savannah.gnu.org/cgit/emacs-tiny-tools.git/tree/lisp/other/folding.el?h=devel

(if (load "folding" 'nomessage 'noerror)
    (folding-mode-add-find-file-hook))

(add-hook 'emacs-lisp-mode-hook 'folding-mode)

(global-set-key (kbd "<f11>") 'folding-toggle-show-hide)

;;}}}

;;{{{ Google Translate

;; https://github.com/manzyuk/google-translate

(add-to-list 'load-path (expand-file-name "google-translate" site-lisp-dir))

(require 'google-translate)
(global-set-key "\C-cT" 'google-translate-at-point)
(global-set-key "\C-ct" 'google-translate-query-translate)
(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "es")
(global-set-key (kbd "C-c R") 'google-translate-at-point-reverse)
(global-set-key (kbd "C-c r") 'google-translate-query-translate-reverse)

;;}}}

;;{{{ Helm

(require 'helm-config)
(helm-mode 1)

;; (eval-after-load 'helm
;;   '(define-key helm-map (kbd "6") '(lambda () (interactive) (insert "^"))))

;; Disable helm for this commands
(add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
(add-to-list 'helm-completing-read-handlers-alist '(dired-do-rename . nil))
(add-to-list 'helm-completing-read-handlers-alist '(dired-do-copy . nil))
(add-to-list 'helm-completing-read-handlers-alist '(LaTeX-environment . nil))
(add-to-list 'helm-completing-read-handlers-alist '(LaTeX-section . nil))
(add-to-list 'helm-completing-read-handlers-alist '(bbdb-create . nil))
(add-to-list 'helm-completing-read-handlers-alist '(TeX-insert-macro . nil))

(global-set-key (kbd "C-SPC")
  (lambda() (interactive)
    (helm
     :prompt "Switch to: "
     :candidate-number-limit 10                  ;; up to 10 of each 
     :sources
     '( helm-c-source-buffers-list               ;; buffers 
        ;anything-c-source-recentf               ;; recent files 
        helm-c-source-bookmarks                  ;; bookmarks
        ;anything-c-source-files-in-current-dir+ ;; current dir
      )
    )
  )
)

;;}}}

;;{{{ iBuffer

;; (global-set-key (kbd "C-x C-b") 'ibuffer)
;; (autoload 'ibuffer "ibuffer" "List buffers." t)

;; Auto indentation
;; (define-key global-map (kbd "RET") 'newline-and-indent)

;;}}}

;;{{{ icicles

;; (add-to-list 'load-path "~/.emacs.d/elpa/icicles-20130430.2109/")
;; (require 'icicles)
;; (icy-mode 1)

;;}}}

;;{{{ Interactive do Mode

(ido-mode t)
(ido-everywhere t)
(add-hook 'ido-setup-hook 'ido-my-keys)
(setq ido-max-prospects 6           ; limit search results
      ido-case-fold t               ; case insensitive
      ido-use-filename-at-point nil
      ido-use-url-at-point nil
      ido-auto-merge-work-directories-length 0
      ido-enable-flex-matching t    ; match characters in the given sequence
)

(defun ido-my-keys ()
  ;;(define-key ido-completion-map (kbd "C-d") 'ido-enter-dired)
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
)

;;{{{ recent stuff

;; --------------
(require 'recentf)
(recentf-mode t)
(setq recentf-max-saved-items 20)

(add-to-list 'recentf-exclude "*.archnovo*")
(add-to-list 'recentf-exclude ".ido.last")

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let* ((file-assoc-list
	  (mapcar (lambda (x)
		    (cons (file-name-nondirectory x)
			  x))
		  recentf-list))
	 (filename-list
	  (remove-duplicates (mapcar #'car file-assoc-list)
			     :test #'string=))
	 (filename (ido-completing-read "Choose recent file: "
					filename-list
					nil
					t)))
    (when filename
      (find-file (cdr (assoc filename
			     file-assoc-list))))))

(global-set-key (kbd "C-x C-r") 'recentf-ido-find-file)

;;}}}

;;}}}

;;{{{ Iswitch buffers

;;(iswitchb-mode 1)
;;
;;(defun iswitchb-local-keys ()
;;      (mapc (lambda (K) 
;;	      (let* ((key (car K)) (fun (cdr K)))
;;    	        (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
;;	    '(("<right>" . iswitchb-next-match)
;;	      ("<left>"  . iswitchb-prev-match)
;;	      ("<up>"    . ignore             )
;;	      ("<down>"  . ignore             ))))

;(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;;}}}

;;{{{ List register
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)
;;}}}

;;{{{ Magit

(require 'magit)

;;}}}

;;{{{ mmm

(require 'mmm-auto)
(setq mmm-global-mode 'maybe)

(mmm-add-group 'markdown-py
               '((markdown-sympycode
                  :submode python-mode
                  :face mmm-comment-submode-face
                  :front ".*\\\\begin{sympycode}"
                  :back  ".*\\\\end{sympycode}")
		 (markdown-pycode
                  :submode python-mode
                  :face mmm-comment-submode-face
                  :front ".*\\\\begin{pycode}"
                  :back  ".*\\\\end{pycode}")
		 (markdown-sympy
                  :submode python-mode
                  :face mmm-comment-submode-face
                  :front ".*\\\\sympy{"
                  :back  "}")
		 (markdown-pylab
                  :submode python-mode
                  :face mmm-comment-submode-face
                  :front ".*\\\\pylab{"
                  :back  "}")
                 ))
(add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-py))

;;}}}

;;{{{ MoinMoin

;; (require 'moinmoin-mode)

;;}}}

;;{{{ Nero
(require 'nero)
;;}}}

;;{{{ Octave

;; (autoload 'octave-mode "octave-mod" nil t)
;; (setq auto-mode-alist
;;       (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; (add-hook 'octave-mode-hook
;; 	  (lambda ()
;; 	    (abbrev-mode 1)
;;             (auto-fill-mode 1)
;;             (if (eq window-system 'x)
;; 		(font-lock-mode 1))))

;;}}}

;;{{{ powerline
;; https://github.com/milkypostman/powerline

(add-to-list 'load-path (expand-file-name "powerline" site-lisp-dir))
(require 'powerline)

(set-face-attribute 'mode-line nil
		    :background "DodgerBlue3" ;OliveDrab3 ;DodgerBlue3
		    :box nil)

(setq global-mode-string nil)

(set-face-attribute 'powerline-active1 nil
		    :foreground "white"
		    :background "grey30"
)

(set-face-attribute 'powerline-active2 nil
		    :foreground "white"
		    :background "grey60"
)

(defun powerline-my-theme ()
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1
                                   'powerline-inactive1))
                          (face2 (if active 'powerline-active2
                                   'powerline-inactive2))
                          (separator-left
                           (intern (format "powerline-%s-%s"
                                           powerline-default-separator
                                           (car powerline-default-separator-dir))))
                          (separator-right
                           (intern (format "powerline-%s-%s"
                                           powerline-default-separator
                                           (cdr powerline-default-separator-dir))))
                          (lhs (list
                                (powerline-raw "%*" nil 'l)
                                ;(powerline-buffer-size nil 'l)

                                ;(powerline-raw mode-line-mule-info nil 'l)
                                (powerline-buffer-id nil 'l)

                                (when (and (boundp 'which-func-mode) which-func-mode)
                                  (powerline-raw which-func-format nil 'l))

                                (powerline-raw " ")
                                (funcall separator-left mode-line face1)

                                (when (boundp 'erc-modified-channels-object)
                                  (powerline-raw erc-modified-channels-object
                                                 face1 'l))

                                (powerline-major-mode face1 'l)
                                (powerline-process face1)
                                (powerline-minor-modes face1 'l)
                                (powerline-narrow face1 'l)

                                (powerline-raw " " face1)
                                (funcall separator-left face1 face2)

                                (powerline-vc face2 'r)))
                          (rhs (list
                                (powerline-raw global-mode-string face2 'r)

                                (funcall separator-right face2 face1)

                                (powerline-raw "%4l" face1 'l)
                                (powerline-raw ":" face1 'l)
                                (powerline-raw "%3c" face1 'r)

                                (funcall separator-right face1 mode-line)
                                (powerline-raw " ")

                                (powerline-raw "%6p" nil 'r)

                                ;;(powerline-hud face2 face1)
				)))
                     (concat
                      (powerline-render lhs)
                      (powerline-fill face2 (powerline-width rhs))
                      (powerline-render rhs)))))))


(powerline-my-theme)

;;}}}

;;{{{ Projectile

;; https://github.com/bbatsov/projectile

;; (add-to-list 'load-path (expand-file-name "projectile" site-lisp-dir))
;; (add-to-list 'load-path (expand-file-name "dash" site-lisp-dir))
;; (add-to-list 'load-path (expand-file-name "s" site-lisp-dir))

;; (require 'projectile)
;; (add-hook 'c-mode-hook 'projectile-on)

;; (require 'helm-projectile)

;; (global-set-key (kbd "C-c h") 'helm-projectile)

;;}}}

;;{{{ Rainbow delimiters

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;;}}}

;;{{{ Sunrise Commander

(setq dired-omit-files (concat dired-omit-files "\\|^\\...+$"))
;;(add-hook 'sr-mode-hook (lambda () (dired-omit-mode nil)))

;; Set attributes shown

;; (perms hard-links owner group size date filename)
;;(setq sr-attributes-display-mask '(nil nil nil nil t t t))

(setq sr-show-file-attributes nil)

;; Listing switches passed to ls
(setq sr-listing-switches "-laDhgG")

;; Use the passive pane for the viewer. (requires sunrise-popview extension)
;; popview is incompatible with buttons
(add-hook 'sr-mode-hook 'sr-popviewer-mode)

(setq sr-popviewer-select-viewer-action
      (lambda nil (let ((sr-running nil)) (other-window 1))))

(setq sr-windows-default-ratio 50)

;;(setq sr-show-hidden-files t)

(defun sr-mod-keys ()
  (local-set-key (kbd "<backspace>") 'sr-dired-prev-subdir))

(add-hook 'sr-mode-hook 'sr-mod-keys)

(global-set-key (kbd "<f1>") 'sunrise)

;;}}}

;;{{{ Window numbering

;(add-to-list 'load-path (expand-file-name "window-numbering" site-lisp-dir))

;(require 'window-numbering)
;(window-numbering-mode 1)

;;}}}

;;{{{ Xah Elisp Mode

(require 'xah-elisp-mode)
(add-to-list 'auto-mode-alist '("\\.el\\'" . xah-elisp-mode))

;;}}}

;;{{{ YASnippets

;; (require 'yasnippet) ;; not yasnippet-bundle
;; (yas/initialize)

;;}}}

;;{{{ Zotelo
;; https://github.com/vitoshka/zotelo

;; (add-to-list 'load-path (expand-file-name "zotelo" site-lisp-dir))

;; (require 'zotelo)
;; (add-hook 'TeX-mode-hook 'zotelo-minor-mode)

;;}}}

(provide 'mb-extern)
