#!/bin/sh

cli=/Applications/Seil.app/Contents/Library/bin/seil

$cli set enable_capslock 1
/bin/echo -n .
$cli set enable_command_l 1
/bin/echo -n .
$cli set enable_control_l 1
/bin/echo -n .
$cli set enable_escape 1
/bin/echo -n .
$cli set enable_option_l 1
/bin/echo -n .
$cli set keycode_capslock 53
/bin/echo -n .
$cli set keycode_command_l 59
/bin/echo -n .
$cli set keycode_control_l 58
/bin/echo -n .
$cli set keycode_escape 57
/bin/echo -n .
$cli set keycode_option_l 55
/bin/echo -n .
