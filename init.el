;; init.el --- Simon Inkin's custom Emacs config

;; Copyright (C) 2020

;; Author:  <simon.inkin@gmail.com>
;; Keywords: init

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:


;; Not tested

  ;; TRAMP optimizations

;; (setq tramp-auto-save-directory "~/tmp/tramp/")
;; (setq tramp-chunksize 2000)

  ;; SSH config file (it's here, 'cause there is no other place right now:
  ;; Host *
  ;;  ControlMaster auto
  ;;  ControlPath ~/tmp/.ssh-control-%r-%h-%p

  ;; Same here -  this is just a sshfs mount command. not an emacs init file command
  ;; sshfs remotehost:/remote/directory/ ~/local/directory -oauto_cache,reconnect,Ciphers=arcfour,Compression=no

  ;; Again:
  ;; wget https://github.com/ericpruitt/sshfsexec/archive/master.zip
  ;; unzip master.zip
  ;; mv sshfsexec-master sshfsexec
  ;; cd sshfsexec
  ;; mkdir -p ~/bin/sshfsexec
  ;; cp sshfsexec.py ~/bin/sshfsexec
  ;; chmod +x ~/bin/sshfsexec/sshfsexec.py
  ;; export PATH="$HOME/bin/sshfsexec:$PATH"
  ;; cd ~/bin/sshfsexec
  ;; ln -s sshfsexec.py git
  ;; hash -r


  ;; http://gleek.github.io/blog/2017/04/11/editing-remote-code-with-emacs/


;; Basics


;; backup directory
(setq backup-directory-alist'(("." . ".bak")))

;; auto-refresh when files have changed on disk
(global-auto-revert-mode t)

;; change emacs shell to bash
(setq-default explicit-shell-file-name "/bin/bash")

;; macOS
(setq mac-option-modifier 'meta)
(setq mac-control-modifier 'control)

;; (setq  x-meta-keysym 'super
;;        x-super-keysym 'meta)

;;Packages

;; packaging
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)

;; automated package install and config
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(defvar use-package-always-defer)
(defvar use-package-always-ensure)
(defvar use-package-check-before-init)

(setq use-package-always-defer      t
      use-package-always-ensure     t
      use-package-check-before-init t)

(use-package auto-package-update
  :ensure t
  :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-hide-results t)
    (auto-package-update-maybe))

;; General Config

;; font

;;(setq default-frame-alist '((font . "Source Code Pro-8")))
;;(set-default-font "Monaco 11")
;;(set-face-attribute 'default nil :font "DejaVu Sans Mono-10" )
(set-face-attribute 'default nil :font "Office Code Pro-13" )


;; themes
(use-package monokai-theme
  :demand t
  :config (load-theme 'monokai t))

(use-package all-the-icons
  :demand t
  :config (all-the-icons-install-fonts t))

;; fill-column
(setq-default fill-column 80)

;; show whitespacing
(use-package whitespace
  :demand t
  :config
    (setq whitespace-line-column 80)
    (setq whitespace-style '(face tabs newline empty trailing lines-tail tab-mark newline-mark))
  :init (add-hook 'prog-mode-hook 'whitespace-mode))

;; remove trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; lines
(global-hl-line-mode t)
(global-display-line-numbers-mode)
(global-visual-line-mode t)

;;columns
(setq column-number-mode t)

;; tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; paranthesis
(show-paren-mode t)

;; rainbow delimeters
(use-package rainbow-delimiters
  :demand t
  :hook
    (prog-mode . rainbow-delimiters-mode))

;; Buffers

;; Makes *scratch* empty.
; (setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
; (defun remove-scratch-buffer ()
;   (if (get-buffer "*scratch*")
;       (kill-buffer "*scratch*")))
; (add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
;;(setq-default message-log-max nil)
;;(kill-buffer "*Messages*")

; ;; Removes *Completions* from buffer after you've opened a file.
; (add-hook 'minibuffer-exit-hook
;       '(lambda ()
;          (let ((buffer "*Completions*"))
;            (and (get-buffer buffer)
;                 (kill-buffer buffer)))))

; ;; Don't show *Buffer list* when opening multiple files at the same time.
; (setq inhibit-startup-buffer-menu t)

; ;; Show only one active window when opening multiple files at the same time.
; (add-hook 'window-setup-hook 'delete-other-windows)

;; TRAMP

(require 'tramp)

;;(custom-set-variables
;; '(tramp-default-method "ssh")
;; '(tramp-default-user "si")
;; '(tramp-default-host "devdevdev.yourawesomefqdn.com"))

(customize-set-variable 'tramp-encoding-shell "/bin/bash")

(add-to-list 'tramp-connection-properties
  (list (regexp-quote "/ssh:si@elixir.yourawesomefqdn.com:")
        "remote-shell" "/bin/bash"))


;; Built In

(global-set-key (kbd "C-x p") #'proced)


;; Projectile

(use-package projectile
  :demand t
  :config
    (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (projectile-mode +1)
    (setq projectile-mode-line "Projectile"))

;; Ivy + Swiper + Counsel

(use-package ivy
  :demand t
  :bind (("C-c C-r" . ivy-resume)
        ("C-x b" . ivy-switch-buffer)
        ("C-x B" . ivy-switch-buffer-other-window)
        ("C-c v" . ivy-push-view)
        ("C-c V" . ivy-pop-view))
  :config
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "%d/%d ")
  :init (ivy-mode 1))

;; example ivy rich buffers icon and other columns config
;; https://mopemope.com/emacs-config/


(defvar ivy-rich-switch-buffer-align-virtual-buffer)

(use-package ivy-rich
  :disabled
  :after ivy
  :demand t
  :preface
    (defun ivy-rich-switch-buffer-icon (candidate)
      (with-current-buffer
          (get-buffer candidate)
        (let ((icon (all-the-icons-icon-for-mode major-mode)))
          (if (symbolp icon)
              (all-the-icons-icon-for-mode 'fundamental-mode)
            icon))))
  :config
    (setq ivy-virtual-abbreviate 'full
          ivy-rich-switch-buffer-align-virtual-buffer t
          ivy-rich-path-style 'abbrev
          ivy-rich-display-transformers-list
            '(ivy-switch-buffer
              (:columns
                ((ivy-rich-switch-buffer-icon (:width 2))
                  (ivy-rich-candidate (:width 30))
                  (ivy-rich-switch-buffer-size (:width 7))
                  (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
                  (ivy-rich-switch-buffer-major-mode (:width 15 :face warning))
                  (ivy-rich-switch-buffer-project (:width 20 :face success))
                  (ivy-rich-switch-buffer-path (:width 50)))
               :predicate
                (lambda (cand) (get-buffer cand)))))
  :init (add-hook 'after-init-hook 'ivy-rich-mode))

(use-package all-the-icons-ivy
  :disabled
  :after ivy-rich
  :demand t
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(use-package swiper
  :after ivy
  :demand t
  :bind (("C-s" . swiper-isearch)))

(use-package counsel
  :after ivy
  :demand t
  :bind (("M-x" . counsel-M-x)
        ("C-x C-f" . counsel-find-file)
        ("M-y" . counsel-yank-pop)
        ("<f1> f" . counsel-describe-function)
        ("<f1> v" . counsel-describe-variable)
        ("<f1> l" . counsel-find-library)
        ("<f2> i" . counsel-info-lookup-symbol)
        ("<f2> u" . counsel-unicode-char)
        ("<f2> j" . counsel-set-variable)
        ("C-c c" . counsel-compile)
        ("C-c g" . counsel-git)
        ("C-c j" . counsel-git-grep)
        ("C-c L" . counsel-git-log)
        ("C-c k" . counsel-ag)
        ("C-c m" . counsel-linux-app)
        ("C-c n" . counsel-fzf)
        ("C-x l" . counsel-locate)
        ("C-c J" . counsel-file-jump)
        ("C-S-o" . counsel-rhythmbox)
        ("C-c w" . counsel-wmctrl)
        ("C-c b" . counsel-bookmark)
        ("C-c d" . counsel-descbinds)
        ("C-c o" . counsel-outline)
        ("C-c t" . counsel-load-theme)
        ("C-c F" . counsel-org-file)))



;; Text

;; (use-package flyspell
;;   :delight
;;   :hook ((markdown-mode org-mode text-mode) . flyspell-mode)
;;          (prog-mode . flyspell-prog-mode)
;;   :custom
;;   (flyspell-abbrev-p t)
;;   (flyspell-default-dictionary "en_US")
;;   (flyspell-issue-message-flag nil)
;;   (flyspell-issue-welcome-flag nil))

;;(use-package flyspell-correct-ivy
;;  :after (flyspell ivy)
;;  :init (setq flyspell-correct-interface #'flyspell-correct-ivy))

;; Autocomplete



;; IDE

;; General IDE

;; GDB

(setq gdb-many-windows t
      gdb-use-separate-io-buffer t)

(advice-add 'gdb-setup-windows :after
            (lambda () (set-window-dedicated-p (selected-window) t)))

;; Save current window layout before opening GUD multiple windows
(defconst gud-window-register 123456)

(defun gud-quit ()
  (interactive)
  (gud-basic-call "quit"))

(add-hook 'gud-mode-hook
          (lambda ()
            (gud-tooltip-mode)
            (window-configuration-to-register gud-window-register)
            (local-set-key (kbd "C-q") 'gud-quit)))

(advice-add 'gud-sentinel :after
            (lambda (proc msg)
              (when (memq (process-status proc) '(signal exit))
                (jump-to-register gud-window-register)
                (bury-buffer))))

;; company mode
(use-package company
  :demand t
  :hook
    (after-init . global-company-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :ensure t
;;  :config
;;  (require 'lsp-mode)
;;  (require 'lsp-clients)
  :diminish lsp-mode
;  :config                               ;
;    (dolist (dir '(
;                 "[/\\\\]assets\\'"
;                 "[/\\\\]\\.git\\'"
;                 ))
                                        ;    (push dir lsp-file-watch-ignored))
  :config
  ;(add-to-list 'lsp-file-watch-ignored "[/\\\\]assets\\'")
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]assets\\'")
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]_build\\'")
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]deps\\'")
  (add-to-list 'lsp-file-watch-ignored "[/\\\\].*\\'")

  :hook
    (c-mode . lsp)
    (c++-mode . lsp)
    (python-mode . lsp)
    (elixir-mode . lsp)
    :init
;;    (add-to-list 'exec-path "/ssh:si@elixir.yourawesomefqdn.com:/home/si/elixir/elixir-ls/release"))
;;;;    (add-to-list 'exec-path "/Users/simon/elixir/elixir/elixir-ls/release"))
    ;;      (add-to-list 'exec-path "/Users/simon/elixir-ls-master/release"))
    ;;(add-to-list 'lsp-file-watch-ignored "[/\\\\]assets\\'")
    (add-to-list 'exec-path "/home/sp/Projects/Elixir/Support/elixir-ls/release"))
;;    (add-to-list 'exec-path "/Users/simon/elixirlsp/elixir-ls/release"))




;; (defcustom lsp-file-watch-ignored '(; SCM tools
;;                                     "[/\\\\]\\.git\\'"
;;                                     "[/\\\\]\\.hg\\'"
;;                                     "[/\\\\]\\.bzr\\'"
;;                                     "[/\\\\]_darcs\\'"
;;                                     "[/\\\\]\\.svn\\'"
;;                                     "[/\\\\]_FOSSIL_\\'"
;;                                     ;; IDE or build tools
;;                                     "[/\\\\]\\.idea\\'"
;;                                     "[/\\\\]\\.ensime_cache\\'"
;;                                     "[/\\\\]\\.eunit\\'"
;;                                     "[/\\\\]node_modules"
;;                                     "[/\\\\]\\.fslckout\\'"
;;                                     "[/\\\\]\\.tox\\'"
;;                                     "[/\\\\]dist\\'"
;;                                     "[/\\\\]dist-newstyle\\'"
;;                                     "[/\\\\]\\.stack-work\\'"
;;                                     "[/\\\\]\\.bloop\\'"
;;                                     "[/\\\\]\\.metals\\'"
;;                                     "[/\\\\]target\\'"
;;                                     "[/\\\\]\\.ccls-cache\\'"
;;                                     "[/\\\\]\\.vscode\\'"
;;                                     ;; Autotools output
;;                                     "[/\\\\]\\.deps\\'"
;;                                     "[/\\\\]build-aux\\'"
;;                                     "[/\\\\]autom4te.cache\\'"
;;                                     "[/\\\\]\\.reference\\'"
;;                                     ;; .Net Core build-output
;;                                     "[/\\\\]bin/Debug\\'"
;;                                     "[/\\\\]obj\\'")

(use-package lsp-ui
  :ensure t
  :config
    (require 'lsp-ui))

(use-package company-lsp
  :after company
  :ensure t
  :config
;;    (require 'company-lsp)
    (push 'company-lsp company-backends)
;;    (add-hook 'after-init-hook 'global-company-mode)
  :hook
    (after-init . global-company-mode))

; ;;syntax checking
; (use-package flycheck
;   :demand t
;   :commands flycheck-mode)
;   ;;:init (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package flycheck
  :demand t
  :hook
    (prog-mode . flycheck-mode))

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.15)))



; https://stackoverflow.com/questions/48051120/display-flycheck-buffer-automatically-when-there-are-errors
;(add-hook 'flycheck-after-syntax-check-hook 'flycheck-list-errors)
(add-hook 'flycheck-after-syntax-check-hook
          (lambda  ()
            (if flycheck-current-errors
                (flycheck-list-errors))))

;; I don't like this one
(use-package flycheck-inline
  :demand t
  :init
    (add-hook 'flycheck-mode-hook 'flycheck-inline-mode))

(use-package yasnippet                  ; Snippets
  :ensure t
  :config
    (setq yas-verbosity 1) ; No need to be so verbose
    (setq yas-wrap-around-region t)

  (with-eval-after-load 'yasnippet
    (setq yas-snippet-dirs '(yasnippet-snippets-dir)))

  (yas-reload-all)
  (yas-global-mode))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

; ;;magit
; (use-package magit
;   :demand t
;   :commands magit-get-top-dir
;   :bind (("C-c g" . magit-status)
;          ("C-c C-g l" . magit-file-log)
;          ("C-c f" . magit-grep))
;   :init
;   (progn
;     ;; magit extensions
;     (use-package magit-blame
;       :bind ("C-c C-g b" . magit-blame-mode))

;     ;; we no longer need vc-git
;     (delete 'Git vc-handled-backends)
;     ;; make magit status go full-screen but remember previous window
;     ;; settings
;     ;; from: http://whattheemacsd.com/setup-magit.el-01.html
;     (defadvice magit-status (around magit-fullscreen activate)
;       (window-configuration-to-register :magit-fullscreen)
;       ad-do-it
;       (delete-other-windows))

;     ;; Close popup when commiting - this stops the commit window
;     ;; hanging around
;     ;; From: http://git.io/rPBE0Q
;     (defadvice git-commit-commit (after delete-window activate)
;       (delete-window))

;     (defadvice git-commit-abort (after delete-window activate)
;       (delete-window))

;     ;; these two force a new line to be inserted into a commit window,
;     ;; which stops the invalid style showing up.
;     ;; From: http://git.io/rPBE0Q
;     (defun magit-commit-mode-init ()
;       (when (looking-at "\n")
;         (open-line 1)))

;     (add-hook 'git-commit-mode-hook 'magit-commit-mode-init))
;   :config
;   (progn
;     ;; restore previously hidden windows
;     (defadvice magit-quit-window (around magit-restore-screen activate)
;       (let ((current-mode major-mode))
;         ad-do-it
;         ;; we only want to jump to register when the last seen buffer
;         ;; was a magit-status buffer.
;         (when (eq 'magit-status-mode current-mode)
;           (jump-to-register :magit-fullscreen))))

;     (defun magit-maybe-commit (&optional show-options)
;       "Runs magit-commit unless prefix is passed"
;       (interactive "P")
;       (if show-options
;           (magit-key-mode-popup-committing)
;         (magit-commit)))

;     (define-key magit-mode-map "c" 'magit-maybe-commit)

;     ;; major mode for editing `git rebase -i` files
;     (use-package rebase-mode)

;     ;; magit settings
;     (setq
;      ;; use ido to look for branches
;      magit-completing-read-function 'magit-ido-completing-read
;      ;; don't put "origin-" in front of new branch names by default
;      magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
;      ;; open magit status in same window as current buffer
;      magit-status-buffer-switch-function 'switch-to-buffer
;      ;; highlight word/letter changes in hunk diffs
;      magit-diff-refine-hunk t
;      ;; ask me if I want to include a revision when rewriting
;      magit-rewrite-inclusive 'ask
;      ;; ask me to save buffers
;      magit-save-some-buffers t
;      ;; pop the process buffer if we're taking a while to complete
;      magit-process-popup-time 10
;      ;; ask me if I want a tracking upstream
;      magit-set-upstream-on-push 'askifnotset
;      )))

; (provide 'init-magit)

;; (use-package undo-tree
;;   :delight
;;   :bind ("C--" . undo-tree-redo)
;;   :init (global-undo-tree-mode)
;;   :custom
;;   (undo-tree-visualizer-timestamps t)
;;   (undo-tree-visualizer-diff t))

;; Language Modes

(use-package feature-mode
  :ensure t)

;;(unless (package-installed-p 'elixir-mode)
;;  (package-install 'elixir-mode))

;; (unless (package-installed-p 'alchemist)
;;  (package-install 'alchemist))


;; https://elixirforum.com/t/emacs-elixir-setup-configuration-wiki/19196

(use-package elixir-mode
   :ensure t
   :hook
   (elixir-mode . (lambda ()
      (add-hook 'before-save-hook 'elixir-format nil t))))
;;
;;
;;
;; ;; Alchemist offers integration with the Mix tool.
;;(use-package alchemist
;;  :ensure t
;;  :hook (elixir-mode . alchemist-mode)
;;  :delight alchemist-mode)
;;
;;
;;(use-package flycheck-mix
;;  :ensure t
;;  :init (add-hook 'flycheck-mode-hook #'flycheck-credo-setup))
;;
;;
;;(use-package flycheck-credo
;;  :ensure t
;;  :defer t
;;  :init (add-hook 'flycheck-mode-hook #'flycheck-credo-setup))


;; https://hasanyavuz.ozderya.net/?p=197
(flycheck-define-checker vhdl-nvc
  "A VHDL syntax checker using nvc."
  :command ("nvc" "--message=compact" "-a" source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column
          ": error: " (message) line-end))
  :modes vhdl-mode)

(add-to-list 'flycheck-checkers 'vhdl-nvc)

;; Visual Config

;; folding
;(use-package hideshow-org
;  :demand t
;  :init (progn
;          (add-hook 'prog-mode-hook (lambda () (hs-org/minor-mode 1)))
;          (setq hs-org/trigger-keys-block (list (kbd "TAB")
;                                                (kbd "<C-tab>")))
;          (setq hs-org/trigger-keys-all (list [S-tab]
;                                              [S-iso-lefttab]
;                                              [(shift tab)]
;                                              [backtab])))
;  :commands hs-org/minor-mode)

;; disable scrollbars
(toggle-scroll-bar -1)
(defun my/disable-scroll-bars (frame)
  "Argument FRAME specifies GUI Emacs frame."
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

;;powerline
(use-package powerline
  :demand t
  :config (powerline-default-theme))

;; F# keys
;;tree view
(use-package neotree
  :demand t
  :bind (([f8] . neotree-toggle))
  :config
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
    (setq neo-smart-open t)
    (setq neo-autorefresh nil)
    (setq neo-window-width 40))

;;minimap
(use-package minimap
  :demand t
  ;;:bind (("C-x m" . minimap-mode))
  :bind (([f9] . minimap-mode))
  :custom
    (minimap-major-modes '(prog-mode))
    (minimap-window-location 'right)
    (minimap-update-delay 0.2)
    (minimap-minimum-width 8))


;; Graphical Emacs

; (defvar maxframe-maximized-p nil "Maxframe is in fullscreen mode.")
; (defun toggle-maxframe ()
;   "Toggle maximized frame."
;   (interactive)
;   (setq maxframe-maximized-p (not maxframe-maximized-p))
;   (cond (maxframe-maximized-p (maximize-frame))
;         (t (restore-frame))))
; (define-key global-map [(alt return)] 'toggle-maxframe)

; (setq ns-use-native-fullscreen nil)

;; default frame size
(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (tool-bar-lines . 1)
              (width . 200) ; chars
              (height . 53) ; lines
              (left . 0)
              (top . 0)))
      (setq default-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 200)
              (height . 53)
              (left . 0)
              (top . 0))))
  (progn
    (setq initial-frame-alist '( (tool-bar-lines . 1)))
    (setq default-frame-alist '( (tool-bar-lines . 1)))))

;; smooth scrolling
 ;; (use-package sublimity
 ;;   :demand t
 ;;  :config
 ;;  (require 'sublimity-scroll)
 ;;  (sublimity-mode 1)
 ;;  ;;(require 'sublimity-map) ;; experimental
 ;;  ;;(require 'sublimity-attractive)
 ;;  )
;; Key rebinds and macros

;; No more typing the whole yes or no. Just y or n will do.
(fset 'yes-or-no-p 'y-or-n-p)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(elixir-mode use-package rainbow-delimiters monokai-theme minimap hideshow-org)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init.el)
;;; init.el ends here
