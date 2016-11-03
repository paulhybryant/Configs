;;; TODO: xmonad can provide similar
;;; features, use it (or maybe not,
;;; since it's quite unstable).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This configuration is guile based.
;;   http://www.gnu.org/software/guile/guile.html
;; any functions that work in guile will work here.
;; see EXTRA FUNCTIONS:

;; Version: 1.8.3

;; If you edit this file, do not forget to uncomment any lines
;; that you change.
;; The semicolon(;) symbol may be used anywhere for comments.

;; To specify a key, you can use 'xbindkeys --key' or
;; 'xbindkeys --multikey' and put one of the two lines in this file.

;; A list of keys is in /usr/include/X11/keysym.h and in
;; /usr/include/X11/keysymdef.h
;; The XK_ is not needed.

;; List of modifier:
;;   Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
;;   Mod3 (CapsLock), Mod4, Mod5 (Scroll).


;; The release modifier is not a standard X modifier, but you can
;; use it if you want to catch release instead of press events

;; By defaults, xbindkeys does not pay attention to modifiers
;; NumLock, CapsLock and ScrollLock.
;; Uncomment the lines below if you want to use them.
;; To dissable them, call the functions with #f


;;;;EXTRA FUNCTIONS: Enable numlock, scrolllock or capslock usage
;;(set-numlock! #t)
;;(set-scrolllock! #t)
;;(set-capslock! #t)

;;;;; Scheme API reference
;;;;
;; Optional modifier state:
;; (set-numlock! #f or #t)
;; (set-scrolllock! #f or #t)
;; (set-capslock! #f or #t)
;;
;; Shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;;
;; Scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;;
;; Other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)


;; Examples of commands:

(xbindkey '(control shift q) "xbindkeys_show")

;; ;; set directly keycode (here control + f with my keyboard)
;; (xbindkey '("m:0x4" "c:41") "xterm")

;; ;; specify a mouse button
;; (xbindkey '(control "b:2") "xterm")

;; ;;(xbindkey '(shift mod2 alt s) "xterm -geom 50x20+20+20")

;; ;; set directly keycode (control+alt+mod2 + f with my keyboard)
;; (xbindkey '(alt "m:4" mod2 "c:0x29") "xterm")

;; ;; Control+Shift+a  release event starts rxvt
;; ;;(xbindkey '(release control shift a) "rxvt")

;; ;; Control + mouse button 2 release event starts rxvt
;; ;;(xbindkey '(releace control "b:2") "rxvt")


;; ;; Extra features
;; (xbindkey-function '(control a)
;; 		   (lambda ()
;; 		     (display "Hello from Scheme!")
;; 		     (newline)))

;; (xbindkey-function '(shift p)
;; 		   (lambda ()
;; 		     (run-command "xterm")))


;; ;; Double click test
;; (xbindkey-function '(control w)
;; 		   (let ((count 0))
;; 		     (lambda ()
;; 		       (set! count (+ count 1))
;; 		       (if (> count 1)
;; 			   (begin
;; 			    (set! count 0)
;; 			    (run-command "xterm"))))))

;; ;; Time double click test:
;; ;;  - short double click -> run an xterm
;; ;;  - long  double click -> run an rxvt
;; (xbindkey-function '(shift w)
;; 		   (let ((time (current-time))
;; 			 (count 0))
;; 		     (lambda ()
;; 		       (set! count (+ count 1))
;; 		       (if (> count 1)
;; 			   (begin
;; 			    (if (< (- (current-time) time) 1)
;; 				(run-command "xterm")
;; 				(run-command "rxvt"))
;; 			    (set! count 0)))
;; 		       (set! time (current-time)))))


;; Chording keys test: Start differents program if only one key is
;; pressed or another if two keys are pressed.
;; If key1 is pressed start cmd-k1
;; If key2 is pressed start cmd-k2
;; If both are pressed start cmd-k1-k2 or cmd-k2-k1 following the
;;   release order
(define (define-chord-keys key1 key2 cmd-k1 cmd-k2 cmd-k1-k2 cmd-k2-k1)
    "Define chording keys"
  (let ((k1 #f) (k2 #f))
    (xbindkey-function key1 (lambda () (set! k1 #t)))
    (xbindkey-function key2 (lambda () (set! k2 #t)))
    (xbindkey-function (cons 'release key1)
		       (lambda ()
			 (if (and k1 k2)
			     (run-command cmd-k1-k2)
			     (if k1 (run-command cmd-k1)))
			 (set! k1 #f) (set! k2 #f)))
    (xbindkey-function (cons 'release key2)
		       (lambda ()
			 (if (and k1 k2)
			     (run-command cmd-k2-k1)
			     (if k2 (run-command cmd-k2)))
			 (set! k1 #f) (set! k2 #f)))))


;; Example:
;;   Shift + b:1                   start an xterm
;;   Shift + b:3                   start an rxvt
;;   Shift + b:1 then Shift + b:3  start gv
;;   Shift + b:3 then Shift + b:1  start xpdf

;; (define-chord-keys '(Mod4 s) '(alt s)
;;   "" "" "" "xdotool search --limit 1 Emacs windowactivate")

;; Here the release order have no importance
;; (the same program is started in both case)
;; (define-chord-keys '(alt "b:1") '(alt "b:3")
;;   "gv" "xpdf" "xterm" "xterm")

;; http://conkeror.org/UpstreamBugs#FocusedpluginspreventConkerorkeybindingsfromworking
(xbindkey '(Mod4 Escape) "conkeror -f unfocus")
;; Do a web search on clipboard content (only if it's opened)
;; (xbindkey '(Mod4 m) "wmctrl -x -a Conkeror && conkeror -f search-clipboard-contents")
;; (xbindkey '(Mod4 Shift m) "conkeror -f search-clipboard-contents-duckduckgo && conkeror -f unfocus")
;; (xbindkey '(Mod4 m) "conkeror -f search-clipboard-contents && conkeror -f unfocus")

;;; NTA: Use xmonad now
;; ;; App switcher
;; (xbindkey '(F1) "wmctrl -x -a Emacs || pgrep emacs || emacs")
;; (xbindkey '(F2) "wmctrl -x -a Conkeror || pgrep xulrunner || conkeror")
;; (xbindkey '(F3) "wmctrl -x -a Terminal || pgrep gnome-terminal || gnome-terminal")
;; (xbindkey '(F9) "wmctrl -x -a Firefox || pgrep firefox || firefox")
;; (xbindkey '(F10) "wmctrl -x -a Chrome || pgrep chrome || google-chrome") ; F*ck
;; (xbindkey '(F11) "wmctrl -x -a Skype || pgrep skype || skype")
;; (xbindkey '(F12) "wmctrl -x -a Pidgin || pgrep pidgin || pidgin")
;; FIXME: This is convoluted and mostly does not work
;; (xbindkey '(F3) "xdotool search --class Pidgin | sort | tail -n 1 | xargs xdotool windowactivate")

;;; NTA: Use xmonad now
;; ;; Toggle fullscreen for current window
;; (xbindkey '(Mod4 Return) "wmctrl -r :ACTIVE: -b toggle,fullscreen")

;;; NTA: Use xmonad now
;; ;; Poor man's window manager
;; ;; wmctrl can execute only 1 action at a time, so...
;; (xbindkey '(Mod4 F2) "wmctrl -r :ACTIVE: -b remove,fullscreen; wmctrl -r :ACTIVE: -e 0,0,0,963,800")
;; (xbindkey '(Mod4 F3) "wmctrl -r :ACTIVE: -b remove,fullscreen; wmctrl -r :ACTIVE: -e 0,963,0,317,800")
;; (xbindkey '(Mod4 F4) "wmctrl -r :ACTIVE: -b remove,fullscreen; wmctrl -r :ACTIVE: -e 0,0,0,1280,800")
;; (xbindkey '(Mod4 Shift F2) "wmctrl -r :ACTIVE: -b remove,fullscreen; wmctrl -r :ACTIVE: -e 0,0,0,640,800")
;; (xbindkey '(Mod4 Shift F3) "wmctrl -r :ACTIVE: -b remove,fullscreen; wmctrl -r :ACTIVE: -e 0,640,0,640,800")

;; Mouse banishment
(xbindkey '(Menu) "xdotool mousemove 640 800; xdotool mousemove 960 0")

;;; Crude, but works
(xbindkey '(XF86AudioMedia) "emacsclient -e '(ublt/start-or-pause)'")
(xbindkey '(Mod4 XF86AudioPlay) "emacsclient -e '(ublt/start-or-pause)'")
(xbindkey '(Mod4 XF86AudioRaiseVolume) "emacsclient -e '(emms-next)'")
(xbindkey '(Mod4 XF86AudioLowerVolume) "emacsclient -e '(emms-previous)'")
(xbindkey '(Mod4 XF86Forward)   "emacsclient -e '(emms-next)")
(xbindkey '(Mod4 XF86Back)       "emacsclient -e '(emms-previous)")

(xbindkey '(XF86AudioRaiseVolume) "amixer set Master 2.25dB+")
(xbindkey '(XF86AudioLowerVolume) "amixer set Master 2.25dB-")

;;; Controling grooveshark
;; (xbindkey '(XF86AudioPlay) "conkeror -f gs-play-or-pause")
;; (xbindkey '(XF86AudioNext) "conkeror -f gs-next")
;; (xbindkey '(XF86AudioPrev) "conkeror -f gs-previous")
;; (xbindkey '(XF86Forward)   "conkeror -f gs-next")
;; (xbindkey '(XF86Back)      "conkeror -f gs-previous")

;;; Controlling VLC
(xbindkey '(XF86AudioPlay) "qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
(xbindkey '(XF86AudioNext) "qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
(xbindkey '(XF86AudioPrev) "qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")


(xbindkey '(F6) "conkeror -f ublt-launch-GMail && wmctrl -x -a Conkeror")
(xbindkey '(F7) "conkeror -f ublt-launch-Feedly && wmctrl -x -a Conkeror")
(xbindkey '(F8) "conkeror -f ublt-launch-Prismatic && wmctrl -x -a Conkeror")
(xbindkey '(F9) "conkeror -f ublt-launch-Facebook && wmctrl -x -a Conkeror")
(xbindkey '(F10) "conkeror -f ublt-launch-Grooveshark && wmctrl -x -a Conkeror")
;; (xbindkey '(XF86Mail) "conkeror -f ublt-launch-GMail && wmctrl -x -a Conkeror")

(xbindkey '(Mod4 XF86Calculator) "conkeror -f ublt-launch-PivotalTracker && wmctrl -x -a Conkeror")

(xbindkey '(Mod4 XF86Sleep) "toggle-night-vision")

;;; Somehow if we bind XF86Mail TAB gets bound as well
(xbindkey '(Mod4 XF86Mail) "exo-open --launch MailReader")


(xbindkey '(Mod4 "6") "yakuake")

;;; Temp
;; (xbindkey '(Mod4 Shift r) "conkeror -f ublt-theme")
;; (xbindkey '(Mod4 r) "conkeror -f ublt-theme-test")

;; (xbindkey  "xrandr --output LVDS1 --off")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
