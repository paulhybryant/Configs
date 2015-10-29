; vim: filetype=scheme sw=2 ts=2 sts=2 et tw=80 nospell

(xbindkey '(control alt v) "$HOME/.local/bin/toggle_vimode")
(xbindkey '(h) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Left]' || xvkbd -xsendevent -text 'h'")
(xbindkey '(j) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Up]' || xvkbd -xsendevent -text 'j'")
(xbindkey '(k) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Down]' || xvkbd -xsendevent -text 'k'")
(xbindkey '(l) "[[ -f /tmp/vimode.lock ]] && xvkbd -xsendevent -text '\\[Right]' || xvkbd -xsendevent -text 'l'")
