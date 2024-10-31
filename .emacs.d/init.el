;; -*-no-byte-compile: t; -*-
;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

(require 'package)
(setq package-user-dir (expand-file-name "elpa-quick/" user-emacs-directory))
(package-initialize)

(load-theme 'manoj-dark t)

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1
      indent-tabs-mode nil
      tab-width 2
      sentence-end-double-space nil
      dired-recursive-deletes 'always
      dired-recursive-copies 'always
      dired-clean-confirm-killing-deleted-buffers nil
      initial-scratch-message ""
      initial-major-mode 'fundamental-mode
      inhibit-startup-message t
      ring-bell-function 'ignore
      diff-switches "-u"
      highlight-nonselected-windows t
      save-interprogram-paste-before-kill t
      native-comp-async-report-warnings-errors nil)

(setq-default mouse-highlight nil
              case-fold-search t
	      case-replace t ;; should replace keep case?
              compilation-scroll-output t
              compilation-ask-about-save nil
              grep-highlight-matches t
              grep-scroll-output nil
	      grep-save-buffers nil
              set-mark-command-repeat-pop t
              show-trailing-whitespace t
              truncate-lines t
              truncate-partial-width-windows nil
              fill-column 80
              ;; autosave
              auto-save-file-name-transforms `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" ,temporary-file-directory t)
                                               (".*" ,(expand-file-name "backups" user-emacs-directory) t))
              ;; lock files
              create-lockfiles nil
	      indent-tabs-mode nil)

(savehist-mode 1)
(blink-cursor-mode 0)

(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))

(tool-bar-mode 0)
(menu-bar-mode 0)

(transient-mark-mode t)
(delete-selection-mode t)

(electric-pair-mode 1)
(setq-default electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)
(electric-indent-mode -1)

(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-style 'parenthesis)

;; enable disabled commands
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode)

(recentf-mode 1)
(setq recentf-max-saved-items 100)

(use-package adaptive-wrap
  :config
  (adaptive-wrap-prefix-mode t))

(setq enable-recursive-minibuffers t)

(put 'set-goal-column 'disabled 't)

(when window-system
  (pixel-scroll-precision-mode 1)
  (setq confirm-kill-emacs 'y-or-n-p))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; backups

(defvar rk/backup-dir (expand-file-name "~/.emacs-backups"))

(when (not (file-exists-p rk/backup-dir))
  (make-directory rk/backup-dir))

(setq make-backup-files nil)

(use-package async-backup
  :ensure
  :config
  (setq async-backup-location rk/backup-dir)
  (add-hook 'after-save-hook #'async-backup))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

(defmacro comment (&rest body)
  "Simply ignores its content..."
  (declare (indent defun)))

(defun rk/init-safe-vars ()
  "Sets what is safe to use in .dir-locals.el"
  (interactive)
  (progn
    (put 'projectile-project-root-files-functions 'safe-local-variable 'listp)
    (put 'projectile-indexing-method 'safe-local-variable 'symbolp)
    (put 'projectile-ignored-projects 'safe-local-variable 'consp)
    (put 'projectile-project-root 'safe-local-variable 'stringp)
    (put 'projectile-project-compilation-cmd 'safe-local-variable 'stringp)
    (put 'before-save-hook 'safe-local-variable 'listp)
    (put 'org-confirm-babel-evaluate 'safe-local-variable 'booleanp)
    (put 'lsp-rust-analyzer-cargo-watch-args 'safe-local-variable 'vectorp)

    (put 'eval 'safe-local-variable (lambda (_) t)))

  (add-to-list 'safe-local-variable-values
               '(eval setq projectile-project-root
                      (locate-dominating-file default-directory ".projectile"))))

(rk/init-safe-vars)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
