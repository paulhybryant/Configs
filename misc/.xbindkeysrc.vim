; vim: filetype=scheme sw=2 ts=2 sts=2 et tw=80 nospell

; Use name directly (control, alt, letter etc)
(xbindkey '(control alt v) "$HOME/.local/bin/toggle_vimode")
; (xbindkey '(h) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Left]' || xvkbd -xsendevent -text 'h'")
; (xbindkey '(j) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Down]' || xvkbd -xsendevent -text 'j'")
; (xbindkey '(k) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Up]' || xvkbd -xsendevent -text 'k'")
; (xbindkey '(l) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Right]' || xvkbd -xsendevent -text 'l'")
; Use letter
(xbindkey '(h) "xvkbd -xsendevent -text '\\[Left]'")
(xbindkey '(j) "xvkbd -xsendevent -text '\\[Down]'")
(xbindkey '(k) "xvkbd -xsendevent -text '\\[Up]'")
(xbindkey '(l) "xvkbd -xsendevent -text '\\[Right]'")
; Use keycode directly (can be found by xbindkeys -k, or -mk for multiple keys)
(xbindkey '("m:0x10" "c:61") "xvkbd -xsendevent -text '\\Cf'")
; TODO: Check why the follow doesn't work
; (xbindkey '(mode2 slash) "xvkbd -xsendevent -text '\\Cf'")
