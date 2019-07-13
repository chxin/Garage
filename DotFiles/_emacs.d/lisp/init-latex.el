;; init-latex.el ---latex environment -*- coding: utf-8; lexical-binding: t; -*-
;; Copyright (C) 2019 Xin Cheng

;; Author: Xin Cheng <chengxinhust@gmail.com>
;; Keywords: latex, auctex, preview, forward/backward searching
;; Package-requires: ((auctex: "")(use-package: "")(pdf-tools: "")
;; executable-requires: (sumatraPDF:"") ;Note: not portable

(require 'use-package)

;;; ===== tex file related mode
(setq-default TeX-master nil)
(mapc (lambda (mode)
    (add-hook 'LaTeX-mode-hook mode))
    (list 'turn-on-cdlatex
        'reftex-mode
        'outline-minor-mode
        'auto-fill-mode
        'flyspell-mode
        'hide-body t))

;;; ===== preview
;; real time preview
;; Note: require xwidget ;https://github.com/chxin/emacs-webkit-katex-render

;; === AUCTex customization
;; compile tex to PDF
(setq TeX-PDF-mode t)
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)
; make sure source specials or SyncTeX being enable to compile it to a forward / backward searching.
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
; always start emacs server when viewing in evance for backward search
(setq TeX-source-correlate-start-server t)

;; = on Ubuntu
;; view the pdf using evince
;; (setq TeX-view-program-selection '((output-pdf "Evince")))
;; = Windows 10 -- mingw
;; view the pdf using pdftools
;;https://nasseralkmim.github.io/notes/2016/08/21/my-latex-environment ;https://emacs.stackexchange.com/questions/19472/how-to-let-auctex-open-pdf-with-pdf-tools
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-tools-install)
  :bind ("C-c C-g" . pdf-sync-forward-search) ;forward search mannuly
  :defer t
  :config
  (setq mouse-wheel-follow-mouse t)
  (setq pdf-view-resize-factor 1.10))

;; view the pdf using sumatraPDF
;; forward and backward search with sumatraPDF not "portable"
;; path of SumatraPDF
;; (setq TeX-view-program-list
;;       '(("Sumatra PDF" ("\"D:/Applications/Sumatra/SumatraPDF.exe\" -reuse-instance" (mode-io-correlate " -forward-search %b %n ") " %o"))))
;; (setq TeX-view-program-selection
;;       '(((output-dvi style-pstricks)
;;          "dvips and start")
;;         (output-dvi "Yap")
;;         (output-pdf "Sumatra PDF")
;;         (output-html "start")))
;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (assq-delete-all 'output-pdf TeX-view-program-selection)
;;             (add-to-list 'TeX-view-program-selection '(output-pdf "Sumatra PDF"))))
;; Note: configuration of backward search in sumatraPDF
;; open SumatraPDF: menu->setting->options->inverse search: C:\emacs\bin\emacsclientw.exe +%l "%f"

;; Note: in case of TeX configurations make Emacs crash, the fllowing 3 configurations help
;; find tex
;; TeX-tree-roots path configuration
;; (setq TeX-tree-roots "D:\\Applications\\Tex\\texmf-dist\\")
;; (setenv "PATH"
;;         (concat
;;          "D:\\Applications\\Tex\\bin\\win32" ";"
;;          (getenv "PATH")))
;; (setq preview-gs-command "D:\\Applications\\Tex\\bin\\win32\\rungs.exe")

;; set fill column to 1000
(add-hook 'LaTeX-mode-hook (lambda () (set-fill-column 1000)))

;; flymake
;; (require 'flymake)
;; (defun flymake-get-tex-args (file-name)
;; (list "pdflatex"
;; (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))
;; (add-hook 'LaTeX-mode-hook 'flymake-mode)

;; outline mode
;; (setq outline-minor-mode-prefix "\C-c \C-o")
(provide 'init-latex)
