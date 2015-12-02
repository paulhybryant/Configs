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
(xbindkey '(a) "vimode insert")
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
; TODO: Find out how to unbind / rebind keys with xbindkey
(bind-d)
(xbindkey '(e) "xvkbd -xsendevent -text '\\C\\[Right]'")
(xbindkey '(f) "")
(xbindkey '(g) "")
(xbindkey '(i) "vimode insert")
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
; D
(xbindkey '(Shift d) "xvkbd -xsendevent -text '\\S\\[End]\\[Delete]'")
; V
(xbindkey '(Shift v) "xvkbd -xsendevent -text '\\[Home]\\S\\[End]'")
; 0
(xbindkey '("0") "xvkbd -xsendevent -text '\\[Home]'")
; $
(xbindkey '("m:0x11" "c:13") "xvkbd -xsendevent -text '\\[End]'")

; Backspace
; (xbindkey '(x) "xvkbd -xsendevent -text '\\b'")
