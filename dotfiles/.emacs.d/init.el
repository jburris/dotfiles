;; Enter key now properly indents current line, moves to next & indents to proper indentation lvl
(define-key global-map (kbd "RET") 'reindent-then-newline-and-indent)

;; Ruby-mode also binds C-j to RET
(add-hook 'ruby-mode-hook
					(defun jb/ruby-newline-and-indent ()
						(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)))

(add-hook 'magit-log-edit-mode-hook
					(defun jb/magit-auto-fill-mode ()
						(auto-fill-mode 1)))

;; Turns off god awful autofill mode.
(auto-fill-mode -1)

;; ido - incremental completion
(ido-mode 1)

;; disable tool-bar
(tool-bar-mode -1)

;; Scroll bars? What is this, 2003?
(scroll-bar-mode -1)

;; el-get
;; Must be initialized 
;; https://github.com/dimitri/el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(el-get
        magit
        markdown
        coffee-mode
        yaml-mode
        rhtml-mode
        haml-mode
        color-theme
        (:name color-theme-solarized
               :after (progn
                        (color-theme-solarized-dark)))))
(el-get 'sync)

;; Emacs starter kit
;; https://github.com/technomancy/emacs-starter-kit
(require 'package)
;; (add-to-list 'package-archives
;; 	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Emacs package manager
(setq package-archives
      '(("ELPA"		. "http://tromey.com/elpa/")
        ("gnu"		. "http://elpa.gnu.org/packages/")
        ("marmalade"	. "http://marmalade-repo.org/packages/")
        ("melpa"	. "http://melpa.milkbox.net/packages/")
        ("SC"		. "http://joseito.republika.pl/sunrise-commander/")))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Starter-kit packages I want installed
(defvar my-packages
  '(starter-kit starter-kit-ruby starter-kit-lisp starter-kit-js)
  "A list of packages to ensure are installed at launch.")

(add-to-list 'load-path "~/.emacs.d/elisp/feature-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/less-css-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/autopair")

;; optional configurations
;; default language if .feature doesn't have "# language: fi"
;(setq feature-default-language "fi")
;; point to cucumber languages.yml or gherkin i18n.yml to use
;; exactly the same localization your cucumber uses
;(setq feature-default-i18n-file "/path/to/gherkin/gem/i18n.yml")
;; and load feature-mode
(require 'feature-mode)
(require 'less-css-mode)
(require 'autopair)

(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
(autopair-global-mode) ;; enable autopair EVERYWHERE

;; From Sudish
;; Emacs HEAD now has support for auto-hiding the OS X menubar.
;; Combine this with moving the frame decoration offscreen and
;; we have fullscreen mode under OS X.
;; (see e7f047d6f3e1ea53c8469c28279c2c284fd4d655)
(when (boundp 'ns-auto-hide-menu-bar)
  (define-key global-map [(super s-return)] 'sj/ns-toggle-menu-bar)
  (defun sj/ns-toggle-menu-bar ()
    "Toggle the auto-hide of the menu bar."
    (interactive)
    (setq ns-auto-hide-menu-bar (not ns-auto-hide-menu-bar)))
  (define-key global-map [(super return)] 'sj/ns-make-frame-fullscreen)
  (defun sj/ns-make-frame-fullscreen ()
    "Make the current frame fullscreen."
    (interactive)
    (setq ns-auto-hide-menu-bar t)
    (cl-labels ((fp (p) (frame-parameter (selected-frame) p)))
      ;; Make this frame large enough to cover the whole screen.
      ;; set-frame-size takes character rows and columns, so convert
      ;; all the pixel-based values accordingly.
      (let* ((rows (/ (display-pixel-height) (frame-char-height)))
         (cols (/ (display-pixel-width)  (frame-char-width)))
         (fringe-pixels (+ (fp 'left-fringe) (fp 'right-fringe)))
         (fringe (/ fringe-pixels (frame-char-width)))
         (scrollbar (/ (fp 'scroll-bar-width) (frame-char-width)))
         (real-cols (- cols fringe scrollbar)))
    (set-frame-size (selected-frame) real-cols rows))
      ;; Move this frame's window decoration offscreen.
      ;; - The magic number here is the size of the decorator in pixels.
      ;; - vertical-gap is any leftover vertical space (pixels) after
      ;;   computing the number of rows above. We distribute this evenly
      ;;   at the top and bottom.
      ;; - vertical-offset must be negative to move the window decoration
      ;;   offscreen.
      (let* ((decorator-size 24)
         (vertical-gap (mod (display-pixel-height) (frame-char-height)))
         (vertical-offset (- (/ vertical-gap 2) decorator-size)))
    (set-frame-position (selected-frame) 0 vertical-offset)))))

(when (boundp 'mac-carbon-version-string)
  (defun sj/mac-carbon-toggle-frame-fullscreen ()
    "Make the current frame fullscreen."
    (interactive)
    (let* ((frame (selected-frame))
	   (fs-param (if (eq (frame-parameter frame 'fullscreen) 'fullboth)
			 nil
		       'fullboth)))
      (set-frame-parameter frame 'fullscreen fs-param)))
  (define-key global-map [(super return)] 'sj/mac-carbon-toggle-frame-fullscreen))

;; Set tabstop values to 2
(defun jb/generate-tab-stops (&optional width max)
	"Return a sequence suitable for `tab-stop-list`."
	(let* ((max-column (or max 200))
				 (tab-wdith (or width tab-width))
				 (count (/ max-column tab-width)))
		(number-sequence tab-width (* tab-width count) tab-width)))

(defun sj/copy-keys-from-keymap (from-map keys &optional to-map)
  "Copy the definitions of key sequences in `keys' from `from-map' to `to-map'.
A new keymap is created if `to-map' is nil.  `keys' should be a
list of the keys whose bindings are to be copied.  Each entry may
also be of the form (from-key . to-key) if the keys differ in the
two keymaps.

Example:
  (\"a\" [backspace]
   (\"v\"  . \"k\")
   ([?v] . [?\C-o])
   (\"\C-y\" . \"x\"))

The keymap will have `from-map's bindings for \"v\" on \"k\" and \"\C-o\",
and the binding for \"\C-y\" on \"x\". The bindings for \"a\" and [backspace]
will be copied as well."
  (let ((new-map (or to-map (make-sparse-keymap))))
    (dolist (entry keys)
      (let ((from-key (if (listp entry) (car entry) entry))
	    (to-key   (if (listp entry) (cdr entry) entry)))
	(define-key new-map to-key (lookup-key from-map from-key))))
     new-map))

;; Distinguish between various Emacs ports to OS X
(cond
 ;; ns port
 ((boundp 'ns-version-string)
  (setq ns-antialias-text t
        ns-option-modifier 'meta)
  (define-key global-map [ns-drag-file] 'ns-find-file))
 ;; mac port
 ((boundp 'mac-carbon-version-string)
  (setq mac-command-modifier 'super
        mac-option-modifier  'meta)
  ;; Command-S to save, C to copy, V to paste, etc.
  (let ((keys '(("\C-x\C-s"    . [(super s)])
                ("\C-w"        . [(super x)])
                ("\M-w"        . [(super c)])
                ("\C-y"        . [(super v)])
                ("\C-xh"       . [(super a)])
                ([(control /)] . [(super z)]))))
    (sj/copy-keys-from-keymap global-map keys global-map))))

(define-key global-map [(super =)]	'text-scale-adjust)
(define-key global-map [(super -)]	'text-scale-adjust)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (jb/generate-tab-stops))
