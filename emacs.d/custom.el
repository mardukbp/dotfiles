(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-list (quote (("zathura" "zathura %s.pdf"))))
 '(TeX-view-program-selection (quote (((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi") (output-pdf "zathura") (output-html "xdg-open"))))
 '(dired-isearch-filenames t)
 '(dired-listing-switches "-laghop")
 '(org-agenda-files (quote ("~/Org/gtd.org" "~/Proyectos/proyectos.org")))
 '(org-agenda-prefix-format (quote ((agenda . " %s %?-12t") (timeline . "  % s") (todo . " %i %-12:c") (tags . " %i ") (search . " %i %-12:c"))))
 '(org-agenda-remove-tags t)
 '(org-agenda-start-on-weekday 0)
 '(org-agenda-use-time-grid nil)
 '(org-deadline-warning-days 1)
 '(package-archives (quote (("ELPA" . "http://tromey.com/elpa/") ("gnu" . "http://elpa.gnu.org/packages/") ("marmalade" . "http://marmalade-repo.org/packages/") ("SC" . "http://joseito.republika.pl/sunrise-commander/") ("MELPA" . "http://melpa.milkbox.net/packages/"))))
 ;;'(recentf-mode t)
 '(sentence-end-double-space nil)
 ;;'(tramp-default-method "ftp")
 '(word-wrap t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-search-feed-face ((t nil)))
 '(elfeed-search-title-face ((t (:foreground "#fff" :height 0.8)))))
