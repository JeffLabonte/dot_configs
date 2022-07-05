;;; ido-sort-mtime-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "ido-sort-mtime" "ido-sort-mtime.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from ido-sort-mtime.el

(defvar ido-sort-mtime-mode nil "\
Non-nil if Ido-Sort-Mtime mode is enabled.
See the `ido-sort-mtime-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `ido-sort-mtime-mode'.")

(custom-autoload 'ido-sort-mtime-mode "ido-sort-mtime" nil)

(autoload 'ido-sort-mtime-mode "ido-sort-mtime" "\
Sort files in Ido's file list by modification time.

This is a minor mode.  If called interactively, toggle the
`Ido-Sort-Mtime mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='ido-sort-mtime-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "ido-sort-mtime" '("ido-sort-mtime-"))

;;;***

(provide 'ido-sort-mtime-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ido-sort-mtime-autoloads.el ends here
