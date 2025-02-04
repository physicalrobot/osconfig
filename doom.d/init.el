(doom! :input
       ;;bidi

       :completion
       (company +childframe) ; the ultimate code completion backend
       vertico             ; the search engine of the future

       :ui
       doom               ; what makes DOOM look the way it does
       doom-dashboard     ; a nifty splash screen for Emacs
       modeline           ; a snazzy Atom-inspired mode-line
       (popup +defaults)  ; tame sudden yet inevitable temporary windows
       ophints            ; highlight the region an operation acts on

       :editor
       (evil +everywhere) ; come to the dark side, we have cookies
       multiple-cursors   ; editing in many places at once
       snippets           ; my elves. They type so I don’t have to
       format             ; automated prettiness

       :emacs
       dired              ; making dired pretty [functional]
       electric           ; smarter, keyword-based electric-indent

       :term
       eshell             ; a consistent, cross-platform shell

       :checkers
       syntax             ; tasing you for every semicolon you forget

       :tools
       (lookup +dictionary +offline) ; helps you navigate your code and documentation
       magit              ; a git porcelain for Emacs
       lsp                ; language server protocol support

       :os
       (:if IS-MAC macos)  ; macOS-specific enhancements

       :lang
       (python +lsp)      ; beautiful is better than ugly
       (org +roam)        ; organize your plain life in plain text

       :config
       (default +bindings +smartparens))
