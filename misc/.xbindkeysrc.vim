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

; Use letter
; see man xbindkey to see what text (keysyms) are available.
(xbindkey '(a) "$HOME/.local/bin/vimode off")
(xbindkey '(b) "xvkbd -xsendevent -text '\\C\\[Left]'")
(xbindkey '(c) "")
(xbindkey '(d) "")
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
(xbindkey '(w) "xvkbd -xsendevent -text '\\C\\[Right]'")
(xbindkey '(x) "xvkbd -xsendevent -text '\\[Delete]'")
(xbindkey '(y) "xvkbd -xsendevent -text '\\Cc'")
(xbindkey '(z) "")

; TODO: See whether the following can be more readable using keysyms
; 0
(xbindkey '("m:0x10" "c:19") "xvkbd -xsendevent -text '\\[Home]'")
; $
(xbindkey '("m:0x11" "c:13") "xvkbd -xsendevent -text '\\[End]'")
; V
(xbindkey '("m:0x11" "c:55") "xvkbd -xsendevent -text '\\Cl'")
; D
(xbindkey '("m:0x11" "c:40") "xvkbd -xsendevent -text '\\S\\[End]\\[Delete]'")
; Backspace
; (xbindkey '(x) "xvkbd -xsendevent -text '\\b'")

; Use keycode directly (can be found by xbindkeys -k)
(xbindkey '("m:0x10" "c:61") "xvkbd -xsendevent -text '\\Cf'")

; TODO: Check why the follow doesn't work
; (xbindkey '(mod2 slash) "xvkbd -xsendevent -text '\\Cf'")
