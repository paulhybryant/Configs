; vim: filetype=scheme sw=2 ts=2 sts=2 et tw=80 nospell

; Emergency key to avoid having to restart if anything goes wrong
(xbindkey '("m:0x10" "c:76") "notify-send 'info' 'killing xbindkeys'; killall xbindkeys 2>&1 > /dev/null")

; Use name directly (control, alt, letter etc)
; (xbindkey '(control alt v) "$HOME/.local/bin/vimode toggle")
; Use escape to swith to vim mode, but only do this when the active window is
; not a terminal (handled in vimode toggle)
; (xbindkey '("m:0x10" "c:66") "$HOME/.local/bin/vimode toggle || xvkbd -xsendevent -text '\\[Escape]'")

; Use ctrl + escape to switch to vim mode
(xbindkey '("m:0x14" "c:66") "$HOME/.local/bin/vimode on")

(define (d-bind-w)
  "DW commands"
  (grab-all-keys)
  (xbindkey-function '(w)
                     (lambda()
                       (run-command "xvkbd -xsendevent -text '\\S\\C\\[Right]\\[Delete]'")
                       (bind-w)
                       )
                     )
  (ungrab-all-keys)
  )

; Use letter
; see man xbindkey / man xvkbd to see what text (keysyms) are available.
(xbindkey '(a) "$HOME/.local/bin/vimode off")
(xbindkey '(b) "xvkbd -xsendevent -text '\\C\\[Left]'")
(xbindkey '(c) "")
(define (bind-d)
  "bind d"
  (xbindkey-function '(d) (lambda ()
                          (d-bind-w)
                          )
                     )
  )
; TODO: Find out how to unbind / rebind keys with xbindkey
; (bind-d)
(xbindkey '(e) "xvkbd -xsendevent -text '\\C\\[Right]'")
(xbindkey '(f) "")
(xbindkey '(g) "")
(xbindkey '(h) "xvkbd -xsendevent -text '\\[Left]'")
(xbindkey '(i) "$HOME/.local/bin/vimode off")
(xbindkey '(j) "xvkbd -xsendevent -text '\\[Down]'")
(xbindkey '(k) "xvkbd -xsendevent -text '\\[Up]'")
(xbindkey '(l) "xvkbd -xsendevent -text '\\[Right]'")
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

; (xbindkey '(dw) )

(xbindkey '(slash) "xvkbd -xsendevent -text '\\Cf'")
; Use keycode directly (can be found by xbindkeys -k)
; (xbindkey '("m:0x10" "c:61") "xvkbd -xsendevent -text '\\Cf'")
; D
(xbindkey '(Shift d) "xvkbd -xsendevent -text '\\S\\[End]\\[Delete]'")
; (xbindkey '("m:0x11" "c:40") "xvkbd -xsendevent -text '\\S\\[End]\\[Delete]'")
; V
(xbindkey '(Shift v) "xvkbd -xsendevent -text '\\Cl'")
; (xbindkey '("m:0x11" "c:55") "xvkbd -xsendevent -text '\\Cl'")
; Backspace
; (xbindkey '(x) "xvkbd -xsendevent -text '\\b'")

; TODO: See whether the following can be more readable using keysyms
; 0
(xbindkey '("m:0x10" "c:19") "xvkbd -xsendevent -text '\\[Home]'")
; $
(xbindkey '("m:0x11" "c:13") "xvkbd -xsendevent -text '\\[End]'")
