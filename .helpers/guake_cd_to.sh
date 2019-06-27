#!/bin/zsh
dbus-send --session --type=method_call --dest=org.guake3.RemoteControl /org/guake3/RemoteControl org.guake3.RemoteControl.show
dbus-send --session --type=method_call --dest=org.guake3.RemoteControl /org/guake3/RemoteControl org.guake3.RemoteControl.execute_command string:"c"
dbus-send --session --type=method_call --dest=org.guake3.RemoteControl /org/guake3/RemoteControl org.guake3.RemoteControl.execute_command string:"cd ${(q)*}"
