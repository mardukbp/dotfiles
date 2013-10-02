;; ==========
;; Init File
;; ==========

;; Remove splash screen
(setq inhibit-splash-screen t)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Set paths
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

(setq themes-dir
      (expand-file-name "themes" site-lisp-dir))

(add-to-list 'Info-default-directory-list (expand-file-name "ebib" site-lisp-dir))

(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'custom-theme-load-path themes-dir)

;; Relocate customizations
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Setup package archives
(require 'packages)

;; Load config files
(require 'mb-global)
(require 'mb-org)
(eval-after-load 'dired '(require 'mb-dired))
(require 'mb-mu4e)
(require 'mb-extern)
(require 'mb-scicomp)
(require 'mb-term)
(eval-after-load 'cc-mode '(require 'mb-c))

;; LaTeX
(require 'tex-site)
(require 'mb-latex)
