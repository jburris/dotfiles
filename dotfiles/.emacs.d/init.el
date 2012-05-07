;; Enter key now properly indents current line, moves to next & indents to proper indentation lvl
(define-key global-map (kbd "RET") 'reindent-then-newline-and-indent)

;; Turns off god awful autofill mode.
(auto-fill-mode -1)

;; ido - incremental completion
(ido-mode 1)

;; disable tool-bar
(tool-bar-mode -1)

;; el-get
;; https://github.com/dimitri/el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(el-get
				magit
        yaml-mode
        rhtml-mode
        color-theme
				(:name color-theme-solarized
							 :after (lambda ()
												(color-theme-solarized-dark)))))

(el-get 'sync)

;; Emacs starter kit
;; https://github.com/technomancy/emacs-starter-kit
(require 'package)
(add-to-list 'package-archives
						 '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Starter-kit packages I want installed
(defvar my-packages '(starter-kit starter-kit-ruby starter-kit-lisp starter-kit-js)
  "A list of packages to ensure are installed at launch.")

;; From Sudish
;; Emacs HEAD now has support for auto-hiding the OS X menubar.
;; Combine this with moving the frame decoration offscreen and
;; we have fullscreen mode under OS X.
;; (see e7f047d6f3e1ea53c8469c28279c2c284fd4d655)
(when (boundp 'ns-auto-hide-menu-bar)
  (define-key global-map [(super S-return)] 'sj/ns-toggle-menu-bar)
  (defun sj/ns-toggle-menu-bar ()
    "Toggle the auto-hide of the menu bar."
    (interactive)
    (setq ns-auto-hide-menu-bar (not ns-auto-hide-menu-bar)))
  (define-key global-map [(super return)] 'sj/ns-make-frame-fullscreen)
  (defun sj/ns-make-frame-fullscreen ()
    "Make the current frame fullscreen."
    (interactive)
    (setq ns-auto-hide-menu-bar t)
    (labels ((fp (p) (frame-parameter (selected-frame) p)))
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
