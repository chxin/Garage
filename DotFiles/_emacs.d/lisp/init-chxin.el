;;; init-chxin.el --- entrance to all customized files. -*- lexical-binding:t -*-

;; Copyright (C) 2019 Xin Cheng

;; Author: Xin Cheng <chengxinhust@gmail.com>
;; Keywords: customized, latex, pdf-tools
;; Version: 0.1
;; Package-requires: ((emacs "26.1") (pdf-tools) (auctex))

;;; ===== usage
;; This file is to be placed in ~/.emacs.d/lisp/
;; This file should be required by ~/.emacs.d/init.el as following
;; (require 'init-chxin)

;; Note: above 'require' command should be placed before init-evil.el required in the file of "~/.emacs.d/init.el"

;;; ===== include customized mode
(require 'init-pdf)
(require 'init-latex)

;;; ===== install package
;; the packages to install in elpa : auctex, flymake-cursor, use-package
;; Note: to install packages not included, uncomment elpa in ~/.emacs.d/lisp/init-elpa.el:106
;; Note: the packages to install manually : pdf-tools
(require-package 'auctex)
(require-package 'use-package)
(require-package 'flymake-cursor)
(require-package 'pdf-tools)
(require-package 'google-translate)
;; (require-package 'leetcode)
(require-package 'dash)
(require-package 'request)
(require-package 'request-deferred)
(require-package 'graphql)
(require-package 'spinner)
;; packages used for cpputils
;; (require-package 'auto-complete-clang)
;;; ===== emacs configuration
;; no ring
(setq ring-bell-function 'ignore)
;; show paren highlight
(show-paren-mode t)
;; timestamp
(defun insdate-insert-date-from (interval)
    "Insert date that is DAYS and MINUTES from current."
    (interactive (list (read-string (format "days_minutes: ") "0t0")))
    (insert (format-time-string "%H:%M:%S %a %m-%d-%Y"
                                (time-add (current-time)
                                          (+ (* (string-to-number (nth 0 (split-string interval "t"))) 86400)
                                             (* (string-to-number (nth 1 (split-string interval "t"))) 60))))))
(global-set-key "\C-c \C-d" `insdate-insert-date-from)

;;; === GUI for window; if terminal, comment the following
;; set window position
;; (set-frame-position (selected-frame) 650 5)
;; full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; half screen
;; (set-frame-width (selected-frame) 60)
;; (set-frame-height (selected-frame) 33)
;; load theme
;; (load-theme 'sanityinc-solarized-dark t)
;; set fontsize
;; (set-default-font "-outline-Courier New-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-")

;; auto split window vertically
(split-window-horizontally)
(other-window 1)
(find-file "~/.emacs.d/org/gtd.org")
(setq i 0)
(while (< i 15)
  (shrink-window-horizontally 1)
  (incf i))
(other-window 1)

;; resize window
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; === encoding system
;; utf-8
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system
    (if (eq system-type 'windows-nt)
        'utf-16-le))  ; https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows

(prefer-coding-system 'utf-8)

;; ===files
;; recent open files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
;; find file at point goto line
(defun find-file-at-point-goto-line (ret)
  "Ignore RET and jump to line number given in `ffap-string-at-point'."
  (when (and
     (stringp ffap-string-at-point)
     (string-match ":\\([0-9]+\\)\\'" ffap-string-at-point))
    (goto-char (point-min))
    (forward-line (1- (string-to-number (match-string 1 ffap-string-at-point))))
		ret))
;; replace ffap
(advice-add 'find-file-at-point :filter-return #'find-file-at-point-goto-line)
;; set shortcut for file access
(defun open-my-init-file ()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-chxin.el"))
(defun open-my-org-file ()
  (interactive)
  (find-file "~/.emacs.d/org/gtd.org"))
(global-set-key (kbd "C-c 1") 'open-my-init-file)
(global-set-key (kbd "C-c 2") 'open-my-org-file)

;; === evil-mode
;; evil insert mode no keybindings
;; this command must be set before evil-mode turns on
(setq evil-disable-insert-state-bindings t)
;; evil find char
;; (evil-mode 1)
;; (evil-local-set-key 'normal ";'" 'evil-repeat-find-char)
;; (evil-local-set-key 'normal ";," 'evil-repeat-find-char-reverse)

;; === org-mode
;; org capture
;; capture function to quickly add gtd to a specific file
(setq org-capture-templates
			'(("t" "ToDo" entry (file+headline "~/Documents/Emacs/org/gtd.org" "arrangement")
				 "* TODO [#B] %?\n %i\n"
				 :empty-line 1)))
(global-set-key (kbd "C-c r") 'org-capture)
;; set eww as the default broswe-url
;; (setq browse-url-browser-function 'eww-browse-url)
(defadvice org-open-at-point (around org-open-at-point-choose-browser activate)
  "`C-u M-x org-open-at-point` open link with `browse-url-generic-program'"
  (let* ((browse-url-browser-function
          (cond
           ;; open with `browse-url-generic-program'
           ((equal (ad-get-arg 0) '(4)) 'browse-url-generic)
           ;; open with w3m
           ;; (t 'w3m-browse-url)
           ;; open with eww
           (t 'eww-browse-url)
           )))
    ad-do-it))
;; set pdf-tools as the default pdf viewer
(eval-after-load 'org '(require 'init-pdf))
(add-to-list 'org-file-apps
    '("\\.pdf\\'" . (lambda (file link)
        (org-pdfview-open link))))

;; === verilog-mode
;; align rules
;; (eval-after-load "align"
;;   '(add-to-list 'align-rules-list
;;                 '(verilog-assignment
;;                   (regexp . "\\(\\s-*\\)<=")
;;                   (mode   . '(verilog-mode))
;;                   (repeat . nil))))

;; flymake settings for verilog mode
;; (defun flymake-verilog-init ()
;;   (let* ((temp (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
;;          (local (file-relative-name temp (file-name-directory buffer-file-name))))
;;     (list "iverilog" (list "-tnull" local))))
;; iverilog error pattern
;; (add-to-list 'flymake-err-line-patterns
;;              '("\\(.*?\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3))
;; (add-to-list 'flymake-err-line-patterns
;;              '("\\(^No top level modules\\)$" nil nil nil 0))
;; (add-to-list 'flymake-err-line-patterns
;;              '("\\(Unknown module type\\)" nil nil nil 0))

;; (add-hook 'verilog-mode-hook (lambda () (flymake-mode 1)))
;; (push '("\\.[v]\\'" flymake-verilog-init) flymake-allowed-file-name-masks)

;; flymake iverilog
;; following maybe available
;; (defadvice flymake-post-syntax-check
;;   (before flymake-force-check-was-interrupted)
;;   (setq flymake-check-was-interrupted t))
;; (ad-activate 'flymake-post-syntax-check)

;; (defun flymake-verilog-init()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
;;          (main-file (file-relative-name temp-file (file-name-directory buffer-file-name)))
;;          (sub-files (flymake-verilog-get-files)))
;;     (list "verilator" (append (list "--lint-only" main-file) sub-files))))

;; (defun flymake-verilog-get-files()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (if (re-search-forward "verilog-library-files:( *\"\\([^)]+\\)\" *)" nil t)
;;         (split-string (match-string-no-properties 1) "\" *\"") (list))))

;; (push '(".+\\.s?v$" flymake-verilog-init) flymake-allowed-file-name-masks)

;; (push '("^%.+: \\(.+\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

;; (add-hook 'verilog-mode-hook '(lambda () (flymake-mode -1)))
;; (setq-default flymake--backend-state `running)

;;; cc-mode
(add-hook 'c-mode-common-hook
          (lambda ()
            (if (derived-mode-p 'c-mode 'c++-mode)
                (cppcm-reload-all)
              )))
;; OPTIONAL, somebody reported that they can use this package with Fortran
(add-hook 'c90-mode-hook (lambda () (cppcm-reload-all)))
;; OPTIONAL, avoid typing full path when starting gdb
(global-set-key (kbd "C-c C-g")
 '(lambda ()(interactive) (gud-gdb (concat "gdb --fullname " (cppcm-get-exe-path-current-buffer)))))
;; OPTIONAL, some users need specify extra flags forwarded to compiler
(setq cppcm-extra-preprocss-flags-from-user '("-I/usr/src/linux/include" "-DNDEBUG"))
;; (require 'auto-complete-config)
;; (require 'auto-complete-clang)
;; (ac-commom-setup)
;; (add-to-list 'ac-source 'ac-clang)
;; gcc lint for cc-mode
;; (defvar flymake-additional-compilation-flags nil)
;; (put 'flymake-additional-compilation-flags 'safe-local-variable 'listp)

;; no need to arrange Makefile
;; (defun flymake-cc-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name)))
;;          (common-args (append (list "-Wall" "-W" "-fsyntax-only" local-file)
;;                               flymake-additional-compilation-flags)))
;;     (if (eq major-mode 'c++-mode)
;;         (list "g++" common-args)
;;       (list "gcc" common-args))))

;; (loop for ext in '("\\.c$" "\\.h$" "\\.cc$" "\\.cpp$" "\\.hh$")
;;       do
;;       (push `(,ext flymake-cc-init) flymake-allowed-file-name-masks))

;; (add-hook 'c-mode-hook (lambda () (flymake-mode t)))
;; ;; (add-hook 'c++-mode-hook (lambda () (flymake-mode t)))

;; flycheck linting
;; (setq-default flycheck-verilator-include-path 'D:/Applications/Mingw/verilator/bin/)
;; (setq-default flycheck-verilator-include-path nil)
;; (setq-default flycheck-verilog-verilator-executable "d:/Applications/Mingw/verilator/bin/verilator.exe")

;; === google translate
;; google translate
(require 'google-translate)

;;If google-translate-enable-ido-completion is non-NIL, the input will be read with ido-style completion.
(require 'google-translate)
(require 'google-translate-default-ui)
(require 'google-translate-smooth-ui)
(global-set-key "\C-ct" 'google-translate-smooth-translate)
(setq-default google-translate--tkk-url "http://translate.google.cn")
(setq-default google-translate-base-url "http://translate.google.cn/translate_a/single")
(setq-default google-translate-listen-url "http://translate.google.cn/translate_tts")
(setq google-translate-backend-method 'curl)
(setq-default google-translate-enable-ido-completion t)
(setq-default google-translate-default-source-language "en")
(setq-default google-translate-default-target-language "zh-CN")
(setq-default google-translate-translation-directions-alist '(("en" . "zh-CN")("zh-CN" . "en")))
(setq-default google-translate-output-destination 'echo-area)
(setq-default google-translate-pop-up-buffer-set-focus t)
;;; Note
;;

;;; === leetcode
(add-to-list 'load-path "~/.emacs.d/elpa/leetcode.el")
(require 'leetcode)
(setq leetcode-account "chengxinhust@163.com")
(setq leetcode-password "P@ssw0rd#LEETCODE")
(setq leetcode-prefer-language "cpp")
(setq leetcode-prefer-sql "mysql")

(provide 'init-chxin)
