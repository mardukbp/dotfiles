;; http://draketo.de/light/english/emacs/convert-ris-citations-bibtex-bibutils

(defun ris-citation-to-bib (&optional ris-url) 
  "get a ris citation as bibtex in one step. Just call M-x
ris-citation-to-bib and enter the ris url. 
Requires bibutils: http://sourceforge.net/p/bibutils/home/Bibutils/ 
"
  (interactive "Mris-url: ")
  (save-excursion
    (let ((bib-file "/home/arne/aufschriebe/ref.bib")
          (bib-buffer (get-buffer "ref.bib"))
          (ris-buffer (url-retrieve-synchronously ris-url)))
      ; firstoff check if we have the bib buffer. If yes, move point to the last line.
      (if (not (member bib-buffer (buffer-list)))
          (setq bib-buffer (find-file-noselect bib-file)))
      (progn 
        (set-buffer bib-buffer)
        (goto-char (point-max)))
      (if ris-buffer
          (set-buffer ris-buffer))
      (shell-command-on-region (point-min) (point-max) "ris2xml | xml2bib" ris-buffer)
      (let ((pmin (- (search-forward "@") 1))
            (pmax (search-forward "}

")))
        (if (member bib-buffer (buffer-list))
            (progn 
              (append-to-buffer bib-buffer pmin pmax)
              (kill-buffer ris-buffer)
              (set-buffer bib-buffer)
              (save-buffer)
          ))))))
