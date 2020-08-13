;; disable automatic description as this is both annoying and can easily
;; get intero stuck

(global-eldoc-mode -1)

(setq inhibit-startup-screen t)

(add-hook 'minibuffer-setup-hook
    (lambda () (setq truncate-lines nil)))

(setq resize-mini-windows t) ; grow and shrink as necessary
(setq max-mini-window-height 10) ; grow up to max of 10 lines

(setq minibuffer-scroll-window t)

;; mac os key bindings

(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'control)
  ;; (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )

;; save tags file without prompt

(setq-default tags-revert-without-query t)

;;; Transparent background:

(set-frame-parameter (selected-frame) 'alpha '(95 . 85))
(add-to-list 'default-frame-alist '(alpha . (95 . 85)))

(defun toggle-transparency ()
  "Toggle Emacs window transparency."
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
		    ((numberp (cdr alpha)) (cdr alpha))
		    ;; Also handle undocumented (<active> <inactive>) form.
		    ((numberp (cadr alpha)) (cadr alpha)))
	      100)
	 '(95 . 50) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;;; PATH

(let ((my-cabal-path (expand-file-name "~/.cabal/bin"))
      (ghcup-path (expand-file-name "~/.ghcup/bin"))
      (npm-bin-path (expand-file-name "~/.nvm/versions/node/v12.18.2/bin"))
      (yarn-global-path (expand-file-name "~/.config/yarn/global/node_modules/.bin")))
      (setenv "PATH" (concat ghcup-path path-separator
			     my-cabal-path path-separator
			     npm-bin-path path-separator
			     yarn-global-path path-separator
			     (getenv "PATH")))
  (add-to-list 'exec-path ghcup-path)
  (add-to-list 'exec-path my-cabal-path)
  (add-to-list 'exec-path npm-bin-path)
  (add-to-list 'exec-path yarn-global-path))

;;; Magit

(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magic-status))

;;; Winum:

(use-package winum
  :ensure t
  :config
  (winum-mode))

;; format-all

(use-package format-all
  :ensure t)

;;; transpose lines

(defmacro save-column (&rest body)
  "Save cursor position column.   save-column (as BODY)."
  `(let ((column (current-column)))
     (unwind-protect
         (progn ,@body)
       (move-to-column column))))
(put 'save-column 'lisp-indent-function 0)

(defun move-line-up ()
  "Move line up."
  (interactive)
  (save-column
    (transpose-lines 1)
    (forward-line -2)))

(defun move-line-down ()
  "Move line down."
  (interactive)
  (save-column
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;;; multiple cursors

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

;;; Projectile:

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;;; counsel-projectile

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode t))

;;; NeoTree

(use-package neotree
  :ensure t
  :config
  (global-set-key (kbd "C-`") 'neotree-toggle))

(setq neo-smart-open t)

;;; ivy

(use-package ivy :demand
  :config
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d "))

;;; Terminal:

; (setq-default explicit-shell-file-name "/usr/bin/zsh")

; (defun my-term-create ()
;   "Create customized terminal."
;   (set-buffer (ansi-term explicit-shell-file-name "terminal"))
;   (term-mode)
;   (term-char-mode)
;   (switch-to-buffer "*terminal*"))

; (defun my-term-buffer-exists ()
;   "Check whether terminal buffer exists."
;   (catch 'loop
;     (dolist (buf (buffer-list))
;       (with-current-buffer buf
; 	(when (derived-mode-p 'term-mode)
; 	  (throw 'loop t))))))

; (defun my-term ()
;   "Customized term command."
;   (interactive)
;   (if (my-term-buffer-exists)
;       (switch-to-buffer "*terminal*")
;     (my-term-create)))

; (define-key global-map (kbd "C-`") (lambda () (interactive) (my-term-create)))

;;; direnv

(use-package direnv
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'direnv-update-environment))

;;; rainbow delimeters

;; (use-package rainbow-delimiters
;;   :ensure t
;;   :hook
;;   (haskell-mode . rainbow-delimeters-mode))

;;; Autocompletion

(use-package company
  :ensure t
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.4)
  (global-set-key (kbd "C-c w") 'company-complete)
  (global-company-mode t))

;; (use-package company-ghci
;;   :ensure t
;;   :after company
;;   :config
;;   (add-to-list 'company-backends 'company-ghci))

;; (use-package company-ghc
;;   :ensure t
;;   :after company
;;   :config
;;   (add-to-list 'company-backends 'company-ghc))

;;; flycheck

(use-package flycheck
  :ensure t
  :config
  ;; (global-flycheck-mode t)
  (global-set-key (kbd "<f7>") 'flycheck-list-errors))

(use-package flycheck-color-mode-line
  :ensure t
  :after flycheck-mode
  :config
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

;;; Haskell:

(use-package haskell-mode
  :ensure t
  :after flycheck
  :init
  (setq-default flycheck-disable-checkers '(haskell-stack-ghc))
  (setq-default haskell-mode-stylish-haskell-path "brittany")

  :config
  ;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  ;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  ;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  ;; (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
  (setq-default haskell-hoogle-command "hoogle")
  (setq haskell-process-type 'auto)
  (setq haskell-stylish-on-save t)
  (setq haskell-tags-on-save t)
  (setq haskell-process-log t)
  (setq haskell-process-auto-import-loaded-modules t)
  (setq haskell-process-suggest-remove-import-lines t)
  (setq haskell-interactive-popup-errors nil)

  (define-key haskell-mode-map [f8] 'haskell-navigate-imports)

  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile)

  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
  (define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))


;;; Dante haskell

(use-package dante
  :ensure t
  :defer t
  :after (haskell-mode flycheck)
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  (add-hook 'haskell-mode-hook 'dante-mode)
  :config
  ;; (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq company-backends (delete 'dante-company company-backends))
  (flycheck-add-next-checker 'haskell-dante '(warning . haskell-hlint)))

;;; GHCid

(defun ghcid ()
  "Run ghcid in a `term' buffer."
  (interactive)
  (require 'term)
  (let* ((cmd "ghcid")
         (h (- (window-height) scroll-margin 3))
         (term-buffer-maximum-size h)
         (args (format "-h %d" h))
         (switches (split-string-and-unquote args))
         (termbuf (apply 'make-term "ghcid" cmd nil switches)))
    (set-buffer termbuf)
    (term-mode)
    (term-line-mode)
    (compilation-minor-mode)
    (switch-to-buffer termbuf)))

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-d") 'ghcid))

;;; attrap - fix errors at point

(use-package attrap
  :ensure t)

(setq-default flycheck-disable-checkers
	      '(c/c++-clang c/c++-cppcheck c/c++-gcc))

(use-package hindent
  :ensure t
  :init
  (add-hook 'haskell-mode-hook  'hindent-mode))

;;; Purescript:

(use-package psci
  :ensure t
  :init
  (add-hook 'purescript-mode-hook 'inferior-psci-mode))

(use-package purescript-mode
  :ensure t
  :init
  (add-hook 'purescript-mode-hook 'turn-on-purescript-identation))

(use-package psc-ide
  :ensure t
  :init
  (add-hook 'purescript-mode-hook
	    (lambda ()
	      (psc-ide-mode)
	      (company-mode)
	      (flycheck-mode)
	      (inferior-psci-mode)
	      (turn-on-purescript-indentation)))
  :config
  (setq psc-ide-rebuild-on-save t))

;;; repl-toggle

(use-package repl-toggle
  :ensure t
  :config
  (add-to-list 'rtog/mode-repl-alist '(purescript-mode . psci)))
  
;; Terraform

(use-package terraform-mode
  :ensure t)

(use-package company-terraform
  :ensure t
  :init)

;; font

(set-face-attribute
 'default
  nil :family "JetBrains Mono" :slant 'normal :weight 'normal :height 141 :width 'normal)

;; Color theme

;; (use-package darktooth-theme
;;   :ensure t
;;   :init
;;   (load-theme 'darktooth t))

(use-package nord-theme
  :ensure t
  :init
  (load-theme 'nord t))

;; no menu bar

(menu-bar-mode -1)

;; no tool bar

(tool-bar-mode -1)

;; parens

(show-paren-mode t)

;; scroll bar

(toggle-scroll-bar -1)

;; Warn before you exit emacs!

(setq confirm-kill-emacs 'yes-or-no-p)

;; make all "yes or no" prompts show "y or n" instead

(fset 'yes-or-no-p 'y-or-n-p)

;; I use version control, don't annoy me with backup files everywhere

(setq make-backup-files nil)
(setq auto-save-default nil)
