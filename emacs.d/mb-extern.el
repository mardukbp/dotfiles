;;{{{ BBDB

(require 'bbdb)
(setq bbdb-file "/media/Archivos/mail/bbdb")
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

;;}}}

;;{{{ Calibre
;; https://github.com/whacked/calibre-mode

(add-to-list 'load-path (expand-file-name "calibre-mode" site-lisp-dir))

(require 'calibre-mode)
(setq sql-sqlite-program "/usr/bin/sqlite3")
(setq calibre-root-dir (expand-file-name "/media/Archivos/Documents/Calibre Library/"))
(setq calibre-db (concat calibre-root-dir "metadata.db"))

;;}}}

;;{{{ ebib
;; https://github.com/joostkremers/ebib

(autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)

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

;;{{{ Magit

(require 'magit)

;;}}}

;;{{{ MoinMoin

;; (require 'moinmoin-mode)

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

(add-to-list 'load-path (expand-file-name "projectile" site-lisp-dir))
(add-to-list 'load-path (expand-file-name "dash" site-lisp-dir))
(add-to-list 'load-path (expand-file-name "s" site-lisp-dir))

(require 'projectile)
(add-hook 'c-mode-hook 'projectile-on)

(require 'helm-projectile)

(global-set-key (kbd "C-c h") 'helm-projectile)

;;}}}

;;{{{ Rainbow delimiters

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;;}}}

;;{{{ Window numbering

(add-to-list 'load-path (expand-file-name "window-numbering" site-lisp-dir))

(require 'window-numbering)
(window-numbering-mode 1)

;;}}}

;;{{{ Xah Elisp Mode

(require 'xah-elisp-mode)
(add-to-list 'auto-mode-alist '("\\.el\\'" . xah-elisp-mode))

;;}}}

;;{{{ YASnippets

;; (require 'yasnippet) ;; not yasnippet-bundle
;; (yas/initialize)

;;}}}

;;{{{ Zotero

;; zotero-plain
;; https://bitbucket.org/egh/zotero-plain/overview

;; (add-to-list 'load-path (expand-file-name "zot4rst" site-lisp-dir))

;;(autoload 'org-zotero-mode "org-zotero" "" t)

;; zotelo: manage Zotero collections from emacs
;; https://github.com/vitoshka/zotelo

;;}}}

(provide 'mb-extern)
