;;====================
;; Org Mode
;;====================

;;{{{ Setup

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(require 'org-protocol)
(require 'org-capture)

(setq default-input-method 'latin-1-prefix)
(add-hook 'org-mode-hook 'toggle-input-method)

;; My org files
(setq org-directory (expand-file-name (file-name-as-directory "/media/Archivos/Documents/org/")))

;; Mobile-org files
;;(setq org-mobile-directory (expand-file-name "MobileOrg" org-directory))
;;(setq org-mobile-files (cons (expand-file-name "notes.org" org-directory)))

(add-hook 'org-mode-hook 'turn-on-font-lock)
;(add-hook 'org-mode-hook 'emph-bold)
;(add-hook 'org-mode-hook 'emph-italics)

;;}}}

;;{{{ Text editing

(add-hook 'org-mode-hook 'visual-line-mode)

;;}}}

;;{{{ Key bindings
;; --------------
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key (kbd "<f1>") 'org-capture)
;;(global-set-key "\C-cc" 'org-capture)
;(setq org-log-done t)
;(setq org-src-fontify-natively t)

(add-hook 'org-mode-hook
	  (lambda ()
	    (local-set-key (kbd "8") '(lambda () (interactive) (insert "*")))

	    (local-set-key (kbd "*") '(lambda () (interactive) (insert "8")))
))

;;}}}

;;{{{ Capture templates
;; ------------------

(setq org-default-notes-file (concat org-directory "notes.org"))

;; the 'w' corresponds to the 'w' used in ~/.conkerorrc:
;; emacsclient \"org-protocol:/capture:/w/  [...]
(setq org-capture-templates
  '(
     ("b" "Bookmarks" entry
      (file+headline (concat org-directory "bookmarks.org") "Bookmarks")
      "* %^{Title}\n\n  Source: %u, %c\n\n  %i")

;;{{{ GTD
  
     ("p" "Pendientes")

     ("pu" "Pendientes/UNAM" entry
      (file+headline (concat org-directory "gtd.org") "UNAM" )
      "* %?\n %i\n")

     ("pc" "Pendientes/Compu" entry
      (file+headline (concat org-directory "gtd.org") "Compu" )
      "* %?\n %i\n")

     ("po" "Pendientes/Otros" entry
      (file+headline (concat org-directory "gtd.org") "Otros" )
      "* %?\n %i\n")

     ("ps" "Pendientes/Salud" entry
      (file+headline (concat org-directory "gtd.org") "Salud" )
      "* %?\n %i\n")

     ("g" "GTD")

     ("ge" "Eventos" entry
      (file+headline (concat org-directory "gtd.org") "Eventos" )
      "* %?\n %i\n")
     
     ("gb" "Compras" entry
      (file+headline (concat org-directory "gtd.org") "Compras" )
      "* TODO %?\n %i\n")

     ("gr" "Reuniones" entry
      (file+headline (concat org-directory "gtd.org") "Reuniones" )
      "* %?\n %i\n")

     ("gd" "Deudas" entry
      (file+headline (concat org-directory "gtd.org") "Deudas" )
      "* %?\n %i\n")

     ("gp" "Proyectos" entry
      (file+headline (concat org-directory "gtd.org") "Proyectos" )
      "* %?\n %i\n")

     ("gc" "Cumpleaños" entry
      (file+headline (concat org-directory "gtd.org") "Cumpleaños" )
      "* TODO %?\n %i\n")

;;}}}

     ("k" "Kurzweil" entry
      (file+headline (concat org-directory "science+tech.org") "Kurzweil" )
      "* %?\n %i\n")
     
     ("f" "Física" entry
      (file+headline (concat org-directory "fisica.org") "Física" )
      "* %?\n %i\n")

     ("p" "PhysOrg" entry
      (file+headline (concat org-directory "science+tech.org") "PhysOrg" )
      "* %?\n %i\n")

     ("i" "Ideas" entry
      (file+headline (concat org-directory "ideas.org") "Ideas" )
      "* %?\n %i\n")

     ("m" "Temp" entry
      (file+headline (concat org-directory "temp.org") "Temp" )
      "* %?\n %i\n")

     ("j" "Happy Journal" entry
      (file+headline (concat org-directory "happy_journal.org") "Journal" )
      "* %?\n %i\n")

     ("l" "Libros" entry
      (file+headline (concat org-directory "libros.org") "Libros" )
      "* %?\n %i\n")

     ("a" "Artículos" entry
      (file+headline (concat org-directory "articulos.org") "Artículos" )
      "* %?\n %i\n")

     ("s" "Salud" entry
      (file+headline (concat org-directory "salud.org") "Salud" )
      "* %?\n %i\n")

     ("d" "Docencia")

     ("dc" "Curso de computación" entry
      (file+headline (concat org-directory "docencia.org") "Computación" )
      "* %?\n %i\n")

;;{{{ Wiki

     ;;("w" "wiki")

     ("w" "Wiki" entry
      (file+headline (concat org-directory "wiki.org") "Wiki" )
      "* %?\n %i\n")

;;}}}
     
     ;; ("em" "Emacs commands" table-line
     ;;  (file+headline (concat org-directory "emacs-refcard.org") "" )
     ;;  "* %?\n %i\n")

     
   )
)

;;}}}

;;{{{ LaTeX

;;(require 'org-latex)
;;(setq org-export-latex-listings 'minted)
;;(add-to-list 'org-export-latex-packages-alist '("" "minted"))

;;}}}

;; Flyspell
;; ---------
;;(setq ispell-local-dictionary "castellano")

;;{{{ Autopairs
;; ----------
;(defun emph-bold ()
;	(global-set-key (kbd "*") 'skeleton-pair-insert-maybe)
;)
;(defun emph-italics ()
;	(global-set-key (kbd "/") 'skeleton-pair-insert-maybe)
;)

;;}}}

;;{{{ Fix conflicts with YASnippet

;; fix some org-mode + yasnippet conflicts:
;; (defun yas/org-very-safe-expand ()
;;   (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (make-variable-buffer-local 'yas/trigger-key)
;;             (setq yas/trigger-key [tab])
;;             (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
;;             (define-key yas/keymap [tab] 'yas/next-field)))

;;}}}

;;{{{ OSD notifications
;; ------------------

(defun djcb-popup (title msg &optional icon sound)
  "Show a popup if we're on X, or echo it otherwise; TITLE is the title
of the message, MSG is the context. Optionally, you can provide an ICON and
a sound to be played"

  (interactive)
  (when sound (shell-command
                (concat "mplayer -really-quiet " sound " 2> /dev/null")))
  (if (eq window-system 'x)
    (shell-command (concat "notify-send -t 100000 "

                     (if icon (concat "-i " icon) "")
                     " '" title "' '" msg "'"))
    ;; text only version

    (message (concat title ": " msg))))


;; the appointment notification facility
(setq
  appt-message-warning-time 15 ;; warn 15 min in advance

  appt-display-mode-line t     ;; show in the modeline
  appt-display-format 'window) ;; use our func
(appt-activate 1)              ;; active appt (appointment notification)
(display-time)                 ;; time display is required for this...

 ;; update appt each time agenda opened

(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

;; our little façade-function for djcb-popup
 (defun djcb-appt-display (min-to-app new-time msg)
    (djcb-popup (format "Appointment in %s minute(s)" min-to-app) msg 
      "/usr/share/icons/gnome/32x32/status/appointment-soon.png"
      "/usr/share/sounds/freedesktop/stereo/window-attention.oga"
      ))
  (setq appt-disp-window-function (function djcb-appt-display))

;;}}}

;; Browser
;; ---------
(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-program "conkeror")

;;{{{ Open with
;; -------------
;; (add-hook 'org-mode-hook
;;     '(lambda ()
;;          (setq org-file-apps
;;              (append '(
;;                  ("\\.pdf\\'" . zathura)
;;              ) org-file-apps ))))

;;}}}

;;{{{ Easy templates
;; ------------------

(setq org-structure-template-alist
      '(("m" "#+begin_comment?\n\n#+end_comment")
       ))

;;}}}

;;{{{ Octopress
;; -------------

(setq org-publish-project-alist
             '(("blog"
                :base-directory "~/octopress/source/org_posts/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/_posts/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("tareas"
                :base-directory "~/octopress/source/tareas/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/tareas/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("presentacion"
                :base-directory "~/octopress/source/presentacion/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/presentacion/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("recursos"
                :base-directory "~/octopress/source/recursos/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/recursos/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("linux"
                :base-directory "~/octopress/source/linux/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/linux/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("programa"
                :base-directory "~/octopress/source/programa/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/programa/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ("contacto"
                :base-directory "~/octopress/source/contacto/"
                :base-extension "org"
                :publishing-directory "~/octopress/source/contacto/"
                :sub-superscript ""
                :recursive t
                :publishing-function org-publish-org-to-html
                :headline-levels 4
                :html-extension "markdown"
                :body-only t)
	       ))

(require 'octopress)

(defalias 'octopost 'octopress-new-post)
(defalias 'octopage 'octopress-new-page)
(defalias 'rakeg    'octopress-generate)
(defalias 'octopre  'octopress-preview)
(defalias 'raked    'octopress-deploy)

;;}}}

;;{{{ Custom link types
;; ---------------------

;;(org-add-link-type
;;   "wiki"
;;   (lambda (link)
;;     (browse-url
;;      (concat "http://en.wikipedia.org/w/index.php?title=Special:Search&search=" link))))

;;}}}

(provide 'mb-org)
