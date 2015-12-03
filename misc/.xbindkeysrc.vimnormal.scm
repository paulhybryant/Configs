; vim: filetype=scheme sw=2 ts=2 sts=2 et tw=80 nospell

; Emergency key to avoid having to restart if anything goes wrong
(xbindkey '("m:0x10" "c:76") "notify-send 'info' 'killing xbindkeys'; killall xbindkeys 2>&1 > /dev/null")

; Use name directly (control, alt, letter etc)
; (xbindkey '(control alt v) "vimode toggle")
; Use escape to swith to vim mode, but only do this when the active window is
; not a terminal (handled in vimode toggle)
; (xbindkey '("m:0x10" "c:66") "vimode toggle || xvkbd -xsendevent -text '\\[Escape]'")

; Use ctrl + escape to switch to vim mode
; Use keycode directly (can be found by xbindkeys -k)
; (xbindkey '("m:0x14" "c:66") "vimode insert")

(define (bind-dw)
  "DW commands"
  (xbindkey-function '(w)
                     (lambda()
                       (run-command "xvkbd -xsendevent -text '\\S\\C\\[Right]'")
                       (run-command "xvkbd -xsendevent -delay 10 -text '\\[Delete]'")
                       (remove-xbindkey '(w))
                       (bind-w)
                       )
                     )
  )

; Use letter
; see man xbindkey / man xvkbd to see what text (keysyms) are available.
(xbindkey '(a) "~/.zsh/bin/vimode insert")
(xbindkey '(b) "xvkbd -xsendevent -text '\\C\\[Left]'")
(xbindkey '(c) "")
(define (bind-d)
  "bind d"
  (xbindkey-function '(d) (lambda ()
                          (remove-xbindkey '(w))
                          (bind-dw)
                          )
                     )
  )
(bind-d)
(xbindkey '(e) "xvkbd -xsendevent -text '\\C\\[Right]'")
(xbindkey '(f) "")
(xbindkey '(g) "")
(xbindkey '(h) "xvkbd -xsendevent -text '\\[Left]'")
(xbindkey '(i) "~/.zsh/bin/vimode insert")
(xbindkey '(j) "xvkbd -xsendevent -text '\\[Down]'")
(xbindkey '(k) "xvkbd -xsendevent -text '\\[Up]'")
(xbindkey '(l) "xvkbd -xsendevent -text '\\[Right]'")
; TODO: Check why xte doesn't work
; (xbindkey '(h) "xte 'key Left'")
; (xbindkey '(j) "xte 'keydown Down' 'keyup Down'")
; (xbindkey '(k) "xte 'keydown Up' 'keyup Up'")
; (xbindkey '(l) "xte 'keydown Right' 'keyup Right'")
(xbindkey '(m) "")
(xbindkey '(n) "")
(xbindkey '(o) "")
(xbindkey '(p) "xvkbd -xsendevent -text '\\Cv'")
(xbindkey '(q) "")
(xbindkey '(r) "")
(xbindkey '(s) "")
(xbindkey '(t) "")
(xbindkey '(u) "")
(xbindkey '(v) "")
(define (bind-w)
  "bind w"
  (xbindkey-function '(w) (lambda ()
                          (run-command "xvkbd -xsendevent -text '\\C\\[Right]'")
                          )
                     )
  )
(bind-w)
(xbindkey '(x) "xvkbd -xsendevent -text '\\[Delete]'")
(xbindkey '(y) "xvkbd -xsendevent -text '\\Cc'")
(xbindkey '(z) "")

(xbindkey '(slash) "xvkbd -xsendevent -text '\\Cf'")

(xbindkey '(Shift a) "")
(xbindkey '(Shift b) "")
(xbindkey '(Shift c) "")
(xbindkey '(Shift d) "xvkbd -xsendevent -text '\\S\\[End]\\[Delete]'")
(xbindkey '(Shift e) "")
(xbindkey '(Shift f) "")
(xbindkey '(Shift g) "")
(xbindkey '(Shift h) "")
(xbindkey '(Shift i) "")
(xbindkey '(Shift j) "")
(xbindkey '(Shift k) "")
(xbindkey '(Shift l) "")
(xbindkey '(Shift m) "")
(xbindkey '(Shift n) "")
(xbindkey '(Shift o) "")
(xbindkey '(Shift p) "")
(xbindkey '(Shift q) "")
(xbindkey '(Shift r) "")
(xbindkey '(Shift s) "")
(xbindkey '(Shift t) "")
(xbindkey '(Shift u) "")
(xbindkey '(Shift v) "xvkbd -xsendevent -text '\\[Home]\\S\\[End]'")
(xbindkey '(Shift w) "")
(xbindkey '(Shift x) "")
(xbindkey '(Shift y) "")
(xbindkey '(Shift z) "")

; 0
(xbindkey '("0") "xvkbd -xsendevent -text '\\[Home]'")
; $
(xbindkey '("m:0x11" "c:13") "xvkbd -xsendevent -text '\\[End]'")

; Backspace
; (xbindkey '(x) "xvkbd -xsendevent -text '\\b'")
