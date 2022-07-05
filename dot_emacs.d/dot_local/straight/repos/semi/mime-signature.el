;;; mime-signature.el --- signature handling module for mime-edit  -*- lexical-binding: t -*-

;; Copyright (C) 2013 Kazuhiro Ito

;; Author: Kazuhiro Ito <kzhr@d1.dion.ne.jp>

;; Keywords: MIME, mail, news

;; This file is part of SEMI (Showy Emacs MIME Interfaces).

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU XEmacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'mime-edit)

(defcustom mime-edit-signature-separator "\n-- \n"
  "Separator between a message text and a signature.  It should
start and must end with LF."
  :group 'mime-edit
  :type 'string)

(defcustom mime-edit-default-signature
  (or (and (boundp 'signature-file-name)
	   signature-file-name)
      (and (boundp 'mail-signature)
	   (cond ((stringp mail-signature)
		  (list (if (string-match
			     (concat
			      "^\n*"
			      (regexp-quote
			       (if (eq ?\n (string-to-char
					    mime-edit-signature-separator))
				   (substring mime-edit-signature-separator 1)
				 mime-edit-signature-separator)))
			     mail-signature)
			    (substring mail-signature (match-end 0))
			  mail-signature)))
		 ((eq mail-signature t)
		  (and (boundp 'mail-signaute-file)
		       mail-signaute-file))
		 (t (list mail-signature))))
      "~/.signature")
  "Specify default signature.
It is string or list consists of strings and functions.
When it is string, indicate signature file name.
When it is list, each string and function's result are
inserted.  Function is called with no argument and returns string
to be inserted."
  :group 'mime-edit
  :type '(choice (file :tag "Signature file name")
		 (repeat (choice
			  (string :tag "Inserting string")
			  (function :tag "Calling function")))))

(defcustom mime-edit-signature-position 'part
  "Position for signature."
  :group 'mime-edit
  :type '(choice (const :tag "Anywhere" nil)
		 (const :tag "At the end of a part" part)
		 (const :tag "At the end of a message" message)))

(defcustom mime-edit-signature-file-prefix nil
  "String containing optional prefix for the signature file names"
  :group 'mime-edit
  :type '(choice (const :tag "Undefine" nil) (string :tag "Define")))

(defcustom mime-edit-signature-alist nil
  "Alist of the form to define inserted signature:
    (((FIELDS . PATTERN) . SIGNATURE)
     ...)

FILEDS is a string or list of strings for searched field names.

PATTERN is a string or list of string or function.  If any
PATTERN's string matchs with any content of FIELDS, SIGNATURE is
inserted.  When PATTERN is function, it is called with two
arguments, field's content and corresponding SIGNATURE.

SIGNATURE is string or list of strings and functions.
When SIGNATURE is string, it indicate signature file suffix.
Actual file name is generated by concatenating with
`mime-edit-signature-file-prefix'.

When SIGNATURE is list, each string and function's result is
inserted.  Function is called no argument and returns string to
be inserted."
  :group 'mime-edit
  :type '(choice
	  (const :tag "Not define" nil)
	  (repeat :tag "Define"
		  (cons
		   (cons (string :tag "Field name")
			 (choice (function :tag "File name suffix returning function")
				 (regexp :tag "Single regexp")
				 (repeat :tag "Multiple regexp" regexp)))
		   (choice (string :tag "Signature file name suffix")
			   (repeat (choice
				    (string :tag "Inserting string")
				    (function :tag "Calling function"))))))))

(defun mime-edit-signature-guess ()
  ;; Guess signature from current buffer and `mime-edit-signature-alist'.
  ;; return signature to be inserted.
  (save-excursion
    (save-restriction
      (std11-narrow-to-header)
      (let ((alist mime-edit-signature-alist)
	    cell fields value field signature tmp)
	(setq signature
	      (catch 'found
		(while alist
		  (setq cell   (car alist)
			fields (caar cell)
			value  (cdar cell))
		  (when (stringp fields) (setq fields (list fields)))
		  (while fields
		    (setq field (std11-fetch-field (car fields)))
		    (cond
		     ((functionp value)
		      (when (setq tmp (apply value field (cdr cell)))
			(throw 'found tmp)))
		     ((stringp field)
		      (when (stringp value) (setq value (list value)))
		      (setq tmp value)
		      (while tmp
			(when (string-match (car tmp) field)
			  (throw 'found (cdr cell)))
			(setq tmp (cdr tmp)))))
		    (setq fields (cdr fields)))
		  (setq alist (cdr alist)))))
	(or (and (stringp signature)
		 (concat mime-edit-signature-file-prefix signature))
	    signature
	    mime-edit-default-signature)))))

(defun mime-edit-signature-insert-plain (signature)
  (if (stringp signature)
      (insert-file-contents signature)
    (while signature
      (cond
       ((stringp (car signature))
	(insert (car signature)))
       ((functionp (car signature))
	(insert (funcall (car signature)))))
      (setq signature (cdr signature))))
  (unless (eq (preceding-char) ?\n)
    (insert ?\n)))

(defun mime-edit-insert-signature ()
  "Insert a signature."
  (interactive)
  (let ((point (point))
	(signature (mime-edit-signature-guess))
	start end text-part-p plain-signature-p)
    (setq plain-signature-p
	  (or (null (stringp signature))
	      (let ((file-type (mime-find-file-type signature)))
		(and (equal "text" (car file-type))
		     (equal "plain" (cadr file-type))))))
    (when (eq mime-edit-signature-position 'message)
      (goto-char (point-max)))
    (re-search-backward mime-edit-tag-regexp nil 'move)
    (setq start (point)
	  end (if (re-search-forward mime-edit-tag-regexp nil t)
		  (match-beginning 0)
		(point-max)))
    (when (> point end)
      (setq start end
	    end (if (re-search-forward mime-edit-tag-regexp nil t)
		    (match-beginning 0)
		  (point-max))))
    (goto-char start)
    (setq text-part-p
	  (or (null (looking-at mime-edit-single-part-tag-regexp))
	      (string-match "^text/plain" (match-string 1))))
    (goto-char (cond ((eq mime-edit-signature-position 'message)
		      (point-max))
		     ((eq mime-edit-signature-position 'part)
		      end)
		     (t
		      point)))
    (unless (and text-part-p plain-signature-p)
      (unless (eq (preceding-char) ?\n) (insert ?\n))
      (mime-edit-insert-tag "text" "plain"))
    (if plain-signature-p
	(progn
	  (unless (eq (preceding-char) ?\n) (insert ?\n))
	  (when (or mime-edit-signature-position
		    (eq end point))
	    (insert mime-edit-signature-separator))
	  (mime-edit-signature-insert-plain signature))
      (mime-edit-insert-file signature))))

;;; @ end
;;;

(provide 'mime-signature)

;;; mime-signature.el ends here
