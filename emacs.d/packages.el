(require 'package)

;(add-to-list 'package-archives 
;             '("melpa" . "http://melpa.milkbox.net/packages/")
;             '("marmalade" . "http://marmalade-repo.org/packages/")
;)

(package-initialize)                  

(add-to-list 'load-path (expand-file-name "elpa" user-emacs-directory))

;; el-get
;; -------

(setq el-get-dir
      (expand-file-name "el-get/" user-emacs-directory))

(add-to-list 'load-path (expand-file-name "el-get" el-get-dir))

;; el-get Stable branch
 (unless (require 'el-get nil 'noerror)
   (with-current-buffer
       (url-retrieve-synchronously
        "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp))))

(add-to-list 'el-get-recipe-path (expand-file-name "recipes" el-get-dir))

(setq el-get-verbose t)

(el-get 'sync)

(provide 'packages)
