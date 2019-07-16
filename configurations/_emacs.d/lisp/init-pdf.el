;;; init-pdf.el --- support emacs pdf viewer -*- lexical-binding:t -*-

;; Copyright (C) 2019 Xin Cheng

;; Authore: Xin Cheng <chengxinhust@gmail.com>
;; Keywords: pdf viewer; pdf-tools; org-mode; tex-mode
;; Package-requires: ((org: "")(pdf-tools:""))
;; executable-requires: (epdfinfo.exe:"")
;; library-requires: (emax64:"") ;https://github.com/m-parashar/emax64; https://sourceforge.net/projects/ezwinports/files

;;; set pdf file related mode
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

;; ===== install pdf-tools for emacs
;; Ref: https://emacs-china.org/t/emax64-xwdiget/8618 ;https://emacs-china.org/t/windows-pdf-tools/7358
;; get emax64: https://github.com/m-parashar/emax64 ;https://github.com/m-parashar/emax64/releases/download/pdumper-20180619/emax64-pdumper-bin-20180619.7z
;; get pdf-tools tar: https://melpa.org/packages/pdf-tools-20190309.744.tar
;; get compiled executable file epdfinfo.exe: https://github.com/politza/pdf-tools;
;; Note: if no compile, some .dll needed for https://github.com/chxin/dot-files/raw/master/_emacs.d/epdfinfo.exe
;; add package to emacs: M-x package-install-file (RET), select pdf-tools-$VERSION.tar
;; install pdf-tools: M-x pdf-tools-install

;; ===== open pdf file link with pdf-tools in org-mode
;; fork from https://github.com/markus1189/org-pdfview
;; Add support for org links from pdfview buffers like docview.
;; To enable this automatically, use:
;;     (eval-after-load 'org '(require 'org-pdfview))
;; If you want, you can also configure the org-mode default open PDF file function.
;; (add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link))))
(require 'org)
(require 'pdf-tools)
(require 'pdf-view)

(if (fboundp 'org-link-set-parameters)
    (org-link-set-parameters "pdfview"
                             :follow #'org-pdfview-open
                             :complete #'org-pdfview-complete-link
                             :store #'org-pdfview-store-link)
  (org-add-link-type "pdfview" 'org-pdfview-open)
  (add-hook 'org-store-link-functions 'org-pdfview-store-link))

(defun org-pdfview-open (link)
  "Open LINK in pdf-view-mode."
  (cond ((string-match "\\(.*\\)::\\([0-9]*\\)\\+\\+\\([[0-9]\\.*[0-9]*\\)"  link)
         (let* ((path (match-string 1 link))
                (page (string-to-number (match-string 2 link)))
                (height (string-to-number (match-string 3 link))))
           (org-open-file path 1)
           (pdf-view-goto-page page)
           (image-set-window-vscroll
            (round (/ (* height (cdr (pdf-view-image-size))) (frame-char-height))))))
        ((string-match "\\(.*\\)::\\([0-9]+\\)$"  link)
         (let* ((path (match-string 1 link))
                (page (string-to-number (match-string 2 link))))
           (org-open-file path 1)
           (pdf-view-goto-page page)))
        (t
         (org-open-file link 1))
        ))

(defun org-pdfview-store-link ()
  "Store a link to a pdfview buffer."
  (when (eq major-mode 'pdf-view-mode)
    ;; This buffer is in pdf-view-mode
    (let* ((path buffer-file-name)
           (page (pdf-view-current-page))
           (link (concat "pdfview:" path "::" (number-to-string page))))
      (org-store-link-props
       :type "pdfview"
       :link link
       :description path))))

(defun org-pdfview-export (link description format)
  "Export the pdfview LINK with DESCRIPTION for FORMAT from Org files."
  (let* ((path (when (string-match "\\(.+\\)::.+" link)
                 (match-string 1 link)))
         (desc (or description link)))
    (when (stringp path)
      (setq path (org-link-escape (expand-file-name path)))
      (cond
       ((eq format 'html) (format "<a href=\"%s\">%s</a>" path desc))
       ((eq format 'latex) (format "\\href{%s}{%s}" path desc))
       ((eq format 'ascii) (format "%s (%s)" desc path))
       (t path)))))

(defun org-pdfview-complete-link (&optional arg)
  "Use the existing file name completion for file.
Links to get the file name, then ask the user for the page number
and append it."
  (concat (replace-regexp-in-string "^file:" "pdfview:" (org-file-complete-link arg))
	  "::"
	  (read-from-minibuffer "Page:" "1")))

(provide 'init-pdf)
